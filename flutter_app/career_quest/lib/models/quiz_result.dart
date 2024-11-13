import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'quiz.dart';

class QuizResult {
  final String quizId;
  final String timestamp;
  final double totalScore;
  final double achievedScore;

  Quiz? _quiz;

  QuizResult({
    required this.quizId,
    required this.timestamp,
    required this.totalScore,
    required this.achievedScore,
  });

  factory QuizResult.fromMap(Map<String, dynamic> map) {
    return QuizResult(
      quizId: map['quizId'],
      timestamp: map['timestamp'],
      totalScore: map['totalScore'],
      achievedScore: map['achievedScore'],
    );
  }

  factory QuizResult.fromString(String data) {
    return QuizResult.fromMap(jsonDecode(data));
  }

  loadQuiz(ProviderRef ref) async {
    try {
      _quiz = Quiz.fromId(quizId);
      await _quiz?.load(ref);
    } catch (e) {
      debugPrint("Cannot load quiz with id: $quizId");
    }
  }

  String? getQuizSummary() {
    return _quiz?.summary;
  }

  double getPercentage() {
    return achievedScore * 100 / totalScore;
  }

  Map<String, dynamic> toMap() {
    return {
      "quizId": quizId,
      "timestamp": timestamp,
      "totalScore": totalScore,
      "achievedScore": achievedScore,
    };
  }

  @override
  String toString() {
    return jsonEncode(toMap());
  }
}
