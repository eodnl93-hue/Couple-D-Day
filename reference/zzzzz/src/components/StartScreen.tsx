import React, { useState, useEffect } from 'react';
import { motion } from 'motion/react';
import { CoupleProfile, Screen } from '../types';

interface StartScreenProps {
  profile: CoupleProfile;
  onNavigate: (screen: Screen) => void;
}

export default function StartScreen({ profile, onNavigate }: StartScreenProps) {
  const [timeElapsed, setTimeElapsed] = useState({
    years: 0,
    days: 0,
    hours: 0,
    minutes: 0,
    seconds: 0,
  });

  useEffect(() => {
    const calculateTime = () => {
      const start = new Date(profile.startDate);
      const now = new Date();
      let diff = now.getTime() - start.getTime();

      if (diff < 0) diff = 0;

      const seconds = Math.floor((diff / 1000) % 60);
      const minutes = Math.floor((diff / (1000 * 60)) % 60);
      const hours = Math.floor((diff / (1000 * 60 * 60)) % 24);
      
      // Approximate years and days
      const totalDays = Math.floor(diff / (1000 * 60 * 60 * 24));
      const years = Math.floor(totalDays / 365);
      const days = totalDays % 365;

      setTimeElapsed({ years, days, hours, minutes, seconds });
    };

    calculateTime();
    const timer = setInterval(calculateTime, 1000);
    return () => clearInterval(timer);
  }, [profile.startDate]);

  const formatDate = (dateStr: string) => {
    const date = new Date(dateStr);
    return `${date.getFullYear()}년 ${String(date.getMonth() + 1).padStart(2, '0')}월 ${String(date.getDate()).padStart(2, '0')}일`;
  };

  return (
    <motion.div
      initial={{ opacity: 0 }}
      animate={{ opacity: 1 }}
      exit={{ opacity: 0 }}
      className="relative h-screen w-full overflow-hidden cursor-pointer bg-black"
      onClick={() => onNavigate('main')}
    >
      {/* Background Image */}
      <img
        src="https://images.unsplash.com/photo-1518173946687-a4c8a9b749f5?auto=format&fit=crop&q=80&w=1000"
        alt="Sunset Silhouette"
        className="absolute inset-0 h-full w-full object-cover opacity-70"
        referrerPolicy="no-referrer"
      />
      
      {/* Overlay for better text readability */}
      <div className="absolute inset-0 bg-gradient-to-b from-black/30 via-transparent to-black/60" />

      {/* Timer Content */}
      <div className="relative h-full flex flex-col items-center justify-center text-white font-sans">
        <div className="flex flex-col items-center space-y-4 mb-20">
          <div className="flex flex-col items-center">
            <span className="text-6xl font-bold mb-1">{timeElapsed.years}</span>
            <span className="text-2xl font-medium opacity-90">년</span>
          </div>
          <div className="flex flex-col items-center">
            <span className="text-6xl font-bold mb-1">{timeElapsed.days}</span>
            <span className="text-2xl font-medium opacity-90">일</span>
          </div>
          <div className="flex flex-col items-center">
            <span className="text-6xl font-bold mb-1">{timeElapsed.hours}</span>
            <span className="text-2xl font-medium opacity-90">시간</span>
          </div>
          <div className="flex flex-col items-center">
            <span className="text-6xl font-bold mb-1">{timeElapsed.minutes}</span>
            <span className="text-2xl font-medium opacity-90">분</span>
          </div>
          <div className="flex flex-col items-center">
            <span className="text-6xl font-bold mb-1">{timeElapsed.seconds}</span>
            <span className="text-2xl font-medium opacity-90">초</span>
          </div>
        </div>

        {/* Bottom Text */}
        <div className="absolute bottom-16 flex flex-col items-center space-y-2">
          <h2 className="text-4xl font-bold tracking-wide">우리의 날 💕</h2>
          <p className="text-xl opacity-80">{formatDate(profile.startDate)}</p>
        </div>
      </div>
    </motion.div>
  );
}
