# Cloud Services Overview

Choose the cloud platform that best fits your needs.

## Options Comparison

### 1. **AWS (Amazon Web Services)** ✅ RECOMMENDED
**Best for**: Production deployments, scalability, complex requirements

| Feature | Details |
|---------|---------|
| **Services** | Elastic Beanstalk, RDS, S3, CloudFront |
| **Free Tier** | 750 hours EC2 + RDS, 20GB storage |
| **Cost (Year 1)** | Free |
| **Cost (Year 2+)** | $80-120/month |
| **Scalability** | Excellent |
| **Learning Curve** | Moderate |
| **Best For** | Large deployments, complex requirements |

**Setup Command:**
```bash
# Windows
scripts/setup-aws.bat

# macOS/Linux
./scripts/setup-aws.sh
```

**Documentation**: [AWS_DEPLOYMENT_GUIDE.md](docs/AWS_DEPLOYMENT_GUIDE.md)

---

### 2. **Heroku**
**Best for**: Quick deployment, simple apps, beginners

| Feature | Details |
|---------|---------|
| **Services** | Dynos, Postgres, Add-ons |
| **Free Tier** | Limited (moved to paid-only in 2022) |
| **Cost (Year 1)** | $50-100/month |
| **Cost (Year 2+)** | $50-100/month |
| **Scalability** | Good |
| **Learning Curve** | Very Easy |
| **Best For** | Quick MVP, learning |

**Setup:**
```bash
# Install Heroku CLI
npm install -g heroku

# Login and deploy
heroku login
heroku create greatway-coop-backend
git push heroku main
```

**Cost**: Dynos start at $5/month, Postgres at $9/month

---

### 3. **Google Cloud Platform (GCP)**
**Best for**: Data analytics, Google services integration

| Feature | Details |
|---------|---------|
| **Services** | Cloud Run, Cloud SQL, App Engine |
| **Free Tier** | 90 days, $300 credits |
| **Cost (Year 1)** | Free (with credits) |
| **Cost (Year 2+)** | $50-150/month |
| **Scalability** | Excellent |
| **Learning Curve** | Moderate |
| **Best For** | Analytics, ML workloads |

---

### 4. **Microsoft Azure**
**Best for**: Microsoft ecosystem, enterprise customers

| Feature | Details |
|---------|---------|
| **Services** | App Service, Azure Database |
| **Free Tier** | 12 months, $200 credits |
| **Cost (Year 1)** | Free (with credits) |
| **Cost (Year 2+)** | $60-140/month |
| **Scalability** | Excellent |
| **Learning Curve** | Moderate-High |
| **Best For** | Enterprise, Windows integration |

---

### 5. **DigitalOcean**
**Best for**: Developers, simple VPS, good pricing

| Feature | Details |
|---------|---------|
| **Services** | Droplets, Managed Databases, App Platform |
| **Free Tier** | $5 app/month trial |
| **Cost (Year 1)** | $5-60/month |
| **Cost (Year 2+)** | $5-60/month |
| **Scalability** | Good |
| **Learning Curve** | Very Easy |
| **Best For** | Small-medium apps, developers |

**Setup:**
```bash
# Install doctl
doctl auth init
doctl apps create --spec app.yaml
```

---

## Quick Deployment Matrix

| Need | Best Option | Cost |
|------|-------------|------|
| **Free & scalable** | AWS Free Tier | $0-80/month |
| **Quick MVP** | Heroku | $50+/month |
| **Best value** | DigitalOcean | $5-60/month |
| **Enterprise** | Azure | $100+/month |
| **Data-heavy** | GCP | $0 (credits) |

---

## Deployment Comparison

### AWS (Current Setup)
```
GitHub → GitHub Actions → S3 → Elastic Beanstalk
                                    ↓
                              RDS MySQL
```
- **Pros**: Scalable, free tier generous, AWS ecosystem
- **Cons**: Complex setup, learning curve

