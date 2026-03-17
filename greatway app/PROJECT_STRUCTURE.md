# PROJECT STRUCTURE

```
greatway app/
│
├── frontend/                          # React + Electron Desktop App
│   ├── public/
│   │   ├── electron.js               # Electron main process
│   │   ├── index.html                # HTML template
│   │   └── favicon.ico
│   ├── src/
│   │   ├── components/
│   │   │   ├── Sidebar.tsx           # Navigation sidebar
│   │   │   ├── Card.tsx              # Reusable card component
│   │   │   └── Layout.tsx            # Main layout wrapper
│   │   ├── pages/
│   │   │   ├── Dashboard.tsx         # Dashboard page
│   │   │   ├── Members.tsx           # Members list page
│   │   │   ├── Finances.tsx          # Financial records page
│   │   │   └── Loans.tsx             # Loans page
│   │   ├── stores/
│   │   │   ├── auth.store.ts         # Auth state management (Zustand)
│   │   │   └── member.store.ts       # Member state management
│   │   ├── utils/
│   │   │   ├── api.ts                # Axios API client
│   │   │   └── helpers.ts            # Helper functions
│   │   ├── types/
│   │   │   └── index.ts              # TypeScript type definitions
│   │   ├── App.tsx                   # Main App component
│   │   ├── index.tsx                 # React entry point
│   │   └── index.css                 # Global styles with Tailwind
│   ├── package.json
│   ├── tsconfig.json
│   ├── tailwind.config.js
│   ├── postcss.config.js
│   ├── .env.example
│   └── README.md
│
├── backend/                           # Express + TypeScript API Server
│   ├── src/
│   │   ├── config/
│   │   │   └── database.ts           # MySQL connection pool
│   │   ├── controllers/
│   │   │   ├── auth.controller.ts    # Auth logic
│   │   │   ├── member.controller.ts  # Member CRUD logic
│   │   │   ├── finance.controller.ts # Financial records logic
│   │   │   └── loan.controller.ts    # Loan logic
│   │   ├── routes/
│   │   │   ├── auth.routes.ts        # Auth endpoints
│   │   │   ├── member.routes.ts      # Member endpoints
│   │   │   ├── finance.routes.ts     # Finance endpoints
│   │   │   ├── loan.routes.ts        # Loan endpoints
│   │   │   └── dashboard.routes.ts   # Dashboard endpoints
│   │   ├── models/
│   │   │   ├── Member.ts             # Member model
│   │   │   ├── Loan.ts               # Loan model
│   │   │   └── Transaction.ts        # Transaction model
│   │   ├── middleware/
│   │   │   ├── auth.ts               # JWT verification
│   │   │   └── validation.ts         # Request validation
│   │   ├── utils/
│   │   │   ├── validators.ts         # Data validators
│   │   │   ├── responses.ts          # Response formatters
│   │   │   └── errors.ts             # Error handlers
│   │   ├── types/
│   │   │   └── index.ts              # TypeScript interfaces
│   │   └── index.ts                  # Express app setup
│   ├── dist/                         # Compiled JavaScript output
│   ├── package.json
│   ├── tsconfig.json
│   ├── .env.example
│   └── README.md
│
├── database/                          # MySQL Schema & Migrations
│   ├── schema/
│   │   ├── 01_init.sql               # Database initialization
│   │   │   • officers table
│   │   │   • members table
│   │   │   • savings table
│   │   │   • shares table
│   │   │   • fees table
│   │   │   • loans table
│   │   │   • loan_repayments table
│   │   │   • audit_logs table
│   │   ├── 02_views.sql              # SQL views
│   │   │   • member_financials view
│   │   │   • loan_details view
│   │   │   • loan_eligibility view
│   │   │   • dashboard_summary view
│   │   └── 03_sample_data.sql        # Sample test data
│   ├── migrations/                   # Future migration scripts
│   ├── scripts/
│   │   ├── init.js                   # Database initialization
│   │   └── migrate.js                # Migration runner
│   ├── package.json
│   └── README.md
│
├── docs/                              # Documentation
│   ├── SETUP_GUIDE.md                # Installation & setup
│   ├── USER_GUIDE.md                 # User manual
│   ├── API_DOCUMENTATION.md          # API reference
│   ├── IMPLEMENTATION_ROADMAP.md     # Project roadmap
│   ├── ARCHITECTURE.md               # System architecture
│   └── TROUBLESHOOTING.md            # Troubleshooting guide
│
├── package.json                       # Root package (workspaces)
├── .gitignore                         # Git ignore file
└── README.md                          # Project overview

```

## Key Files Description

### Frontend Files
- **electron.js**: Electron main process - creates window, handles lifecycle
- **App.tsx**: Main React component with routing
- **Dashboard.tsx**: Member statistics and overview
- **Members.tsx**: Member list and management
- **Layout.tsx**: Main UI layout with sidebar
- **api.ts**: Axios client with interceptors

### Backend Files
- **index.ts**: Express app initialization
- **database.ts**: MySQL connection pool setup
- **auth.routes.ts**: Login/logout endpoints
- **member.routes.ts**: Member CRUD endpoints
- **loan.routes.ts**: Loan management endpoints
- **types/index.ts**: TypeScript interfaces

### Database Files
- **01_init.sql**: Creates all tables and relationships
- **02_views.sql**: Creates SQL views for common queries
- **03_sample_data.sql**: Sample data for testing

### Documentation Files
- **SETUP_GUIDE.md**: How to install and configure
- **USER_GUIDE.md**: How to use the application
- **API_DOCUMENTATION.md**: Complete API reference
- **IMPLEMENTATION_ROADMAP.md**: Development plan
