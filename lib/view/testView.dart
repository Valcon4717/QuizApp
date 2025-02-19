import 'dart:io';
import '../model/question.dart';

class TestView {
  void welcomeMessage() {
    print('\n──────────────────────────────────────────────');
    print("        \x1B[1;32m✨Welcome to the Quiz App!✨\x1B[0m");
    print('──────────────────────────────────────────────');
  }

  void goodbyeMessage() {
    print('\n──────────────────────────────────────────────\n');
    print("Thank you for taking the quiz!");
    print('\n──────────────────────────────────────────────\n');
  }

  void loadingMessage() {
    print("\n\x1B[30mLoading questions...\x1B[0m\n");
  }

  void displayScore(int score, int total) {
    print("\nQuiz Complete! Your score: $score / $total");
  }

  void displayQuestion(Question question, int index) {
    print('\n──────────────────────────────────────────────\n');
    print('Question ${index + 1}: ${question.display()}');
  }

  void reviewIncorrectAnswers(Map<int, Question> incorrectQuestions, Map<Question, String> userAnswers) {
    if (incorrectQuestions.isEmpty) return;

    print("\n📋 Review Incorrect Answers:");

    for (var entry in incorrectQuestions.entries) {
      int questionNumber = entry.key + 1;
      Question question = entry.value;

      print('\n──────────────────────────────────────────────');
      print('Question $questionNumber:');
      print(question.display());
      print('❌ Your Answer: ${userAnswers[question]}');
      print('Correct Answer: ${question.getCorrectAnswer()}');
    }
  }

  int getNumQuestions(int totalAvailableQuestions) {
    int? numQuestions;

    while (numQuestions == null) {
      stdout.write(
          "How many questions would you like to answer?\n(Max: $totalAvailableQuestions, defaults 5 if you enter a space): ");
      String? input = stdin.readLineSync();

      if (input == " ") {
        numQuestions = 5;
      } else {
        numQuestions = int.tryParse(input ?? "");
      }

      if (numQuestions == null ||
          numQuestions <= 0 ||
          numQuestions > totalAvailableQuestions) {
        print(
            "Invalid input. Please enter a number between 1 and $totalAvailableQuestions.");
        numQuestions = null;
      }
    }

    return numQuestions;
  }

  String displayCurrentAnswer(dynamic answer, int index) {
    print('\n──────────────────────────────────────────────');
    print("\nYour previous answer for Question $index: \x1B[1;34m$answer\x1B[0m");
    return answer.toString();
  }

  String getUserNavigation() {
    stdout.write(
        "Type your answer, '[n]ext' to move forward, or '[p]revious' to go back: ");
    return stdin.readLineSync()?.trim().toLowerCase() ?? "";
  }

  String getUserAnswer() {
    return stdin.readLineSync()?.trim() ?? "";
  }

  bool askUserToReviewIncorrect() {
    print("\nWould you like to review incorrect answers? [y]es or [n]o:");
    String response = getUserAnswer().toLowerCase();
    return response == "yes" || response == "y";
  }
}
