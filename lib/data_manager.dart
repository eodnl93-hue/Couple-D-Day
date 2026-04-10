import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'models.dart';

class DataManager {
  static final DataManager _instance = DataManager._internal();
  factory DataManager() => _instance;
  DataManager._internal();

  late SharedPreferences _prefs;

  late CoupleProfile profile;
  List<Post> posts = [];

  Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
    _loadData();
  }

  void _loadData() {
    final profileStr = _prefs.getString('couple_profile');
    if (profileStr != null) {
      profile = CoupleProfile.fromJson(jsonDecode(profileStr));
    } else {
      profile = CoupleProfile(
        nickname: "영희💕철수",
        startDate: "2022-06-01T00:00:00.000Z",
        profileImage: "https://picsum.photos/seed/couple/200",
        backgroundImage: "https://images.unsplash.com/photo-1518173946687-a4c8a9b749f5?auto=format&fit=crop&q=80&w=1000",
        themeColor: 'pink',
      );
    }
    AppColors.currentThemeName = profile.themeColor;
    AppColors.themeNotifier.value = profile.themeColor;

    final postsStr = _prefs.getString('couple_posts');
    if (postsStr != null) {
      final List<dynamic> decoded = jsonDecode(postsStr);
      posts = decoded.map((e) => Post.fromJson(e)).toList();
    } else {
      posts = [
        Post(
          id: '1',
          date: "2023-12-25T00:00:00.000Z",
          imageUrl: "https://picsum.photos/seed/xmas/800/800",
          memo: "첫 번째 크리스마스! 명동에서 맛있는 거 먹고 행복했어 🎄",
        ),
        Post(
          id: '2',
          date: "2024-01-01T00:00:00.000Z",
          imageUrl: "https://picsum.photos/seed/newyear/800/800",
          memo: "새해 복 많이 받자! 우리 올해도 행복하자 🌅",
        )
      ];
    }
  }

  Future<void> saveProfile(CoupleProfile p) async {
    profile = p;
    await _prefs.setString('couple_profile', jsonEncode(p.toJson()));
  }

  Future<void> savePosts(List<Post> p) async {
    posts = p;
    await _prefs.setString('couple_posts', jsonEncode(p.map((e) => e.toJson()).toList()));
  }
}
