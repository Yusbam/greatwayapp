import React, { useState } from 'react';
import { Layout } from '../components/Layout';
import { Member } from '../types';

const Members: React.FC = () => {
  const [members, setMembers] = useState<Member[]>([]);
  const [loading, setLoading] = useState(false);

  // TODO: Fetch members from API
  React.useEffect(() => {
    setLoading(true);
    // Simulate API call
    setTimeout(() => {
      setMembers([
        {
          member_id: 1,
          member_code: 'GC001',
          first_name: 'John',
          last_name: 'Doe',
          email: 'john@example.com',
          phone: '08012345678',
          date_of_birth: new Date(),
          address: '123 Main St',
          occupation: 'Engineer',
          guarantor_name: 'Jane Doe',
          guarantor_phone: '08098765432',
          date_joined: new Date(),
          status: 'active',
        },
      ]);
      setLoading(false);
    }, 500);
  }, []);

  return (
    <Layout>
      <div>
        <div className="flex justify-between items-center mb-8">
          <h1 className="text-3xl font-bold">Members</h1>
          <button className="px-4 py-2 bg-blue-600 text-white rounded hover:bg-blue-700">
            Add Member
          </button>
        </div>

        {loading ? (
          <div className="text-center py-8">Loading...</div>
        ) : (
          <div className="bg-white rounded-lg shadow overflow-x-auto">
            <table className="w-full">
              <thead className="bg-gray-50 border-b">
                <tr>
                  <th className="px-6 py-3 text-left text-sm font-semibold">Member Code</th>
                  <th className="px-6 py-3 text-left text-sm font-semibold">Name</th>
                  <th className="px-6 py-3 text-left text-sm font-semibold">Email</th>
                  <th className="px-6 py-3 text-left text-sm font-semibold">Phone</th>
                  <th className="px-6 py-3 text-left text-sm font-semibold">Status</th>
                  <th className="px-6 py-3 text-left text-sm font-semibold">Actions</th>
                </tr>
              </thead>
              <tbody>
                {members.map((member) => (
                  <tr key={member.member_id} className="border-b hover:bg-gray-50">
                    <td className="px-6 py-4 text-sm font-medium">{member.member_code}</td>
                    <td className="px-6 py-4 text-sm">{`${member.first_name} ${member.last_name}`}</td>
                    <td className="px-6 py-4 text-sm">{member.email}</td>
                    <td className="px-6 py-4 text-sm">{member.phone}</td>
                    <td className="px-6 py-4 text-sm">
                      <span className={`px-2 py-1 rounded text-xs font-semibold ${
                        member.status === 'active' ? 'bg-green-100 text-green-800' : 'bg-gray-100 text-gray-800'
                      }`}>
                        {member.status}
                      </span>
                    </td>
                    <td className="px-6 py-4 text-sm">
                      <button className="text-blue-600 hover:text-blue-900 mr-4">View</button>
                      <button className="text-green-600 hover:text-green-900 mr-4">Edit</button>
                      <button className="text-red-600 hover:text-red-900">Delete</button>
                    </td>
                  </tr>
                ))}
              </tbody>
            </table>
          </div>
        )}
      </div>
    </Layout>
  );
};

export default Members;
