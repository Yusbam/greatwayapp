import React from 'react';

export const Sidebar: React.FC = () => {
  return (
    <aside className="w-64 bg-gray-900 text-white h-screen p-4">
      <div className="mb-8">
        <h1 className="text-2xl font-bold">Greatway Coop</h1>
        <p className="text-sm text-gray-400">Member Management</p>
      </div>

      <nav className="space-y-2">
        <a href="/" className="block px-4 py-2 rounded hover:bg-gray-800">
          Dashboard
        </a>
        <a href="/members" className="block px-4 py-2 rounded hover:bg-gray-800">
          Members
        </a>
        <a href="/finances" className="block px-4 py-2 rounded hover:bg-gray-800">
          Finances
        </a>
        <a href="/loans" className="block px-4 py-2 rounded hover:bg-gray-800">
          Loans
        </a>
        <a href="/reports" className="block px-4 py-2 rounded hover:bg-gray-800">
          Reports
        </a>
        <a href="/settings" className="block px-4 py-2 rounded hover:bg-gray-800">
          Settings
        </a>
      </nav>

      <div className="absolute bottom-4 left-4 right-4">
        <button className="w-full px-4 py-2 bg-red-600 rounded hover:bg-red-700">
          Logout
        </button>
      </div>
    </aside>
  );
};
