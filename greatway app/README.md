# Greatway Cooperative Society - Member Management System

A comprehensive desktop application for managing cooperative society member records, financial transactions, loans, and overall member performance.

## Features

### Member Management
- Personal information records
- KYC/member verification
- Member status tracking (active, inactive, suspended)

### Financial Records
- Savings account tracking
- Shares management
- AGM fees collection
- Administrative charges
- Subscription management (Ileya savings, etc.)

### Loan Management
- Loan applications
- Eligibility checking (6-month membership requirement)
- Loanable amount calculation (2x savings + 10% shares requirement)
- Loan status tracking
- Loan details and terms
- Repayment progress monitoring
- Business loan options

### Dashboard & Reporting
- Member financial performance overview
- Loan portfolio analysis
- Payment history and analytics
- Compliance and audit trails

## Project Structure

```
greatway app/
├── frontend/              # Electron + React + TypeScript
├── backend/               # Express + TypeScript + MySQL
├── database/              # MySQL schemas and migrations
├── docs/                  # Documentation
├── package.json           # Root package config
└── README.md
```

## Technology Stack

- **Frontend**: Electron 30+, React 18, TypeScript, TailwindCSS
- **Backend**: Node.js 20+, Express 4.x, TypeScript
- **Database**: MySQL 8.0+
- **Deployment**: Local/On-premises

## Getting Started

### Prerequisites
- Node.js 20+ and npm
- MySQL 8.0+

### Installation

```bash
# Install root dependencies
npm install

# Install frontend dependencies
cd frontend
npm install

# Install backend dependencies
cd ../backend
npm install
```

### Development

```bash
# From root directory
npm run dev
```

### Building for Production

```bash
npm run build
```

## Cloud Deployment

Deploy to AWS with automatic CI/CD:

```bash
# Windows
scripts/setup-aws.bat

# macOS/Linux
chmod +x scripts/setup-aws.sh
./scripts/setup-aws.sh
```

See [CLOUD_DEPLOYMENT.md](CLOUD_DEPLOYMENT.md) and [docs/AWS_DEPLOYMENT_GUIDE.md](docs/AWS_DEPLOYMENT_GUIDE.md) for details.

### Cloud Service Options

- **AWS** (Recommended): $0/month (year 1), $80-120/month after ✅
- **Heroku**: $50+/month from start
- **DigitalOcean**: $12/month
- **GCP/Azure**: $0 (with credits)

See [docs/CLOUD_SERVICES_COMPARISON.md](docs/CLOUD_SERVICES_COMPARISON.md)

## Database Setup

See [database/README.md](database/README.md) for MySQL setup and schema initialization.

## API Documentation

See [backend/README.md](backend/README.md) for REST API documentation.

## User Guide

See [docs/USER_GUIDE.md](docs/USER_GUIDE.md) for detailed usage instructions.

## License

All rights reserved © Greatway Cooperative Society
