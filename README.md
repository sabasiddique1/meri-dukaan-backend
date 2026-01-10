# Meri Dukaan - POS + Admin Analytics Backend

A complete Point of Sale (POS) system with Admin Analytics built with NestJS, PostgreSQL, and Prisma.

## Features

- **POS System**: QR code scanning, cart management, invoice generation
- **Inventory Management**: Real-time stock updates with movement audit
- **PDF Generation**: Automatic invoice PDF generation
- **Admin Analytics**: Dashboard with sales trends, brand distribution, market share
- **WebSocket Support**: Real-time updates for admin dashboard
- **Role-Based Access Control**: ADMIN, SALES, INVENTORY, PURCHASE roles
- **JWT Authentication**: Secure API access

## Prerequisites

- Node.js 20+ 
- PostgreSQL 15+
- npm or yarn

## Installation

### 1. Clone the repository
```bash
git clone https://github.com/YOUR_USERNAME/meri-dukaan-backend.git
cd meri-dukaan-backend
```

### 2. Install dependencies
```bash
npm install
```

### 3. Setup environment variables
```bash
cp .env.example .env
```

Edit `.env` file with your configuration:
```env
DATABASE_URL="postgresql://user:password@localhost:5432/meri_dukaan?schema=public"
JWT_SECRET="your-super-secret-jwt-key"
PORT=3001
STORAGE_PATH="./storage"
```

### 4. Setup database
```bash
# Generate Prisma Client
npm run prisma:generate

# Run migrations
npm run prisma:migrate

# Seed database
npm run prisma:seed
```

### 5. Start the server
```bash
npm run start:dev
```

Server will run on `http://localhost:3001`

## API Documentation

### Authentication
- `POST /auth/login` - Login and get JWT token

### POS Endpoints
- `POST /pos/scan` - Scan product QR code
- `POST /pos/invoices` - Create invoice
- `GET /pos/invoices/:id` - Get invoice details
- `GET /pos/invoices/:id/pdf` - Download invoice PDF

### Admin Analytics
- `GET /admin/filters` - Get filter options
- `GET /admin/analytics/summary` - Dashboard summary
- `GET /admin/analytics/sales-trend` - Sales trend data
- `GET /admin/analytics/brand-distribution` - Brand distribution
- `GET /admin/analytics/market-share` - Market share data
- `GET /admin/analytics/brands` - Brand list
- `GET /admin/analytics/top-skus` - Top SKUs

## Default Users

All users have password: `password123`

- **Admin**: `admin@meridukaan.com` (ADMIN role)
- **Sales 1**: `sales1@meridukaan.com` (SALES role - Karachi)
- **Sales 2**: `sales2@meridukaan.com` (SALES role - Lahore)
- **Inventory**: `inventory@meridukaan.com` (INVENTORY role)
- **Purchase**: `purchase@meridukaan.com` (PURCHASE role)

## Project Structure

```
src/
├── auth/           # Authentication module
├── pos/            # POS operations
├── admin/          # Admin analytics
├── websocket/      # WebSocket gateway
├── prisma/         # Prisma service
└── common/         # Shared utilities
```

## Testing

```bash
# Unit tests
npm test

# Integration tests
npm run test:e2e

# Test coverage
npm run test:cov
```

## Deployment

### Deploy on Railway

1. **Install Railway CLI**:
   ```bash
   npm install -g @railway/cli
   ```

2. **Login to Railway**:
   ```bash
   railway login
   ```

3. **Initialize Project**:
   ```bash
   railway init
   ```

4. **Add PostgreSQL Database**:
   - Railway Dashboard → Your Project → New → Database → PostgreSQL
   - Or via CLI: `railway add` (select PostgreSQL)

5. **Link Your Service**:
   - Railway Dashboard → Your Project → New → GitHub Repo
   - Select `MRKhan003/meri-dukaan-backend`

6. **Set Environment Variables** (in Railway Dashboard):
   - Go to your service → Variables tab
   - Add:
     ```
     DATABASE_URL=<auto-set-from-postgres-service>
     JWT_SECRET=<your-secret-key>
     PORT=3001
     STORAGE_PATH=/app/storage
     NODE_ENV=production
     ```

7. **Deploy**:
   - Railway automatically deploys on git push
   - Or manually: `railway up`

8. **Run Migrations** (after first deploy):
   - Railway Dashboard → Your Service → Deployments → Latest → View Logs
   - Or via CLI: `railway run npm run prisma:migrate:deploy`
   - Then: `railway run npm run prisma:seed`

9. **Your API URL**: Check Railway dashboard for your service URL

### Docker Support

```bash
# Start with Docker Compose
docker-compose up -d

# Stop
docker-compose down
```

## Available Scripts

- `npm run start:dev` - Start development server
- `npm run build` - Build for production
- `npm run start:prod` - Start production server
- `npm run prisma:studio` - Open Prisma Studio (database browser)
- `npm run prisma:migrate` - Run database migrations
- `npm run prisma:seed` - Seed database

## WebSocket

WebSocket namespace: `/ws`

Events:
- `invoice.created` - Emitted when invoice is created
- `inventory.updated` - Emitted when inventory is updated

## License

MIT

## Contributors

Your name here

## Support

For issues and questions, please open an issue on GitHub.