### Heroku
```
GitHub → Heroku Buildpack → Heroku Dyno
                                ↓
                         Heroku Postgres
```
- **Pros**: Simple, instant deployment, easy scaling
- **Cons**: Expensive after free tier, less control

### DigitalOcean
```
GitHub → DigitalOcean → App Platform → DigitalOcean Database
```
- **Pros**: Developer-friendly, good pricing, simple
- **Cons**: Less scalability than big providers

---

## Production Recommendations

### **For Greatway Cooperative**

**Recommended**: AWS (Current Setup)
- Generous free tier for 12 months
- Scales from 500 to 2000 members easily
- Pay-as-you-go after free tier
- Professional appearance

**Budget over 3 years**:
- Year 1: $0 (free tier)
- Year 2: ~$100/month = $1,200
- Year 3: ~$100/month = $1,200
- **Total**: ~$2,400

**Alternative**: DigitalOcean
- Simpler setup
- Fixed pricing ($12/month minimum)
- Better for small organizations
- Total 3-year cost: ~$400

---

## Next Steps

### Choose Your Cloud Platform

#### 1. **Using AWS** (Recommended)
```bash
# Automated setup
scripts/setup-aws.bat        # Windows
./scripts/setup-aws.sh       # macOS/Linux
```
See: [AWS_DEPLOYMENT_GUIDE.md](docs/AWS_DEPLOYMENT_GUIDE.md)

#### 2. **Using Heroku**
Create `Procfile`:
```
web: cd backend && npm start
```

Deploy:
```bash
heroku login
heroku create
git push heroku main
```

#### 3. **Using DigitalOcean**
See: [DigitalOcean Documentation](https://docs.digitalocean.com)

#### 4. **Using GCP**
See: [GCP Documentation](https://cloud.google.com/docs)

---

## Cost Calculators

- **AWS Pricing**: https://calculator.aws/
- **Heroku Pricing**: https://www.heroku.com/pricing
- **GCP Pricing**: https://cloud.google.com/pricing
- **Azure Pricing**: https://azure.microsoft.com/pricing/calculator/
- **DigitalOcean Pricing**: https://www.digitalocean.com/pricing

---

## Migration Between Clouds

If you change cloud providers later:

1. **Code**: No changes needed (Docker-compatible)
2. **Database**: Export SQL, import to new cloud
3. **Secrets**: Update environment variables
4. **DNS**: Update domain records

**Database backup before migration:**
```bash
mysqldump -h old-server -u admin -p greatway_coop > backup.sql
mysql -h new-server -u admin -p greatway_coop < backup.sql
```

---

## Security Considerations

For all cloud providers:

- ✅ Use HTTPS/TLS encryption
- ✅ Set strong database passwords
- ✅ Enable backups and point-in-time recovery
- ✅ Use VPC/private networks where possible
- ✅ Regular security audits
- ✅ 2FA on cloud accounts
- ✅ Encryption at rest and in transit

See [docs/AWS_DEPLOYMENT_GUIDE.md](docs/AWS_DEPLOYMENT_GUIDE.md#security) for detailed security setup.

---

## Support & Community

| Provider | Community | Support |
|----------|-----------|---------|
| AWS | Huge | Excellent (24/7 paid) |
| Heroku | Large | Good (support) |
| GCP | Large | Excellent (24/7 paid) |
| Azure | Large | Excellent (24/7 paid) |
| DigitalOcean | Growing | Good (24/7 paid) |

---

## Ready to Deploy?

**Start with AWS (recommended)**:
```bash
# Read the guide
cat docs/AWS_DEPLOYMENT_GUIDE.md

# Run setup
scripts/setup-aws.bat        # Windows
./scripts/setup-aws.sh       # Linux/macOS
```

**Questions?** Check [CLOUD_DEPLOYMENT.md](CLOUD_DEPLOYMENT.md)
