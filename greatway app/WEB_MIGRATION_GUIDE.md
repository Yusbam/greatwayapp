# Web Migration & Azure Integration Guide

## 🎯 What Changed

Your Greatway Cooperative Management System has been successfully converted from a **desktop Electron application** to a **modern web application** with **Azure Blob Storage** integration for file management.

## 📋 Summary of Changes

### 1. **Removed Electron Desktop Framework**
- ❌ Deleted Electron dependencies (electron, electron-builder, electron-is-dev)
- ❌ Removed electron.js wrapper and Electron build configurations
- ❌ Removed desktop build scripts (build:mac, build:win, build:linux)
- ✅ Replaced with standard React web development

### 2. **Converted to Web Application**
- ✅ Frontend now runs as a standard React web app (port 3000)
- ✅ Backend serves as REST API (port 3001)
- ✅ Configured proper CORS for web security
- ✅ Added environment variable support for deployment flexibility

### 3. **Integrated Azure Blob Storage**
- ✅ Added Azure Storage SDK (@azure/storage-blob)
- ✅ Created file upload/download/delete utilities
- ✅ Implemented secure file handling with multer
- ✅ Added SAS URL generation for temporary access
- ✅ Files stored in Azure instead of local system

### 4. **Updated Dependencies**

**Frontend Changes:**
```json
// Removed
- "electron": "^30.0.0"
- "electron-builder": "^24.6.4"
- "concurrently": "^8.2.2"
- "wait-on": "^7.1.0"

// Added
+ "serve": "^14.2.0"
```

**Backend Changes:**
```json
// Added for Azure integration
+ "@azure/storage-blob": "^3.23.0"
+ "multer": "^1.4.5-lts.1"
+ "uuid": "^9.0.1"
```

### 5. **New Files Created**

```
backend/src/
  ├── config/
  │   └── azure.ts                 (Azure client configuration)
  ├── middleware/
  │   └── upload.ts                (File upload middleware)
  ├── utils/
  │   └── azureStorage.ts          (Azure storage utilities)
  └── routes/
      └── file.routes.ts           (File upload/delete/SAS endpoints)

frontend/src/utils/
  └── api.ts                        (Updated with uploadFile helpers)

frontend/Dockerfile                 (New - containerize frontend)

Root level:
  ├── AZURE_SETUP.md               (Azure configuration guide)
  ├── WEB_SETUP.md                 (Web deployment guide)
  ├── backend/.env.example         (Updated with Azure vars)
  └── frontend/.env.example        (Updated)
```

## 🚀 Quick Start Guide

### Prerequisites
- Node.js 20+ and npm 10+
- Azure Subscription (free tier available)
- MySQL 8.0+

### Step 1: Setup Azure Storage

See [AZURE_SETUP.md](./AZURE_SETUP.md) for detailed instructions:

1. Create Azure Storage Account
2. Get connection string
3. Create blob container
4. Update environment variables

### Step 2: Configure Environment

**Backend** - Create `backend/.env`:
```env
PORT=3001
NODE_ENV=development
DB_HOST=localhost
DB_USER=root
DB_PASSWORD=password
DB_NAME=greatway
JWT_SECRET=your-secret-key

# Azure configuration (see AZURE_SETUP.md)
AZURE_STORAGE_CONNECTION_STRING=your-connection-string
AZURE_STORAGE_ACCOUNT_NAME=your-account
AZURE_STORAGE_ACCOUNT_KEY=your-key
AZURE_STORAGE_CONTAINER_NAME=greatway-documents
```

**Frontend** - Create `frontend/.env`:
```env
REACT_APP_API_URL=http://localhost:3001/api
REACT_APP_ENV=development
```

### Step 3: Install & Run

```bash
# Install all dependencies
npm install

# Setup database
npm run db:setup
npm run db:migrate

# Development: Terminal 1 - Backend
npm run dev:backend

# Development: Terminal 2 - Frontend
npm run dev:frontend
```

Access the app at **http://localhost:3000**

### Step 4: Test File Upload

1. Navigate to Members or relevant section
2. Upload a document
3. File is automatically uploaded to Azure Blob Storage
4. You'll get a permanent Azure URL

