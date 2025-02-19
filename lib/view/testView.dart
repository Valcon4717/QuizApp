import 'dart:io';
import '../model/question.dart';

class TestView {
  void welcomeMessage() {
    print('\n──────────────────────────────────────────────');
    print("        \x1B[1;32m✨Welcome to the Quiz App!✨\x1B[0m");
    print('──────────────────────────────────────────────');
  }

  void goodbyeMessage() {
    print("Thank you for taking the quiz!");
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

  void reviewIncorrectAnswers(List<Question> incorrectQuestions) {
    if (incorrectQuestions.isEmpty) return;
    print("\nReview Incorrect Answers:");
    for (var question in incorrectQuestions) {
      print('\n──────────────────────────────────────────────\n');
      print('Incorrect: ${question.display()}');
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
    print("\n→ Current answer for question $index : $answer");
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
    print("\nWould you like to review incorrect answers? (yes/no)");
    String response = getUserAnswer().toLowerCase();
    return response == "yes";
  }
}
