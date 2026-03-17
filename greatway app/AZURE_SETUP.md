# Azure Configuration Guide

## Environment Variables Required

Create a `.env` file in the backend directory with the following Azure configuration:

```env
# Azure Blob Storage
AZURE_STORAGE_CONNECTION_STRING=DefaultEndpointsProtocol=https;AccountName=<your-account-name>;AccountKey=<your-account-key>;EndpointSuffix=core.windows.net

# Azure Storage Account Details
AZURE_STORAGE_ACCOUNT_NAME=<your-account-name>
AZURE_STORAGE_ACCOUNT_KEY=<your-account-key>

# Container name (optional, defaults to 'greatway-documents')
AZURE_STORAGE_CONTAINER_NAME=greatway-documents

# Backend Configuration
PORT=3001
NODE_ENV=development

# Database
DB_HOST=localhost
DB_USER=root
DB_PASSWORD=password
DB_NAME=greatway
DB_PORT=3306

# JWT
JWT_SECRET=your-jwt-secret-key-here
```

## Setting up Azure Blob Storage

### Step 1: Create Azure Storage Account

1. Go to [Azure Portal](https://portal.azure.com)
2. Click "Create a resource" → Search for "Storage account"
3. Create a new storage account with:
   - **Resource Group**: Create new or use existing
   - **Storage account name**: Something like `greatwayapp` (must be globally unique)
   - **Region**: Select your preferred region
   - **Performance**: Standard
   - **Redundancy**: Locally-redundant storage (LRS) or Geo-redundant (GRS)

### Step 2: Get Connection String

1. Go to your Storage Account
2. Under "Settings", click "Access keys"
3. Copy the "Connection string" under "connectionString"
4. Paste this into your `.env` file as `AZURE_STORAGE_CONNECTION_STRING`

### Step 3: Create a Blob Container

1. In your Storage Account, go to "Containers" under "Data storage"
2. Click "+ Container"
3. Name it `greatway-documents`
4. Set access level to "Container" for public read access (or "Private" for secure access)

### Step 4: Update Environment Variables

```env
AZURE_STORAGE_CONNECTION_STRING=<your-connection-string>
AZURE_STORAGE_ACCOUNT_NAME=<your-account-name>
AZURE_STORAGE_ACCOUNT_KEY=<your-account-key>
AZURE_STORAGE_CONTAINER_NAME=greatway-documents
```

## Using File Upload in Routes

In your routes, use the upload middleware and Azure storage utilities:

```typescript
import express from 'express';
import upload from '../middleware/upload';
import { uploadFileToBlob } from '../utils/azureStorage';

const router = express.Router();

router.post('/upload', upload.single('file'), async (req, res) => {
  try {
    if (!req.file) {
      return res.status(400).json({ error: 'No file provided' });
    }

    const uploadedFile = await uploadFileToBlob(
      req.file.buffer,
      req.file.originalname,
      req.file.mimetype
    );

    res.json({
      success: true,
      file: uploadedFile,
    });
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
});

export default router;
```

## Frontend Considerations

- The frontend now communicates with the Express backend
- File uploads are handled via FormData and multipart/form-data
- Azure Blob URLs are returned by the server for secure access
- No need for Azure SDK integration in frontend

## Production Deployment

For production, consider:
- Using Managed Identity or Service Principal instead of connection strings
- Enabling Azure CDN for faster content delivery
- Setting up Azure Storage firewall rules
- Using Azure Key Vault for secret management
- Implementing encryption for sensitive data
