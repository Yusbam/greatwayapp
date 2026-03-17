import express from 'express';

export const router = express.Router();

// GET /api/members - List all members
router.get('/', (req, res) => {
  res.json({ message: 'Get all members' });
});

// GET /api/members/:id - Get member details
router.get('/:id', (req, res) => {
  res.json({ message: 'Get member details', id: req.params.id });
});

// POST /api/members - Register new member
router.post('/', (req, res) => {
  res.json({ message: 'Register new member' });
});

// PUT /api/members/:id - Update member
router.put('/:id', (req, res) => {
  res.json({ message: 'Update member', id: req.params.id });
});

export default router;
