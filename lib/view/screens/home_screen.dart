import 'package:flutter/material.dart';
import 'package:quiz_app/model/test_service.dart';
import '../../controller/test_controller.dart';
import 'question_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final testController = TestController();
    final testServices = TestServices();

    return Scaffold(
      appBar: AppBar(title: const Text('Quiz Home')),
      body: Center(
        child: ElevatedButton(
          child: const Text('Start Quiz'),
          onPressed: () {
            // Navigate to QuestionScreen
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => QuestionScreen(controller: testController, testServices: testServices),
              ),
            );
          },
        ),
      ),
    );
  }
}