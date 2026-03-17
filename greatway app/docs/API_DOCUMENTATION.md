# API DOCUMENTATION - Greatway Cooperative Member Management System

## Base URL
```
http://localhost:3001/api
```

## Authentication
All endpoints (except `/auth/login`) require a JWT token in the Authorization header:
```
Authorization: Bearer <token>
```

## Response Format

### Success Response
```json
{
  "status": "success",
  "data": { /* response data */ }
}
```

### Error Response
```json
{
  "status": "error",
  "error": "Error message",
  "code": "ERROR_CODE"
}
```

## Endpoints

### Authentication

#### Login
```
POST /auth/login
Content-Type: application/json

{
  "username": "string",
  "password": "string"
}

Response:
{
  "token": "jwt_token",
  "officer": { officer details }
}
```

#### Logout
```
POST /auth/logout
Authorization: Bearer <token>
```

#### Refresh Token
```
POST /auth/refresh
Authorization: Bearer <token>
```

---

### Members

#### List All Members
```
GET /members?status=active&page=1&limit=20
Authorization: Bearer <token>

Query Parameters:
- status: active|inactive|suspended (optional)
- page: page number (optional, default: 1)
- limit: records per page (optional, default: 20)

Response:
{
  "data": [
    {
      "member_id": 1,
      "member_code": "GC001",
      "first_name": "John",
      "last_name": "Doe",
      "email": "john@example.com",
      "phone": "08012345678",
      "status": "active"
    }
  ],
  "pagination": { "page": 1, "limit": 20, "total": 450 }
}
```

#### Get Member Details
```
GET /members/:member_id
Authorization: Bearer <token>

Response:
{
  "member_id": 1,
  "member_code": "GC001",
  "first_name": "John",
  "last_name": "Doe",
  "email": "john@example.com",
  "phone": "08012345678",
  "date_of_birth": "1985-05-15",
  "address": "123 Main Street",
  "occupation": "Engineer",
  "guarantor_name": "Jane Doe",
  "guarantor_phone": "08098765432",
  "date_joined": "2024-03-17",
  "status": "active",
  "financials": {
    "total_savings": 200000,
    "total_shares": 15000,
    "total_fees_paid": 15000,
    "active_loans": 1,
    "total_loan_amount": 100000
  }
}
```

#### Register New Member
```
POST /members
Authorization: Bearer <token>
Content-Type: application/json

{
  "first_name": "string",
  "last_name": "string",
  "middle_name": "string",
  "email": "string",
  "phone": "string",
  "date_of_birth": "YYYY-MM-DD",
  "address": "string",
  "occupation": "string",
  "guarantor_name": "string",
  "guarantor_phone": "string",
  "date_joined": "YYYY-MM-DD"
}

Response:
{
  "member_id": 1,
  "member_code": "GC001",
  "message": "Member registered successfully"
}
```

#### Update Member
```
PUT /members/:member_id
Authorization: Bearer <token>
Content-Type: application/json

{
  "first_name": "string",
  "email": "string",
  "phone": "string",
  "status": "active|inactive|suspended"
}
```

---

### Financial Records

#### Record Savings
```
POST /finances/savings
Authorization: Bearer <token>
Content-Type: application/json

{
  "member_id": 1,
  "amount": 50000,
  "transaction_date": "2026-03-17",
  "description": "Monthly savings"
}

Response:
{
  "savings_id": 1,
  "message": "Savings recorded successfully"
}
```

#### Record Shares
```
POST /finances/shares
Authorization: Bearer <token>
Content-Type: application/json

{
  "member_id": 1,
  "share_price": 500,
  "quantity": 20,
  "acquisition_date": "2026-03-17"
}

Response:
{
  "shares_id": 1,
  "total_amount": 10000,
  "message": "Shares recorded successfully"
}
```

#### Record Fee
```
POST /finances/fees
Authorization: Bearer <token>
Content-Type: application/json

{
  "member_id": 1,
  "fee_type": "agm|administrative|ileya|other",
  "amount": 10000,
  "payment_date": "2026-03-17",
  "description": "AGM 2025"
}

Response:
{
  "fee_id": 1,
  "message": "Fee recorded successfully"
}
```

---

### Loans

#### List All Loans
```
GET /loans?status=disbursed&member_id=1
Authorization: Bearer <token>

Query Parameters:
- status: pending|approved|disbursed|paid|defaulted (optional)
- member_id: filter by member (optional)
- page: page number (optional)
- limit: records per page (optional)
```

