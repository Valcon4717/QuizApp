import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../controller/theme_controller.dart';
import '../../controller/test_controller.dart';

/// This function clears the user session by removing all data from SharedPreferences
/// and navigating to the login screen.
/// It is called when the user logs out from the app.
/// [context] is the BuildContext of the current widget tree.
Future<void> clearUserSession(BuildContext context) async {
  final prefs = await SharedPreferences.getInstance();
  await prefs.clear();
  Navigator.pushReplacementNamed(context, '/login');
}

/// HomeSreen is a StatefulWidget that represents the main screen of the app.
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

/// _HomeScreenState is the state class for HomeScreen.
class _HomeScreenState extends State<HomeScreen> {
  String _username = '';
  int numQuestions = 10;
  late final TextEditingController _numQuestionsController;
  String? _numError;

  // For the checkboxes
  bool isMultipleChoice = true;
  bool isFillInBlank = false;
  bool inputError = false;
  int availableCount = 10;

  @override
  void initState() {
    super.initState();
    _loadUsername();
    _numQuestionsController =
        TextEditingController(text: numQuestions.toString());
    _updateAvailableQuestions();
  }

  // _loadUsername() loads the username from SharedPreferences
  Future<void> _loadUsername() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _username = prefs.getString('username') ?? 'No Name';
    });
  }

  // dispose() is called when the widget is removed from the widget tree
  @override
  void dispose() {
    _numQuestionsController.dispose();
    super.dispose();
  }

  // _updateAvailableQuestions() retrieves the available question count from the TestController
  Future<void> _updateAvailableQuestions() async {
    final prefs = await SharedPreferences.getInstance();
    final username = prefs.getString('username') ?? '';
    final pin = prefs.getString('pin') ?? '';

    if (username.isNotEmpty && pin.isNotEmpty) {
      availableCount = await Provider.of<TestController>(context, listen: false)
          .getAvailableQuestionCount(username: username, pin: pin);
      setState(() {});
    }
  }

  // _isPreferencesValid() checks if the quiz preferences are valid
  bool _isPreferencesValid() {
    return numQuestions > 0 &&
        numQuestions <= availableCount &&
        (isMultipleChoice || isFillInBlank) &&
        _numError == null;
  }

  // _preferencesErrorMessage() returns an error message if the quiz preferences are invalid
  String? _preferencesErrorMessage() {
    if (numQuestions <= 0) {
      return "Enter a number greater than 0.";
    } else if (numQuestions > availableCount) {
      return "Only $availableCount questions are available.";
    } else if (!isMultipleChoice && !isFillInBlank) {
      return "Select at least one question type.";
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    final themeController = Provider.of<ThemeController>(context);
    final bool isDarkMode = themeController.themeMode == ThemeMode.dark;

    bool isStartEnabled = _isPreferencesValid();

    return Scaffold(
      // AppBar
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.surface,
        scrolledUnderElevation: 0,
        title: Text(
          "codeHive",
          style: TextStyle(
            fontFamily: 'FiraCode',
            fontWeight: FontWeight.w800,
            color: Theme.of(context).colorScheme.primaryContainer,
          ),
        ),
      ),

      // Navigation Drawer
      drawer: NavigationDrawer(
        backgroundColor: Theme.of(context).colorScheme.secondary,
        selectedIndex: null,
        onDestinationSelected: (index) async {
          switch (index) {
            case 0:
              themeController.toggleTheme();
              break;
            case 1:
              await clearUserSession(context);
              break;
          }
        },
        children: [
          DrawerHeader(
            child: Stack(
              children: [
                Positioned(
                  top: 0,
                  left: 230,
                  child: IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                ),
                Positioned(
                  left: 0,
                  bottom: 0,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CircleAvatar(
                        radius: 28,
                        backgroundColor: Colors.transparent,
                        backgroundImage: AssetImage(
                          isDarkMode
                              ? 'assets/icons/HoneyDarkComplex.png'
                              : 'assets/icons/HoneyLightComplex.png',
                        ),
                        child: Container(
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: Theme.of(context)
                                  .colorScheme
                                  .secondaryContainer,
                              width: 1.5,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 12),
                      const Text(
                        "Hello,",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 24,
                        ),
                      ),
                      Text(
                        _username,
                        style: const TextStyle(
                          fontWeight: FontWeight.w400,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // Navigation Drawer items
          NavigationDrawerDestination(
            icon: Icon(isDarkMode ? Icons.light_mode : Icons.dark_mode),
            label: const Text("Toggle Theme"),
          ),
          NavigationDrawerDestination(
            icon: const Icon(Icons.logout),
            label: const Text("Logout"),
          ),
        ],
      ),

      // Main content
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 24.0),
              // Welcome text
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  children: [
                    const Text(
                      "Welcome, ",
                      style: TextStyle(fontSize: 24),
                    ),
                    Text(
                      _username,
                      style: const TextStyle(fontSize: 24),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20.0),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Card(
                  color: Theme.of(context).colorScheme.secondary,
                  elevation: 4,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16.0),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(24.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        SizedBox(height: 20.0),
                        Text(
                          "How many questions would you like to answer?",
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                        const SizedBox(height: 16.0),
                        // Number input for questions with plus and minus buttons.
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            IconButton(
                              icon: const Icon(Icons.remove),
                              onPressed: () {
                                setState(() {
                                  if (numQuestions > 1) {
                                    numQuestions--;
                                    _numQuestionsController.text =
                                        numQuestions.toString();
                                  }
                                });
                              },
                            ),
                            SizedBox(
                              width: 95,
                              child: TextField(
                                textAlign: TextAlign.center,
                                keyboardType: TextInputType.number,
                                controller: _numQuestionsController,
                                onChanged: (value) {
                                  setState(() {
                                    final enteredValue = int.tryParse(value);
                                    if (enteredValue == null ||
                                        enteredValue <= 0 ||
                                        enteredValue > availableCount) {
                                      _numError =
                                          "must be > 0 and <= $availableCount";
                                    } else {
                                      _numError = null;
                                      numQuestions = enteredValue;
                                      _updateAvailableQuestions();
                                    }
                                  });
                                },
                                style:
                                    Theme.of(context).textTheme.headlineMedium,
                                decoration: InputDecoration(
                                  border: const OutlineInputBorder(),
                                  isDense: true,
                                  errorMaxLines: 2,
                                  contentPadding: const EdgeInsets.symmetric(
                                      vertical: 8, horizontal: 8),
                                  errorText: _numError,
                                  errorStyle: const TextStyle(fontSize: 12),
                                ),
                              ),
                            ),
                            IconButton(
                              icon: const Icon(Icons.add),
                              onPressed: () {
                                setState(() {
                                  numQuestions++;
                                  _numQuestionsController.text =
                                      numQuestions.toString();
                                });
                              },
                            ),
                          ],
                        ),
                        const SizedBox(height: 20.0),
                        // Question type checkboxes
                        Text(
                          "What types of questions do you want to be asked?",
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                        const SizedBox(height: 32.0),
                        CheckboxListTile(
                          title: const Text("Multiple Choice"),
                          value: isMultipleChoice,
                          onChanged: (bool? value) {
                            setState(() {
                              isMultipleChoice = value ?? false;
                            });
                          },
                        ),
                        CheckboxListTile(
                          title: const Text("Fill in Blank"),
                          value: isFillInBlank,
                          onChanged: (bool? value) {
                            setState(() {
                              isFillInBlank = value ?? false;
                            });
                          },
                        ),
                        const SizedBox(height: 10),

                        // Error message if preferences are invalid
                        if (!_isPreferencesValid())
                          Padding(
                            padding: const EdgeInsets.only(bottom: 16.0),
                            child: Text(
                              _preferencesErrorMessage() ??
                                  "Enter a valid option",
                              style: const TextStyle(
                                color: Colors.red,
                                fontWeight: FontWeight.bold,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),

                        // "Start Quiz" button
                        ElevatedButton(
                          onPressed: isStartEnabled
                              ? () async {
                                  final parsedNum = int.tryParse(
                                      _numQuestionsController.text);
                                  if (parsedNum != null && parsedNum > 0) {
                                    numQuestions = parsedNum;
                                  }

                                  // Retrieve SharedPreferences instance
                                  final prefs =
                                      await SharedPreferences.getInstance();

                                  // Save the quiz preferences
                                  await prefs.setInt(
                                      'numQuestions', numQuestions);
                                  await prefs.setBool(
                                      'isMultipleChoice', isMultipleChoice);
                                  await prefs.setBool(
                                      'isFillInBlank', isFillInBlank);

                                  // Retrieve username and pin
                                  final username =
                                      prefs.getString('username') ?? '';
                                  final pin = prefs.getString('pin') ?? '';

                                  // Ensure username and pin are valid
                                  if (username.isEmpty || pin.isEmpty) {
                                    Navigator.pushReplacementNamed(
                                        context, '/login');
                                    return;
                                  }

                                  // Call the controller’s loadQuiz
                                  await Provider.of<TestController>(context,
                                          listen: false)
                                      .loadQuiz(
                                    numQuestions: numQuestions,
                                    username: username,
                                    pin: pin,
                                    isMultipleChoice: isMultipleChoice,
                                    isFillInBlank: isFillInBlank,
                                  );

                                  // Navigate to the QuizScreen
                                  Navigator.pushNamed(context, '/quiz');
                                }
                              : null,
                          style: ElevatedButton.styleFrom(
                            backgroundColor:
                                Theme.of(context).colorScheme.primaryContainer,
                            foregroundColor:
                                Theme.of(context).colorScheme.onPrimary,
                            minimumSize: const Size(double.infinity, 50),
                          ),
                          child: const Text("Start Quiz"),
                        ),
                        const SizedBox(height: 20),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
