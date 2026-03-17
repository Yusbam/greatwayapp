# GitHub Setup Guide

Push your code to GitHub repository for cloud deployment and version control.

## Step 1: Create GitHub Repository

### A. Create Repository on GitHub

1. Go to **https://github.com/new**
2. Fill in:
   - **Repository name**: `greatway-coop-management`
   - **Description**: "Member Management System for Greatway Cooperative"
   - **Visibility**: Choose **Public** (for free actions) or **Private**
   - **Initialize with**: Leave empty (we'll push existing code)
3. Click **Create repository**

### B. Copy Repository URL

After creation, you'll see:
```
https://github.com/YOUR_USERNAME/greatway-coop-management.git
```

---

## Step 2: Setup Git Locally

### Initialize Repository

```bash
cd "c:\Users\Yusbam\Desktop\greatway app"

# Initialize git if not already
git init

# Add remote
git remote add origin https://github.com/YOUR_USERNAME/greatway-coop-management.git

# Verify
git remote -v
```

---

## Step 3: Configure Git User

```bash
git config user.name "Your Name"
git config user.email "your.email@example.com"

# Make it global (for all repos)
git config --global user.name "Your Name"
git config --global user.email "your.email@example.com"
```

---

## Step 4: Create .gitignore

File should already exist, but verify it includes:

```
# Dependencies
node_modules/
npm-debug.log*
yarn-debug.log*
yarn-error.log*

# Build output
dist/
build/
out/

# Environment
.env
.env.local
.env.production
.env.*.local

# IDE
.vscode/
.idea/
*.swp
*.swo
*~
.DS_Store

# Database backups
*.sql
backup.sql

# OS
Thumbs.db

# Logs
logs/
*.log
```

---

## Step 5: First Commit

```bash
# Check status
git status

# Add all files
git add .

# Create commit
git commit -m "Initial commit: Greatway Cooperative Member Management System

- Frontend: Electron + React + TypeScript
- Backend: Express + TypeScript + MySQL
- Database: Complete schema with views
- Documentation: Setup guides, API docs, roadmap
- Cloud: AWS deployment configuration
"

# Verify
git log --oneline
```

---

## Step 6: Push to GitHub

### First Push

```bash
# Push main branch
git branch -M main
git push -u origin main

# Verify
git branch -a
```

### Subsequent Pushes

```bash
git add .
git commit -m "Your commit message"
git push
```

---

## Step 7: Add GitHub Secrets (For AWS Deployment)

### A. Generate AWS Access Keys

1. Go to **AWS Console** → **IAM** → **Users**
2. Select your user → **Security credentials**
3. Create **Access key** (save these securely)

### B. Add to GitHub

1. Go to GitHub repository
2. **Settings** → **Secrets and variables** → **Actions** → **New repository secret**

Add these secrets:

| Secret Name | Value |
|-------------|-------|
| `AWS_ACCESS_KEY_ID` | Your AWS access key ID |
| `AWS_SECRET_ACCESS_KEY` | Your AWS secret access key |
| `AWS_REGION` | `us-east-1` |

**Important**: Keep these secret! Never commit to repo.

---

## Step 8: Verify CI/CD Pipeline

### A. Check GitHub Actions

1. Go to repository → **Actions** tab
2. You should see workflow runs trigger on each push
3. Workflow file: `.github/workflows/deploy-aws.yml`

### B. Wait for Deployment

First deployment may take 10-15 minutes:
- ✅ Tests run
- ✅ Build completes
- ✅ Deploy to AWS
- ✅ Environment info displays

### C. Get API Endpoint

After successful deployment:
1. Check Actions output
2. Look for Elastic Beanstalk CNAME
3. API URL: `http://<CNAME>/api`

---

## Troubleshooting

### "fatal: not a git repository"

```bash
# Initialize git
git init
git remote add origin https://github.com/YOUR_USERNAME/greatway-coop-management.git
```

### "Authentication failed"

**Option 1: Use Personal Access Token**
```bash
# Create token on GitHub
# Settings → Developer settings → Personal access tokens → Generate new token

git remote set-url origin https://YOUR_TOKEN@github.com/YOUR_USERNAME/greatway-coop-management.git
git push
```

**Option 2: SSH Key (Recommended)**
```bash
# Generate SSH key
ssh-keygen -t ed25519 -C "your.email@example.com"

# Add to GitHub
# Settings → SSH and GPG keys → Add SSH key
```

### "Your branch is ahead of origin"

This is fine! Just push:
```bash
git push
```

### "Merge conflict"

```bash
# Pull latest
git pull origin main

# Resolve conflicts in files
# Then commit
git add .
git commit -m "Resolve conflicts"
git push
```

---

## Useful Git Commands

```bash
# Check status
git status

# View changes
git diff

# View commits
git log --oneline -10

# Create branch
git checkout -b feature/your-feature

# Switch branch
git checkout main

# Merge branch
git merge feature/your-feature

# Delete branch
git branch -d feature/your-feature

# Undo last commit (keep changes)
git reset --soft HEAD~1

# Undo changes to file
git checkout -- filename.ts
```

---

## Branching Strategy

```
main (production)
  ↓
develop (staging)
  ↓
feature/member-management
feature/loan-system
feature/dashboard
  ↓
Individual commits
```

### Create Feature Branch

```bash
git checkout -b feature/member-management
# Make changes
git add .
git commit -m "Add member CRUD endpoints"
git push origin feature/member-management

# Create Pull Request on GitHub
```

---

## GitHub Issues & Projects

### Track Development

1. Go to **Issues** tab
2. Create issue:
   - `[BACKEND] Implement member controller`
   - `[FRONTEND] Build dashboard`
   - `[DATABASE] Optimize queries`

3. Use **Projects** to track progress:
   - Backlog
   - In Progress
   - In Review
   - Done

### Link to Code

```bash
git commit -m "Implement member controller - fixes #123"
# This closes Issue #123
```

---

## Repository Settings

### Protect Main Branch

1. **Settings** → **Branches**
2. Add rule for `main`
3. Require:
   - ✅ Pull request reviews
   - ✅ Dismiss stale reviews
   - ✅ Require status checks (tests)
   - ✅ Require branches to be up to date

### Enable GitHub Pages

For documentation:
1. **Settings** → **Pages**
2. Source: `main` → `docs`
3. GitHub will host your docs at `https://your-username.github.io/greatway-coop-management/`

---

## Continuous Deployment

Your workflow automatically:
1. Tests code on push
2. Builds application
3. Deploys to AWS Elastic Beanstalk
4. Updates RDS database schema (if needed)

See `.github/workflows/deploy-aws.yml` for details.

---

## Next Steps

1. **Create GitHub account** (if needed)
2. **Create repository**
3. **Push code**:
   ```bash
   git init
   git add .
   git commit -m "Initial commit"
   git remote add origin https://github.com/YOUR_USERNAME/greatway-coop-management.git
   git push -u origin main
   ```
4. **Add AWS secrets** for CI/CD
5. **Monitor deployment** in Actions tab

---

## Resources

- [GitHub Documentation](https://docs.github.com)
- [Git Command Reference](https://git-scm.com/docs)
- [GitHub Actions](https://docs.github.com/en/actions)
- [GitHub Secrets](https://docs.github.com/en/actions/security-guides/encrypted-secrets)

---

**Ready to push?** Follow the steps above!
