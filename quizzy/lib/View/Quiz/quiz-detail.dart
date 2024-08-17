import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:quizzy/View/Quiz/quiz-screen.dart';
import 'package:quizzy/hooks/fetch-specific-quiz.dart';
import 'package:quizzy/common/colo_extension.dart';
import 'package:quizzy/common/round_button.dart';

class SpecificQuizDetail extends HookWidget {
  const SpecificQuizDetail({super.key, required this.quizId});
  final String quizId;

  @override
  Widget build(BuildContext context) {
    final hookResult = useFetchQuiz(quizId);
    final quiz = hookResult.data;
    final isLoading = hookResult.isLoading;
    final error = hookResult.error;
    var media = MediaQuery.of(context).size;

    if (isLoading) {
      return Scaffold(
        body: Center(child: CircularProgressIndicator(color: TColor.primaryColor1)),
      );
    }

    if (error != null) {
      return Scaffold(
        body: Center(child: Text('Error: ${error.toString()}', style: TextStyle(color: TColor.secondaryColor1))),
      );
    }

    if (quiz == null) {
      return Scaffold(
        body: Center(child: Text('Quiz not found', style: TextStyle(color: TColor.gray))),
      );
    }

    return Scaffold(
      body: Container(
        color: TColor.primaryColor2,
        child: Column(
          children: [
            Container(
              height: media.width * 0.5,
              decoration: BoxDecoration(
                gradient: LinearGradient(colors: TColor.primaryG),
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(media.width * 0.060),
                  bottomRight: Radius.circular(media.width * 0.060),
                ),
              ),
              child: SafeArea(
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    Image.asset(
                      "assets/img/bg_dots.png",
                      height: media.width * 0.4,
                      width: double.maxFinite,
                      fit: BoxFit.fitHeight,
                    ),
                    Positioned(
                      top: 16,
                      left: 16,
                      child: IconButton(
                        icon: Icon(Icons.arrow_back, color: TColor.white),
                        onPressed: () => Navigator.of(context).pop(),
                      ),
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          quiz.name,
                          style: TextStyle(
                            color: TColor.white,
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 8),
                        Text(
                          "${quiz.questionCount} Questions | ${quiz.difficulty}",
                          style: TextStyle(
                            color: TColor.white.withOpacity(0.7),
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Text(
                        "Description",
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: TColor.white,
                        ),
                      ),
                      SizedBox(height: 8),
                      Text(
                        quiz.description,
                        style: TextStyle(
                          fontSize: 16,
                          color: TColor.white,
                        ),
                      ),
                      SizedBox(height: 24),
                      _buildQuizInfoContainer(context, quiz),
                      SizedBox(height: 24),
                      Text(
                        "Are you ready to start?",
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: TColor.white,
                        ),
                      ),
                      SizedBox(height: 16),
                      
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: Container(
        color: TColor.primaryColor1,
        child: Padding(
          padding: const EdgeInsets.only(bottom: 16),
          child: RoundButton(
                  
                          title: "Start Quiz",
                          onPressed: () {
                            Get.to(QuizScreen(quizId: quiz.id, quizName: quiz.name));
                          },
                        ),
        ),
      ),
    );
  }

  Widget _buildQuizInfoContainer(BuildContext context, dynamic quiz) {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: TColor.primaryColor1,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Quiz Details",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: TColor.white,
            ),
          ),
          SizedBox(height: 16),
          _buildInfoRow(Icons.help_outline, "Questions", "${quiz.questionCount}"),
          SizedBox(height: 8),
          _buildInfoRow(Icons.timer, "Duration", "30 minutes"), // Assuming a duration, adjust as needed
          SizedBox(height: 8),
          _buildInfoRow(Icons.star_border, "Difficulty", quiz.difficulty),
        ],
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String label, String value) {
    return Row(
      children: [
        Icon(icon, color: Colors.amber, size: 20),
        SizedBox(width: 8),
        Text(
          "$label: ",
          style: TextStyle(
            fontSize: 16,
            color: TColor.white.withOpacity(0.7),
          ),
        ),
        Text(
          value,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: TColor.white,
          ),
        ),
      ],
    );
  }
}