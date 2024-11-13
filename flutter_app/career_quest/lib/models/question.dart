import 'dart:convert';

import 'package:flutter/material.dart';

class Question {
  String question;
  List<String> options;
  int correctOptionIndex;

  Question({
    required this.question,
    required this.options,
    required this.correctOptionIndex,
  });

  factory Question.fromMap(Map<String, dynamic> map) {
    return Question(
      question: map["question"],
      options: List<String>.from(map["options"]),
      correctOptionIndex: map["correctOptionIndex"],
    );
  }

  static List<Map<String, dynamic>> questionsToMapList(
      List<Question> questions) {
    List<Map<String, dynamic>> result = [];
    for (Question ques in questions) {
      result.add(ques.toMap());
    }
    return result;
  }

  Map<String, dynamic> toMap() {
    return {
      "question": question,
      "options": options,
      "correctOptionIndex": correctOptionIndex
    };
  }

  factory Question.fromString(String data) {
    return Question.fromMap(jsonDecode(data));
  }

  static List<Question> getQuestionListFromMap(Map<String, dynamic> map) {
    List<Question> questions = [];
    if (map.containsKey("questions")) {
      List<Map<String, dynamic>> data =
          List<Map<String, dynamic>>.from(map["questions"]);
      for (Map<String, dynamic> q in data) {
        questions.add(Question.fromMap(q));
      }
    }
    return questions;
  }

  static List<Question> getQuestionListFromString(String data) {
    debugPrint(data);
    return getQuestionListFromMap(jsonDecode(data));
  }

  @override
  String toString() {
    return jsonEncode(toMap());
  }
}
