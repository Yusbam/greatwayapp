import dotenv from 'dotenv';

// Load environment variables
dotenv.config();
dotenv.config({ path: `.env.${process.env.NODE_ENV}` });

export const config = {
  // Application
  port: parseInt(process.env.PORT || '3001'),
  environment: process.env.NODE_ENV || 'development',
  isDevelopment: process.env.NODE_ENV === 'development',
  isProduction: process.env.NODE_ENV === 'production',

  // Database
  database: {
    host: process.env.DB_HOST || 'localhost',
    port: parseInt(process.env.DB_PORT || '3306'),
    user: process.env.DB_USER || 'root',
    password: process.env.DB_PASSWORD || '',
    database: process.env.DB_NAME || 'greatway_coop',
    waitForConnections: true,
    connectionLimit: parseInt(process.env.DB_POOL_LIMIT || '10'),
    queueLimit: 0,
  },

  // JWT
  jwt: {
    secret: process.env.JWT_SECRET || 'dev-change-me-in-production',
    expiresIn: '24h',
    refreshExpiresIn: '7d',
  },

  // CORS
  cors: {
    origin: process.env.CORS_ORIGIN === '*' 
      ? '*' 
      : (process.env.CORS_ORIGIN || 'http://localhost:3000').split(','),
    credentials: true,
  },

  // Logging
  logging: {
    level: process.env.LOG_LEVEL || 'info',
    format: process.env.LOG_FORMAT || 'json',
  },

  // API
  api: {
    prefix: '/api',
    version: 'v1',
  },

  // Timeouts
  timeouts: {
    requestTimeout: 30000,
    connectionTimeout: 5000,
  },
};

// Validation
if (!config.jwt.secret || config.jwt.secret === 'dev-change-me-in-production') {
  if (config.isProduction) {
    throw new Error('JWT_SECRET must be set in production');
  }
}

export default config;
