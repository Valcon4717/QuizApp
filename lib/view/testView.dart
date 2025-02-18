import 'dart:io';
import '../model/question.dart';

class TestView {
  void welcomeMessage() {
    print("Welcome to the Quiz App!");
  }

  void goodbyeMessage() {
    print("Thank you for taking the quiz!");
  }

  void loadingMessage() {
    print("Loading questions...");
  }

  void displayScore(int score, int total) {
    print("\nQuiz Complete! Your score: $score / $total");
  }

  void displayQuestion(Question question) {
    question.display();
  }

  void reviewIncorrectAnswers(List<Question> incorrectQuestions) {
    if (incorrectQuestions.isEmpty) return;
    print("\nReview Incorrect Answers:");
    for (var question in incorrectQuestions) {
      displayQuestion(question);
    }
  }

  int getNumQuestions(int totalAvailableQuestions) {
    int? numQuestions;

    while (numQuestions == null) {
      stdout.write(
          "How many questions would you like to answer? (Max: $totalAvailableQuestions): ");
      String? input = stdin.readLineSync();

      numQuestions = int.tryParse(input ?? "");

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
