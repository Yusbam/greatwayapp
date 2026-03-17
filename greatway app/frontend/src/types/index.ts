export interface Member {
  member_id: number;
  member_code: string;
  first_name: string;
  last_name: string;
  middle_name?: string;
  email: string;
  phone: string;
  date_of_birth: Date;
  address: string;
  occupation: string;
  guarantor_name: string;
  guarantor_phone: string;
  date_joined: Date;
  status: 'active' | 'inactive' | 'suspended';
}

export interface MemberFinancials {
  member_id: number;
  total_savings: number;
  total_shares: number;
  total_fees_paid: number;
  active_loans: number;
  total_loan_amount: number;
}

export interface Loan {
  loan_id: number;
  member_id: number;
  principal_amount: number;
  interest_rate: number;
  tenure_months: number;
  status: 'pending' | 'approved' | 'disbursed' | 'paid' | 'defaulted';
  loan_type: 'personal' | 'business';
}

export interface DashboardSummary {
  total_members: number;
  active_members: number;
  total_savings: number;
  total_shares: number;
  total_loans_outstanding: number;
  total_fees_collected: number;
}
