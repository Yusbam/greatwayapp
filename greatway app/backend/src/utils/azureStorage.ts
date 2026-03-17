import { blobServiceClient, containerName } from '../config/azure';
import { v4 as uuidv4 } from 'uuid';
import path from 'path';

interface UploadedFile {
  filename: string;
  url: string;
  size: number;
  contentType: string;
}

/**
 * Upload a file to Azure Blob Storage
 */
export async function uploadFileToBlob(
  fileBuffer: Buffer,
  originalFilename: string,
  contentType: string
): Promise<UploadedFile> {
  try {
    const containerClient = blobServiceClient.getContainerClient(containerName);

    // Ensure container exists
    await containerClient.createIfNotExists({ access: 'container' });

    // Generate unique filename
    const ext = path.extname(originalFilename);
    const uniqueFilename = `${uuidv4()}${ext}`;

    const blockBlobClient = containerClient.getBlockBlobClient(uniqueFilename);

    await blockBlobClient.upload(fileBuffer, fileBuffer.length, {
      blobHTTPHeaders: {
        blobContentType: contentType,
      },
    });

    return {
      filename: uniqueFilename,
      url: blockBlobClient.url,
      size: fileBuffer.length,
      contentType,
    };
  } catch (error) {
    console.error('Error uploading file to Azure Blob Storage:', error);
    throw new Error(`Failed to upload file to Azure: ${error}`);
  }
}

/**
 * Delete a file from Azure Blob Storage
 */
export async function deleteFileFromBlob(filename: string): Promise<void> {
  try {
    const containerClient = blobServiceClient.getContainerClient(containerName);
    const blockBlobClient = containerClient.getBlockBlobClient(filename);
    await blockBlobClient.delete();
  } catch (error) {
    console.error('Error deleting file from Azure Blob Storage:', error);
    throw new Error(`Failed to delete file from Azure: ${error}`);
  }
}

/**
 * Generate a SAS URL for a file (optional - for secure temporary access)
 */
export async function generateSASUrl(
  filename: string,
  expiryMinutes: number = 60
): Promise<string> {
  try {
    const containerClient = blobServiceClient.getContainerClient(containerName);
    const blockBlobClient = containerClient.getBlockBlobClient(filename);

    const { generateBlobSASQueryParameters, BlobSASPermissions } = require('@azure/storage-blob');

    const sasUrl = `${blockBlobClient.url}?${generateBlobSASQueryParameters(
      {
        containerName,
        blobName: filename,
        permissions: BlobSASPermissions.parse('racwd'),
        expiresOn: new Date(new Date().valueOf() + expiryMinutes * 60 * 1000),
      },
      {
        accountName: process.env.AZURE_STORAGE_ACCOUNT_NAME || '',
        accountKey: process.env.AZURE_STORAGE_ACCOUNT_KEY || '',
      }
    )}`;

    return sasUrl;
  } catch (error) {
    console.error('Error generating SAS URL:', error);
    throw new Error(`Failed to generate SAS URL: ${error}`);
  }
}
