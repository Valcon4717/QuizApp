import 'dart:convert';
import 'package:http/http.dart' as http;

class AuthenticationService {
  final String _baseUrl = "https://www.cs.utep.edu/cheon/cs4381/homework/quiz/quiz.php";

  /// Attempts to log in with the given [username] and [pin].
  /// Optionally, a [quiz] parameter can be provided (default is "quiz01").
  /// Returns a Map with keys such as 'response' (bool) and 'reason' (String) on failure,
  /// or other user/profile data on success.
  Future<Map<String, dynamic>> login(String username, String pin, {String quiz = "quiz01"}) async {
    final url = "$_baseUrl?user=$username&pin=$pin&quiz=$quiz";
    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data;
      } else {
        return {"response": false, "reason": "Server error: ${response.statusCode}"};
      }
    } catch (e) {
      return {"response": false, "reason": "Error: $e"};
    }
  }
}