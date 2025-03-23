import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({super.key});

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  final PageController _pageController = PageController();
  int _currentIndex = 0;
  late final List<Map<String, String>> pagesData;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Initialize pagesData here so we can use Theme.of(context)
    pagesData = [
      {
        "image": Theme.of(context).brightness == Brightness.dark
            ? "assets/images/QuizDark.png"
            : "assets/images/QuizLight.png",
        "title": "Master Dart & Flutter",
        "caption": "Build your foundation with targeted quiz questions."
      },
      {
        "image": Theme.of(context).brightness == Brightness.dark
            ? "assets/images/GrowDark.png"
            : "assets/images/GrowLight.png",
        "title": "Practice Consistently",
        "caption": "Develop a daily habit of tackling new challenges."
      },
      {
        "image": Theme.of(context).brightness == Brightness.dark
            ? "assets/images/DevDark.png"
            : "assets/images/DevLight.png",
        "title": "Level Up & Get Hired",
        "caption": "Polish your skills, ace interviews, and stand out."
      },
    ];
  }

  Future<void> _completeSetup(BuildContext context) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isSetupComplete', true);
    Navigator.pushReplacementNamed(context, '/home');
  }

  void _onNextPressed() {
    if (_currentIndex < pagesData.length - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } else {
      _completeSetup(context);
    }
  }

  void _onPageChanged(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            // Expanded PageView
            Expanded(
              child: PageView.builder(
                controller: _pageController,
                onPageChanged: _onPageChanged,
                itemCount: pagesData.length,
                itemBuilder: (context, index) {
                  final data = pagesData[index];
                  return Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24.0,
                      vertical: 32.0,
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // Display the image; replace with your own assets
                        Image.asset(
                          data["image"]!,
                          height: 200,
                        ),
                        const SizedBox(height: 32),
                        Text(
                          data["title"]!,
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 16),
                        Text(
                          data["caption"]!,
                          textAlign: TextAlign.center,
                          style: const TextStyle(fontSize: 16),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
            // Dot indicators
            SmoothPageIndicator(
              controller: _pageController,
              count: pagesData.length,
              effect: WormEffect(
                activeDotColor: Theme.of(context).colorScheme.primary,
                dotHeight: 8,
                dotWidth: 8,
              ),
            ),
            const SizedBox(height: 24),
            // Bottom button
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 24.0,
                vertical: 24.0,
              ),
              child: ElevatedButton(
                onPressed: _onNextPressed,
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size(double.infinity, 50),
                ),
                child: Text(
                  _currentIndex == pagesData.length - 1 ? "Start" : "Next",
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}