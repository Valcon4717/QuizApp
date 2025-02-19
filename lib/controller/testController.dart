import '../model/testServices.dart';
import '../model/question.dart';
import '../view/testView.dart';

class TestController {
  final TestServices _service = TestServices();
  final TestView _view = TestView();

  Future<void> startQuiz() async {
    _view.welcomeMessage();

    _view.loadingMessage();
    List<Question> questions = await _service.fetchAllQuestions();

    // Validate user input against available questions
    int numQuestions = _view.getNumQuestions(questions.length);

    questions.shuffle();
    List<Question> selectedQuestions = questions.take(numQuestions).toList();

    Map<Question, String> userAnswers = _navigateQuestions(selectedQuestions);

    Map<String, dynamic> results = _gradeQuiz(selectedQuestions, userAnswers);
    int score = results['score'];
    Map<int, Question> incorrectAnswers = results['incorrect'];

    _view.displayScore(score, numQuestions);

    if (incorrectAnswers.isNotEmpty && _view.askUserToReviewIncorrect()) {
      _view.reviewIncorrectAnswers(incorrectAnswers, userAnswers);
    }

    _view.goodbyeMessage();
  }

  // Navigate through questions and return user answers
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
          if (index < questions.length - 1) index++;
          break;
        case "prev":
        case "p":
          if (index > 0) {
            index--;
            _view.displayCurrentAnswer(userAnswers[questions[index]], index+1);
          }
          break;
        default:
          if (_isValidUserResponse(questions[index], userInput)) {
            userAnswers[questions[index]] = userInput;
            index++;
          } else {
            print("Invalid answer. Please enter a valid option.");
          }
      }
    }

    return userAnswers;
  }

  // Grade the quiz and return score and incorrect answers
  Map<String, dynamic> _gradeQuiz(
      List<Question> questions, Map<Question, String> userAnswers) {
    int score = 0;
    Map<int, Question> incorrectAnswers = {};

    for (int i = 0; i < questions.length; i++) {
      Question question = questions[i];
      String userResponse = userAnswers[question] ?? "";

      if (question.checkResponse(userResponse)) {
        score++;
      } else {
        incorrectAnswers[i] = question;
      }
    }

    return {'score': score, 'incorrect': incorrectAnswers};
  }

  bool _isValidUserResponse(Question question, String response) {
    return question.isValidAnswer(response);
  }
}