#### Get Loan Details
```
GET /loans/:loan_id
Authorization: Bearer <token>

Response:
{
  "loan_id": 1,
  "member_id": 1,
  "principal_amount": 100000,
  "interest_rate": 10,
  "tenure_months": 12,
  "status": "disbursed",
  "loan_type": "personal",
  "application_date": "2026-01-15",
  "approval_date": "2026-01-20",
  "disbursement_date": "2026-01-21",
  "total_repaid": 30000,
  "outstanding_balance": 70000,
  "repayments": [
    {
      "repayment_id": 1,
      "amount": 10000,
      "payment_date": "2026-02-15"
    }
  ]
}
```

#### Check Loan Eligibility
```
GET /loans/:member_id/eligibility
Authorization: Bearer <token>

Response:
{
  "member_id": 1,
  "eligibility_status": "Eligible",
  "min_membership_met": "Yes",
  "no_defaulted_loans": "Yes",
  "active_loans": 1,
  "below_loan_limit": true,
  "total_savings": 200000,
  "loanable_amount": 400000,
  "reasoning": "Member meets all eligibility criteria"
}
```

#### Apply for Loan
```
POST /loans/apply
Authorization: Bearer <token>
Content-Type: application/json

{
  "member_id": 1,
  "loan_type": "personal|business",
  "requested_amount": 100000,
  "tenure_months": 12,
  "purpose": "Business expansion"
}

Response:
{
  "loan_id": 1,
  "status": "pending",
  "message": "Loan application submitted successfully"
}
```

#### Approve Loan
```
POST /loans/:loan_id/approve
Authorization: Bearer <token>
Content-Type: application/json

{
  "principal_amount": 100000,
  "interest_rate": 10,
  "tenure_months": 12
}

Response:
{
  "loan_id": 1,
  "status": "approved",
  "message": "Loan approved successfully"
}
```

#### Disburse Loan
```
POST /loans/:loan_id/disburse
Authorization: Bearer <token>
Content-Type: application/json

{
  "disbursement_date": "2026-03-17"
}

Response:
{
  "loan_id": 1,
  "status": "disbursed",
  "message": "Loan disbursed successfully"
}
```

#### Record Loan Repayment
```
POST /loans/:loan_id/repay
Authorization: Bearer <token>
Content-Type: application/json

{
  "amount": 10000,
  "payment_date": "2026-03-17",
  "description": "Monthly repayment"
}

Response:
{
  "repayment_id": 1,
  "outstanding_balance": 90000,
  "message": "Repayment recorded successfully"
}
```

---

### Dashboard

#### Get Summary Statistics
```
GET /dashboard/summary
Authorization: Bearer <token>

Response:
{
  "total_members": 450,
  "active_members": 420,
  "inactive_members": 20,
  "suspended_members": 10,
  "total_savings": 5250000,
  "total_shares": 1850000,
  "total_loans_outstanding": 3200000,
  "total_loans_paid": 1500000,
  "total_fees_collected": 450000,
  "defaulted_loans": 5
}
```

#### Get Member Performance Dashboard
```
GET /dashboard/member/:member_id
Authorization: Bearer <token>

Response:
{
  "member_code": "GC001",
  "full_name": "John Doe",
  "status": "active",
  "total_savings": 200000,
  "total_shares": 15000,
  "total_fees_paid": 15000,
  "active_loans": 1,
  "total_loan_amount": 100000,
  "loan_details": [
    {
      "loan_id": 1,
      "principal_amount": 100000,
      "interest_rate": 10,
      "status": "disbursed",
      "total_repaid": 30000,
      "outstanding_balance": 70000
    }
  ]
}
```

---

## Error Codes

| Code | HTTP Status | Description |
|------|-------------|-------------|
| NOT_FOUND | 404 | Resource not found |
| UNAUTHORIZED | 401 | Invalid or missing token |
| FORBIDDEN | 403 | Insufficient permissions |
| VALIDATION_ERROR | 422 | Invalid request data |
| CONFLICT | 409 | Resource already exists |
| INTERNAL_ERROR | 500 | Server error |
| MEMBER_NOT_ELIGIBLE | 422 | Member doesn't meet loan eligibility |
| DUPLICATE_MEMBER | 409 | Member code already exists |

---

## Rate Limiting

- 100 requests per minute per IP
- 1000 requests per hour per API key

---

## Pagination

All list endpoints support pagination:
- `page`: Current page (default: 1)
- `limit`: Records per page (default: 20, max: 100)

Response includes:
```json
{
  "data": [/* items */],
  "pagination": {
    "page": 1,
    "limit": 20,
    "total": 450,
    "pages": 23
  }
}
```
