export interface Officer {
  officer_id: number;
  username: string;
  email: string;
  password: string;
  full_name: string;
  role: 'admin' | 'manager' | 'operator';
  created_at: Date;
  updated_at: Date;
}

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
  created_at: Date;
  updated_at: Date;
}

export interface Savings {
  savings_id: number;
  member_id: number;
  amount: number;
  transaction_date: Date;
  description?: string;
  created_at: Date;
}

export interface Shares {
  shares_id: number;
  member_id: number;
  share_price: number;
  quantity: number;
  total_amount: number;
  acquisition_date: Date;
  created_at: Date;
}

export interface Loan {
  loan_id: number;
  member_id: number;
  principal_amount: number;
  interest_rate: number;
  tenure_months: number;
  application_date: Date;
  approval_date?: Date;
  disbursement_date?: Date;
  status: 'pending' | 'approved' | 'disbursed' | 'paid' | 'defaulted';
  loan_type: 'personal' | 'business';
  created_at: Date;
  updated_at: Date;
}

export interface LoanRepayment {
  repayment_id: number;
  loan_id: number;
  amount: number;
  payment_date: Date;
  description?: string;
  created_at: Date;
}

export interface Fee {
  fee_id: number;
  member_id: number;
  fee_type: 'agm' | 'administrative' | 'ileya' | 'other';
  amount: number;
  payment_date: Date;
  description?: string;
  created_at: Date;
}
