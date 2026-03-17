# AWS Cloud Deployment Guide - Greatway Cooperative

Deploy your application to AWS with managed services using the free tier.

## Architecture Overview

```
GitHub Repository
    ↓
    ├─→ GitHub Actions (CI/CD)
    │       ↓
    ├─→ AWS Elastic Beanstalk (App Server) - Free tier eligible
    │   ├─ Frontend: Electron app (downloadable)
    │   └─ Backend: Node.js API
    │
    └─→ AWS RDS (MySQL Database) - Free tier eligible
        └─ greatway_coop database
```

## AWS Services Used

### 1. **AWS Elastic Beanstalk** (Free Tier Eligible)
- Fully managed application deployment
- Auto-scaling and load balancing
- Easy rollback and monitoring
- Free tier: 750 hours/month of t2.micro instances

### 2. **AWS RDS for MySQL** (Free Tier Eligible)
- Managed MySQL database
- Automatic backups
- Multi-AZ option
- Free tier: 750 hours/month, 20GB storage, 20GB backup

### 3. **GitHub** (Free)
- Code repository and version control
- GitHub Actions for CI/CD
- Automated testing and deployment

### 4. **AWS S3** (Optional - for Electron installer distribution)
- Static hosting for desktop app installers

## Pre-requisites

- AWS Account (free tier)
- GitHub Account
- Git installed locally
- AWS CLI (optional but recommended)

## Step 1: Create GitHub Repository

### A. Create Repository on GitHub

1. Go to https://github.com/new
2. Create repository: `greatway-coop-management`
3. Choose: **Public** or **Private**
4. Add description: "Member Management System for Greatway Cooperative"
5. Click **Create Repository**

### B. Initialize Local Git

```bash
cd "c:\Users\Yusbam\Desktop\greatway app"

git init
git add .
git commit -m "Initial commit: Project setup"

git branch -M main
git remote add origin https://github.com/YOUR_USERNAME/greatway-coop-management.git
git push -u origin main
```

Replace `YOUR_USERNAME` with your GitHub username.

## Step 2: Create AWS RDS MySQL Database

### A. Create RDS Instance

1. Go to AWS Console → RDS
2. Click **Create database**
3. Select **MySQL** → **Free tier template**
4. Configure:
   - **DB Instance ID**: `greatway-coop-db`
   - **Master username**: `admin`
   - **Password**: Generate strong password (save it!)
   - **Allocated storage**: 20 GB (free tier max)
   - **Storage type**: gp2
   - **Public accessibility**: Yes (for development)
   - **Backup retention**: 7 days (free tier)

5. Click **Create Database**

### B. Get Connection Details

Once created, copy:
- **Endpoint**: `greatway-coop-db.xxxxx.us-east-1.rds.amazonaws.com`
- **Port**: `3306`
- **Master username**: `admin`

### C. Initialize Database Schema

Once RDS is running:

```bash
# Install MySQL client if needed
# macOS: brew install mysql-client
# Windows: choco install mysql

mysql -h your-endpoint.rds.amazonaws.com -u admin -p

# Enter password when prompted

# Then run:
CREATE DATABASE greatway_coop CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
USE greatway_coop;

# Import your SQL files:
SOURCE database/schema/01_init.sql
SOURCE database/schema/02_views.sql
SOURCE database/schema/03_sample_data.sql
```

## Step 3: Setup Elastic Beanstalk for Backend

### A. Create Elastic Beanstalk Environment

1. Go to AWS Console → Elastic Beanstalk
2. Click **Create application**
   - **Application name**: `greatway-coop-backend`
   - **Environment name**: `greatway-coop-backend-prod`

