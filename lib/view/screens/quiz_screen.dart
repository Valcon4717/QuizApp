import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:developer';
import '../../controller/test_controller.dart';
import '../../model/multiple_choice_question.dart';
import '../../model/fill_in_blank_question.dart';
import '../../model/question.dart';

/// QuizScreen is a StatefulWidget that provides a quiz interface
class QuizScreen extends StatefulWidget {
  const QuizScreen({super.key});

  @override
  State<QuizScreen> createState() => _QuizScreenState();
}

/// _QuizScreenState is the state class for QuizScreen
class _QuizScreenState extends State<QuizScreen> {
  late TestController testController;
  final PageController _pageController = PageController();
  int _currentPage = 0;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    // Get the TestController from Provider.
    testController = Provider.of<TestController>(context, listen: false);
    _startQuiz();
  }

  // _startQuiz initializes the quiz by loading questions and user data.
  Future<void> _startQuiz() async {
    final prefs = await SharedPreferences.getInstance();
    final username = prefs.getString('username') ?? '';
    final pin = prefs.getString('pin') ?? '';

    // Retrieve quiz preferences, providing defaults if they aren't set.
    final numQuestions = prefs.getInt('numQuestions') ?? 10;
    log("QuizScreen: Number of questions: $numQuestions", name: "QuizScreen");
    final isMultipleChoice = prefs.getBool('isMultipleChoice') ?? true;
    final isFillInBlank = prefs.getBool('isFillInBlank') ?? false;
    debugPrint(
        "QuizScreen: Starting quiz with username: $username and pin: $pin");

    // If username or pin is empty, navigate to login screen.
    if (username.isEmpty || pin.isEmpty) {
      Navigator.pushReplacementNamed(context, '/login');
      return;
    }

    // Load quiz questions based on user preferences
    await testController.loadQuiz(
      numQuestions: numQuestions,
      username: username,
      pin: pin,
      isMultipleChoice: isMultipleChoice,
      isFillInBlank: isFillInBlank,
    );
    setState(() {
      isLoading = false;
    });
  }

  // Handles the submission of answers for fill-in-the-blank questions
  void _onAnswerSubmitted(String answer) {
    final currentQuestion = testController.questions[_currentPage];
    testController.recordAnswer(currentQuestion, answer);
  }

  // Navigates to previous or next question
  void _onNextOrPrev(bool isNext) {
    if (isNext) {
      if (_currentPage < testController.questions.length - 1) {
        _pageController.nextPage(
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeInOut);
      }
    } else {
      if (_currentPage > 0) {
        _pageController.previousPage(
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeInOut);
      }
    }
  }

  // Handles the submission of the quiz
  void _onSubmitQuiz() {
    bool hasUnanswered = testController.questions
        .any((q) => testController.userAnswers[q] == null);

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Confirm Submission"),
          content: Text(hasUnanswered
              ? "There are unanswered questions. Are you sure you want to submit the quiz, or would you like to continue answering?"
              : "Are you sure you want to submit the quiz?"),
          actions: [
            // Continue Quiz button
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text("Continue Quiz"),
            ),

            // Submit button
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                testController.gradeQuiz();
                final int score = testController.score;
                final int total = testController.questions.length;
                final Map<int, Question> incorrectAnswers =
                    testController.incorrectAnswers;
                Navigator.pushNamed(
                  context,
                  '/results',
                  arguments: {
                    'score': score,
                    'total': total,
                    'incorrectAnswers': incorrectAnswers,
                  },
                );
              },
              child: const Text("Submit"),
            ),
          ],
        );
      },
    );
  }

  // Builds the multiple choice options for a question
  /// [question] is the MultipleChoiceQuestion object
  Widget _buildMultipleChoiceOptions(MultipleChoiceQuestion question) {
    return StatefulBuilder(
      builder: (context, setState) {
        String? currentAnswer = testController.userAnswers[question];
        int? selectedValue =
            currentAnswer != null ? int.tryParse(currentAnswer) : null;
        return Column(
          children: List.generate(question.options.length, (optionIndex) {
            return RadioListTile<int>(
              title: Text(question.options[optionIndex]),
              value: optionIndex + 1,
              groupValue: selectedValue,
              onChanged: (value) {
                setState(() {
                  selectedValue = value;
                  testController.recordAnswer(question, value.toString());
                });
              },
            );
          }),
        );
      },
    );
  }

  // Handles the back button press to confirm exit
  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      // ignore: deprecated_member_use
      onPopInvoked: (didPop) async {
        final shouldQuit = await showDialog<bool>(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: const Text("Confirm Exit"),
              content: const Text(
                "You have not completed your quiz. Are you sure you want to quit or continue?",
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop(false);
                  },
                  child: const Text("Continue Quiz"),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop(true);
                  },
                  child: const Text("Quit"),
                ),
              ],
            );
          },
        );
        if (shouldQuit == true) {
          Navigator.pushReplacementNamed(context, '/home');
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Spacer(),
              Text(
                "Quiz",
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              const Spacer(),
              Text(
                "Q ${_currentPage + 1} / ${testController.questions.length}",
              ),
            ],
          ),
          bottom: PreferredSize(
            preferredSize: const Size.fromHeight(4.0),
            child: TweenAnimationBuilder<double>(
              tween: Tween<double>(
                begin: 0.0,
                end: testController.questions.isNotEmpty
                    ? (_currentPage + 1) / testController.questions.length
                    : 0.0,
              ),
              duration: const Duration(milliseconds: 500),
              builder: (context, value, child) {
                return LinearProgressIndicator(
                  value: value,
                  backgroundColor: Theme.of(context).colorScheme.surface,
                  valueColor: AlwaysStoppedAnimation<Color>(
                    Theme.of(context).colorScheme.primary,
                  ),
                );
              },
            ),
          ),
        ),
        body: isLoading
            ? const Center(child: CircularProgressIndicator())
            : Column(
                children: [
                  Expanded(
                    child: PageView.builder(
                      controller: _pageController,
                      itemCount: testController.questions.length,
                      onPageChanged: (index) {
                        setState(() {
                          _currentPage = index;
                        });
                      },
                      itemBuilder: (context, index) {
                        final question = testController.questions[index];
                        return Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: SingleChildScrollView(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Question ${index + 1}",
                                  style:
                                      Theme.of(context).textTheme.headlineSmall,
                                ),
                                const SizedBox(height: 16),
                                Text(
                                  question.stem,
                                  style: Theme.of(context).textTheme.bodyLarge,
                                ),
                                const SizedBox(height: 16),
                                if (question.figure != null &&
                                    question.figure!.isNotEmpty)
                                  Center(
                                    child: Image.network(
                                      'https://www.cs.utep.edu/cheon/cs4381/homework/quiz/figure.php?name=${question.figure}',
                                      height: 200,
                                    ),
                                  ),
                                const SizedBox(height: 24),
                                if (question is MultipleChoiceQuestion)
                                  _buildMultipleChoiceOptions(question)
                                else if (question is FillInBlankQuestion)
                                  TextField(
                                    onSubmitted: _onAnswerSubmitted,
                                    decoration: const InputDecoration(
                                      labelText: "Your answer",
                                      border: OutlineInputBorder(),
                                    ),
                                  ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  // Navigation controls.
                  Padding(
                    padding: const EdgeInsets.all(35.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        ElevatedButton(
                          onPressed: () => _onNextOrPrev(false),
                          child: const Text("prev"),
                        ),
                        ElevatedButton(
                          onPressed: () {
                            if (_currentPage ==
                                testController.questions.length - 1) {
                              _onSubmitQuiz();
                            } else {
                              _onNextOrPrev(true);
                            }
                          },
                          child: Text(_currentPage ==
                                  testController.questions.length - 1
                              ? "Submit"
                              : "Next"),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}
