/**
 * @license
 * SPDX-License-Identifier: Apache-2.0
 */

import React, { useState, useEffect } from 'react';
import { AnimatePresence } from 'motion/react';
import { CoupleProfile, Post, Screen } from './types';
import StartScreen from './components/StartScreen';
import MainScreen from './components/MainScreen';
import SettingsScreen from './components/SettingsScreen';
import PostCreationScreen from './components/PostCreationScreen';

// Initial Mock Data
const INITIAL_PROFILE: CoupleProfile = {
  nickname: "영희💕철수",
  startDate: "2022-06-01T00:00:00.000Z",
  profileImage: "https://picsum.photos/seed/couple/200",
};

const INITIAL_POSTS: Post[] = [
  {
    id: '1',
    date: "2023-12-25T00:00:00.000Z",
    imageUrl: "https://picsum.photos/seed/xmas/800/800",
    memo: "첫 번째 크리스마스! 명동에서 맛있는 거 먹고 행복했어 🎄",
  },
  {
    id: '2',
    date: "2024-01-01T00:00:00.000Z",
    imageUrl: "https://picsum.photos/seed/newyear/800/800",
    memo: "새해 복 많이 받자! 우리 올해도 행복하자 🌅",
  }
];

export default function App() {
  const [currentScreen, setCurrentScreen] = useState<Screen>('start');
  const [editingPost, setEditingPost] = useState<Post | null>(null);
  const [profile, setProfile] = useState<CoupleProfile>(() => {
    const saved = localStorage.getItem('couple_profile');
    return saved ? JSON.parse(saved) : INITIAL_PROFILE;
  });
  const [posts, setPosts] = useState<Post[]>(() => {
    const saved = localStorage.getItem('couple_posts');
    return saved ? JSON.parse(saved) : INITIAL_POSTS;
  });

  // Persist data
  useEffect(() => {
    localStorage.setItem('couple_profile', JSON.stringify(profile));
  }, [profile]);

  useEffect(() => {
    localStorage.setItem('couple_posts', JSON.stringify(posts));
  }, [posts]);

  const handleSaveProfile = (updatedProfile: CoupleProfile) => {
    setProfile(updatedProfile);
    setCurrentScreen('main');
  };

  const handleAddPost = (newPost: Post) => {
    if (editingPost) {
      setPosts(posts.map(p => p.id === newPost.id ? newPost : p));
    } else {
      setPosts([newPost, ...posts]);
    }
    setEditingPost(null);
    setCurrentScreen('main');
  };

  const handleDeletePost = (id: string) => {
    setPosts(posts.filter(p => p.id !== id));
  };

  const handleEditPost = (post: Post) => {
    setEditingPost(post);
    setCurrentScreen('edit_post');
  };

  const handleToggleLike = (id: string) => {
    setPosts(posts.map(p => p.id === id ? { ...p, isLiked: !p.isLiked } : p));
  };

  return (
    <div className="min-h-screen bg-gray-100 font-sans antialiased">
      <div className="max-w-md mx-auto h-screen relative overflow-hidden bg-white shadow-2xl">
        <AnimatePresence mode="wait">
          {currentScreen === 'start' && (
            <div key="start" className="h-full w-full">
              <StartScreen 
                profile={profile} 
                onNavigate={setCurrentScreen} 
              />
            </div>
          )}
          {currentScreen === 'main' && (
            <div key="main" className="h-full w-full">
              <MainScreen 
                profile={profile} 
                posts={posts} 
                onNavigate={setCurrentScreen} 
                onDeletePost={handleDeletePost}
                onEditPost={handleEditPost}
                onToggleLike={handleToggleLike}
              />
            </div>
          )}
          {currentScreen === 'settings' && (
            <div key="settings" className="h-full w-full">
              <SettingsScreen 
                profile={profile} 
                onSave={handleSaveProfile} 
                onBack={() => setCurrentScreen('main')} 
              />
            </div>
          )}
          {(currentScreen === 'create_post' || currentScreen === 'edit_post') && (
            <div key={currentScreen} className="h-full w-full">
              <PostCreationScreen 
                onSave={handleAddPost} 
                onBack={() => {
                  setEditingPost(null);
                  setCurrentScreen('main');
                }} 
                initialPost={editingPost || undefined}
              />
            </div>
          )}
        </AnimatePresence>
      </div>
    </div>
  );
}
