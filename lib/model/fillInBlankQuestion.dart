import 'question.dart';

class FillInBlankQuestion extends Question {
  List<String> possibleAnswers;

  FillInBlankQuestion(String stem, this.possibleAnswers) : super(stem, 2);

  // Factory constructor to create a FillInBlankQuestion object from a JSON object
  factory FillInBlankQuestion.fromJson(Map<String, dynamic> json) {
    return FillInBlankQuestion(json['stem'], List<String>.from(json['answer']));
  }

  @override
  bool checkResponse(Object response) {
    if (response is String) {
      return possibleAnswers
          .any((answer) => answer.toLowerCase() == response.toLowerCase());
    }
    return false;
  }

  @override
  String display() {
    return '\n$stem';
  }

  @override
  String getCorrectAnswer() {
    return possibleAnswers.join(', ');
  }

  @override
  bool isValidAnswer(String response) {
    return response.isNotEmpty;
  }
}
