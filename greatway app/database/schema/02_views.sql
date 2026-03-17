-- Loan eligibility calculation
-- A member is eligible for a loan if:
-- 1. They have been a member for at least 6 months
-- 2. They have no defaulted loans
-- 3. They don't have more than 3 active loans

CREATE OR REPLACE VIEW loan_eligibility AS
SELECT 
  m.member_id,
  m.member_code,
  CONCAT(m.first_name, ' ', m.last_name) as full_name,
  m.date_joined,
  DATEDIFF(CURDATE(), m.date_joined) as days_member,
  CASE WHEN DATEDIFF(CURDATE(), m.date_joined) >= 180 THEN 'Yes' ELSE 'No' END as min_membership_met,
  CASE WHEN NOT EXISTS(SELECT 1 FROM loans WHERE member_id = m.member_id AND status = 'defaulted') THEN 'Yes' ELSE 'No' END as no_defaulted_loans,
  COUNT(DISTINCT CASE WHEN l.status IN ('pending', 'approved', 'disbursed') THEN l.loan_id END) as active_loans,
  COUNT(DISTINCT CASE WHEN l.status IN ('pending', 'approved', 'disbursed') THEN l.loan_id END) < 3 as below_loan_limit,
  COALESCE(SUM(s.amount), 0) as total_savings,
  CASE 
    WHEN DATEDIFF(CURDATE(), m.date_joined) >= 180 
    AND NOT EXISTS(SELECT 1 FROM loans WHERE member_id = m.member_id AND status = 'defaulted')
    AND COUNT(DISTINCT CASE WHEN l.status IN ('pending', 'approved', 'disbursed') THEN l.loan_id END) < 3
    THEN 'Eligible'
    ELSE 'Not Eligible'
  END as eligibility_status,
  CASE 
    WHEN DATEDIFF(CURDATE(), m.date_joined) >= 180 
    AND NOT EXISTS(SELECT 1 FROM loans WHERE member_id = m.member_id AND status = 'defaulted')
    AND COUNT(DISTINCT CASE WHEN l.status IN ('pending', 'approved', 'disbursed') THEN l.loan_id END) < 3
    THEN COALESCE(SUM(s.amount), 0) * 2
    ELSE 0
  END as loanable_amount
FROM members m
LEFT JOIN loans l ON m.member_id = l.member_id
LEFT JOIN savings s ON m.member_id = s.member_id
WHERE m.status = 'active'
GROUP BY m.member_id, m.member_code, m.first_name, m.last_name, m.date_joined;

-- Dashboard summary view
CREATE OR REPLACE VIEW dashboard_summary AS
SELECT 
  COUNT(DISTINCT m.member_id) as total_members,
  COUNT(DISTINCT CASE WHEN m.status = 'active' THEN m.member_id END) as active_members,
  COUNT(DISTINCT CASE WHEN m.status = 'inactive' THEN m.member_id END) as inactive_members,
  COUNT(DISTINCT CASE WHEN m.status = 'suspended' THEN m.member_id END) as suspended_members,
  COALESCE(SUM(s.amount), 0) as total_savings,
  COALESCE(SUM(sh.total_amount), 0) as total_shares,
  COALESCE(SUM(CASE WHEN l.status IN ('pending', 'approved', 'disbursed') THEN l.principal_amount ELSE 0 END), 0) as total_loans_outstanding,
  COALESCE(SUM(CASE WHEN l.status = 'paid' THEN l.principal_amount ELSE 0 END), 0) as total_loans_paid,
  COALESCE(SUM(f.amount), 0) as total_fees_collected,
  COUNT(DISTINCT CASE WHEN l.status = 'defaulted' THEN l.loan_id END) as defaulted_loans
FROM members m
LEFT JOIN savings s ON m.member_id = s.member_id
LEFT JOIN shares sh ON m.member_id = sh.member_id
LEFT JOIN loans l ON m.member_id = l.member_id
LEFT JOIN fees f ON m.member_id = f.member_id;
