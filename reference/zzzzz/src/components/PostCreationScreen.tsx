import React, { useState } from 'react';
import { motion } from 'motion/react';
import { ArrowLeft, Camera, Calendar, Check } from 'lucide-react';
import { Post, Screen } from '../types';

interface PostCreationScreenProps {
  onSave: (newPost: Post) => void;
  onBack: () => void;
  initialPost?: Post;
}

export default function PostCreationScreen({ onSave, onBack, initialPost }: PostCreationScreenProps) {
  const [date, setDate] = useState(initialPost?.date.split('T')[0] || new Date().toISOString().split('T')[0]);
  const [memo, setMemo] = useState(initialPost?.memo || '');
  const [imageUrl, setImageUrl] = useState(initialPost?.imageUrl || '');

  const handleImagePick = () => {
    // Simulate image picker
    const randomId = Math.floor(Math.random() * 1000);
    setImageUrl(`https://picsum.photos/seed/${randomId}/800/800`);
  };

  const handleRegister = () => {
    if (!imageUrl) {
      alert('사진을 선택해주세요!');
      return;
    }
    onSave({
      id: initialPost?.id || Date.now().toString(),
      date: new Date(date).toISOString(),
      imageUrl,
      memo,
    });
  };

  return (
    <motion.div
      initial={{ y: '100%' }}
      animate={{ y: 0 }}
      exit={{ y: '100%' }}
      transition={{ type: 'spring', damping: 25, stiffness: 200 }}
      className="flex flex-col h-screen bg-white max-w-md mx-auto shadow-xl"
    >
      {/* Header */}
      <div className="p-6 pt-12 flex items-center justify-between border-b border-gray-50">
        <div className="flex items-center space-x-4">
          <button onClick={onBack} className="p-2 -ml-2 text-gray-600 hover:bg-gray-100 rounded-full transition-colors">
            <ArrowLeft size={24} />
          </button>
          <h1 className="text-xl font-bold text-gray-800">{initialPost ? '추억 수정하기' : '추억 기록하기'}</h1>
        </div>
        <button 
          onClick={handleRegister}
          className="text-pink-500 font-bold hover:bg-pink-50 px-3 py-1 rounded-lg transition-colors"
        >
          {initialPost ? '수정' : '등록'}
        </button>
      </div>

      <div className="flex-1 overflow-y-auto p-6 space-y-6">
        {/* Image Selection Area */}
        <div 
          onClick={handleImagePick}
          className={`relative aspect-square w-full rounded-3xl border-2 border-dashed border-gray-200 flex flex-col items-center justify-center cursor-pointer overflow-hidden transition-all ${imageUrl ? 'border-none' : 'hover:bg-gray-50'}`}
        >
          {imageUrl ? (
            <>
              <img 
                src={imageUrl} 
                alt="Preview" 
                className="w-full h-full object-cover"
                referrerPolicy="no-referrer"
              />
              <div className="absolute inset-0 bg-black/20 flex items-center justify-center opacity-0 hover:opacity-100 transition-opacity">
                <Camera size={48} className="text-white" />
              </div>
            </>
          ) : (
            <>
              <div className="bg-pink-50 p-6 rounded-full mb-4">
                <Camera size={48} className="text-pink-300" />
              </div>
              <p className="text-gray-400 font-medium">사진을 선택하세요</p>
            </>
          )}
        </div>

        {/* Input Fields */}
        <div className="space-y-6">
          <div className="space-y-2">
            <label className="text-base font-semibold text-gray-500 ml-1">날짜</label>
            <div className="relative">
              <input 
                type="date" 
                value={date}
                onChange={(e) => setDate(e.target.value)}
                className="w-full px-4 py-3 bg-gray-50 border border-gray-100 rounded-2xl focus:outline-none focus:ring-2 focus:ring-pink-200 focus:bg-white transition-all appearance-none text-base"
              />
              <Calendar size={20} className="absolute right-4 top-1/2 -translate-y-1/2 text-gray-400 pointer-events-none" />
            </div>
          </div>

          <div className="space-y-2">
            <label className="text-base font-semibold text-gray-500 ml-1">메모</label>
            <textarea 
              value={memo}
              onChange={(e) => setMemo(e.target.value)}
              placeholder="이날의 소중한 기억을 남겨보세요..."
              rows={4}
              className="w-full px-4 py-3 bg-gray-50 border border-gray-100 rounded-2xl focus:outline-none focus:ring-2 focus:ring-pink-200 focus:bg-white transition-all resize-none text-base"
            />
          </div>
        </div>
      </div>

      {/* Floating Action Button for Register (Alternative) */}
      <div className="p-6 border-t border-gray-50">
        <button 
          onClick={handleRegister}
          className="w-full py-4 bg-pink-500 text-white font-bold rounded-2xl shadow-lg shadow-pink-100 flex items-center justify-center space-x-2 hover:bg-pink-600 active:scale-95 transition-all"
        >
          <Check size={20} />
          <span>기록 저장하기</span>
        </button>
      </div>
    </motion.div>
  );
}
