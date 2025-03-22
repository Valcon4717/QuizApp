import 'package:flutter/material.dart';
import '../../controller/test_controller.dart';
import '../../model/test_service.dart';

class QuestionScreen extends StatefulWidget {
  final TestController controller;
  final TestServices testServices;
  const QuestionScreen({super.key, required this.controller, required this.testServices});

  @override
  State<QuestionScreen> createState() => _QuestionScreenState();
}

class _QuestionScreenState extends State<QuestionScreen> {
  int currentIndex = 0;
  bool isLoading = true;
  List questions = []; // Replace with your actual Question model type

  @override
  void initState() {
    super.initState();
    _loadQuestions();
  }

  Future<void> _loadQuestions() async {
    final fetchedQuestions = await widget.testServices.fetchAllQuestions();
    setState(() {
      questions = fetchedQuestions;
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      appBar: AppBar(title: const Text('Quiz')),
      body: questions.isEmpty
          ? const Center(child: Text('No questions found'))
          : Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(questions[currentIndex].stem), // Display question stem
                  // TODO: Display multiple-choice or fill-in blank logic
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      ElevatedButton(
                        child: const Text('Previous'),
                        onPressed: currentIndex > 0
                            ? () {
                                setState(() {
                                  currentIndex--;
                                });
                              }
                            : null,
                      ),
                      ElevatedButton(
                        child: const Text('Next'),
                        onPressed: currentIndex < questions.length - 1
                            ? () {
                                setState(() {
                                  currentIndex++;
                                });
                              }
                            : null,
                      ),
                    ],
                  )
                ],
              ),
            ),
    );
  }
}