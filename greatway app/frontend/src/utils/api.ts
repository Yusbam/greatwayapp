import axios, { AxiosInstance } from 'axios';

const API_URL = process.env.REACT_APP_API_URL || 'http://localhost:3001/api';

const apiClient: AxiosInstance = axios.create({
  baseURL: API_URL,
  timeout: 10000,
});

// Request interceptor
apiClient.interceptors.request.use((config) => {
  const token = localStorage.getItem('token');
  if (token) {
    config.headers.Authorization = `Bearer ${token}`;
  }
  return config;
});

// Response interceptor
apiClient.interceptors.response.use(
  (response) => response,
  (error) => {
    if (error.response?.status === 401) {
      localStorage.removeItem('token');
      window.location.href = '/login';
    }
    return Promise.reject(error);
  }
);

/**
 * Upload a file to Azure Blob Storage via backend
 * @param file - File to upload
 * @returns Promise with upload response including Azure URL
 */
export const uploadFile = async (file: File) => {
  const formData = new FormData();
  formData.append('file', file);
  
  return apiClient.post('/files/upload', formData, {
    headers: {
      'Content-Type': 'multipart/form-data',
    },
  });
};

/**
 * Delete a file from Azure Blob Storage
 * @param filename - The blob filename to delete
 */
export const deleteFile = async (filename: string) => {
  return apiClient.delete(`/files/${filename}`);
};

/**
 * Generate a temporary SAS URL for secure file access
 * @param filename - The blob filename
 * @param expiryMinutes - How long the URL should be valid (default 60 minutes)
 */
export const generateFileSASUrl = async (filename: string, expiryMinutes: number = 60) => {
  return apiClient.post(`/files/sas-url/${filename}`, { expiryMinutes });
};

export default apiClient;
