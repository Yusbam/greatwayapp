# Greatway Cooperative Database

MySQL schema and initialization scripts.

## Setup

```bash
# Create database and tables
npm run init

# Run migrations
npm run migrate
```

## Database Schema

### Tables

#### officers
- officer_id (PK)
- username
- email
- password
- full_name
- role (admin, manager, operator)
- created_at
- updated_at

#### members
- member_id (PK)
- member_code (UNIQUE)
- first_name, last_name, middle_name
- email, phone
- date_of_birth, address, occupation
- guarantor_name, guarantor_phone
- date_joined
- status (active, inactive, suspended)
- created_at, updated_at

#### savings
- savings_id (PK)
- member_id (FK)
- amount
- transaction_date
- description
- created_at

#### shares
- shares_id (PK)
- member_id (FK)
- share_price, quantity, total_amount
- acquisition_date
- created_at

#### fees
- fee_id (PK)
- member_id (FK)
- fee_type (agm, administrative, ileya, other)
- amount
- payment_date
- description
- created_at

#### loans
- loan_id (PK)
- member_id (FK)
- principal_amount
- interest_rate
- tenure_months
- loan_type (personal, business)
- status (pending, approved, disbursed, paid, defaulted)
- application_date, approval_date, disbursement_date
- created_at, updated_at

#### loan_repayments
- repayment_id (PK)
- loan_id (FK)
- amount
- payment_date
- description
- created_at

#### audit_logs
- log_id (PK)
- officer_id (FK)
- action (CREATE, UPDATE, DELETE)
- table_name
- record_id
- old_value, new_value
- created_at
