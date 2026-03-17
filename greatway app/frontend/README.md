# Greatway Cooperative - Frontend

React + TypeScript + Electron desktop application for member management.

## Features

- **Member Management**: Register, view, and manage member profiles
- **Financial Dashboard**: Track savings, shares, and fees
- **Loan Management**: Apply, approve, and manage loans
- **Performance Analytics**: Visual dashboards and reports
- **Desktop Application**: Built with Electron for Windows, Mac, and Linux

## Setup

```bash
npm install
```

## Development

```bash
npm run dev
```

This will start the React dev server and Electron simultaneously.

## Build

```bash
# Cross-platform
npm run build

# Windows only
npm run build:win

# macOS only
npm run build:mac

# Linux only
npm run build:linux
```

## Project Structure

```
frontend/
├── public/
│   ├── electron.js          # Electron main process
│   └── preload.js           # Preload script for IPC
├── src/
│   ├── components/          # React components
│   ├── pages/               # Page components
│   ├── stores/              # Zustand stores
│   ├── utils/               # Utility functions
│   ├── types/               # TypeScript types
│   ├── App.tsx
│   └── index.tsx
└── package.json
```

## Environment Variables

Create `.env` file in frontend root:

```env
REACT_APP_API_URL=http://localhost:3001/api
```
