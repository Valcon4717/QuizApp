import 'package:practise_test/controller/testController.dart';

/// Entry point of the Quiz Application.
///
/// This initializes the [TestController] and starts the quiz.
void main() async {
  TestController controller = TestController();
  await controller.startQuiz();
}
