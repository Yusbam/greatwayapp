import { create } from 'zustand';

interface AuthState {
  isAuthenticated: boolean;
  user: any | null;
  login: (credentials: any) => Promise<void>;
  logout: () => void;
}

export const useAuthStore = create<AuthState>((set) => ({
  isAuthenticated: !!localStorage.getItem('token'),
  user: null,
  login: async (credentials) => {
    // TODO: Implement login
    set({ isAuthenticated: true });
  },
  logout: () => {
    localStorage.removeItem('token');
    set({ isAuthenticated: false, user: null });
  },
}));
