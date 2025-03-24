import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'view/screens/login_screen.dart';
import 'view/screens/home_screen.dart';
import 'view/screens/welcome_screen.dart';
import 'view/screens/quiz_screen.dart';
import 'controller/theme_controller.dart';
import 'controller/login_controller.dart';
import 'controller/test_controller.dart';
import 'view/screens/result_screen.dart';
import 'model/authentication_service.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final prefs = await SharedPreferences.getInstance();
  final username = prefs.getString('username');
  final pin = prefs.getString('pin');
  final isSetupComplete = prefs.getBool('isSetupComplete') ?? false;

  Widget firstScreen;
  if (username != null && pin != null && pin.isNotEmpty) {
    firstScreen = isSetupComplete ? const HomeScreen() : const WelcomeScreen();
  } else {
    firstScreen = const LoginScreen();
  }

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => ThemeController()),
        ChangeNotifierProvider(create:(context) => TestController()),
        ChangeNotifierProvider(
          create: (_) =>
              LoginController(authService: AuthenticationService()),
        ),
      ],
      child: QuizApp(firstScreen: firstScreen),
    ),
  );
}

class QuizApp extends StatelessWidget {
  final Widget firstScreen;
  const QuizApp({super.key, required this.firstScreen});

  @override
  Widget build(BuildContext context) {
    final themeController = Provider.of<ThemeController>(context);

    return MaterialApp(
      title: 'CodeHive',
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xffd77c04),
        ).copyWith(
          primaryContainer: const Color(0xffd77c04),
          onPrimaryContainer: const Color(0xfff4eee6),
          secondaryContainer: const Color(0xff75501f),
          onSecondaryContainer: const Color(0xfff4eee6),
          tertiaryContainer: const Color(0xffebb166),
          onTertiaryContainer: const Color(0xff1b1713),
          secondary: const Color(0xffece7de),
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
          secondary: const Color(0xff201a13),
          error: const Color(0xffcf6679),
          onError: const Color(0xff19130b),
          surface: const Color(0xff19130b),
          onSurface: const Color(0xffece8e4),
        ),
      ),
      themeMode: themeController.themeMode,
      home: firstScreen,
      routes: {
        '/welcome': (context) => const WelcomeScreen(),
        '/login': (context) => const LoginScreen(),
        '/home': (context) => const HomeScreen(),
        '/quiz': (context) => const QuizScreen(),
        '/results': (context) => const ResultsScreen(),
      },
    );
  }
}