-- Create database
CREATE DATABASE IF NOT EXISTS greatway_coop CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
USE greatway_coop;

-- Officers table
CREATE TABLE IF NOT EXISTS officers (
  officer_id INT AUTO_INCREMENT PRIMARY KEY,
  username VARCHAR(50) UNIQUE NOT NULL,
  email VARCHAR(100) UNIQUE NOT NULL,
  password VARCHAR(255) NOT NULL,
  full_name VARCHAR(100) NOT NULL,
  role ENUM('admin', 'manager', 'operator') DEFAULT 'operator',
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  INDEX idx_username (username),
  INDEX idx_email (email)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Members table
CREATE TABLE IF NOT EXISTS members (
  member_id INT AUTO_INCREMENT PRIMARY KEY,
  member_code VARCHAR(50) UNIQUE NOT NULL,
  first_name VARCHAR(50) NOT NULL,
  last_name VARCHAR(50) NOT NULL,
  middle_name VARCHAR(50),
  email VARCHAR(100) NOT NULL,
  phone VARCHAR(20) NOT NULL,
  date_of_birth DATE,
  address TEXT,
  occupation VARCHAR(100),
  guarantor_name VARCHAR(100),
  guarantor_phone VARCHAR(20),
  date_joined DATE NOT NULL,
  status ENUM('active', 'inactive', 'suspended') DEFAULT 'active',
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  UNIQUE INDEX idx_member_code (member_code),
  INDEX idx_status (status),
  INDEX idx_date_joined (date_joined)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Savings table
CREATE TABLE IF NOT EXISTS savings (
  savings_id INT AUTO_INCREMENT PRIMARY KEY,
  member_id INT NOT NULL,
  amount DECIMAL(15, 2) NOT NULL,
  transaction_date DATE NOT NULL,
  description VARCHAR(255),
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (member_id) REFERENCES members(member_id) ON DELETE CASCADE,
  INDEX idx_member_id (member_id),
  INDEX idx_transaction_date (transaction_date)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Shares table
CREATE TABLE IF NOT EXISTS shares (
  shares_id INT AUTO_INCREMENT PRIMARY KEY,
  member_id INT NOT NULL,
  share_price DECIMAL(10, 2) NOT NULL,
  quantity INT NOT NULL,
  total_amount DECIMAL(15, 2) GENERATED ALWAYS AS (share_price * quantity) STORED,
  acquisition_date DATE NOT NULL,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (member_id) REFERENCES members(member_id) ON DELETE CASCADE,
  INDEX idx_member_id (member_id),
  INDEX idx_acquisition_date (acquisition_date)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Fees table
CREATE TABLE IF NOT EXISTS fees (
  fee_id INT AUTO_INCREMENT PRIMARY KEY,
  member_id INT NOT NULL,
  fee_type ENUM('agm', 'administrative', 'ileya', 'other') NOT NULL,
  amount DECIMAL(10, 2) NOT NULL,
  payment_date DATE NOT NULL,
  description VARCHAR(255),
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (member_id) REFERENCES members(member_id) ON DELETE CASCADE,
  INDEX idx_member_id (member_id),
  INDEX idx_fee_type (fee_type),
  INDEX idx_payment_date (payment_date)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Loans table
CREATE TABLE IF NOT EXISTS loans (
  loan_id INT AUTO_INCREMENT PRIMARY KEY,
  member_id INT NOT NULL,
  principal_amount DECIMAL(15, 2) NOT NULL,
  interest_rate DECIMAL(5, 2) NOT NULL,
  tenure_months INT NOT NULL,
  loan_type ENUM('personal', 'business') NOT NULL,
  status ENUM('pending', 'approved', 'disbursed', 'paid', 'defaulted') DEFAULT 'pending',
  application_date DATE NOT NULL,
  approval_date DATE,
  disbursement_date DATE,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  FOREIGN KEY (member_id) REFERENCES members(member_id) ON DELETE CASCADE,
  INDEX idx_member_id (member_id),
  INDEX idx_status (status),
  INDEX idx_application_date (application_date)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Loan repayments table
CREATE TABLE IF NOT EXISTS loan_repayments (
  repayment_id INT AUTO_INCREMENT PRIMARY KEY,
  loan_id INT NOT NULL,
  amount DECIMAL(15, 2) NOT NULL,
  payment_date DATE NOT NULL,
  description VARCHAR(255),
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (loan_id) REFERENCES loans(loan_id) ON DELETE CASCADE,
  INDEX idx_loan_id (loan_id),
  INDEX idx_payment_date (payment_date)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Audit logs table
CREATE TABLE IF NOT EXISTS audit_logs (
  log_id INT AUTO_INCREMENT PRIMARY KEY,
  officer_id INT,
  action ENUM('CREATE', 'UPDATE', 'DELETE') NOT NULL,
  table_name VARCHAR(50) NOT NULL,
  record_id INT,
  old_value LONGTEXT,
  new_value LONGTEXT,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (officer_id) REFERENCES officers(officer_id) ON DELETE SET NULL,
  INDEX idx_officer_id (officer_id),
  INDEX idx_created_at (created_at),
  INDEX idx_table_name (table_name)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Create views for commonly used queries
CREATE OR REPLACE VIEW member_financials AS
SELECT 
  m.member_id,
  m.member_code,
  CONCAT(m.first_name, ' ', m.last_name) as full_name,
  m.status,
  COALESCE(SUM(CASE WHEN s.savings_id IS NOT NULL THEN s.amount ELSE 0 END), 0) as total_savings,
  COALESCE(SUM(CASE WHEN sh.shares_id IS NOT NULL THEN sh.total_amount ELSE 0 END), 0) as total_shares,
  COALESCE(SUM(CASE WHEN f.fee_id IS NOT NULL THEN f.amount ELSE 0 END), 0) as total_fees_paid,
  COUNT(DISTINCT CASE WHEN l.status IN ('pending', 'approved', 'disbursed') THEN l.loan_id END) as active_loans,
  COALESCE(SUM(CASE WHEN l.status IN ('pending', 'approved', 'disbursed') THEN l.principal_amount ELSE 0 END), 0) as total_loan_amount
FROM members m
LEFT JOIN savings s ON m.member_id = s.member_id
LEFT JOIN shares sh ON m.member_id = sh.member_id
LEFT JOIN fees f ON m.member_id = f.member_id
LEFT JOIN loans l ON m.member_id = l.member_id
GROUP BY m.member_id, m.member_code, m.first_name, m.last_name, m.status;

CREATE OR REPLACE VIEW loan_details AS
SELECT 
  l.loan_id,
  l.member_id,
  CONCAT(m.first_name, ' ', m.last_name) as member_name,
  m.member_code,
  l.principal_amount,
  l.interest_rate,
  l.tenure_months,
  l.loan_type,
  l.status,
  l.application_date,
  l.approval_date,
  l.disbursement_date,
  COALESCE(SUM(lr.amount), 0) as total_repaid,
  (l.principal_amount - COALESCE(SUM(lr.amount), 0)) as outstanding_balance
FROM loans l
LEFT JOIN members m ON l.member_id = m.member_id
LEFT JOIN loan_repayments lr ON l.loan_id = lr.loan_id
GROUP BY l.loan_id;
