import 'dart:convert';

List<QuizModel> quizModelFromJson(String str) => List<QuizModel>.from(json.decode(str).map((x) => QuizModel.fromJson(x)));

String quizModelToJson(List<QuizModel> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class QuizModel {
    final String id;
    final String name;
    final String description;
    final String imageUrl;
    final int questionCount;
    final String difficulty;

    QuizModel({
        required this.id,
        required this.name,
        required this.description,
        required this.imageUrl,
        required this.questionCount,
        required this.difficulty,
    });

    factory QuizModel.fromJson(Map<String, dynamic> json) => QuizModel(
        id: json["id"],
        name: json["name"],
        description: json["description"],
        imageUrl: json["imageUrl"],
        questionCount: json["questionCount"],
        difficulty: json["difficulty"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "description": description,
        "imageUrl": imageUrl,
        "questionCount": questionCount,
        "difficulty": difficulty,
    };
}