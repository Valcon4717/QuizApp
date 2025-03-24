import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../model/multiple_choice_question.dart';
import '../../controller/test_controller.dart';
import '../../model/question.dart';

class ResultsScreen extends StatelessWidget {
  const ResultsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final testController = Provider.of<TestController>(context);
    final int score = testController.score;
    final int total = testController.questions.length;
    final Map<int, Question> incorrect = testController.incorrectAnswers;
    final Map<Question, String> userAnswers = testController.userAnswers;

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          // Fixed header area
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Center(
                child: Column(
                  children: [
                    const SizedBox(height: 70),
                    Text(
                      "Quiz Results",
                      style: Theme.of(context).textTheme.headlineSmall,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      "$score / $total",
                      style: Theme.of(context)
                          .textTheme
                          .headlineSmall!
                          .copyWith(
                            color:
                                Theme.of(context).colorScheme.primaryContainer,
                          ),
                    ),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ),
          ),
          incorrect.isNotEmpty
              ? SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (context, index) {
                      final questionIndex = incorrect.keys.elementAt(index);
                      final Question question = incorrect[questionIndex]!;
                      final String userAnswerRaw =
                          userAnswers[question] ?? "No answer";
                      // Convert numeric answer to option text if multiple choice
                      String userAnswerDisplay = userAnswerRaw;

                      if (question is MultipleChoiceQuestion) {
                        final choiceIndex = int.tryParse(userAnswerRaw);
                        if (choiceIndex != null &&
                            choiceIndex > 0 &&
                            choiceIndex <= question.options.length) {
                          userAnswerDisplay = question.options[choiceIndex - 1];
                        }
                      }
                      final String correctAnswer = question.getCorrectAnswer();
                      return Card(
                        color: Theme.of(context).colorScheme.secondary,
                        margin: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 8),
                        elevation: 2,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(12),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Question ${questionIndex + 1}:",
                                style: Theme.of(context).textTheme.titleMedium,
                              ),
                              const SizedBox(height: 8),
                              Text(
                                question.stem,
                                style: Theme.of(context).textTheme.bodyLarge,
                              ),
                              const SizedBox(height: 8),
                              Text(
                                "Your answer: $userAnswerDisplay",
                                style: const TextStyle(color: Colors.red),
                              ),
                              Text(
                                "Correct answer: $correctAnswer",
                                style: const TextStyle(color: Colors.green),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                    childCount: incorrect.length,
                  ),
                )
              : SliverToBoxAdapter(
                  child: Center(
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Text(
                        "Great job! All answers are correct!",
                        style: Theme.of(context).textTheme.headlineMedium,
                      ),
                    ),
                  ),
                ),
          // "Return Home" button at the bottom
          SliverToBoxAdapter(
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 16.0, vertical: 24.0),
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pushReplacementNamed(context, '/home');
                },
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size(double.infinity, 50),
                  backgroundColor:
                      Theme.of(context).colorScheme.tertiaryContainer,
                ),
                child: const Text("Return Home"),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
