import 'question.dart';

/// A subclass of [Question] that represents a multiple-choice question.
///
/// It contains a stem (the question text), a list of options, and the index of the correct answer.
class MultipleChoiceQuestion extends Question {
  List<String> options;
  int correctAnswer;
  String? figure;

  MultipleChoiceQuestion(String stem, this.options, this.correctAnswer, this.figure)
      : super(stem, 1);

  /// Creates a multiple-choice question from JSON.
  factory MultipleChoiceQuestion.fromJson(Map<String, dynamic> json) {
    return MultipleChoiceQuestion(
        json['stem'], List<String>.from(json['options']), json['answer'], json['figure']);
  }

  /// Checks if the provided [response] is correct.
  @override
  bool checkResponse(Object response) {
    if (response is int) {
      return response == correctAnswer;
    } else if (response is String) {
      int? parsedResponse = int.tryParse(response);
      return parsedResponse != null && parsedResponse == correctAnswer;
    }
    return false;
  }

  /// Displays the question stem and options.
  @override
  String display() {
    StringBuffer displayString = StringBuffer("\n$stem\n");
    if (figure != null && figure!.isNotEmpty) {
      displayString.writeln("Figure: $figure");
    }
    options.asMap().forEach((index, option) {
      displayString.writeln('  ${index + 1}. $option');
    });
    return displayString.toString();
  }

  /// Returns the correct answer as a string.
  @override
  String getCorrectAnswer() {
    return options[correctAnswer - 1];
  }

  /// Validates if the provided [response] is a valid answer.
  @override
  bool isValidAnswer(String response) {
    int? choice = int.tryParse(response);
    return choice != null && choice > 0 && choice <= options.length;
  }
}
