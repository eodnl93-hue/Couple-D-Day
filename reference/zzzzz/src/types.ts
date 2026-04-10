export interface CoupleProfile {
  nickname: string;
  startDate: string; // ISO string
  profileImage: string;
}

export interface Post {
  id: string;
  date: string; // ISO string
  imageUrl: string;
  memo: string;
  isLiked?: boolean;
}

export type Screen = 'start' | 'main' | 'settings' | 'create_post' | 'edit_post';
