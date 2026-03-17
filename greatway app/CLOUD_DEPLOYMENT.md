# Cloud Deployment - Greatway Cooperative

This directory contains scripts and configurations for cloud deployment.

## Quick Cloud Setup

### Option 1: Automated Setup (Recommended)

**Windows:**
```bash
scripts\setup-aws.bat
```

**macOS/Linux:**
```bash
chmod +x scripts/setup-aws.sh
./scripts/setup-aws.sh
```

### Option 2: Manual Setup

Follow [docs/AWS_DEPLOYMENT_GUIDE.md](../docs/AWS_DEPLOYMENT_GUIDE.md) step by step.

## Cloud Architecture

```
GitHub Repository
    ↓
GitHub Actions (CI/CD) → Automatically deploy on push to main
    ↓
AWS Elastic Beanstalk (Backend API)
    ↓
AWS RDS (MySQL Database)
```

## File Structure

```
├── .ebextensions/
│   ├── nodecommand.config      # Elastic Beanstalk Node config
│   └── env.config              # Environment variables
├── .github/workflows/
│   └── deploy-aws.yml          # CI/CD pipeline
├── scripts/
│   ├── setup-aws.sh            # Linux/macOS setup
│   └── setup-aws.bat           # Windows setup
├── Dockerfile                  # Docker image for backend
└── docker-compose.yml          # Local Docker deployment
```

## Deployment Steps

### 1. **Push Code to GitHub**

```bash
git add .
git commit -m "Add cloud deployment"
git push origin main
```

### 2. **GitHub Actions Automatically Deploys**

- Triggered on push to `main` branch
- Builds backend application
- Tests application
- Uploads to S3
- Deploys to Elastic Beanstalk

### 3. **Access Your Application**

- API: `http://greatway-coop-backend-prod.us-east-1.elasticbeanstalk.com/api`
- Frontend: Download Electron installer or build web version

## Environment Variables

Required for AWS deployment (.env files):

```env
NODE_ENV=production
PORT=8080
DB_HOST=your-rds-endpoint.us-east-1.rds.amazonaws.com
DB_USER=admin
DB_PASSWORD=your-password
DB_NAME=greatway_coop
JWT_SECRET=your-secret-key
AWS_REGION=us-east-1
```

## Docker Deployment

### Local Testing with Docker

```bash
docker-compose up -d
```

Accesses:
- Backend API: http://localhost:3001
- MySQL: localhost:3306

### Push to AWS ECR (Optional)

```bash
aws ecr create-repository --repository-name greatway-coop-backend

docker build -t greatway-coop-backend:latest backend/
docker tag greatway-coop-backend:latest <account-id>.dkr.ecr.us-east-1.amazonaws.com/greatway-coop-backend:latest
docker push <account-id>.dkr.ecr.us-east-1.amazonaws.com/greatway-coop-backend:latest
```

## Cost Optimization

### Free Tier (Year 1)
- ✅ Elastic Beanstalk: 750 hours t2.micro/month
- ✅ RDS: 750 hours t3.micro/month + 20GB storage
- ✅ GitHub: Free
- **Total**: $0/month

### Production (Year 2+)
- Elastic Beanstalk t3.small: ~$40-60/month
- RDS t3.small: ~$35-45/month
- Storage & data transfer: ~$5-10/month
- **Total**: ~$80-115/month

### Cost Reduction Tips
1. Use Auto-scaling to stop instances when not in use
2. Use Reserved Instances for better pricing
3. Monitor CloudWatch for unused resources
4. Delete test environments
5. Use RDS backup retention of 1 day (not 7)

## Monitoring

### Cloud Watch Logs

```bash
aws logs tail /aws/elasticbeanstalk/greatway-coop-backend-prod --follow
```

### Current Deployment Status

```bash
aws elasticbeanstalk describe-environments \
  --environment-names greatway-coop-backend-prod \
  --query 'Environments[0].[Status,Health]'
```

## Troubleshooting

### Application Won't Deploy
1. Check GitHub Actions logs
2. Verify AWS credentials in GitHub Secrets
3. Check Elastic Beanstalk logs:
```bash
aws elasticbeanstalk request-environment-info \
  --environment-name greatway-coop-backend-prod \
  --info-type tail
```

### Database Connection Failed
1. Verify RDS security group allows port 3306
2. Test connection:
```bash
mysql -h your-rds-endpoint -u admin -p -e "SELECT 1;"
```
3. Check environment variables in Elastic Beanstalk

### Deployment is Slow
1. Check instance type (t2.micro is very slow)
2. Upgrade to t3.small or t3.medium
3. Enable caching in CloudFront

## Useful AWS CLI Commands

```bash
# View all resources
aws elasticbeanstalk describe-environments
aws rds describe-db-instances

# Deploy new version
aws elasticbeanstalk update-environment \
  --environment-name greatway-coop-backend-prod \
  --version-label "your-version-label"

# SSH into EC2 instance
aws ec2-instance-connect ssh --instance-id <id> --os-user ec2-user

# View logs
aws logs tail /aws/elasticbeanstalk/greatway-coop-backend-prod
```

## References

- [AWS Free Tier](https://aws.amazon.com/free/)
- [Elastic Beanstalk Documentation](https://docs.aws.amazon.com/elasticbeanstalk/)
- [RDS Documentation](https://docs.aws.amazon.com/rds/)
- [GitHub Actions Documentation](https://docs.github.com/en/actions)

---

**Status**: Ready for cloud deployment  
**Last Updated**: 2026-03-17
