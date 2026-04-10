import React, { useState } from 'react';
import { motion } from 'motion/react';
import { ArrowLeft, Camera, Calendar } from 'lucide-react';
import { CoupleProfile, Screen } from '../types';

interface SettingsScreenProps {
  profile: CoupleProfile;
  onSave: (updatedProfile: CoupleProfile) => void;
  onBack: () => void;
}

export default function SettingsScreen({ profile, onSave, onBack }: SettingsScreenProps) {
  const [nick1, nick2] = profile.nickname.split('💕').concat(['', '']);
  const [nickname1, setNickname1] = useState(nick1);
  const [nickname2, setNickname2] = useState(nick2);
  const [startDate, setStartDate] = useState(profile.startDate.split('T')[0]);
  const [profileImage, setProfileImage] = useState(profile.profileImage);

  const handleImageChange = () => {
    // Simulate image picker
    const randomId = Math.floor(Math.random() * 1000);
    setProfileImage(`https://picsum.photos/seed/${randomId}/200`);
  };

  const handleSave = () => {
    onSave({
      ...profile,
      nickname: `${nickname1}💕${nickname2}`,
      startDate: new Date(startDate).toISOString(),
      profileImage,
    });
  };

  return (
    <motion.div
      initial={{ x: '100%' }}
      animate={{ x: 0 }}
      exit={{ x: '100%' }}
      transition={{ type: 'spring', damping: 25, stiffness: 200 }}
      className="flex flex-col h-screen bg-white max-w-md mx-auto shadow-xl"
    >
      {/* Header */}
      <div className="p-6 pt-12 flex items-center space-x-4 border-b border-gray-50">
        <button onClick={onBack} className="p-2 -ml-2 text-gray-600 hover:bg-gray-100 rounded-full transition-colors">
          <ArrowLeft size={24} />
        </button>
        <h1 className="text-xl font-bold text-gray-800">프로필 설정</h1>
      </div>

      <div className="flex-1 overflow-y-auto p-6 space-y-8">
        {/* Profile Image Section */}
        <div className="flex flex-col items-center space-y-4">
          <div className="relative group">
            <div className="w-32 h-32 rounded-full overflow-hidden border-4 border-pink-50 shadow-inner">
              <img 
                src={profileImage || "https://picsum.photos/seed/couple/200"} 
                alt="Profile" 
                className="w-full h-full object-cover"
                referrerPolicy="no-referrer"
              />
            </div>
            <button 
              onClick={handleImageChange}
              className="absolute bottom-0 right-0 bg-pink-500 text-white p-3 rounded-full shadow-lg border-4 border-white hover:scale-110 transition-transform"
            >
              <Camera size={20} />
            </button>
          </div>
          <p className="text-sm text-gray-400">프로필 사진을 변경하려면 카메라 아이콘을 누르세요</p>
        </div>

        {/* Form Section */}
        <div className="space-y-6">
          <div className="space-y-2">
            <label className="text-base font-semibold text-gray-500 ml-1">애칭</label>
            <div className="flex items-center space-x-1">
              <input 
                type="text" 
                value={nickname1}
                onChange={(e) => setNickname1(e.target.value)}
                placeholder="닉네임 1"
                className="flex-1 min-w-0 px-2 py-3 bg-gray-50 border border-gray-100 rounded-2xl focus:outline-none focus:ring-2 focus:ring-pink-200 focus:bg-white transition-all text-center text-base sm:text-lg"
              />
              <span className="text-pink-500 text-xl shrink-0">💕</span>
              <input 
                type="text" 
                value={nickname2}
                onChange={(e) => setNickname2(e.target.value)}
                placeholder="닉네임 2"
                className="flex-1 min-w-0 px-2 py-3 bg-gray-50 border border-gray-100 rounded-2xl focus:outline-none focus:ring-2 focus:ring-pink-200 focus:bg-white transition-all text-center text-base sm:text-lg"
              />
            </div>
          </div>

          <div className="space-y-2">
            <label className="text-base font-semibold text-gray-500 ml-1">연애 시작일</label>
            <div className="relative">
              <input 
                type="date" 
                value={startDate}
                onChange={(e) => setStartDate(e.target.value)}
                className="w-full px-4 py-3 bg-gray-50 border border-gray-100 rounded-2xl focus:outline-none focus:ring-2 focus:ring-pink-200 focus:bg-white transition-all appearance-none text-base"
              />
              <Calendar size={20} className="absolute right-4 top-1/2 -translate-y-1/2 text-gray-400 pointer-events-none" />
            </div>
          </div>
        </div>
      </div>

      {/* Save Button */}
      <div className="p-6 border-t border-gray-50">
        <button 
          onClick={handleSave}
          className="w-full py-4 bg-pink-500 text-white font-bold rounded-2xl shadow-lg shadow-pink-100 hover:bg-pink-600 active:scale-95 transition-all"
        >
          저장하기
        </button>
      </div>
    </motion.div>
  );
}
