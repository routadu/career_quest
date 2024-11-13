import 'dart:convert';

import 'package:career_quest/services/prompt_generator.dart';
import 'package:career_quest/models/question.dart';
import 'package:career_quest/models/quiz.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:flutter/material.dart';

class GeminiService {
  Future<String> getResponse(String query) async {
    HttpsCallable req = FirebaseFunctions.instance.httpsCallable("geminiRes");
    final response = await req.call(<String, dynamic>{"prompt": query});
    if (response.data != null) {
      final map = Map.from(response.data);
      if (map.containsKey("prompt_response")) {
        return map["prompt_response"];
      } else {
        return "No response";
      }
    } else {
      return "Some error occured";
    }
  }

  Future<String> getCareerPath(
    String educationLevel,
    List<String> interests,
  ) async {
    final String query = PromptGenerator.generateCareerPathPrompt(
      educationLevel,
      interests,
    );
    return await getResponse(query);
  }

  Future<Quiz> getQuizQuestions(
    String educationLevel,
    List<String> interests,
  ) async {
    final String query = PromptGenerator.generateQuizPrompt(
      educationLevel,
      interests,
    );
    final String response = await getResponse(query);
    final Map<String, dynamic> map = jsonDecode(response);
    final String title = map['title'];
    final String description = map['description'];
    final String summary = map['summary'];

    int startingIndex = response.indexOf("{");
    int lastIndex = response.lastIndexOf("}");
    debugPrint("Quiz response from gemini: $response");
    List<Question> questions = Question.getQuestionListFromString(
        response.substring(startingIndex, lastIndex + 1));

    return Quiz(
      id: "NEW",
      title: title,
      description: description,
      summary: summary,
      questions: questions,
    );
  }
}
