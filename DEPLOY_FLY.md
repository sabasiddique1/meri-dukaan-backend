# Fly.io Deployment Guide

## Step-by-Step CLI Deployment

### Step 1: Login to Fly.io
```bash
export PATH="$HOME/.fly/bin:$PATH"
fly auth login
```
This will open a browser. Sign up/login with GitHub or email.

### Step 2: Launch the App
```bash
cd /Users/saba/Desktop/meri_dukaan/meri-dukaan-backend
fly launch --no-deploy
```
This will:
- Detect your Dockerfile
- Ask for app name (or use default: meri-dukaan-backend)
- Ask for region (choose closest to you, e.g., `iad` for US East)
- Create the app on Fly.io

### Step 3: Create PostgreSQL Database
```bash
fly postgres create --name meri-dukaan-db --region iad
```
This will:
- Create a PostgreSQL database
- Show you the connection string
- Note the app name for linking

### Step 4: Link Database to App
```bash
fly postgres attach meri-dukaan-db --app meri-dukaan-backend
```
This automatically sets `DATABASE_URL` environment variable.

### Step 5: Set Environment Variables
```bash
# Set JWT secret
fly secrets set JWT_SECRET=your-super-secret-jwt-key-change-this

# Set storage path
fly secrets set STORAGE_PATH=/app/storage

# Verify secrets
fly secrets list
```

### Step 6: Deploy
```bash
fly deploy
```
This will:
- Build your Docker image
- Push to Fly.io
- Deploy your app
- Show you the URL (e.g., https://meri-dukaan-backend.fly.dev)

### Step 7: Run Database Migrations
```bash
# SSH into the app
fly ssh console

# Inside the console, run:
npm run prisma:migrate:deploy
npm run prisma:seed

# Exit
exit
```

### Step 8: Verify Deployment
```bash
# Check app status
fly status

# Check logs
fly logs

# Open app in browser
fly open
```

## Quick Commands Reference

```bash
# View app info
fly status

# View logs
fly logs

# SSH into app
fly ssh console

# Scale app (if needed)
fly scale count 1

# Open app URL
fly open

# Update secrets
fly secrets set KEY=value

# View secrets
fly secrets list
```

## Your App URLs

After deployment, you'll get:
- **API**: https://meri-dukaan-backend.fly.dev
- **Health Check**: https://meri-dukaan-backend.fly.dev/health
- **Swagger Docs**: https://meri-dukaan-backend.fly.dev/api-docs

## Troubleshooting

### If deployment fails:
```bash
# Check build logs
fly logs

# Check app status
fly status

# Restart app
fly apps restart meri-dukaan-backend
```

### If database connection fails:
```bash
# Verify database is attached
fly postgres list

# Re-attach if needed
fly postgres attach meri-dukaan-db --app meri-dukaan-backend
```

### If you need to update:
```bash
# Just push code and redeploy
git push
fly deploy
```
