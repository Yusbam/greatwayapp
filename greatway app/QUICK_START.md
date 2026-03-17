# QUICK START GUIDE

Get started with the Greatway Cooperative Member Management System in 5 minutes.

## Prerequisites
- Node.js 20+ installed
- MySQL 8.0+ running
- ~500MB free disk space

## 5-Minute Setup

### 1. Create MySQL Database (2 minutes)

Open MySQL command line:
```bash
mysql -u root -p
```

Run:
```sql
CREATE DATABASE greatway_coop CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
EXIT;
```

### 2. Import Schema (1 minute)

```bash
cd database/schema
mysql -u root -p greatway_coop < 01_init.sql
mysql -u root -p greatway_coop < 02_views.sql
mysql -u root -p greatway_coop < 03_sample_data.sql
cd ../..
```

### 3. Setup Backend (1 minute)

```bash
cd backend
npm install
cp .env.example .env
```

Edit `.env`:
```env
PORT=3001
DB_HOST=localhost
DB_USER=root
DB_PASSWORD=your_password
DB_NAME=greatway_coop
JWT_SECRET=my_secret_key
```

### 4. Setup Frontend (1 minute)

```bash
cd ../frontend
npm install
cp .env.example .env
```

### 5. Run Application

From root directory:
```bash
npm install
npm run dev
```

App opens at: http://localhost:3000

## First Login

**Username**: admin  
**Password**: hashedPassword123  
(Change this in production!)

## Next Steps

1. Read [SETUP_GUIDE.md](docs/SETUP_GUIDE.md) for detailed setup
2. Review [USER_GUIDE.md](docs/USER_GUIDE.md) for features
3. Check [API_DOCUMENTATION.md](docs/API_DOCUMENTATION.md) for API
4. See [IMPLEMENTATION_ROADMAP.md](docs/IMPLEMENTATION_ROADMAP.md) for development plan

## Getting Help

- Check [PROJECT_STRUCTURE.md](PROJECT_STRUCTURE.md) to understand the layout
- Review database schema in `database/schema/01_init.sql`
- Check backend routes in `backend/src/routes/`
- Review React components in `frontend/src/components/`

## Common Commands

```bash
# Development
npm run dev

# Backend only
npm run dev:backend

# Frontend only  
npm run dev:frontend

# Build for production
npm run build

# Run tests
npm test

# Database backup
mysqldump -u root -p greatway_coop > backup.sql
```

## Troubleshooting

**Error: Cannot connect to MySQL**
- Ensure MySQL is running
- Check `.env` credentials
- Verify database exists with: `mysql -u root -p -e "SHOW DATABASES;"`

**Port already in use**
- Change PORT in `backend/.env`
- Or kill process: `netstat -ano | findstr :3001` (Windows)

**Module not found**
- Delete `node_modules` and `package-lock.json`
- Run `npm install` again

---

**Ready to start? Run:** `npm run dev`
