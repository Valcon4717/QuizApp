import 'question.dart';

/// A subclass of [Question] that represents a fill-in-the-blank question.
///
/// It contains a stem (the question text) and a list of possible answers.
class FillInBlankQuestion extends Question {
  List<String> possibleAnswers;
  String? figure;

  FillInBlankQuestion(String stem, this.possibleAnswers, this.figure)
      : super(stem, 2);

  /// Creates a fill-in-the-blank question from JSON.
  factory FillInBlankQuestion.fromJson(Map<String, dynamic> json) {
    return FillInBlankQuestion(
        json['stem'], List<String>.from(json['answer']), json['figure']);
  }

  /// Checks if the provided [response] is correct.
  @override
  bool checkResponse(Object response) {
    if (response is String) {
      return possibleAnswers
          .any((answer) => answer.toLowerCase() == response.toLowerCase());
    }
    return false;
  }

  /// Displays the question stem.
  @override
  @override
  String display() {
    String result = "\n$stem";
    if (figure != null && figure!.isNotEmpty) {
      result += "\nFigure: $figure";
    }
    return result;
  }

  /// Returns the correct answer as a string.
  @override
  String getCorrectAnswer() {
    return possibleAnswers.join(', ');
  }

  /// Validates if the provided [response] is a valid answer.
  @override
  bool isValidAnswer(String response) {
    return response.isNotEmpty;
  }
}
