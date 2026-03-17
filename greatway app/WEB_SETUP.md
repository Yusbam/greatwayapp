# Web Application Setup Instructions

## Overview

This application has been converted from an Electron desktop app to a modern web application with Azure Blob Storage for file management.

## Architecture Changes

### Before (Electron Desktop)
- Electron app running on user's desktop
- Local file storage
- No cloud integration

### After (Web Application)
- React frontend served over HTTP
- Express backend API
- Azure Blob Storage for file management
- Can be deployed to any web server or cloud platform

## Quick Start - Web Development

### 1. Install Dependencies

```bash
npm install
```

### 2. Configure Azure

Follow the instructions in [AZURE_SETUP.md](./AZURE_SETUP.md) to:
- Create Azure Storage Account
- Get connection string
- Create blob container
- Set environment variables

### 3. Setup Backend Environment

Create `.env` file in `backend/` directory:

```env
AZURE_STORAGE_CONNECTION_STRING=<your-connection-string>
AZURE_STORAGE_ACCOUNT_NAME=<your-account>
AZURE_STORAGE_ACCOUNT_KEY=<your-key>
PORT=3001
DB_HOST=localhost
DB_USER=root
DB_PASSWORD=password
DB_NAME=greatway
JWT_SECRET=your-secret-key
```

### 4. Setup Database

```bash
npm run db:setup
npm run db:migrate
```

### 5. Run Development Server

Terminal 1 - Backend:
```bash
npm run dev:backend
```

Terminal 2 - Frontend:
```bash
npm run dev:frontend
```

The application will be available at `http://localhost:3000`

## Building for Production

### Frontend Build
```bash
npm run build:frontend
```

This creates optimized static files in `frontend/build/`

### Backend Build
```bash
npm run build:backend
```

This compiles TypeScript to JavaScript in `backend/dist/`

### Docker Deployment

Build Docker image:
```bash
docker-compose build
```

Run with Docker:
```bash
docker-compose up
```

## File Upload Handling

Files are now handled through the backend API:

1. Frontend sends file to `/api/upload` endpoint via FormData
2. Backend receives file in memory (via multer)
3. Backend uploads to Azure Blob Storage
4. Server returns permanent Azure URL to frontend
5. Frontend displays file link from Azure

## Deployment Options

### Option 1: Azure App Service
- Deploy backend to Azure App Service
- Serve frontend from Azure Static Web Apps or Azure CDN
- Use Azure Storage for file management

### Option 2: Docker + Azure Container Instances
- Containerize both frontend and backend
- Deploy to Azure Container Instances
- Use Azure Storage for file management

### Option 3: Traditional VPS/Cloud Server
- Deploy to any server with Node.js runtime
- Serve frontend with Nginx or Apache
- Use Azure Storage Blob for file management

## Key Features Enabled

✅ Web-based access from any browser
✅ Cross-platform (works on Mac, Windows, Linux)
✅ Cloud file storage with Azure Blob
✅ Scalable API backend
✅ No desktop application installation required
✅ Mobile-friendly UI with Tailwind CSS

## Removed Components

The following Electron-specific files and dependencies have been removed:
- `electron.js` (desktop app wrapper)
- `preload.js` (Electron IPC)
- electron-builder (desktop packaging)
- electron (Electron framework)
- electron-is-dev (development detection)

## Frontend Changes

- Removed Electron dependencies
- Added `serve` package for production static serving
- Updated scripts to use standard React development server
- No system tray or window chrome features
- Clean web-based UI

## Support

For issues with Azure setup, see [AZURE_SETUP.md](./AZURE_SETUP.md)
For API documentation, see [docs/API_DOCUMENTATION.md](./docs/API_DOCUMENTATION.md)
