import React from 'react';

interface CardProps {
  title: string;
  value: string | number;
  icon?: React.ReactNode;
  trend?: number;
}

export const Card: React.FC<CardProps> = ({ title, value, icon, trend }) => {
  return (
    <div className="bg-white rounded-lg shadow p-6">
      <div className="flex items-start justify-between">
        <div>
          <p className="text-gray-600 text-sm font-medium">{title}</p>
          <p className="text-2xl font-bold mt-2">{value}</p>
          {trend && (
            <p className={`text-sm mt-2 ${trend > 0 ? 'text-green-600' : 'text-red-600'}`}>
              {trend > 0 ? '+' : ''}{trend}% from last month
            </p>
          )}
        </div>
        {icon && <div className="text-gray-400 text-2xl">{icon}</div>}
      </div>
    </div>
  );
};
