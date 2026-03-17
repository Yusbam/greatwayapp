# Greatway Cooperative - Backend API

Express.js REST API server for member management, financial records, and loan processing.

## Setup

```bash
npm install
```

## Environment Variables

Create `.env` file:

```env
PORT=3001
NODE_ENV=development
DB_HOST=localhost
DB_USER=root
DB_PASSWORD=your_password
DB_NAME=greatway_coop
JWT_SECRET=your_jwt_secret_key
```

## Running

```bash
# Development
npm run dev

# Production
npm run build
npm start
```

## API Endpoints

### Authentication
- `POST /api/auth/login` - Officer login
- `POST /api/auth/logout` - Logout
- `POST /api/auth/refresh` - Refresh token

### Members
- `GET /api/members` - List all members
- `GET /api/members/:id` - Get member details
- `POST /api/members` - Register new member
- `PUT /api/members/:id` - Update member info
- `DELETE /api/members/:id` - Deactivate member

### Financial Records
- `GET /api/members/:id/finances` - Get member financial summary
- `POST /api/finances/savings` - Record savings deposit
- `POST /api/finances/shares` - Record share purchase
- `POST /api/finances/fees` - Record fee payment

### Loans
- `GET /api/loans` - List all loans
- `GET /api/loans/:id` - Get loan details
- `POST /api/loans/apply` - Submit loan application
- `GET /api/loans/:id/eligibility` - Check loan eligibility
- `POST /api/loans/:id/approve` - Approve loan
- `POST /api/loans/:id/disburse` - Disburse loan
- `POST /api/loans/:id/repay` - Record loan repayment

### Dashboard
- `GET /api/dashboard/summary` - Overall statistics
- `GET /api/dashboard/member/:id` - Member performance dashboard

## Testing

```bash
npm test
```

## Linting

```bash
npm run lint
```
