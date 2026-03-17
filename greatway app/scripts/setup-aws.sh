#!/bin/bash

# AWS Cloud Setup Script for Greatway Cooperative
# This script automates AWS resource creation

set -e

echo "🚀 Greatway Cooperative - AWS Cloud Setup"
echo "=========================================="

# Check prerequisites
if ! command -v aws &> /dev/null; then
    echo "❌ AWS CLI is not installed. Please install it first."
    exit 1
fi

# Variables
REGION="us-east-1"
APP_NAME="greatway-coop"
DB_INSTANCE="greatway-coop-db"
ENVIRONMENT="greatway-coop-backend-prod"
BUCKET_NAME="greatway-coop-deployments-$(date +%s)"

echo ""
echo "📝 Enter your AWS details:"
read -p "AWS Profile (default: default): " PROFILE
PROFILE=${PROFILE:-default}

read -sp "AWS Access Key ID: " AWS_KEY_ID
echo ""
read -sp "AWS Secret Access Key: " AWS_SECRET
echo ""

# Configure AWS credentials
export AWS_ACCESS_KEY_ID=$AWS_KEY_ID
export AWS_SECRET_ACCESS_KEY=$AWS_SECRET
export AWS_DEFAULT_REGION=$REGION

echo ""
echo "✅ AWS credentials configured"

# Step 1: Create S3 bucket for deployments
echo ""
echo "📦 Creating S3 bucket for deployments..."
aws s3 mb s3://$BUCKET_NAME --region $REGION || true
echo "✅ S3 bucket created: $BUCKET_NAME"

# Step 2: Create RDS MySQL Instance
echo ""
echo "🗄️  Creating RDS MySQL instance (this may take 5-10 minutes)..."

read -sp "Enter MySQL master password: " DB_PASSWORD
echo ""

aws rds create-db-instance \
    --db-instance-identifier $DB_INSTANCE \
    --db-instance-class db.t3.micro \
    --engine mysql \
    --engine-version 8.0.35 \
    --master-username admin \
    --master-user-password "$DB_PASSWORD" \
    --allocated-storage 20 \
    --storage-type gp3 \
    --publicly-accessible \
    --backup-retention-period 7 \
    --region $REGION \
    --no-copy-tags-from-source || echo "RDS instance may already exist"

echo "⏳ Waiting for RDS instance to be available (this may take 10 minutes)..."
aws rds wait db-instance-available \
    --db-instance-identifier $DB_INSTANCE \
    --region $REGION

echo "✅ RDS MySQL instance created"

# Get RDS endpoint
RDS_ENDPOINT=$(aws rds describe-db-instances \
    --db-instance-identifier $DB_INSTANCE \
    --query 'DBInstances[0].Endpoint.Address' \
    --output text \
    --region $REGION)

echo "📍 RDS Endpoint: $RDS_ENDPOINT"

# Step 3: Create Elastic Beanstalk Application
echo ""
echo "🚀 Creating Elastic Beanstalk application..."

aws elasticbeanstalk create-application \
    --application-name $APP_NAME \
    --region $REGION || echo "Application may already exist"

echo "✅ Elastic Beanstalk application created"

# Step 4: Create Environment
echo ""
echo "🌍 Creating Elastic Beanstalk environment..."

aws elasticbeanstalk create-environment \
    --application-name $APP_NAME \
    --environment-name $ENVIRONMENT \
    --solution-stack-name "64bit Amazon Linux 2 v5.9.8 running Node.js 20" \
    --option-settings \
        Namespace=aws:ec2:instances,OptionName=InstanceTypes,Value=t2.micro,t3.micro \
        Namespace=aws:autoscaling:asg,OptionName=MinSize,Value=1 \
        Namespace=aws:autoscaling:asg,OptionName=MaxSize,Value=2 \
    --region $REGION || echo "Environment may already exist"

echo "⏳ Waiting for environment to be ready (this may take 5-10 minutes)..."
aws elasticbeanstalk wait environment-exists \
    --environment-names $ENVIRONMENT \
    --region $REGION

echo "✅ Elastic Beanstalk environment created"

# Get environment CNAME
ENVIRONMENT_CNAME=$(aws elasticbeanstalk describe-environments \
    --environment-names $ENVIRONMENT \
    --query 'Environments[0].CNAME' \
    --output text \
    --region $REGION)

echo "🌐 Environment CNAME: $ENVIRONMENT_CNAME"

# Step 5: Create .env.production file
echo ""
echo "📝 Creating environment configuration..."

cat > .env.production << EOF
NODE_ENV=production
PORT=8080
DB_HOST=$RDS_ENDPOINT
DB_USER=admin
DB_PASSWORD=$DB_PASSWORD
DB_NAME=greatway_coop
JWT_SECRET=$(openssl rand -base64 32)
LOG_LEVEL=info
CORS_ORIGIN=*
AWS_REGION=$REGION
EOF

echo "✅ Environment configuration created (.env.production)"

# Step 6: Display summary
echo ""
echo "✅ AWS SETUP COMPLETE!"
echo "=========================================="
echo ""
echo "📋 Summary:"
echo "   AWS Region: $REGION"
echo "   S3 Bucket: $BUCKET_NAME"
echo "   RDS Endpoint: $RDS_ENDPOINT"
echo "   RDS Instance: $DB_INSTANCE"
echo "   Elastic Beanstalk App: $APP_NAME"
echo "   EB Environment: $ENVIRONMENT"
echo "   EB CNAME: $ENVIRONMENT_CNAME"
echo ""
echo "🔑 Next Steps:"
echo "   1. Initialize RDS database:"
echo "      mysql -h $RDS_ENDPOINT -u admin -p < database/schema/01_init.sql"
echo ""
echo "   2. Add GitHub Secrets:"
echo "      - AWS_ACCESS_KEY_ID"
echo "      - AWS_SECRET_ACCESS_KEY"
echo ""
echo "   3. Push to GitHub to trigger deployment"
echo ""
echo "🔗 API Endpoint: http://$ENVIRONMENT_CNAME/api"
echo ""
