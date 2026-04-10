import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'data_manager.dart';
import 'models.dart';
import 'screens/start_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await DataManager().init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<String>(
      valueListenable: AppColors.themeNotifier,
      builder: (context, themeName, child) {
        return MaterialApp(
          title: 'Couple D-Day',
          debugShowCheckedModeBanner: false,
          localizationsDelegates: const [
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          supportedLocales: const [
            Locale('ko', 'KR'),
          ],
          locale: const Locale('ko', 'KR'),
          theme: ThemeData(
            fontFamily: 'Pretendard',
            colorSchemeSeed: AppColors.pink500, // Reads from the dynamic theme
            scaffoldBackgroundColor: Colors.white,
          ),
          home: const StartScreen(),
        );
      },
    );
  }
}
