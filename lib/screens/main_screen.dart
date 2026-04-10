import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:intl/intl.dart';
import '../models.dart';
import '../data_manager.dart';
import '../image_utils.dart';
import 'settings_screen.dart';
import 'post_creation_screen.dart';
import 'start_screen.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  late CoupleProfile profile;
  late List<Post> posts;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  void _loadData() {
    setState(() {
      profile = DataManager().profile;
      posts = DataManager().posts;
    });
  }

  int _calculateDDay() {
    final start = DateTime.parse(profile.startDate);
    final now = DateTime.now();
    final diff = now.difference(start);
    return diff.inDays + 1;
  }

  String _formatDate(String dateStr) {
    final date = DateTime.parse(dateStr);
    return DateFormat('yyyy.MM.dd').format(date);
  }

  void _deletePost(String id) {
    setState(() {
      posts.removeWhere((p) => p.id == id);
      DataManager().savePosts(posts);
    });
  }

  void _toggleLike(String id) {
    setState(() {
      final index = posts.indexWhere((p) => p.id == id);
      if (index != -1) {
        posts[index].isLiked = !posts[index].isLiked;
        DataManager().savePosts(posts);
      }
    });
  }

  void _navigate(Widget screen) {
    Navigator.pushReplacement(
      context,
      PageRouteBuilder(
        pageBuilder: (_, __, ___) => screen,
        transitionsBuilder: (_, anim, __, child) => FadeTransition(opacity: anim, child: child),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.pink50,
      body: Column(
        children: [
          // Header
          GestureDetector(
            onTap: () => _navigate(const SettingsScreen()),
            child: Container(
              margin: EdgeInsets.only(top: MediaQuery.of(context).padding.top),
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: AppColors.pink100.withOpacity(0.8),
                border: Border(bottom: BorderSide(color: AppColors.pink200.withOpacity(0.5))),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.pink300.withOpacity(0.1),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  )
                ],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      SizedBox(
                        width: 64,
                        height: 64,
                        child: Stack(
                          clipBehavior: Clip.none,
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                border: Border.all(color: AppColors.pink200, width: 2),
                                image: DecorationImage(
                                  image: getImageProvider(profile.profileImage),
                                  fit: BoxFit.cover,
                                )
                              ),
                            ),
                            Positioned(
                              bottom: -4,
                              right: -4,
                              child: Container(
                                padding: const EdgeInsets.all(4),
                                decoration: BoxDecoration(
                                  color: AppColors.pink500,
                                  shape: BoxShape.circle,
                                  border: Border.all(color: Colors.white, width: 2),
                                ),
                                child: const Icon(Icons.favorite, size: 12, color: Colors.white),
                              ),
                            )
                          ],
                        ),
                      ),
                      const SizedBox(width: 16),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            profile.nickname,
                            style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: AppColors.gray800),
                          ),
                          Text(
                            "D+${_calculateDDay()}",
                            style: TextStyle(fontSize: 20, fontWeight: FontWeight.w900, color: AppColors.pink500),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const Icon(LucideIcons.settings, size: 20, color: AppColors.gray400),
                ],
              ),
            ),
          ),
          
          // Feed
          Expanded(
            child: posts.isEmpty 
                ? _buildEmptyState()
                : ListView.separated(
                    padding: const EdgeInsets.only(top: 16, bottom: 100, left: 16, right: 16),
                    itemCount: posts.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 24),
                    itemBuilder: (context, index) {
                      final post = posts[index];
                      return _buildPostCard(post).animate().fadeIn().scale(begin: const Offset(0.95, 0.95));
                    },
                  ),
          ),
        ],
      ).animate().fadeIn().moveY(begin: 20, end: 0),
      bottomSheet: _buildBottomNav(),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(LucideIcons.heart, size: 64, color: AppColors.pink200),
          const SizedBox(height: 16),
          Text("우리의 소중한 추억을\n기록해보세요! 💕", 
            textAlign: TextAlign.center,
            style: TextStyle(color: AppColors.pink300, fontSize: 18, fontWeight: FontWeight.w500)
          ),
        ],
      ),
    );
  }

  Widget _buildPostCard(Post post) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.gray100),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  _formatDate(post.date),
                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500, color: AppColors.gray500),
                ),
                Row(
                  children: [
                    IconButton(
                      icon: Icon(
                        post.isLiked ? Icons.favorite : LucideIcons.heart,
                        color: post.isLiked ? AppColors.pink500 : AppColors.gray400,
                        size: 18,
                      ),
                      onPressed: () => _toggleLike(post.id),
                      constraints: const BoxConstraints(),
                      padding: const EdgeInsets.all(8),
                    ),
                    PopupMenuButton<String>(
                      icon: const Icon(LucideIcons.moreVertical, size: 18, color: AppColors.gray400),
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(),
                      onSelected: (value) {
                        if (value == 'edit') {
                          _navigate(PostCreationScreen(initialPost: post));
                        } else if (value == 'delete') {
                          _deletePost(post.id);
                        }
                      },
                      itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
                        const PopupMenuItem<String>(
                          value: 'edit',
                          child: Row(
                            children: [
                              Icon(LucideIcons.edit3, size: 14, color: AppColors.gray700),
                              SizedBox(width: 8),
                              Text('수정', style: TextStyle(fontSize: 14)),
                            ],
                          ),
                        ),
                        const PopupMenuItem<String>(
                          value: 'delete',
                          child: Row(
                            children: [
                              Icon(LucideIcons.trash2, size: 14, color: AppColors.red500),
                              SizedBox(width: 8),
                              Text('삭제', style: TextStyle(fontSize: 14, color: AppColors.red500)),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
          AspectRatio(
            aspectRatio: 1,
            child: Container(
              color: AppColors.gray100,
              child: buildImageWidget(post.imageUrl, fit: BoxFit.cover),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Text(
              post.memo,
              style: const TextStyle(fontSize: 18, color: AppColors.gray800, height: 1.5),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomNav() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        border: const Border(top: BorderSide(color: AppColors.gray100)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, -4),
          )
        ],
      ),
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 32),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          IconButton(
            icon: const Icon(LucideIcons.home, size: 24, color: AppColors.gray400),
            onPressed: () => _navigate(const StartScreen()),
          ),
          GestureDetector(
            onTap: () => _navigate(const PostCreationScreen()),
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.pink500,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: AppColors.pink200.withOpacity(0.8),
                    blurRadius: 10,
                    spreadRadius: 2,
                    offset: const Offset(0, 4),
                  )
                ]
              ),
              child: const Icon(LucideIcons.plus, size: 28, color: Colors.white),
            )
          ),
          IconButton(
            icon: const Icon(LucideIcons.user, size: 24, color: AppColors.gray400),
            onPressed: () => _navigate(const SettingsScreen()),
          ),
        ],
      ),
    );
  }
}
