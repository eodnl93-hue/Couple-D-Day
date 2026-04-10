import React from 'react';
import { motion, AnimatePresence } from 'motion/react';
import { Heart, Plus, Settings, User, MoreVertical, Trash2, Edit3, Home, Search } from 'lucide-react';
import { CoupleProfile, Post, Screen } from '../types';

interface MainScreenProps {
  profile: CoupleProfile;
  posts: Post[];
  onNavigate: (screen: Screen) => void;
  onDeletePost: (id: string) => void;
  onEditPost: (post: Post) => void;
  onToggleLike: (id: string) => void;
}

export default function MainScreen({ profile, posts, onNavigate, onDeletePost, onEditPost, onToggleLike }: MainScreenProps) {
  const [activeMenu, setActiveMenu] = React.useState<string | null>(null);

  const calculateDDay = () => {
    const start = new Date(profile.startDate);
    const now = new Date();
    const diff = now.getTime() - start.getTime();
    const days = Math.floor(diff / (1000 * 60 * 60 * 24)) + 1;
    return days;
  };

  const formatDate = (dateStr: string) => {
    const date = new Date(dateStr);
    return `${date.getFullYear()}.${String(date.getMonth() + 1).padStart(2, '0')}.${String(date.getDate()).padStart(2, '0')}`;
  };

  return (
    <motion.div
      initial={{ opacity: 0, y: 20 }}
      animate={{ opacity: 1, y: 0 }}
      className="flex flex-col h-screen bg-gray-50 max-w-md mx-auto shadow-xl"
      onClick={() => setActiveMenu(null)}
    >
      {/* Header / Profile Section */}
      <div 
        className="bg-white p-6 pt-12 flex items-center justify-between border-b border-gray-100 cursor-pointer hover:bg-gray-50 transition-colors"
        onClick={() => onNavigate('settings')}
      >
        <div className="flex items-center space-x-4">
          <div className="relative">
            <div className="w-16 h-16 rounded-full overflow-hidden border-2 border-pink-200">
              <img 
                src={profile.profileImage || "https://picsum.photos/seed/couple/200"} 
                alt="Profile" 
                className="w-full h-full object-cover"
                referrerPolicy="no-referrer"
              />
            </div>
            <div className="absolute -bottom-1 -right-1 bg-pink-500 rounded-full p-1 border-2 border-white">
              <Heart size={12} className="text-white fill-current" />
            </div>
          </div>
          <div>
            <h1 className="text-2xl font-bold text-gray-800">{profile.nickname}</h1>
            <p className="text-xl font-black text-pink-500">D+{calculateDDay()}</p>
          </div>
        </div>
        <div className="flex flex-col items-end">
          <Settings size={20} className="text-gray-400" />
        </div>
      </div>

      {/* Feed Section */}
      <div className="flex-1 overflow-y-auto pb-24 px-4 space-y-6 pt-4">
        {posts.length === 0 ? (
          <div className="flex flex-col items-center justify-center h-64 text-gray-400 space-y-4">
            <Heart size={48} className="opacity-20" />
            <p>첫 번째 추억을 기록해보세요!</p>
          </div>
        ) : (
          posts.map((post) => (
            <motion.div 
              key={post.id}
              initial={{ opacity: 0, scale: 0.95 }}
              whileInView={{ opacity: 1, scale: 1 }}
              viewport={{ once: true }}
              className="bg-white rounded-2xl overflow-hidden shadow-sm border border-gray-100 relative"
            >
              <div className="p-4 flex items-center justify-between">
                <span className="text-base font-medium text-gray-500">{formatDate(post.date)}</span>
                <div className="flex items-center space-x-2">
                  <button 
                    onClick={(e) => {
                      e.stopPropagation();
                      onToggleLike(post.id);
                    }}
                    className="p-1 hover:bg-gray-100 rounded-full transition-colors"
                  >
                    <Heart 
                      size={18} 
                      className={`${post.isLiked ? 'text-pink-500 fill-current' : 'text-gray-400'}`} 
                    />
                  </button>
                  <button 
                    onClick={(e) => {
                      e.stopPropagation();
                      setActiveMenu(activeMenu === post.id ? null : post.id);
                    }}
                    className="p-1 hover:bg-gray-100 rounded-full transition-colors text-gray-400"
                  >
                    <MoreVertical size={18} />
                  </button>
                </div>
              </div>

              {/* Dropdown Menu */}
              <AnimatePresence>
                {activeMenu === post.id && (
                  <motion.div
                    initial={{ opacity: 0, scale: 0.9, y: -10 }}
                    animate={{ opacity: 1, scale: 1, y: 0 }}
                    exit={{ opacity: 0, scale: 0.9, y: -10 }}
                    className="absolute right-4 top-12 bg-white shadow-xl border border-gray-100 rounded-xl py-2 z-10 min-w-[100px]"
                  >
                    <button 
                      onClick={(e) => {
                        e.stopPropagation();
                        onEditPost(post);
                        setActiveMenu(null);
                      }}
                      className="w-full px-4 py-2 text-left text-sm text-gray-700 hover:bg-gray-50 flex items-center space-x-2"
                    >
                      <Edit3 size={14} />
                      <span>수정</span>
                    </button>
                    <button 
                      onClick={(e) => {
                        e.stopPropagation();
                        if (confirm('정말 삭제하시겠습니까?')) {
                          onDeletePost(post.id);
                        }
                        setActiveMenu(null);
                      }}
                      className="w-full px-4 py-2 text-left text-sm text-red-500 hover:bg-red-50 flex items-center space-x-2"
                    >
                      <Trash2 size={14} />
                      <span>삭제</span>
                    </button>
                  </motion.div>
                )}
              </AnimatePresence>

              <div className="aspect-square w-full overflow-hidden bg-gray-100">
                <img 
                  src={post.imageUrl} 
                  alt="Memory" 
                  className="w-full h-full object-cover"
                  referrerPolicy="no-referrer"
                />
              </div>
              <div className="p-4">
                <p className="text-lg text-gray-800 leading-relaxed whitespace-pre-wrap">{post.memo}</p>
              </div>
            </motion.div>
          ))
        )}
      </div>

      {/* Bottom Navigation */}
      <div className="fixed bottom-0 left-1/2 -translate-x-1/2 w-full max-w-md bg-white border-t border-gray-100 px-4 py-4 flex items-center justify-around shadow-[0_-4px_10px_rgba(0,0,0,0.05)]">
        <button 
          onClick={() => onNavigate('start')}
          className="text-gray-400 hover:text-pink-500 transition-colors p-2"
        >
          <Home size={24} />
        </button>
        <button 
          onClick={() => onNavigate('create_post')}
          className="bg-pink-500 text-white p-4 rounded-full shadow-lg shadow-pink-200 hover:scale-110 transition-transform active:scale-95 flex items-center justify-center"
        >
          <Plus size={28} />
        </button>
        <button 
          onClick={() => onNavigate('settings')}
          className="text-gray-400 hover:text-pink-500 transition-colors p-2"
        >
          <User size={24} />
        </button>
      </div>
    </motion.div>
  );
}
