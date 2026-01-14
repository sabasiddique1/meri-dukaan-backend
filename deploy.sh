#!/bin/bash
# Fly.io Deployment Script
# Run this script to deploy your app to Fly.io

set -e

echo "🚀 Starting Fly.io Deployment..."
echo ""

# Add Fly CLI to PATH
export PATH="$HOME/.fly/bin:$PATH"

# Step 1: Check if logged in
echo "📋 Step 1: Checking authentication..."
if ! fly auth whoami &>/dev/null; then
    echo "❌ Not logged in. Please run: fly auth login"
    echo "   This will open a browser for authentication."
    exit 1
fi

echo "✅ Logged in as: $(fly auth whoami)"
echo ""

# Step 2: Launch app (if not already launched)
echo "📋 Step 2: Launching app..."
if ! fly status &>/dev/null; then
    echo "Creating new app..."
    fly launch --no-deploy --name meri-dukaan-backend --region iad
else
    echo "✅ App already exists"
fi
echo ""

# Step 3: Check for PostgreSQL
echo "📋 Step 3: Checking PostgreSQL database..."
if ! fly postgres list | grep -q meri-dukaan-db; then
    echo "Creating PostgreSQL database..."
    fly postgres create --name meri-dukaan-db --region iad --vm-size shared-cpu-1x --volume-size 3
    echo "Waiting for database to be ready..."
    sleep 10
else
    echo "✅ Database already exists"
fi
echo ""

# Step 4: Attach database
echo "📋 Step 4: Attaching database to app..."
fly postgres attach meri-dukaan-db --app meri-dukaan-backend || echo "Database already attached"
echo ""

# Step 5: Set secrets (if not already set)
echo "📋 Step 5: Setting environment variables..."
if [ -z "$JWT_SECRET" ]; then
    echo "⚠️  JWT_SECRET not set. Please set it:"
    echo "   fly secrets set JWT_SECRET=your-secret-key"
    read -p "Enter JWT_SECRET (or press Enter to skip): " jwt_secret
    if [ -n "$jwt_secret" ]; then
        fly secrets set JWT_SECRET="$jwt_secret"
    fi
else
    fly secrets set JWT_SECRET="$JWT_SECRET"
fi

fly secrets set STORAGE_PATH=/app/storage
echo "✅ Environment variables set"
echo ""

# Step 6: Deploy
echo "📋 Step 6: Deploying application..."
fly deploy
echo ""

# Step 7: Show app info
echo "📋 Step 7: Deployment complete!"
echo ""
echo "✅ Your app is live at:"
fly status | grep Hostname || fly open --show-url
echo ""
echo "📝 Next steps:"
echo "   1. Run database migrations:"
echo "      fly ssh console -C 'npm run prisma:migrate:deploy'"
echo "   2. Seed database:"
echo "      fly ssh console -C 'npm run prisma:seed'"
echo "   3. View logs:"
echo "      fly logs"
echo ""