3. Platform: **Node.js 20 running on 64bit Amazon Linux 2**
4. Application code: **Sample application** (we'll deploy from GitHub)
5. Click **Create**

### B. Create `.ebextensions/nodecommand.config`

```yaml
option_settings:
  aws:elasticbeanstalk:container:nodejs:
    NodeCommand: "npm start"
    EnvironmentVariables:
      NODE_ENV: production
      PORT: 8080
```

### C. Create `.ebextensions/env.config`

```yaml
option_settings:
  aws:elasticbeanstalk:application:environment:
    DB_HOST: "your-rds-endpoint"
    DB_USER: "admin"
    DB_PASSWORD: "your-password"
    DB_NAME: "greatway_coop"
    JWT_SECRET: "your-super-secret-jwt-key"
    NODE_ENV: "production"
    CORS_ORIGIN: "*"
```

### D. Update Backend package.json

Add to backend `package.json`:

```json
{
  "engines": {
    "node": "20.x"
  },
  "scripts": {
    "start": "node dist/index.js",
    "build": "tsc",
    "postinstall": "npm run build"
  }
}
```

## Step 4: Setup GitHub Actions CI/CD

### A. Create `.github/workflows/deploy.yml`

Create file in your repo root:

```yaml
name: Deploy to Elastic Beanstalk

on:
  push:
    branches: [main]

jobs:
  deploy:
    runs-on: ubuntu-latest
    
    steps:
    - uses: actions/checkout@v3
    
    - name: Configure AWS credentials
      uses: aws-actions/configure-aws-credentials@v2
      with:
        aws-access-key-id: ${{ secrets.AWS_ACCESS_KEY_ID }}
        aws-secret-access-key: ${{ secrets.AWS_SECRET_ACCESS_KEY }}
        aws-region: us-east-1
    
    - name: Deploy to Elastic Beanstalk
      uses: einaregilsson/beanstalk-deploy@v21
      with:
        aws_access_key: ${{ secrets.AWS_ACCESS_KEY_ID }}
        aws_secret_key: ${{ secrets.AWS_SECRET_ACCESS_KEY }}
        application_name: greatway-coop-backend
        environment_name: greatway-coop-backend-prod
        region: us-east-1
        version_label: "app-${{ github.sha }}"
        deployment_package: backend.zip
```

### B. Add GitHub Secrets

1. Go to GitHub repo → Settings → Secrets and variables → Actions
2. Add:
   - `AWS_ACCESS_KEY_ID`: Your AWS access key
   - `AWS_SECRET_ACCESS_KEY`: Your AWS secret key

## Step 5: Cloud Environment Configuration

### A. Create `.env.cloud` for Backend

```env
PORT=8080
NODE_ENV=production
DB_HOST=your-rds-endpoint.amazonaws.com
DB_USER=admin
DB_PASSWORD=your-password
DB_NAME=greatway_coop
JWT_SECRET=your-super-secret-jwt-key-change-this
LOG_LEVEL=info
CORS_ORIGIN=*
```

### B. Update Backend Config

Create `backend/src/config/env.ts`:

```typescript
import dotenv from 'dotenv';

dotenv.config();

export const config = {
  port: process.env.PORT || 3001,
  environment: process.env.NODE_ENV || 'development',
  database: {
    host: process.env.DB_HOST || 'localhost',
    user: process.env.DB_USER || 'root',
    password: process.env.DB_PASSWORD || '',
    database: process.env.DB_NAME || 'greatway_coop',
  },
  jwt: {
    secret: process.env.JWT_SECRET || 'dev-secret-key',
    expiresIn: '24h',
  },
  cors: {
    origin: process.env.CORS_ORIGIN === '*' ? true : process.env.CORS_ORIGIN?.split(','),
  },
};
```

## Step 6: Deploy Application

### A. Push to GitHub

```bash
git add .
git commit -m "Add cloud deployment configuration"
git push origin main
```

### B. Monitor Deployment

1. Go to GitHub → Actions tab
2. Wait for workflow to complete
3. Check Elastic Beanstalk console for deployment status

### C. Get API Endpoint

Once deployed:

```
https://greatway-coop-backend-prod.us-east-1.elasticbeanstalk.com/api
```

Update frontend `.env.production`:

```env
REACT_APP_API_URL=https://greatway-coop-backend-prod.us-east-1.elasticbeanstalk.com/api
```

## Step 7: Deploy Frontend (Electron App)

### A. Build Electron App

```bash
cd frontend
npm run build
```

### B. Store Installer on S3 (Optional)

1. Create S3 bucket: `greatway-coop-installers`
2. Upload built installers
3. Generate shareable links

### C. Or Deploy Web Version

If you want a web version:

```bash
# Build frontend
npm run build

# Deploy to AWS Amplify
amplify init
amplify publish
```

## Monitoring & Maintenance

### View Logs

```bash
# Elastic Beanstalk logs
aws elasticbeanstalk request-environment-info \
  --environment-name greatway-coop-backend-prod \
  --info-type tail

aws elasticbeanstalk retrieve-environment-info \
  --environment-name greatway-coop-backend-prod \
  --info-type tail
```

### Database Backups

AWS RDS automatically backs up your database. To restore:

1. AWS Console → RDS → Automated backups
2. Select snapshot → Restore to new DB instance

### Scaling

If you need more resources:

1. Elastic Beanstalk → Configuration → Capacity
2. Increase instance type (no longer free tier)
3. or Enable auto-scaling

## Cost Estimation (Free Tier)

| Service | Free Tier | Typical Cost |
|---------|-----------|--------------|
| Elastic Beanstalk | 750 hrs/month (t2.micro) | ~$40-60/month (beyond free tier) |
| RDS MySQL | 750 hrs/month, 20GB | ~$20-30/month (beyond free tier) |
| GitHub | Unlimited public repos | Free |
| **Total** | **Free (Year 1)** | **~$60-90/month (Year 2+)** |

## Troubleshooting

### Deployment Fails

1. Check GitHub Actions logs
2. SSH into EB instance:
   ```bash
   aws ec2-instance-connect ssh --instance-id <id> --os-user ec2-user
   ```
3. Check `/var/log/eb-docker/containers/eb_current_app/` logs

### Database Connection Error

1. Check RDS security group allows inbound on port 3306
2. Verify DB_HOST in environment variables
3. Test connection:
   ```bash
   mysql -h your-endpoint -u admin -p -e "SELECT 1;"
   ```

### Environment Variables Not Loading

1. Update Elastic Beanstalk configuration
2. Redeploy application

## Next Steps

1. ✅ Create GitHub repository
2. ✅ Setup AWS RDS database
3. ✅ Create Elastic Beanstalk environment
4. ✅ Configure GitHub Actions
5. ✅ Deploy backend API
6. Deploy frontend (Electron or web)
7. Monitor and maintain
8. Scale as needed

## References

- [AWS Elastic Beanstalk Docs](https://docs.aws.amazon.com/elasticbeanstalk/)
- [AWS RDS Docs](https://docs.aws.amazon.com/rds/)
- [GitHub Actions Docs](https://docs.github.com/en/actions)
- [Node.js on Elastic Beanstalk](https://docs.aws.amazon.com/elasticbeanstalk/latest/dg/create-deploy-nodejs.html)
