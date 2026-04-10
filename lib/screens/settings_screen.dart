import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../models.dart';
import '../data_manager.dart';
import '../image_utils.dart';
import 'package:image_picker/image_picker.dart';
import 'main_screen.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  late String _nickname1;
  late String _nickname2;
  late String _startDate;
  late String _profileImage;
  late String _backgroundImage;
  late String _themeColor;
  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    final profile = DataManager().profile;
    final parts = profile.nickname.split('💕');
    _nickname1 = parts.isNotEmpty ? parts[0] : '';
    _nickname2 = parts.length > 1 ? parts[1] : '';
    _startDate = profile.startDate.split('T')[0];
    _profileImage = profile.profileImage;
    _backgroundImage = profile.backgroundImage;
    _themeColor = profile.themeColor;
  }

  Future<void> _handleImageChange() async {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (ctx) {
        return SafeArea(
          child: Wrap(
            children: [
              ListTile(
                leading: Icon(LucideIcons.camera, color: AppColors.pink500),
                title: const Text('카메라로 촬영하기'),
                onTap: () async {
                  Navigator.of(ctx).pop();
                  final XFile? image = await _picker.pickImage(source: ImageSource.camera);
                  if (image != null) {
                    setState(() {
                      _profileImage = image.path;
                    });
                  }
                },
              ),
              ListTile(
                leading: Icon(LucideIcons.image, color: AppColors.pink500),
                title: const Text('갤러리에서 선택하기'),
                onTap: () async {
                  Navigator.of(ctx).pop();
                  final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
                  if (image != null) {
                    setState(() {
                      _profileImage = image.path;
                    });
                  }
                },
              ),
            ],
          ),
        );
      },
    );
  }

  Future<void> _handleBackgroundImageChange() async {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (ctx) {
        return SafeArea(
          child: Wrap(
            children: [
              ListTile(
                leading: Icon(LucideIcons.camera, color: AppColors.pink500),
                title: const Text('카메라로 촬영하기'),
                onTap: () async {
                  Navigator.of(ctx).pop();
                  final XFile? image = await _picker.pickImage(source: ImageSource.camera);
                  if (image != null) {
                    setState(() {
                      _backgroundImage = image.path;
                    });
                  }
                },
              ),
              ListTile(
                leading: Icon(LucideIcons.image, color: AppColors.pink500),
                title: const Text('갤러리에서 선택하기'),
                onTap: () async {
                  Navigator.of(ctx).pop();
                  final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
                  if (image != null) {
                    setState(() {
                      _backgroundImage = image.path;
                    });
                  }
                },
              ),
            ],
          ),
        );
      },
    );
  }

  void _handleSave() async {
    final newProfile = CoupleProfile(
      nickname: "$_nickname1💕$_nickname2",
      startDate: "${_startDate}T00:00:00.000Z",
      profileImage: _profileImage,
      backgroundImage: _backgroundImage,
      themeColor: _themeColor,
    );
    await DataManager().saveProfile(newProfile);
    if (mounted) {
      Navigator.pushReplacement(
        context,
        PageRouteBuilder(
          pageBuilder: (_, __, ___) => const MainScreen(),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.pink50,
      body: SafeArea(
        child: Column(
          children: [
            // Header
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 24, 16, 16),
              child: Row(
                children: [
                  IconButton(
                    icon: const Icon(LucideIcons.arrowLeft, size: 24, color: AppColors.gray600),
                    onPressed: () {
                      Navigator.pushReplacement(
                        context,
                        PageRouteBuilder(pageBuilder: (_, __, ___) => const MainScreen()),
                      );
                    },
                  ),
                  const SizedBox(width: 8),
                  const Text("프로필 설정", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: AppColors.gray800)),
                ],
              ),
            ),
            
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(24),
                child: Column(
                  children: [
                    // Profile Image
                    Column(
                      children: [
                        GestureDetector(
                          onTap: _handleImageChange,
                          child: Stack(
                            clipBehavior: Clip.none,
                            children: [
                              Container(
                                width: 128,
                                height: 128,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  border: Border.all(color: AppColors.pink50, width: 4),
                                  image: DecorationImage(
                                    image: getImageProvider(_profileImage),
                                    fit: BoxFit.cover,
                                  )
                                ),
                              ),
                              Positioned(
                                bottom: 0,
                                right: 0,
                                child: Container(
                                  padding: const EdgeInsets.all(12),
                                  decoration: BoxDecoration(
                                    color: AppColors.pink500,
                                    shape: BoxShape.circle,
                                    border: Border.all(color: Colors.white, width: 4),
                                  ),
                                  child: const Icon(LucideIcons.camera, size: 20, color: Colors.white),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 16),
                        const Text("프로필 사진을 변경하려면 카메라 아이콘을 누르세요", style: TextStyle(color: AppColors.gray400, fontSize: 14)),
                      ],
                    ),
                    
                    const SizedBox(height: 32),
                    
                    // Forms
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Padding(
                          padding: EdgeInsets.only(left: 4, bottom: 8),
                          child: Text("애칭", style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: AppColors.gray500)),
                        ),
                        Row(
                          children: [
                            Expanded(
                              child: TextFormField(
                                initialValue: _nickname1,
                                onChanged: (v) => _nickname1 = v,
                                textAlign: TextAlign.center,
                                decoration: InputDecoration(
                                  hintText: "닉네임 1",
                                  filled: true,
                                  fillColor: AppColors.gray50,
                                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: const BorderSide(color: AppColors.gray100)),
                                  enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: const BorderSide(color: AppColors.gray100)),
                                  focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: BorderSide(color: AppColors.pink200, width: 2)),
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 8),
                              child: Text("💕", style: TextStyle(fontSize: 24, color: AppColors.pink500)),
                            ),
                            Expanded(
                              child: TextFormField(
                                initialValue: _nickname2,
                                onChanged: (v) => _nickname2 = v,
                                textAlign: TextAlign.center,
                                decoration: InputDecoration(
                                  hintText: "닉네임 2",
                                  filled: true,
                                  fillColor: AppColors.gray50,
                                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: const BorderSide(color: AppColors.gray100)),
                                  enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: const BorderSide(color: AppColors.gray100)),
                                  focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: BorderSide(color: AppColors.pink200, width: 2)),
                                ),
                              ),
                            ),
                          ],
                        ),
                        
                        const SizedBox(height: 24),
                        
                        const Padding(
                          padding: EdgeInsets.only(left: 4, bottom: 8),
                          child: Text("연애 시작일", style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: AppColors.gray500)),
                        ),
                        GestureDetector(
                          onTap: () async {
                            final date = await showDatePicker(
                              context: context,
                              initialDate: DateTime.parse(_startDate),
                              firstDate: DateTime(2000),
                              lastDate: DateTime.now(),
                            );
                            if (date != null) {
                              setState(() {
                                _startDate = date.toIso8601String().split('T')[0];
                              });
                            }
                          },
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                            decoration: BoxDecoration(
                              color: AppColors.gray50,
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(color: AppColors.gray100),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(_startDate, style: const TextStyle(fontSize: 16, color: AppColors.gray800)),
                                const Icon(LucideIcons.calendar, size: 20, color: AppColors.gray400),
                              ],
                            ),
                          ),
                        ),
                        
                        const SizedBox(height: 24),
                        
                        const Padding(
                          padding: EdgeInsets.only(left: 4, bottom: 8),
                          child: Text("앱 배경 사진", style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: AppColors.gray500)),
                        ),
                        Align(
                          alignment: Alignment.centerLeft,
                          child: GestureDetector(
                            onTap: _handleBackgroundImageChange,
                            child: Container(
                              height: 120,
                              width: 120,
                              decoration: BoxDecoration(
                                color: AppColors.gray50,
                                borderRadius: BorderRadius.circular(16),
                                border: Border.all(color: AppColors.gray100),
                                image: DecorationImage(
                                  image: getImageProvider(_backgroundImage),
                                  fit: BoxFit.cover,
                                  colorFilter: ColorFilter.mode(Colors.black.withOpacity(0.3), BlendMode.darken),
                                )
                              ),
                              child: const Center(
                                child: Icon(LucideIcons.camera, size: 32, color: Colors.white),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 24),
                        
                        const Padding(
                          padding: EdgeInsets.only(left: 4, bottom: 8),
                          child: Text("앱 테마 색상", style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: AppColors.gray500)),
                        ),
                        Wrap(
                          spacing: 16,
                          children: [
                            _buildThemeOption('pink', AppColors.themes['pink']!.c500),
                            _buildThemeOption('blue', AppColors.themes['blue']!.c500),
                            _buildThemeOption('purple', AppColors.themes['purple']!.c500),
                            _buildThemeOption('green', AppColors.themes['green']!.c500),
                          ],
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ),
            
            // Save Button
            Padding(
              padding: const EdgeInsets.all(24),
              child: ElevatedButton(
                onPressed: _handleSave,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.pink500,
                  foregroundColor: Colors.white,
                  minimumSize: const Size(double.infinity, 56),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  elevation: 5,
                  shadowColor: AppColors.pink100,
                  textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                child: const Text("저장하기"),
              ),
            )
          ],
        ),
      ),
    ).animate().slideX(begin: 1.0, end: 0, curve: Curves.easeOutQuad, duration: 300.ms);
  }

  Widget _buildThemeOption(String id, Color color) {
    return GestureDetector(
      onTap: () {
        setState(() {
          _themeColor = id;
          AppColors.currentThemeName = id;
          AppColors.themeNotifier.value = id;
        });
      },
      child: Container(
        width: 48,
        height: 48,
        decoration: BoxDecoration(
          color: color,
          shape: BoxShape.circle,
          border: Border.all(
            color: _themeColor == id ? AppColors.gray800 : Colors.transparent,
            width: 3,
          )
        ),
      ),
    );
  }
}
