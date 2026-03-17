-- Sample data for testing
-- Insert sample officer
INSERT INTO officers (username, email, password, full_name, role) VALUES
('admin', 'admin@greatwaycoop.com', 'hashedPassword123', 'Admin User', 'admin');

-- Insert sample members
INSERT INTO members (member_code, first_name, last_name, email, phone, date_of_birth, address, occupation, guarantor_name, guarantor_phone, date_joined, status) VALUES
('GC001', 'John', 'Doe', 'john.doe@example.com', '08012345678', '1985-05-15', '123 Main Street, Lagos', 'Engineer', 'Jane Doe', '08098765432', DATE_SUB(CURDATE(), INTERVAL 12 MONTH), 'active'),
('GC002', 'Mary', 'Johnson', 'mary.johnson@example.com', '08023456789', '1990-03-20', '456 Oak Road, Lagos', 'Teacher', 'Robert Johnson', '08087654321', DATE_SUB(CURDATE(), INTERVAL 10 MONTH), 'active'),
('GC003', 'Chioma', 'Okafor', 'chioma.okafor@example.com', '08034567890', '1988-07-10', '789 Pine Lane, Lagos', 'Nurse', 'Emeka Okafor', '08076543210', DATE_SUB(CURDATE(), INTERVAL 8 MONTH), 'active'),
('GC004', 'Ibrahim', 'Adeyemi', 'ibrahim.adeyemi@example.com', '08045678901', '1992-11-25', '321 Elm Street, Lagos', 'Trader', 'Fatima Adeyemi', '08065432109', DATE_SUB(CURDATE(), INTERVAL 6 MONTH), 'active'),
('GC005', 'Zainab', 'Mohammed', 'zainab.mohammed@example.com', '08056789012', '1995-02-08', '654 Maple Avenue, Lagos', 'Student', 'Ahmed Mohammed', '08054321098', DATE_SUB(CURDATE(), INTERVAL 3 MONTH), 'active');

-- Insert sample savings
INSERT INTO savings (member_id, amount, transaction_date, description) VALUES
(1, 50000, DATE_SUB(CURDATE(), INTERVAL 1 MONTH), 'Monthly savings'),
(1, 50000, DATE_SUB(CURDATE(), INTERVAL 2 MONTH), 'Monthly savings'),
(1, 100000, DATE_SUB(CURDATE(), INTERVAL 3 MONTH), 'Additional savings'),
(2, 30000, DATE_SUB(CURDATE(), INTERVAL 1 MONTH), 'Monthly savings'),
(2, 30000, DATE_SUB(CURDATE(), INTERVAL 2 MONTH), 'Monthly savings'),
(3, 75000, DATE_SUB(CURDATE(), INTERVAL 1 MONTH), 'Monthly savings'),
(4, 40000, DATE_SUB(CURDATE(), INTERVAL 1 MONTH), 'Monthly savings'),
(5, 25000, DATE_SUB(CURDATE(), INTERVAL 1 MONTH), 'Monthly savings');

-- Insert sample shares
INSERT INTO shares (member_id, share_price, quantity, acquisition_date) VALUES
(1, 500, 20, DATE_SUB(CURDATE(), INTERVAL 8 MONTH)),
(1, 500, 10, DATE_SUB(CURDATE(), INTERVAL 4 MONTH)),
(2, 500, 15, DATE_SUB(CURDATE(), INTERVAL 6 MONTH)),
(3, 500, 30, DATE_SUB(CURDATE(), INTERVAL 7 MONTH)),
(4, 500, 10, DATE_SUB(CURDATE(), INTERVAL 5 MONTH));

-- Insert sample fees
INSERT INTO fees (member_id, fee_type, amount, payment_date, description) VALUES
(1, 'agm', 10000, DATE_SUB(CURDATE(), INTERVAL 6 MONTH), 'AGM 2025'),
(1, 'administrative', 5000, DATE_SUB(CURDATE(), INTERVAL 3 MONTH), 'Admin fee'),
(2, 'agm', 10000, DATE_SUB(CURDATE(), INTERVAL 6 MONTH), 'AGM 2025'),
(3, 'administrative', 5000, DATE_SUB(CURDATE(), INTERVAL 2 MONTH), 'Admin fee'),
(4, 'ileya', 15000, DATE_SUB(CURDATE(), INTERVAL 1 MONTH), 'Ileya savings');

-- Insert sample loans
INSERT INTO loans (member_id, principal_amount, interest_rate, tenure_months, loan_type, status, application_date, approval_date, disbursement_date) VALUES
(1, 100000, 10, 12, 'personal', 'disbursed', DATE_SUB(CURDATE(), INTERVAL 10 MONTH), DATE_SUB(CURDATE(), INTERVAL 9 MONTH), DATE_SUB(CURDATE(), INTERVAL 9 MONTH)),
(2, 150000, 10, 12, 'personal', 'disbursed', DATE_SUB(CURDATE(), INTERVAL 8 MONTH), DATE_SUB(CURDATE(), INTERVAL 7 MONTH), DATE_SUB(CURDATE(), INTERVAL 7 MONTH)),
(3, 200000, 12, 18, 'business', 'approved', DATE_SUB(CURDATE(), INTERVAL 2 MONTH), DATE_SUB(CURDATE(), INTERVAL 1 MONTH), NULL),
(4, 50000, 10, 6, 'personal', 'pending', DATE_SUB(CURDATE(), INTERVAL 1 WEEK), NULL, NULL);

-- Insert sample loan repayments
INSERT INTO loan_repayments (loan_id, amount, payment_date, description) VALUES
(1, 10000, DATE_SUB(CURDATE(), INTERVAL 8 MONTH), 'Monthly repayment'),
(1, 10000, DATE_SUB(CURDATE(), INTERVAL 7 MONTH), 'Monthly repayment'),
(1, 10000, DATE_SUB(CURDATE(), INTERVAL 6 MONTH), 'Monthly repayment'),
(2, 15000, DATE_SUB(CURDATE(), INTERVAL 6 MONTH), 'Monthly repayment'),
(2, 15000, DATE_SUB(CURDATE(), INTERVAL 5 MONTH), 'Monthly repayment');
