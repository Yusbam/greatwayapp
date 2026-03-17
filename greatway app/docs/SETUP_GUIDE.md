# SETUP GUIDE - Greatway Cooperative Member Management System

## System Requirements

- Node.js 20.0.0 or higher
- npm 10.0.0 or higher
- MySQL 8.0 or higher
- Windows, macOS, or Linux operating system
- Minimum 4GB RAM
- 500MB free disk space

## Installation Steps

### 1. Clone/Extract Project

```bash
cd greatway app
```

### 2. Install Root Dependencies

```bash
npm install
```

### 3. Setup Database

#### Create MySQL Database

```bash
mysql -u root -p
```

Then run in MySQL shell:
```sql
CREATE DATABASE greatway_coop CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
```

#### Initialize Database Schema

```bash
cd database
npm install
npm run init
npm run migrate
cd ..
```

Or manually import the SQL files:
```bash
mysql -u root -p greatway_coop < database/schema/01_init.sql
mysql -u root -p greatway_coop < database/schema/02_views.sql
mysql -u root -p greatway_coop < database/schema/03_sample_data.sql
```

### 4. Setup Backend

```bash
cd backend
npm install
```

Create `.env` file:
```env
PORT=3001
NODE_ENV=development
DB_HOST=localhost
DB_USER=root
DB_PASSWORD=your_mysql_password
DB_NAME=greatway_coop
JWT_SECRET=your_secret_jwt_key
LOG_LEVEL=info
```

### 5. Setup Frontend

```bash
cd ../frontend
npm install
```

Create `.env` file:
```env
REACT_APP_API_URL=http://localhost:3001/api
REACT_APP_ENV=development
```

## Running the Application

### Development Mode

From the root directory:

```bash
npm run dev
```

This will start:
- Backend API on http://localhost:3001
- Frontend React dev server on http://localhost:3000
- Electron desktop window

Alternative - run components separately:

```bash
# Terminal 1: Backend only
npm run dev:backend

# Terminal 2: Frontend only
npm run dev:frontend
```

### Production Build

```bash
npm run build
```

Output will be in the `build/` directory.

## First Time Setup

1. **Create admin account**
   - The database comes with a sample admin user
   - Username: `admin`
   - Password: `hashedPassword123`

2. **Add officers**
   - Go to Settings → Officers
   - Create new officer accounts for your team

3. **Verify database connection**
   - Backend will show "Server running on port 3001"
   - Check API health: http://localhost:3001/health

4. **Test the application**
   - Login with admin credentials
   - Navigate through dashboard to verify functionality

## Configuration

### Backend Configuration

Edit `backend/.env`:
- `PORT`: API server port
- `DB_HOST`: MySQL server host
- `DB_USER`: MySQL username
- `DB_PASSWORD`: MySQL password
- `DB_NAME`: Database name
- `JWT_SECRET`: Secret for JWT tokens
- `NODE_ENV`: Set to 'production' for production

### Frontend Configuration

Edit `frontend/.env`:
- `REACT_APP_API_URL`: Backend API URL
- `REACT_APP_ENV`: Environment (development/production)

## Troubleshooting

### MySQL Connection Error
```
Error: connect ECONNREFUSED 127.0.0.1:3306
```
- Ensure MySQL is running
- Check connection credentials in `.env`
- Verify database name is created

### Port Already in Use
```
Error: listen EADDRINUSE: address already in use :::3001
```
- Change PORT in backend `.env`
- Or kill the existing process using the port

### Module Not Found
```
Error: Cannot find module 'express'
```
- Run `npm install` in the appropriate directory
- Delete `node_modules` and `package-lock.json`, then reinstall

### Electron Won't Start
- Ensure React dev server is running on port 3000
- Check `.env` files are correctly configured
- Try clearing electron cache: `rm -rf node_modules/electron`

## Database Backup

```bash
# Backup
mysqldump -u root -p greatway_coop > backup.sql

# Restore
mysql -u root -p greatway_coop < backup.sql
```

## Next Steps

1. Read [USER_GUIDE.md](USER_GUIDE.md) for application usage
2. Customize branding in `frontend/src/components/`
3. Configure SMTP for email notifications
4. Set up regular database backups
5. Configure user roles and permissions

## Support

For issues or questions:
1. Check error logs in `backend/logs/`
2. Review browser console for frontend errors
3. Contact development team for assistance
