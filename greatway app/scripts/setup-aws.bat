@echo off
REM AWS Cloud Setup Script for Greatway Cooperative (Windows)

echo ========================================
echo Greatway Cooperative - AWS Cloud Setup
echo ========================================
echo.

REM Check if AWS CLI is installed
where aws >nul 2>nul
if %ERRORLEVEL% NEQ 0 (
    echo Error: AWS CLI is not installed. Please install it first.
    echo Download from: https://aws.amazon.com/cli/
    exit /b 1
)

setlocal enabledelayedexpansion

set REGION=us-east-1
set APP_NAME=greatway-coop
set DB_INSTANCE=greatway-coop-db
set ENVIRONMENT=greatway-coop-backend-prod

for /f "tokens=1" %%a in ('powershell -NoProfile -Command "Get-Random"') do set TIMESTAMP=%%a
set BUCKET_NAME=greatway-coop-deployments-%TIMESTAMP%

echo.
echo Enter your AWS details:

set /p PROFILE="AWS Profile (default: default): "
if "!PROFILE!"=="" set PROFILE=default

set /p AWS_KEY_ID="AWS Access Key ID: "
set /p AWS_SECRET="AWS Secret Access Key: "

REM Set environment variables
set AWS_ACCESS_KEY_ID=%AWS_KEY_ID%
set AWS_SECRET_ACCESS_KEY=%AWS_SECRET%
set AWS_DEFAULT_REGION=%REGION%

echo.
echo [1/5] Creating S3 bucket for deployments...
aws s3 mb s3://%BUCKET_NAME% --region %REGION%
if %ERRORLEVEL% EQU 0 (
    echo S3 bucket created: %BUCKET_NAME%
) else (
    echo S3 bucket may already exist
)

echo.
echo [2/5] Creating RDS MySQL instance...
set /p DB_PASSWORD="Enter MySQL master password: "

aws rds create-db-instance ^
    --db-instance-identifier %DB_INSTANCE% ^
    --db-instance-class db.t3.micro ^
    --engine mysql ^
    --engine-version 8.0.35 ^
    --master-username admin ^
    --master-user-password %DB_PASSWORD% ^
    --allocated-storage 20 ^
    --storage-type gp3 ^
    --publicly-accessible ^
    --backup-retention-period 7 ^
    --region %REGION%

if %ERRORLEVEL% EQU 0 (
    echo RDS instance creation initiated
) else (
    echo RDS instance may already exist
)

echo Waiting for RDS instance to be available (this may take 10 minutes)...
aws rds wait db-instance-available ^
    --db-instance-identifier %DB_INSTANCE% ^
    --region %REGION%

echo RDS instance ready

echo.
echo [3/5] Getting RDS endpoint...
for /f "delims=" %%i in ('aws rds describe-db-instances --db-instance-identifier %DB_INSTANCE% --query "DBInstances[0].Endpoint.Address" --output text --region %REGION%') do set RDS_ENDPOINT=%%i

echo RDS Endpoint: %RDS_ENDPOINT%

echo.
echo [4/5] Creating Elastic Beanstalk application...
aws elasticbeanstalk create-application ^
    --application-name %APP_NAME% ^
    --region %REGION%

if %ERRORLEVEL% EQU 0 (
    echo Elastic Beanstalk application created
) else (
    echo Application may already exist
)

echo.
echo [5/5] Creating Elastic Beanstalk environment...
aws elasticbeanstalk create-environment ^
    --application-name %APP_NAME% ^
    --environment-name %ENVIRONMENT% ^
    --solution-stack-name "64bit Amazon Linux 2 v5.9.8 running Node.js 20" ^
    --option-settings ^
        Namespace=aws:ec2:instances,OptionName=InstanceTypes,Value=t2.micro,t3.micro ^
        Namespace=aws:autoscaling:asg,OptionName=MinSize,Value=1 ^
        Namespace=aws:autoscaling:asg,OptionName=MaxSize,Value=2 ^
    --region %REGION%

if %ERRORLEVEL% EQU 0 (
    echo Elastic Beanstalk environment created
) else (
    echo Environment may already exist
)

echo Waiting for environment to be ready (this may take 5-10 minutes)...
aws elasticbeanstalk wait environment-exists ^
    --environment-names %ENVIRONMENT% ^
    --region %REGION%

echo.
echo Getting environment CNAME...
for /f "delims=" %%i in ('aws elasticbeanstalk describe-environments --environment-names %ENVIRONMENT% --query "Environments[0].CNAME" --output text --region %REGION%') do set ENVIRONMENT_CNAME=%%i

echo.
echo ========================================
echo AWS SETUP COMPLETE!
echo ========================================
echo.
echo Summary:
echo   AWS Region: %REGION%
echo   S3 Bucket: %BUCKET_NAME%
echo   RDS Endpoint: %RDS_ENDPOINT%
echo   RDS Instance: %DB_INSTANCE%
echo   EB Application: %APP_NAME%
echo   EB Environment: %ENVIRONMENT%
echo   EB CNAME: %ENVIRONMENT_CNAME%
echo.
echo Next Steps:
echo   1. Initialize database:
echo      mysql -h %RDS_ENDPOINT% -u admin -p^<password^> ^< database\schema\01_init.sql
echo.
echo   2. Add GitHub Secrets:
echo      - AWS_ACCESS_KEY_ID
echo      - AWS_SECRET_ACCESS_KEY
echo.
echo   3. Push code to GitHub
echo.
echo API Endpoint: http://%ENVIRONMENT_CNAME%/api
echo.

pause
