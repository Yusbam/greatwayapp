import express from 'express';
import upload from '../middleware/upload';
import { uploadFileToBlob, deleteFileFromBlob, generateSASUrl } from '../utils/azureStorage';

const router = express.Router();

/**
 * Upload a file to Azure Blob Storage
 * POST /api/files/upload
 * Body: multipart/form-data with 'file' field
 */
router.post('/upload', upload.single('file'), async (req, res) => {
  try {
    if (!req.file) {
      return res.status(400).json({ 
        error: 'No file provided',
        code: 'NO_FILE'
      });
    }

    const uploadedFile = await uploadFileToBlob(
      req.file.buffer,
      req.file.originalname,
      req.file.mimetype
    );

    res.json({
      success: true,
      message: 'File uploaded successfully',
      file: {
        filename: uploadedFile.filename,
        originalName: req.file.originalname,
        url: uploadedFile.url,
        size: uploadedFile.size,
        contentType: uploadedFile.contentType,
        uploadedAt: new Date().toISOString()
      }
    });
  } catch (error: any) {
    console.error('File upload error:', error);
    res.status(500).json({ 
      error: error.message || 'Failed to upload file',
      code: 'UPLOAD_ERROR'
    });
  }
});

/**
 * Delete a file from Azure Blob Storage
 * DELETE /api/files/:filename
 */
router.delete('/:filename', async (req, res) => {
  try {
    const { filename } = req.params;

    if (!filename) {
      return res.status(400).json({ 
        error: 'Filename is required',
        code: 'NO_FILENAME'
      });
    }

    await deleteFileFromBlob(filename);

    res.json({
      success: true,
      message: 'File deleted successfully',
      filename
    });
  } catch (error: any) {
    console.error('File deletion error:', error);
    res.status(500).json({ 
      error: error.message || 'Failed to delete file',
      code: 'DELETE_ERROR'
    });
  }
});

/**
 * Generate a temporary SAS URL for secure file access
 * POST /api/files/sas-url/:filename
 * Body: { expiryMinutes?: number } (optional, defaults to 60 minutes)
 */
router.post('/sas-url/:filename', async (req, res) => {
  try {
    const { filename } = req.params;
    const { expiryMinutes = 60 } = req.body;

    if (!filename) {
      return res.status(400).json({ 
        error: 'Filename is required',
        code: 'NO_FILENAME'
      });
    }

    const sasUrl = await generateSASUrl(filename, expiryMinutes);

    res.json({
      success: true,
      sasUrl,
      expiresIn: `${expiryMinutes} minutes`,
      expiresAt: new Date(Date.now() + expiryMinutes * 60 * 1000).toISOString()
    });
  } catch (error: any) {
    console.error('SAS URL generation error:', error);
    res.status(500).json({ 
      error: error.message || 'Failed to generate SAS URL',
      code: 'SAS_ERROR'
    });
  }
});

export default router;
