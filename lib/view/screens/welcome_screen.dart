import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

/// WelcomeScreen is a StatefulWidget that provides a welcome interface
/// for the app. It guides users through the app's features and
/// encourages them to start using it.
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

  // _completeSetup is called when the user completes the setup process
  // It saves the setup completion status in shared preferences.
  Future<void> _completeSetup(BuildContext context) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isSetupComplete', true);
    Navigator.pushReplacementNamed(context, '/home');
  }

  // _onNextPressed is called when the user presses the "Next" button
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

  // _onPageChanged is called when the page changes in the PageView
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

            // Dot indicator
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

            // Next button
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
