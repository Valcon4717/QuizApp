import 'package:flutter/material.dart';
import '../model/test_service.dart';
import '../model/question.dart';

/// TestController is a ChangeNotifier that manages the quiz state
/// It handles loading questions, recording answers, grading the quiz,
/// and resetting the quiz data.
class TestController extends ChangeNotifier {
  final TestServices _service = TestServices();

  List<Question> _questions = [];
  Map<Question, String> _userAnswers = {};
  int _score = 0;
  Map<int, Question> _incorrectAnswers = {};

  bool _isLoading = false;
  bool get isLoading => _isLoading;
  List<Question> get questions => _questions;
  Map<Question, String> get userAnswers => _userAnswers;
  int get score => _score;
  Map<int, Question> get incorrectAnswers => _incorrectAnswers;

  /// Loads the quiz questions from the service using the provided login credentials
  /// and filters them based on the user's preferences given [isMultipleChoice] and
  /// [isFillInBlank]
  Future<void> loadQuiz({
    int? numQuestions,
    required String username,
    required String pin,
    bool isMultipleChoice = true,
    bool isFillInBlank = false,
  }) async {
    _isLoading = true;
    notifyListeners();

    // Fetch all questions with authentication info
    List<Question> fetchedQuestions =
        await _service.fetchAllQuestions(username, pin);

    // Filter the questions based on the user’s preferences
    List<Question> filtered = fetchedQuestions.where((q) {
      bool typeMatch = false;
      if (q.type == 1 && isMultipleChoice) typeMatch = true;
      if (q.type == 2 && isFillInBlank) typeMatch = true;
      return typeMatch;
    }).toList();

    filtered.shuffle();

    if (numQuestions != null &&
        numQuestions > 0 &&
        numQuestions <= filtered.length) {
      _questions = filtered.take(numQuestions).toList();
    } else {
      _questions = filtered;
    }

    _isLoading = false;
    notifyListeners();
  }

  /// getAvailableQuestionCount() returns the number of available questions
  /// given [username] and [pin]
  Future<int> getAvailableQuestionCount({
    required String username,
    required String pin,
  }) async {
    List<Question> fetchedQuestions =
        await _service.fetchAllQuestions(username, pin);
    return fetchedQuestions.length;
  }

  /// Records the user's answer for a given [question] and [answer]
  void recordAnswer(Question question, String answer) {
    _userAnswers[question] = answer;
    notifyListeners();
  }

  /// gradeQuiz() grades the quiz by checking each question's answer
  void gradeQuiz() {
    int calculatedScore = 0;
    Map<int, Question> incorrect = {};

    for (int i = 0; i < _questions.length; i++) {
      Question q = _questions[i];
      String userResponse = _userAnswers[q] ?? "No answer";
      if (q.checkResponse(userResponse)) {
        calculatedScore++;
      } else {
        incorrect[i] = q;
      }
    }
    _score = calculatedScore;
    _incorrectAnswers = incorrect;
    notifyListeners();
  }

  /// Resets the quiz data
  void resetQuiz() {
    _questions = [];
    _userAnswers = {};
    _score = 0;
    _incorrectAnswers = {};
    notifyListeners();
  }
}
