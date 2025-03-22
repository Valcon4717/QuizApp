import 'dart:io';
import '../model/question.dart';

/// TestView handles all user interactions and displays messages to the user.
class TestView {
  /// Displays a welcome message to the user.
  void welcomeMessage() {
    print("\x1B[1;32m┌──────────────────────────────────────────┐\x1B[0m");
    print("\x1B[1;32m│      ✨ Welcome to the Quiz App! ✨      │\x1B[0m");
    print("\x1B[1;32m└──────────────────────────────────────────┘\x1B[0m");
  }

  /// Displays a goodbye message to the user.
  void goodbyeMessage() {
    print("\n\x1B[1;36m┌──────────────────────────────────────────┐\x1B[0m");
    print("\x1B[1;36m│    Thank you for taking the quiz! 👋     │\x1B[0m");
    print("\x1B[1;36m└──────────────────────────────────────────┘\x1B[0m");
  }

  /// Displays a message indicating that the quiz is loading.
  void loadingMessage() {
    print("\x1B[30mLoading questions...\x1B[0m\n");
  }

  /// Displays the final score using [score] and [total] questions.
  void displayScore(int score, int total) {
    print("\n🎉\x1B[1;32m Quiz Complete! Your score: \x1B[0m$score / $total");
  }

  /// Displays the [question] in the quiz with its [index].
  void displayQuestion(Question question, int index) {
    print('\n──────────────────────────────────────────────\n');
    print('Question ${index + 1}: ${question.display()}');
  }

  /// Ask the user if they want to review incorrect answers.
  ///
  /// Returns `true` if the user wants to review, `false` otherwise.
  bool askUserToReviewIncorrect() {
    return getYesOrNo("Would you like to review incorrect answers?");
  }

  /// Retrieves the user's input
  String getUserAnswer() {
    return stdin.readLineSync()?.trim() ?? "";
  }

  /// Displays the current [answer] for the question at [index].
  String displayCurrentAnswer(dynamic answer, int index) {
    print('\n──────────────────────────────────────────────');
    print(
        "\nYour \x1B[1;34mprevious answer\x1B[0m for Question $index: \x1B[1;34m$answer\x1B[0m");
    return answer.toString();
  }

  /// Displays the user's navigation options.
  String getUserNavigation() {
    stdout.write(
        "Type your answer, '[n]ext' to move forward, or '[p]revious' to go back: ");
    return stdin.readLineSync()?.trim().toLowerCase() ?? "";
  }

  /// Displays the incorrect answers along with the correct answers.
  ///
  /// This method takes a map of [incorrectQuestions] and the [userAnswers].
  void reviewIncorrectAnswers(Map<int, Question> incorrectQuestions,
      Map<Question, String> userAnswers) {
    if (incorrectQuestions.isEmpty) return;

    print("\n📋 Review Incorrect Answers:");

    incorrectQuestions.forEach((questionNumber, question) {
      print('\n──────────────────────────────────────────────');
      print('Question ${questionNumber + 1}:');
      print(question.display());
      print('❌ Your Answer: ${userAnswers[question]}');
      print('✅ Correct Answer: ${question.getCorrectAnswer()}');
    });
  }

  /// Displays a message when an invlaid [answer] is entered
  void invalidAnswer(String? answer, int index) {
    print('\n──────────────────────────────────────────────');
    print("\n\x1B[1;31m❌ Invalid answer\x1B[0m, please try again.");
  }

  /// Prompts the user with a yes/no question.
  ///
  /// Returns `true` for yes and `false` for no.
  bool getYesOrNo(String message) {
    while (true) {
      stdout.write("\n$message (y/n): ");
      String response = stdin.readLineSync()?.trim().toLowerCase() ?? "";

      if (response == "y" || response == "yes") return true;
      if (response == "n" || response == "no") return false;

      print(
          "\x1B[1;31mInvalid input\x1B[0m. Please enter 'y' for yes or 'n' for no.");
    }
  }
}
