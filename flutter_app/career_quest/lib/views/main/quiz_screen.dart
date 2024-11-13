import 'package:career_quest/models/question.dart';
import 'package:flutter/material.dart';

class QuizScreen extends StatefulWidget {
  static const String name = 'quiz';
  static const String path = '/$name';

  final List<Question> questions;

  const QuizScreen({super.key, required this.questions});

  @override
  _QuizScreenState createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> {
  int currentQuestionIndex =
      0; // To track which question is currently being displayed
  int score = 0; // To track the total score
  List<int> selectedOptions = []; // To track the user's selected options

  @override
  void initState() {
    super.initState();
    selectedOptions = List<int>.filled(widget.questions.length,
        -1); // Initialize selected options as -1 (no selection)
  }

  // Function to handle user's answer selection
  void selectOption(int optionIndex) {
    setState(() {
      selectedOptions[currentQuestionIndex] =
          optionIndex; // Update the selected option for the current question
    });
  }

  // Function to calculate the score
  void calculateScore() {
    score = 0;
    for (int i = 0; i < widget.questions.length; i++) {
      if (selectedOptions[i] == widget.questions[i].correctOptionIndex) {
        score++;
      }
    }
  }

  // Function to move to the next question or show the results
  void nextQuestion() {
    if (currentQuestionIndex < widget.questions.length - 1) {
      setState(() {
        currentQuestionIndex++;
      });
    } else {
      calculateScore();
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text("Quiz Completed"),
          content: Text("Your score is $score/${widget.questions.length}"),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                setState(() {
                  currentQuestionIndex = 0;
                  selectedOptions =
                      List<int>.filled(widget.questions.length, -1);
                });
              },
              child: const Text("Retry"),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.of(context).pop(score);
              },
              child: const Text("Close"),
            ),
          ],
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    Question currentQuestion = widget.questions[currentQuestionIndex];

    return Scaffold(
      appBar: AppBar(
        title: const Text("Quiz"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Display the question
            Text(
              "Question ${currentQuestionIndex + 1}/${widget.questions.length}",
              style:
                  const TextStyle(fontSize: 22.0, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            Text(
              currentQuestion.question,
              style: const TextStyle(fontSize: 18.0),
            ),
            const SizedBox(height: 20),

            // Display the options as buttons
            ...List.generate(currentQuestion.options.length, (index) {
              return RadioListTile<int>(
                title: Text(currentQuestion.options[index]),
                value: index,
                groupValue: selectedOptions[currentQuestionIndex],
                onChanged: (value) {
                  if (value != null) {
                    selectOption(value); // Update selected option
                  }
                },
              );
            }),

            const Spacer(),

            // Button to move to the next question or show the results
            ElevatedButton(
              onPressed: nextQuestion,
              child: Text(
                currentQuestionIndex < widget.questions.length - 1
                    ? "Next Question"
                    : "Finish Quiz",
              ),
            ),
          ],
        ),
      ),
    );
  }
}
