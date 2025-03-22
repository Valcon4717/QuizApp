import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
// import 'view/screens/home_screen.dart';
import 'view/screens/login_screen.dart';
import 'controller/theme_controller.dart';

void main() {
  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider(create: (context) => ThemeController()),
    ],
    child: QuizApp(),
  ));
}

class QuizApp extends StatelessWidget {
  const QuizApp({super.key});

  @override
  Widget build(BuildContext context) {
    final themeController = Provider.of<ThemeController>(context);

    return MaterialApp(
      title: 'Quiz App',
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xfffb9f28),
        ).copyWith(
          primaryContainer: const Color(0xffd77c04),
          onPrimaryContainer: const Color(0xfff4eee6),
          secondaryContainer: const Color(0xff75501f),
          onSecondaryContainer: const Color(0xfff4eee6),
          tertiaryContainer: const Color(0xffebb166),
          onTertiaryContainer: const Color(0xff1b1713),
          error: const Color(0xffb00020),
          onError: const Color(0xfff4eee6),
          surface: const Color(0xfff4eee6),
          onSurface: const Color(0xff1b1713),
        ),
      ),
      darkTheme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xfffb9f28),
          brightness: Brightness.dark,
        ).copyWith(
          primaryContainer: const Color(0xfffb9f28),
          onPrimaryContainer: const Color(0xff19130b),
          secondaryContainer: const Color(0xffe0bb8a),
          onSecondaryContainer: const Color(0xffece8e4),
          tertiaryContainer: const Color(0xff996014),
          onTertiaryContainer: const Color(0xff19130b),
          error: const Color(0xffcf6679),
          onError: const Color(0xff19130b),
          surface: const Color(0xff19130b),
          onSurface: const Color(0xffece8e4),
        ),
      ),
      themeMode: themeController.themeMode,
      home: const LoginScreen(),
    );
  }
}
