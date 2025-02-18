import 'question.dart';

class MultipleChoiceQuestion extends Question {
  List<String> options;
  int correctAnswer;

  MultipleChoiceQuestion(String stem, this.options, this.correctAnswer)
      : super(stem, 1);

  // Factory constructor to create a MultipleChoiceQuestion object from a JSON object
  factory MultipleChoiceQuestion.fromJson(Map<String, dynamic> json) {
    return MultipleChoiceQuestion(
        json['stem'], List<String>.from(json['options']), json['answer']);
  }

  @override
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


  @override
  void display() {
    print("\n$stem");
    options.asMap().forEach((index, option) {
      print('${index + 1}. $option');
    });
  }

  @override
  bool isValidAnswer(String response) {
    int? choice = int.tryParse(response);
    return choice != null && choice > 0 && choice <= options.length;
  }
}
