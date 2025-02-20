import 'dart:convert';
import 'package:http/http.dart' as http;
import 'question.dart';
import 'dart:developer' as developer;

/// The TestServices class is responsible for fetching quiz data from a remote server.
///
/// It provides methods to fetch a specific quiz by its number and to fetch all quizzes available.
class TestServices {
  final String url = 'https://www.cs.utep.edu/cheon/cs4381/homework/quiz/';

  /// Fetches a quiz by its [quizNumber].
  ///
  /// Returnes a `Future` that resolves to a list of [Question] objects.
  Future<List<Question>> fetchQuiz(int quizNumber) async {
    final quizName = 'quiz${quizNumber.toString().padLeft(2, '0')}';

    try {
      // Send a GET request to the server with the quiz name as a query parameter
      var response = await http.get(Uri.parse('$url?quiz=$quizName'));
      if (response.statusCode == 200) {
        var data = json.decode(response.body);

        // Check if the response indicates that the quiz was found
        if (data['response'] == false) {
          developer.log("Quiz $quizName not found");
          return [];
        }

        // Parse the JSON response to extract the quiz questions
        List<dynamic> rawQuestions = data['quiz']['questions'];
        List<Question> questionList = [];

        for (var q in rawQuestions) {
          Question question = Question.fromJson(q);
          questionList.add(question);
        }

        return questionList;
      } else {
        print(
            'Failed to load quiz $quizNumber, status code: ${response.statusCode}');
        return [];
      }
    } catch (e) {
      print('Error fetching quiz $quizNumber: $e');
      return [];
    }
  }

  /// Fetches all quizzes available by incrementing the quiz number until no more quizzes are found.
  ///
  /// Returns a `Future` that resolves to a list of all [Question] objects from all quizzes.
  Future<List<Question>> fetchAllQuestions() async {
    List<Question> allQuestions = [];
    int quizNumber = 1;

    while (true) {
      List<Question> questions = await fetchQuiz(quizNumber);

      if (questions.isEmpty) break;
      allQuestions.addAll(questions);
      quizNumber++;
    }

    return allQuestions;
  }
}
