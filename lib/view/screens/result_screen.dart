import 'package:flutter/material.dart';

class ResultScreen extends StatelessWidget {
  final int score;
  final int total;

  const ResultScreen({super.key, required this.score, required this.total});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Results')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Your Score: $score / $total'),
            ElevatedButton(
              child: const Text('Review Incorrect Answers'),
              onPressed: () {
                // Navigate to a review screen or show answers in a dialog
              },
            ),
            ElevatedButton(
              child: const Text('Restart'),
              onPressed: () {
                Navigator.pop(context); // or Navigator.of(context).popUntil(...)
              },
            ),
          ],
        ),
      ),
    );
  }
}