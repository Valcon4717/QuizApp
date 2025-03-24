import 'dart:convert';
import 'package:http/http.dart' as http;
import 'question.dart';
import 'dart:developer' as developer;

/// The TestServices class is responsible for fetching quiz data from a remote server.
///
/// It provides methods to fetch a specific quiz by its number and to fetch all quizzes available.
/// Now, it includes the required login parameters: user and pin.
class TestServices {
  // Updated base URL to point to quiz.php
  final String _baseUrl = 'https://www.cs.utep.edu/cheon/cs4381/homework/quiz/quiz.php';

  /// Fetches a quiz by its [quizNumber] for a given [username] and [pin].
  ///
  /// Returns a `Future` that resolves to a list of [Question] objects.
  Future<List<Question>> fetchQuiz(int quizNumber, String username, String pin) async {
    final quizName = 'quiz${quizNumber.toString().padLeft(2, '0')}';
    final url = '$_baseUrl?user=$username&pin=$pin&quiz=$quizName';

    try {
      // Send a GET request to the server with the user, pin, and quiz parameters.
      var response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        var data = json.decode(response.body);

        // Check if the response indicates that the quiz was found.
        if (data['response'] == false) {
          developer.log("Quiz $quizName not found: ${data['reason']}");
          return [];
        }

        // Parse the JSON response to extract the quiz questions.
        List<dynamic> rawQuestions = data['quiz']['questions'];
        List<Question> questionList = [];

        for (var q in rawQuestions) {
          Question question = Question.fromJson(q);
          questionList.add(question);
        }

        return questionList;
      } else {
        print('Failed to load quiz $quizNumber, status code: ${response.statusCode}');
        return [];
      }
    } catch (e) {
      print('Error fetching quiz $quizNumber: $e');
      return [];
    }
  }

  /// Fetches all quizzes available by incrementing the quiz number until no more quizzes are found.
  ///
  /// The [username] and [pin] parameters are used in each API call.
  /// Returns a `Future` that resolves to a list of all [Question] objects from all quizzes.
  Future<List<Question>> fetchAllQuestions(String username, String pin) async {
    List<Question> allQuestions = [];
    int quizNumber = 1;

    while (true) {
      List<Question> questions = await fetchQuiz(quizNumber, username, pin);
      if (questions.isEmpty) break;
      allQuestions.addAll(questions);
      quizNumber++;
    }

    return allQuestions;
  }
}


// import 'dart:convert';
// import 'package:http/http.dart' as http;
// import 'question.dart';
// import 'dart:developer' as developer;

// /// The TestServices class is responsible for fetching quiz data from a remote server.
// /// For testing purposes, this version always fetches quiz99.
// class TestServices {
//   // Updated base URL to point to quiz.php
//   final String _baseUrl = 'https://www.cs.utep.edu/cheon/cs4381/homework/quiz/quiz.php';

//   /// Fetches quiz99 for a given [username] and [pin], ignoring the [quizNumber] parameter.
//   Future<List<Question>> fetchQuiz(int quizNumber, String username, String pin) async {
//     // For testing, override quizName to always "quiz99".
//     final quizName = 'quiz99';
//     final url = '$_baseUrl?user=$username&pin=$pin&quiz=$quizName';

//     try {
//       // Send a GET request to the server with the user, pin, and quiz parameters.
//       var response = await http.get(Uri.parse(url));
//       if (response.statusCode == 200) {
//         var data = json.decode(response.body);

//         // Check if the response indicates that the quiz was found.
//         if (data['response'] == false) {
//           developer.log("Quiz $quizName not found: ${data['reason']}");
//           return [];
//         }

//         // Parse the JSON response to extract the quiz questions.
//         List<dynamic> rawQuestions = data['quiz']['questions'];
//         List<Question> questionList = [];

//         for (var q in rawQuestions) {
//           Question question = Question.fromJson(q);
//           questionList.add(question);
//         }

//         return questionList;
//       } else {
//         print('Failed to load quiz $quizName, status code: ${response.statusCode}');
//         return [];
//       }
//     } catch (e) {
//       print('Error fetching quiz $quizName: $e');
//       return [];
//     }
//   }

//   /// Fetches all quizzes available by incrementing the quiz number until no more quizzes are found.
//   /// For testing, this method could simply return quiz99.
//   Future<List<Question>> fetchAllQuestions(String username, String pin) async {
//     // For testing, simply return the questions for quiz99.
//     return await fetchQuiz(99, username, pin);
//   }
// }