## 📦 Deployment Options

### Option 1: Docker Compose (Recommended for Development)
```bash
docker-compose up --build
```

Access at http://localhost:3000

### Option 2: Azure App Service

**Deploy Backend:**
```bash
# Build and deploy to Azure App Service
az webapp deployment
```

**Deploy Frontend:**
```bash
# Deploy to Azure Static Web Apps
az staticwebapp create
```

### Option 3: Kubernetes

Use the Docker images with your Kubernetes cluster (provided docker-compose.yml can be adapted).

## 🔑 API Endpoints

### File Operations

**Upload File**
```http
POST /api/files/upload
Content-Type: multipart/form-data

Body:
file: <binary data>

Response:
{
  "success": true,
  "file": {
    "filename": "550e8400-e29b-41d4-a716-446655440000.pdf",
    "url": "https://account.blob.core.windows.net/...",
    "size": 1024,
    "contentType": "application/pdf"
  }
}
```

**Delete File**
```http
DELETE /api/files/{filename}

Response:
{ "success": true, "message": "File deleted successfully" }
```

**Generate Temporary SAS URL**
```http
POST /api/files/sas-url/{filename}
Content-Type: application/json

Body:
{ "expiryMinutes": 60 }

Response:
{
  "success": true,
  "sasUrl": "https://account.blob.core.windows.net/...?sv=...",
  "expiresIn": "60 minutes"
}
```

## 📝 Frontend Usage

Upload files in your React components:

```typescript
import { uploadFile } from '../utils/api';

const handleFileUpload = async (file: File) => {
  try {
    const response = await uploadFile(file);
    console.log('File uploaded:', response.data.file.url);
    // Use response.data.file.url to display or store reference
  } catch (error) {
    console.error('Upload failed:', error);
  }
};
```

## 🔒 Security Considerations

1. **Azure Access:**
   - Use connection strings in development only
   - Use Managed Identity or Service Principal in production
   - Store secrets in Azure Key Vault

2. **CORS:**
   - Configured for localhost development
   - Update `ALLOWED_ORIGINS` for production domains

3. **File Validation:**
   - Only specific file types allowed (PDF, images, Office, etc.)
   - 50 MB file size limit
   - Update as needed in `backend/src/middleware/upload.ts`

4. **Authentication:**
   - JWT tokens required for API access
   - File upload endpoints protected by auth middleware

## ⚠️ Breaking Changes

### For End Users
- Application now accessed via web browser instead of desktop app
- Must set up Azure Storage Account (one-time setup)
- No more local file storage - all files in Azure cloud

### For Developers
- Electron-specific code removed; use standard Node.js APIs
- No IPC (Inter-Process Communication) available
- System tray features no longer available
- Desktop notifications need alternative (e.g., browser notifications)

## ✅ Verification Checklist

After migration:
- [ ] Azure Storage Account created
- [ ] Connection string in .env files
- [ ] Database migrated successfully
- [ ] Backend runs: `npm run dev:backend`
- [ ] Frontend runs: `npm run dev:frontend`
- [ ] App accessible at http://localhost:3000
- [ ] Can upload files to Azure
- [ ] File URLs are permanent Azure Blob URLs

## 🆘 Troubleshooting

### "Cannot find module '@azure/storage-blob'"
```bash
cd backend
npm install
```

### Azure connection string errors
- Verify string format in `.env`
- Check Azure KeyVault for correct connection string
- Ensure container name matches configuration

### CORS errors in browser console
- Check `ALLOWED_ORIGINS` environment variable
- Add your frontend URL to allowed origins
- Restart backend after changes

### Files not uploading
- Check browser console for errors
- Verify Azure credentials are valid
- Ensure container exists in Azure Storage
- Check file size doesn't exceed 50 MB

## 📚 Additional Resources

- [Azure Storage Documentation](https://learn.microsoft.com/en-us/azure/storage/)
- [Express.js Documentation](https://expressjs.com/)
- [React Documentation](https://react.dev/)
- [TypeScript Documentation](https://www.typescriptlang.org/)

---

**Migration completed successfully!** Your application is now ready for web deployment with Azure cloud storage. 🎉
