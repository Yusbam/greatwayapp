import express from 'express';

export const router = express.Router();

// GET /api/loans - List all loans
router.get('/', (req, res) => {
  res.json({ message: 'Get all loans' });
});

// GET /api/loans/:id - Get loan details
router.get('/:id', (req, res) => {
  res.json({ message: 'Get loan details', id: req.params.id });
});

// POST /api/loans/apply - Apply for loan
router.post('/apply', (req, res) => {
  res.json({ message: 'Loan application submitted' });
});

// GET /api/loans/:id/eligibility - Check eligibility
router.get('/:id/eligibility', (req, res) => {
  res.json({ message: 'Check loan eligibility', id: req.params.id });
});

// POST /api/loans/:id/approve - Approve loan
router.post('/:id/approve', (req, res) => {
  res.json({ message: 'Loan approved', id: req.params.id });
});

// POST /api/loans/:id/repay - Record repayment
router.post('/:id/repay', (req, res) => {
  res.json({ message: 'Repayment recorded', id: req.params.id });
});

export default router;
