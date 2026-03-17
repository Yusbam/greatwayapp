import express from 'express';

export const router = express.Router();

// GET /api/dashboard/summary - Overall statistics
router.get('/summary', (req, res) => {
  res.json({ message: 'Get dashboard summary' });
});

// GET /api/dashboard/member/:id - Member performance
router.get('/member/:id', (req, res) => {
  res.json({ message: 'Get member performance', id: req.params.id });
});

export default router;
