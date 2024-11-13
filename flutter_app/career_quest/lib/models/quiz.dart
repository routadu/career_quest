import 'dart:convert';

import 'package:career_quest/models/question.dart';
import 'package:career_quest/providers/providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class Quiz {
  String id;
  String? title;
  String? description;
  List<Question>? questions;
  String? summary;

  bool _isLoaded = false;

  Quiz({
    required this.id,
    this.title,
    this.description,
    this.questions,
    this.summary,
  }) {
    if (title != null && description != null && questions != null) {
      _isLoaded = true;
    }
  }

  bool get isEmpty => id == "0";
  bool get isNew => id == "NEW";
  bool get isSummaryAvailable => summary != null && summary != "";

  factory Quiz.empty() {
    return Quiz(id: "0");
  }

  factory Quiz.newQuiz() {
    return Quiz(id: "NEW");
  }

  factory Quiz.fromId(String id) {
    return Quiz(id: id);
  }

  factory Quiz.fromMap(Map<String, dynamic> map) {
    return Quiz(
      id: map["id"],
      title: map["title"],
      description: map["description"],
      questions: Question.getQuestionListFromMap(map),
      summary: map["summary"],
    );
  }

  factory Quiz.fromString(String data) {
    return Quiz.fromMap(jsonDecode(data));
  }

  Future<String> getSummary() async {
    if (isSummaryAvailable) return summary!;
    await generateSummary();
    return summary ?? "";
  }

  Future<void> generateSummary() async {
    if (isSummaryAvailable) return;
    try {
      summary = "";
    } catch (e) {
      summary = "";
    }
  }

  Future<void> load(ProviderRef ref) async {
    if (_isLoaded) return;
    try {
      Quiz quiz = await ref.read(firestoreServiceProvider).getQuiz(id);
      if (quiz.isEmpty) {
        throw Exception("Cannot obtain the quiz from database with id: $id");
      }
      title = quiz.title;
      description = quiz.description;
      if (quiz.isSummaryAvailable) {
        summary = quiz.summary;
      } else {
        await generateSummary();
      }
      _isLoaded = true;
    } catch (e) {
      debugPrint("Unable to load quiz data");
      _isLoaded = false;
    }
  }

  Map<String, dynamic> toMap() {
    return {
      "id": id,
      "title": title,
      "description": description,
      "questions": Question.questionsToMapList(questions ?? []),
      "summary": summary,
    };
  }

  @override
  String toString() {
    return jsonEncode(toMap());
  }
}
