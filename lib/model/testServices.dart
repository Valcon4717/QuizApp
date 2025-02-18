import 'dart:convert';
import 'package:http/http.dart' as http;
import 'question.dart';
import 'dart:developer' as developer;

class TestServices {
  final String url = 'https://www.cs.utep.edu/cheon/cs4381/homework/quiz/';

  // Fetches single quiz
  Future<List<Question>> fetchQuiz(int quizNumber) async {
    // ensure quiz number is formatted correctly
    final quizName = 'quiz${quizNumber.toString().padLeft(2, '0')}';

    try {
      var response = await http.get(Uri.parse('$url?quiz=$quizName'));
      if (response.statusCode == 200) {
        var data = json.decode(response.body);

        if (data['response'] == false) {
          developer.log("Quiz $quizName not found");
          return [];
        }

        // parse questions into Question objects
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

  // Fetches all quizzes
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
