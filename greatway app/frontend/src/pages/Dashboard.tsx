import React from 'react';
import { Layout } from '../components/Layout';
import { Card } from '../components/Card';
import { DashboardSummary } from '../types';

const Dashboard: React.FC = () => {
  // TODO: Fetch actual data from API
  const summary: DashboardSummary = {
    total_members: 450,
    active_members: 420,
    total_savings: 5250000,
    total_shares: 1850000,
    total_loans_outstanding: 3200000,
    total_fees_collected: 450000,
  };

  return (
    <Layout>
      <div>
        <h1 className="text-3xl font-bold mb-8">Dashboard</h1>

        <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-6 mb-8">
          <Card
            title="Total Members"
            value={summary.total_members}
            trend={5}
          />
          <Card
            title="Active Members"
            value={summary.active_members}
            trend={3}
          />
          <Card
            title="Total Savings"
            value={`₦${(summary.total_savings / 1000000).toFixed(2)}M`}
            trend={8}
          />
          <Card
            title="Total Shares"
            value={`₦${(summary.total_shares / 1000000).toFixed(2)}M`}
            trend={-2}
          />
          <Card
            title="Outstanding Loans"
            value={`₦${(summary.total_loans_outstanding / 1000000).toFixed(2)}M`}
            trend={12}
          />
          <Card
            title="Fees Collected"
            value={`₦${(summary.total_fees_collected / 1000).toFixed(0)}K`}
            trend={6}
          />
        </div>

        <div className="grid grid-cols-1 lg:grid-cols-2 gap-8">
          <div className="bg-white rounded-lg shadow p-6">
            <h2 className="text-lg font-semibold mb-4">Recent Activities</h2>
            <div className="text-gray-500 text-center py-8">
              No recent activities
            </div>
          </div>

          <div className="bg-white rounded-lg shadow p-6">
            <h2 className="text-lg font-semibold mb-4">Loan Status Summary</h2>
            <div className="text-gray-500 text-center py-8">
              Chart coming soon
            </div>
          </div>
        </div>
      </div>
    </Layout>
  );
};

export default Dashboard;
