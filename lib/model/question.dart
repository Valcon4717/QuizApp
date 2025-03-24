import 'multiple_choice_question.dart';
import 'fill_in_blank_question.dart';

/// Abstract class representing a question.
///
/// This class serves as a base for different types of questions
/// such as multiple-choice and fill-in-the-blank.
abstract class Question {
  String stem;
  int type;

  Question(this.stem, this.type);

  /// Checks if the provided [response] is correct.
  bool checkResponse(Object response);

  /// Returns a string representation of the question.
  String display();

  /// Validates if the provided [response] is a valid answer.
  bool isValidAnswer(String response);

  /// Returns the correct answer as a string.
  String getCorrectAnswer();

  /// Returns the figure associated with the question, if any.
  String? get figure => null;

  /// Factory method to create a [Question] object from a JSON object.
  static Question fromJson(Map<String, dynamic> json) {
    switch (json['type']) {
      case 1:
        return MultipleChoiceQuestion.fromJson(json);
      case 2:
        return FillInBlankQuestion.fromJson(json);
      default:
        throw Exception("Unknown question type: ${json['type']}");
    }
  }
}
