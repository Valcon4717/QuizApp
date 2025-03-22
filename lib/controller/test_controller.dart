import 'dart:io';
import '../model/test_service.dart';
import '../model/question.dart';
import '../view/test_view.dart';

/// Controls the quiz flow and user interaction, including fetching questions,
/// navigating through them, and grading the quiz.
class TestController {
  final TestServices _service = TestServices();
  final TestView _view = TestView();

  /// Starts the quiz process by fetching questions, displaying them,
  /// collecting responses, and grading the quiz.
  Future<void> startQuiz() async {
    _view.welcomeMessage();
    _view.loadingMessage();

    // Fetch all questions from the service
    List<Question> questions = await _service.fetchAllQuestions();
    int numQuestions = _getNumQuestions(questions.length);

    // Shuffle the questions and select the specified number
    questions.shuffle();
    List<Question> selectedQuestions = questions.take(numQuestions).toList();

    // Navigate through the questions and collect user responses
    Map<Question, String> userAnswers = _navigateQuestions(selectedQuestions);

    // Grade the quiz and get the score and incorrect answers
    Map<String, dynamic> results = _gradeQuiz(selectedQuestions, userAnswers);
    int score = results['score'];
    Map<int, Question> incorrectAnswers = results['incorrect'];

    _view.displayScore(score, numQuestions);

    // Display the correct answers for incorrect responses
    if (incorrectAnswers.isNotEmpty && _view.askUserToReviewIncorrect()) {
      _view.reviewIncorrectAnswers(incorrectAnswers, userAnswers);
    }

    _view.goodbyeMessage();
  }

  /// Navigates through the [questions], allowing the user to answer or skip.
  ///
  /// Returns a `map` of questions and their corresponding user answers.
  Map<Question, String> _navigateQuestions(List<Question> questions) {
    int index = 0;
    Map<Question, String> userAnswers = {};

    while (index < questions.length) {
      _view.displayQuestion(questions[index], index);
      String userInput = _view.getUserNavigation();

      switch (userInput) {
        case "next":
        case "n":
        case "":
          if (index < questions.length - 1) {
            index++;
          } else {
            // Check for unanswered questions before ending the quiz
            if (_handleEndOfQuiz(questions, userAnswers)) return userAnswers;
            index = questions.indexWhere((q) => userAnswers[q] == null);
          }
          break;
        case "prev":
        case "p":
          if (index > 0) {
            index--;
            // Display the previous answer if available
            _view.displayCurrentAnswer(
                _getAnswerOrDefault(userAnswers, questions[index]), index + 1);
          }
          break;
        default:
          if (_isValidUserResponse(questions[index], userInput)) {
            // Store the user's answer
            userAnswers[questions[index]] = userInput;
            if (index < questions.length - 1) {
              index++;
            } else {
              if (_handleEndOfQuiz(questions, userAnswers)) return userAnswers;
              index = questions.indexWhere((q) => userAnswers[q] == null);
            }
          } else {
            _view.invalidAnswer(
                _getAnswerOrDefault(userAnswers, questions[index]), index + 1);
          }
      }
    }

    return userAnswers;
  }

  /// Handles the end of the quiz by checking for unanswered questions
  ///
  /// Returns `true` if the quiz can be ended, otherwise `false`.
  bool _handleEndOfQuiz(
      List<Question> questions, Map<Question, String> userAnswers) {
    if (_checkForUnansweredQuestions(questions, userAnswers)) {
      if (_endQuiz(questions, userAnswers)) {
        _markUnansweredQuestions(questions, userAnswers);
        return true;
      }
      return false;
    }
    return true;
  }

  /// Marks unanswered questions with a default response.
  void _markUnansweredQuestions(
      List<Question> questions, Map<Question, String> userAnswers) {
    for (var question in questions) {
      userAnswers.putIfAbsent(question, () => "No answer");
    }
  }

  /// Retrieves the user's answer for a question,
  /// or a default message if not answered.
  String _getAnswerOrDefault(
      Map<Question, String> userAnswers, Question question) {
    return userAnswers[question] ?? "No answer";
  }

  /// Grades the quiz by checking [userAnswers] against correct answers.
  ///
  /// Returns a `map` containing the score and a list of incorrect answers.
  Map<String, dynamic> _gradeQuiz(
      List<Question> questions, Map<Question, String> userAnswers) {
    int score = 0;
    Map<int, Question> incorrectAnswers = {};

    for (int i = 0; i < questions.length; i++) {
      Question question = questions[i];
      String userResponse = _getAnswerOrDefault(userAnswers, question);

      if (question.checkResponse(userResponse)) {
        score++;
      } else {
        incorrectAnswers[i] = question;
      }
    }

    return {'score': score, 'incorrect': incorrectAnswers};
  }

  /// Checks if the user's [response] is valid for the given [question].
  ///
  /// Returns `true` if the response is valid, otherwise `false`.
  bool _isValidUserResponse(Question question, String response) {
    return question.isValidAnswer(response);
  }

  /// Checks if there are any unanswered questions.
  ///
  /// Returns `true` if there are unanswered questions, otherwise `false`.
  bool _checkForUnansweredQuestions(
      List<Question> questions, Map<Question, String?> userAnswers) {
    return questions.any((q) => userAnswers[q] == null);
  }

  /// Prompts the user to confirm if they want to end the quiz
  /// even if there are unanswered [questions].
  ///
  /// Returns `true` if the user confirms, otherwise `false`.
  bool _endQuiz(List<Question> questions, Map<Question, String?> userAnswers) {
    int unansweredCount = questions.where((q) => userAnswers[q] == null).length;

    if (unansweredCount > 0) {
      print(
          "\n\x1B[1;33m⚠️ You have $unansweredCount unanswered questions ⚠️\x1B[0m");
      if (_view.getYesOrNo("Would you still like to end the quiz?")) {
        return true;
      } else {
        print("\n\x1B[1;36mContinuing the quiz...\x1B[0m");
        return false;
      }
    }
    return true;
  }

  /// Prompts the user for the number of questions to answer
  ///
  /// Returns the number of questions as an `int`.
  int _getNumQuestions(int totalAvailableQuestions) {
    int? numQuestions;

    do {
      stdout.write(
          "\nHow many questions would you like to answer?\n(Max: $totalAvailableQuestions, defaults 5 if you enter a space): ");
      String? input = stdin.readLineSync();

      numQuestions = (input == " ") ? 5 : int.tryParse(input ?? "");

      if (numQuestions == null ||
          numQuestions <= 0 ||
          numQuestions > totalAvailableQuestions) {
        print(
            "\x1B[1;31mInvalid input\x1B[0m. Please enter a number between 1 and $totalAvailableQuestions.");
        numQuestions = null;
      }
    } while (numQuestions == null);

    return numQuestions;
  }
}
