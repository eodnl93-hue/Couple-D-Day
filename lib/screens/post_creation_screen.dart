import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:uuid/uuid.dart';
import '../models.dart';
import '../data_manager.dart';
import '../image_utils.dart';
import 'package:image_picker/image_picker.dart';
import 'main_screen.dart';

class PostCreationScreen extends StatefulWidget {
  final Post? initialPost;
  const PostCreationScreen({super.key, this.initialPost});

  @override
  State<PostCreationScreen> createState() => _PostCreationScreenState();
}

class _PostCreationScreenState extends State<PostCreationScreen> {
  late String _date;
  late String _memo;
  late String _imageUrl;
  final ImagePicker _picker = ImagePicker();
  
  @override
  void initState() {
    super.initState();
    _date = widget.initialPost?.date.split('T')[0] ?? DateTime.now().toIso8601String().split('T')[0];
    _memo = widget.initialPost?.memo ?? '';
    _imageUrl = widget.initialPost?.imageUrl ?? '';
  }

  Future<void> _handleImagePick() async {
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
                      _imageUrl = image.path;
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
                      _imageUrl = image.path;
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

  void _handleRegister() {
    if (_imageUrl.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('사진을 선택해주세요!')),
      );
      return;
    }
    
    final newPost = Post(
      id: widget.initialPost?.id ?? const Uuid().v4(),
      date: "${_date}T00:00:00.000Z",
      imageUrl: _imageUrl,
      memo: _memo,
      isLiked: widget.initialPost?.isLiked ?? false,
    );
    
    final posts = DataManager().posts;
    if (widget.initialPost != null) {
      final index = posts.indexWhere((p) => p.id == widget.initialPost!.id);
      if (index != -1) posts[index] = newPost;
    } else {
      posts.insert(0, newPost);
    }
    DataManager().savePosts(posts);
    
    Navigator.pushReplacement(
      context,
      PageRouteBuilder(pageBuilder: (_, __, ___) => const MainScreen()),
    );
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
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
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
                      Text(
                        widget.initialPost != null ? '추억 수정하기' : '추억 기록하기',
                        style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: AppColors.gray800),
                      ),
                    ],
                  ),
                  TextButton(
                    onPressed: _handleRegister,
                    style: TextButton.styleFrom(
                      foregroundColor: AppColors.pink500,
                      textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                    ),
                    child: Text(widget.initialPost != null ? '수정' : '등록'),
                  )
                ],
              ),
            ),
            
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(24),
                child: Column(
                  children: [
                    // Image Selection
                    GestureDetector(
                      onTap: _handleImagePick,
                      child: Container(
                        width: double.infinity,
                        height: MediaQuery.of(context).size.width - 48,
                        decoration: BoxDecoration(
                          color: _imageUrl.isEmpty ? Colors.white : AppColors.gray100,
                          borderRadius: BorderRadius.circular(24),
                          border: _imageUrl.isEmpty ? Border.all(color: AppColors.gray200, width: 2, style: BorderStyle.none) : null,
                        ),
                        clipBehavior: Clip.antiAlias,
                        child: _imageUrl.isEmpty 
                            ? CustomPaint(
                                painter: DashedBorderPainter(),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Container(
                                      padding: const EdgeInsets.all(24),
                                      decoration: BoxDecoration(color: AppColors.pink50, shape: BoxShape.circle),
                                      child: Icon(LucideIcons.camera, size: 48, color: AppColors.pink300),
                                    ),
                                    const SizedBox(height: 16),
                                    const Text("사진을 선택하세요", style: TextStyle(color: AppColors.gray400, fontWeight: FontWeight.w500, fontSize: 16)),
                                  ],
                                ),
                              )
                            : Stack(
                                fit: StackFit.expand,
                                children: [
                                  buildImageWidget(_imageUrl, fit: BoxFit.cover),
                                ],
                              ),
                      ),
                    ),
                    
                    const SizedBox(height: 24),
                    
                    // Inputs
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Padding(
                          padding: EdgeInsets.only(left: 4, bottom: 8),
                          child: Text("날짜", style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: AppColors.gray500)),
                        ),
                        GestureDetector(
                          onTap: () async {
                            final date = await showDatePicker(
                              context: context,
                              initialDate: DateTime.parse(_date),
                              firstDate: DateTime(2000),
                              lastDate: DateTime.now(),
                            );
                            if (date != null) {
                              setState(() {
                                _date = date.toIso8601String().split('T')[0];
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
                                Text(_date, style: const TextStyle(fontSize: 16, color: AppColors.gray800)),
                                const Icon(LucideIcons.calendar, size: 20, color: AppColors.gray400),
                              ],
                            ),
                          ),
                        ),
                        
                        const SizedBox(height: 24),
                        
                        const Padding(
                          padding: EdgeInsets.only(left: 4, bottom: 8),
                          child: Text("메모", style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: AppColors.gray500)),
                        ),
                        TextFormField(
                          initialValue: _memo,
                          onChanged: (v) => _memo = v,
                          maxLines: 4,
                          decoration: InputDecoration(
                            hintText: "이날의 소중한 기억을 남겨보세요...",
                            filled: true,
                            fillColor: AppColors.gray50,
                            border: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: const BorderSide(color: AppColors.gray100)),
                            enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: const BorderSide(color: AppColors.gray100)),
                            focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: BorderSide(color: AppColors.pink200, width: 2)),
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ),
            
            // Register Button Alternative
            Padding(
              padding: const EdgeInsets.all(24),
              child: ElevatedButton.icon(
                onPressed: _handleRegister,
                icon: const Icon(LucideIcons.check, size: 20),
                label: const Text("기록 저장하기"),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.pink500,
                  foregroundColor: Colors.white,
                  minimumSize: const Size(double.infinity, 56),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  elevation: 5,
                  shadowColor: AppColors.pink100,
                  textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
            )
          ],
        ),
      ),
    ).animate().slideY(begin: 1.0, end: 0, curve: Curves.easeOutQuad, duration: 300.ms);
  }
}

// Simple dash border painter for image picker box
class DashedBorderPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    var paint = Paint()
      ..color = AppColors.gray200
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke;
      
    var path = Path();
    var rrect = RRect.fromRectAndRadius(Rect.fromLTRB(0, 0, size.width, size.height), const Radius.circular(24));
    path.addRRect(rrect);

    // Dashing
    const double dashWidth = 8;
    const double dashSpace = 8;
    var metrics = path.computeMetrics();
    for (var metric in metrics) {
      double distance = 0.0;
      while (distance < metric.length) {
        canvas.drawPath(metric.extractPath(distance, distance + dashWidth), paint);
        distance += dashWidth + dashSpace;
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
