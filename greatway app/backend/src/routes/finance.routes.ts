import express from 'express';

export const router = express.Router();

// POST /api/finances/savings - Record savings
router.post('/savings', (req, res) => {
  res.json({ message: 'Record savings' });
});

// POST /api/finances/shares - Record shares
router.post('/shares', (req, res) => {
  res.json({ message: 'Record shares' });
});

// POST /api/finances/fees - Record fees
router.post('/fees', (req, res) => {
  res.json({ message: 'Record fees' });
});

export default router;
