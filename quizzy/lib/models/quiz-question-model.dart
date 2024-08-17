import 'dart:convert';

List<QuizQuestionModel> quizQuestionModelFromJson(String str) => 
    List<QuizQuestionModel>.from(json.decode(str).map((x) => QuizQuestionModel.fromJson(x)));

class QuizQuestionModel {
  final String id;
  final String quizId;
  final String text;
  final List<String> options;
  final int correctAnswer;
  final String explanation;
  final int timerDuration;

  QuizQuestionModel({
    required this.id,
    required this.quizId,
    required this.text,
    required this.options,
    required this.correctAnswer,
    required this.explanation,
    required this.timerDuration,
  });

  factory QuizQuestionModel.fromJson(Map<String, dynamic> json) => QuizQuestionModel(
    id: json["id"],
    quizId: json["quizId"],
    text: json["text"],
    options: List<String>.from(json["options"].map((x) => x)),
    correctAnswer: json["correctAnswer"],
    explanation: json["explanation"],
    timerDuration: json["timerDuration"],
  );
}