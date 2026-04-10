import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../data_manager.dart';
import '../image_utils.dart';
import 'main_screen.dart';

class StartScreen extends StatefulWidget {
  const StartScreen({super.key});

  @override
  State<StartScreen> createState() => _StartScreenState();
}

class _StartScreenState extends State<StartScreen> {
  late Timer _timer;
  Duration _diff = Duration.zero;

  @override
  void initState() {
    super.initState();
    _calculateTime();
    _timer = Timer.periodic(const Duration(seconds: 1), (_) => _calculateTime());
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  void _calculateTime() {
    final start = DateTime.parse(DataManager().profile.startDate);
    final now = DateTime.now();
    setState(() {
      _diff = now.difference(start);
      if (_diff.isNegative) _diff = Duration.zero;
    });
  }

  @override
  Widget build(BuildContext context) {
    final totalDays = _diff.inDays;
    final years = totalDays ~/ 365;
    final days = totalDays % 365;
    final hours = _diff.inHours % 24;
    final minutes = _diff.inMinutes % 60;
    final seconds = _diff.inSeconds % 60;
    
    final profile = DataManager().profile;
    final startDate = DateTime.parse(profile.startDate);

    return Scaffold(
      backgroundColor: Colors.black,
      body: GestureDetector(
        onTap: () {
          Navigator.pushReplacement(
            context,
            PageRouteBuilder(
              pageBuilder: (_, __, ___) => const MainScreen(),
              transitionsBuilder: (_, anim, __, child) => FadeTransition(opacity: anim, child: child),
            ),
          );
        },
        child: Stack(
          fit: StackFit.expand,
          children: [
            ColorFiltered(
              colorFilter: ColorFilter.mode(Colors.black.withOpacity(0.3), BlendMode.darken),
              child: buildImageWidget(
                profile.backgroundImage,
                fit: BoxFit.cover,
              ),
            ),
            Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Color(0x4D000000), // black/30
                    Colors.transparent,
                    Color(0x99000000), // black/60
                  ],
                ),
              ),
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildTimeBlock(years.toString(), '년'),
                const SizedBox(height: 16),
                _buildTimeBlock(days.toString(), '일'),
                const SizedBox(height: 16),
                _buildTimeBlock(hours.toString(), '시간'),
                const SizedBox(height: 16),
                _buildTimeBlock(minutes.toString(), '분'),
                const SizedBox(height: 16),
                _buildTimeBlock(seconds.toString(), '초'),
                const SizedBox(height: 80), // offset for bottom
              ],
            ),
            Positioned(
              bottom: 64,
              left: 0,
              right: 0,
              child: Column(
                children: [
                   const Text(
                     "우리의 날 💕",
                     style: TextStyle(
                       color: Colors.white,
                       fontSize: 36,
                       fontWeight: FontWeight.bold,
                       letterSpacing: 1.5,
                     ),
                   ),
                   const SizedBox(height: 8),
                   Text(
                     "${startDate.year}년 ${startDate.month.toString().padLeft(2, '0')}월 ${startDate.day.toString().padLeft(2, '0')}일",
                     style: TextStyle(
                       color: Colors.white.withOpacity(0.8),
                       fontSize: 20,
                     ),
                   ),
                ],
              ),
            ),
          ],
        ),
      ).animate().fadeIn(duration: 500.ms),
    );
  }

  Widget _buildTimeBlock(String value, String label) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          value,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 60,
            fontWeight: FontWeight.bold,
            height: 1,
          ),
        ),
        Text(
          label,
          style: TextStyle(
            color: Colors.white.withOpacity(0.9),
            fontSize: 24,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}
