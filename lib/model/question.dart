import 'MultipleChoiceQuestion.dart';
import 'FillInBlankQuestion.dart';

abstract class Question {
  String stem;
  int type;

  Question(this.stem, this.type);

  bool checkResponse(Object response);
  void display();
  bool isValidAnswer(String response);

  // Delegates to specific subclasses
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