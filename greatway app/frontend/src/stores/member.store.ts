import { create } from 'zustand';

interface Member {
  member_id: number;
  member_code: string;
  first_name: string;
  last_name: string;
  email: string;
  phone: string;
  status: 'active' | 'inactive' | 'suspended';
}

interface MemberState {
  members: Member[];
  selectedMember: Member | null;
  loading: boolean;
  fetchMembers: () => Promise<void>;
  selectMember: (member: Member) => void;
}

export const useMemberStore = create<MemberState>((set) => ({
  members: [],
  selectedMember: null,
  loading: false,
  fetchMembers: async () => {
    // TODO: Implement fetch from API
    set({ loading: true });
    set({ loading: false });
  },
  selectMember: (member) => {
    set({ selectedMember: member });
  },
}));
