# Cloud Deployment - Quick Reference Card

**Your application is ready for cloud deployment!**

---

## 🚀 5-Minute Cloud Setup

### Choose Your Cloud Provider

#### **AWS (Recommended) - Free Year 1**
```bash
# Windows
scripts/setup-aws.bat

# macOS/Linux
chmod +x scripts/setup-aws.sh
./scripts/setup-aws.sh
```

#### **Heroku - Quick Deploy**
```bash
npm install -g heroku
heroku login
heroku create greatway-coop-backend
git push heroku main
```

#### **DigitalOcean - Best Value**
See docs/CLOUD_SERVICES_COMPARISON.md

---

## 📋 Step-by-Step AWS Deployment

### 1. GitHub Setup (10 min)
```bash
cd "c:\Users\Yusbam\Desktop\greatway app"
git init
git add .
git commit -m "Initial commit"
git remote add origin https://github.com/YOUR_USERNAME/greatway-coop-management.git
git branch -M main
git push -u origin main
```

### 2. AWS Account (5 min)
- Create AWS account: https://aws.amazon.com
- Create user with access keys
- Save credentials securely

### 3. Automated AWS Setup (10 min)
```bash
# Windows
scripts/setup-aws.bat

# or macOS/Linux
./scripts/setup-aws.sh
```

This automatically creates:
- ✅ AWS S3 bucket
- ✅ RDS MySQL database
- ✅ Elastic Beanstalk application
- ✅ Environment variables

### 4. GitHub Secrets (5 min)
Go to GitHub → Settings → Secrets → Add:
- `AWS_ACCESS_KEY_ID`
- `AWS_SECRET_ACCESS_KEY`

### 5. Automatic Deployment (Happens on push)
```bash
git push origin main
```

GitHub Actions automatically:
1. Builds application
2. Runs tests
3. Deploys to AWS
4. Updates API endpoint

---

## 🔗 After Deployment

**API Endpoint**: `http://your-eb-environment.us-east-1.elasticbeanstalk.com/api`

**Update Frontend**:
```env
# frontend/.env.production
REACT_APP_API_URL=http://your-eb-environment.us-east-1.elasticbeanstalk.com/api
```

---

## 💰 Cost Summary

| Year | Cost | Note |
|------|------|------|
| **Year 1** | **$0** | AWS free tier |
| **Year 2+** | **$80-120/month** | After free tier |

### What's Included (Free Tier)
- ✅ EC2 t2.micro: 750 hrs/month (~1 instance)
- ✅ RDS t3.micro: 750 hrs/month + 20GB storage
- ✅ GitHub Actions: Unlimited (for public repos)

### Cost by Service
- Elastic Beanstalk: ~$40-60/month
- RDS MySQL: ~$20-40/month
- Other (S3, bandwidth): ~$5-10/month

---

## 📁 Cloud Files Created

**GitHub CI/CD**:
- `.github/workflows/deploy-aws.yml` - Automatic deployment

**AWS Configuration**:
- `backend/.ebextensions/nodecommand.config` - Node.js settings
- `backend/.ebextensions/env.config` - Environment variables

**Docker** (Optional):
- `backend/Dockerfile` - Container image
- `docker-compose.yml` - Local development

**Setup Scripts**:
- `scripts/setup-aws.sh` - Linux/macOS setup
- `scripts/setup-aws.bat` - Windows setup

---

## 📚 Documentation

| Document | Purpose |
|----------|---------|
| [CLOUD_DEPLOYMENT.md](CLOUD_DEPLOYMENT.md) | Cloud deployment overview |
| [docs/AWS_DEPLOYMENT_GUIDE.md](docs/AWS_DEPLOYMENT_GUIDE.md) | Detailed AWS setup (40+ pages) |
| [docs/CLOUD_SERVICES_COMPARISON.md](docs/CLOUD_SERVICES_COMPARISON.md) | Compare cloud providers |
| [docs/GITHUB_SETUP.md](docs/GITHUB_SETUP.md) | GitHub setup instructions |

---

## ✅ Pre-Deployment Checklist

- [ ] All your code is committed
- [ ] `.env` files are in `.gitignore`
- [ ] Backend builds successfully: `cd backend && npm run build`
- [ ] Database schema is finalized
- [ ] AWS account created
- [ ] AWS credentials saved securely
- [ ] GitHub repository created
- [ ] Code pushed to GitHub main branch
- [ ] GitHub secrets added (AWS credentials)
- [ ] Ready to run setup script

---

## 🎯 Common Tasks

### Deploy New Changes
```bash
git add .
git commit -m "Your changes"
git push origin main
# GitHub Actions automatically deploys!
```

### View Deployment Logs
```bash
# GitHub Actions
Go to: GitHub → Actions → Latest Run

# AWS Elastic Beanstalk
aws elasticbeanstalk request-environment-info \
  --environment-name greatway-coop-backend-prod \
  --info-type tail
```

### Check API Health
```bash
curl https://your-endpoint.elasticbeanstalk.com/health
```

### Update Environment Variables
1. GitHub: Update deployment workflow
2. AWS Console: Update Elastic Beanstalk environment
3. Re-deploy: `git push` triggers automatic deployment

### Rollback to Previous Version
```bash
aws elasticbeanstalk update-environment \
  --environment-name greatway-coop-backend-prod \
  --version-label <previous-label>
```

---

## 🐛 Troubleshooting

### Deployment Fails
1. Check GitHub Actions logs
2. Verify AWS credentials in secrets
3. Check backend builds locally: `npm run build`

### Database Connection Error
```bash
# Test connection
mysql -h your-rds-endpoint.amazonaws.com -u admin -p
# Should connect successfully
```

### API Returns 500 Error
```bash
# Check Elastic Beanstalk logs
aws elasticbeanstalk request-environment-info \
  --environment-name greatway-coop-backend-prod \
  --info-type tail

aws elasticbeanstalk retrieve-environment-info \
  --environment-name greatway-coop-backend-prod \
  --info-type tail
```

See [docs/AWS_DEPLOYMENT_GUIDE.md](docs/AWS_DEPLOYMENT_GUIDE.md#troubleshooting) for more solutions.

---

## 🔐 Security Checklist

- [ ] Strong database password (20+ chars)
- [ ] JWT_SECRET is long and random
- [ ] AWS credentials in GitHub Secrets (not code)
- [ ] RDS backup retention enabled
- [ ] HTTPS/TLS enabled
- [ ] Regular database backups

---

## 📞 Support Resources

- AWS Support: https://console.aws.amazon.com/support/
- GitHub Help: https://docs.github.com/
- Email: support@greatwaycoop.com (future)

---

## 🎉 Success Indicators

Once deployed, you should see:
1. ✅ GitHub Actions "Deploy to Elastic Beanstalk" completes
2. ✅ Elastic Beanstalk shows "Green" health status
3. ✅ API returns 200 from `/api/health`
4. ✅ RDS shows "available" status
5. ✅ No errors in Elastic Beanstalk logs

---

**Start deployment**: Run `scripts/setup-aws.bat` or Read [docs/AWS_DEPLOYMENT_GUIDE.md](docs/AWS_DEPLOYMENT_GUIDE.md)

**Questions?** Check [CLOUD_DEPLOYMENT.md](CLOUD_DEPLOYMENT.md) or contact support.
