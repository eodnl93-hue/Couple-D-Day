import 'package:flutter/material.dart';

class CoupleProfile {
  String nickname;
  String startDate;
  String profileImage;
  String backgroundImage;
  String themeColor; // e.g. 'pink', 'blue', 'purple', 'green'

  CoupleProfile({
    required this.nickname,
    required this.startDate,
    required this.profileImage,
    required this.backgroundImage,
    this.themeColor = 'pink',
  });

  factory CoupleProfile.fromJson(Map<String, dynamic> json) {
    return CoupleProfile(
      nickname: json['nickname'] ?? '영희💕철수',
      startDate: json['startDate'] ?? '2022-06-01T00:00:00.000Z',
      profileImage: json['profileImage'] ?? 'https://picsum.photos/seed/couple/200',
      backgroundImage: json['backgroundImage'] ?? 'https://images.unsplash.com/photo-1518173946687-a4c8a9b749f5?auto=format&fit=crop&q=80&w=1000',
      themeColor: json['themeColor'] ?? 'pink',
    );
  }

  Map<String, dynamic> toJson() => {
    'nickname': nickname,
    'startDate': startDate,
    'profileImage': profileImage,
    'backgroundImage': backgroundImage,
    'themeColor': themeColor,
  };
}

class Post {
  String id;
  String date;
  String imageUrl;
  String memo;
  bool isLiked;

  Post({
    required this.id,
    required this.date,
    required this.imageUrl,
    required this.memo,
    this.isLiked = false,
  });

  factory Post.fromJson(Map<String, dynamic> json) {
    return Post(
      id: json['id'],
      date: json['date'],
      imageUrl: json['imageUrl'],
      memo: json['memo'],
      isLiked: json['isLiked'] ?? false,
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'date': date,
    'imageUrl': imageUrl,
    'memo': memo,
    'isLiked': isLiked,
  };
}

class AppThemeColors {
  final Color c500;
  final Color c600;
  final Color c300;
  final Color c200;
  final Color c100;
  final Color c50;

  const AppThemeColors({required this.c500, required this.c600, required this.c300, required this.c200, required this.c100, required this.c50});
}

class AppColors {
  static const themes = {
    'pink': AppThemeColors(c500: Color(0xFFEC4899), c600: Color(0xFFDB2777), c300: Color(0xFFF9A8D4), c200: Color(0xFFFBCFE8), c100: Color(0xFFFCE7F3), c50: Color(0xFFFDF2F8)),
    'blue': AppThemeColors(c500: Color(0xFF3B82F6), c600: Color(0xFF2563EB), c300: Color(0xFF93C5FD), c200: Color(0xFFBFDBFE), c100: Color(0xFFDBEAFE), c50: Color(0xFFEFF6FF)),
    'purple': AppThemeColors(c500: Color(0xFFA855F7), c600: Color(0xFF9333EA), c300: Color(0xFFD8B4FE), c200: Color(0xFFE9D5FF), c100: Color(0xFFF3EAFF), c50: Color(0xFFFAF5FF)),
    'green': AppThemeColors(c500: Color(0xFF22C55E), c600: Color(0xFF16A34A), c300: Color(0xFF86EFAC), c200: Color(0xFFBBF7D0), c100: Color(0xFFDCFCE7), c50: Color(0xFFF0FDF4)),
  };

  static String currentThemeName = 'pink';
  static final ValueNotifier<String> themeNotifier = ValueNotifier('pink');

  static AppThemeColors get _current => themes[currentThemeName] ?? themes['pink']!;

  static Color get pink500 => _current.c500;
  static Color get pink600 => _current.c600;
  static Color get pink300 => _current.c300;
  static Color get pink200 => _current.c200;
  static Color get pink100 => _current.c100;
  static Color get pink50 => _current.c50;

  // Static grays
  static const Color gray800 = Color(0xFF1F2937);
  static const Color gray700 = Color(0xFF374151);
  static const Color gray600 = Color(0xFF4B5563);
  static const Color gray500 = Color(0xFF6B7280);
  static const Color gray400 = Color(0xFF9CA3AF);
  static const Color gray200 = Color(0xFFE5E7EB);
  static const Color gray100 = Color(0xFFF3F4F6);
  static const Color gray50 = Color(0xFFF9FAFB);
  static const Color red500 = Color(0xFFEF4444);
  static const Color red50 = Color(0xFFFEF2F2);
}

