import express from 'express';

export const router = express.Router();

// Placeholder routes - to be implemented
router.post('/login', (req, res) => {
  res.json({ message: 'Login endpoint' });
});

router.post('/logout', (req, res) => {
  res.json({ message: 'Logout endpoint' });
});

export default router;
