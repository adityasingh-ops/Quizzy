import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:quizzy/View/Home/main-tab.dart';
import 'package:quizzy/common/colo_extension.dart';
import 'package:quizzy/common/round_button.dart';
import 'package:fl_chart/fl_chart.dart';

class QuizResultScreen extends StatelessWidget {
  final String quizName;
  final int score;
  final int totalQuestions;
  final List<Map<String, dynamic>> incorrectAnswers;
  final int timeTaken;

  const QuizResultScreen({
    Key? key,
    required this.quizName,
    required this.score,
    required this.totalQuestions,
    required this.incorrectAnswers,
    required this.timeTaken,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final percentage = (score / totalQuestions) * 100;
    final incorrectCount = totalQuestions - score;
    final media = MediaQuery.of(context).size;
    return Scaffold(
      body: Container(
        color: TColor.secondaryColor1,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeader(context, media, percentage),
              SizedBox(height: 20),
              _buildChartsSection(score, incorrectCount, percentage),
              SizedBox(height: 20),
              _buildTimeTaken(),
              SizedBox(height: 30),
              _buildIncorrectAnswersSection(),
              SizedBox(height: 30),
              Center(
                child: RoundButton(
                  title: 'Back to Home',
                  onPressed: () => Get.to(() => MainTabView()),
                ),
              ),
              SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context, Size media, double percentage) {
    return Container(
      height: media.height * 0.35,
      decoration: BoxDecoration(
        gradient: LinearGradient(colors: TColor.primaryG),
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(30),
          bottomRight: Radius.circular(30),
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
              fit: BoxFit.cover,
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
                  quizName,
                  style: TextStyle(
                    color: TColor.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 20),
                _buildScoreSection(percentage),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildScoreSection(double percentage) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          'Your Score',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: TColor.white),
        ),
        SizedBox(height: 10),
        Text(
          '$score / $totalQuestions',
          style: TextStyle(fontSize: 48, fontWeight: FontWeight.bold, color: TColor.white),
        ),
        SizedBox(height: 10),
        Container(
          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.2),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Text(
            '${percentage.toStringAsFixed(1)}%',
            style: TextStyle(fontSize: 20, color: Colors.white, fontWeight: FontWeight.bold),
          ),
        ),
      ],
    );
  }

  Widget _buildChartsSection(int correctCount, int incorrectCount, double accuracy) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 20),
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: TColor.primaryColor1,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        children: [
          Text(
            'Performance Summary',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: TColor.white),
          ),
          SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildPieChart(correctCount, incorrectCount),
              Column(
                children: [
                  _buildLegendItem('Correct', Colors.green, correctCount),
                  SizedBox(height: 10),
                  _buildLegendItem('Incorrect', TColor.gray, incorrectCount),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPieChart(int correctCount, int incorrectCount) {
    return SizedBox(
      height: 150,
      width: 150,
      child: PieChart(
        PieChartData(
          sections: [
            PieChartSectionData(
              color: Colors.green,
              value: correctCount.toDouble(),
              title: '',
              radius: 30,
            ),
            PieChartSectionData(
              color: TColor.gray,
              value: incorrectCount.toDouble(),
              title: '',
              radius: 30,
            ),
          ],
          sectionsSpace: 2,
          centerSpaceRadius: 40,
          startDegreeOffset: 270,
        ),
      ),
    );
  }

  Widget _buildLegendItem(String label, Color color, int count) {
    return Row(
      children: [
        Container(
          width: 16,
          height: 16,
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
          ),
        ),
        SizedBox(width: 8),
        Text('$label: $count', style: TextStyle(fontSize: 14, color: TColor.white)),
      ],
    );
  }

  Widget _buildTimeTaken() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 20),
      padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
      decoration: BoxDecoration(
        color: TColor.primaryColor1.withOpacity(0.7),
        borderRadius: BorderRadius.circular(15),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.timer, color: TColor.white),
          SizedBox(width: 10),
          Text(
            'Time Taken: ${Duration(seconds: timeTaken).toString().split('.').first}',
            style: TextStyle(fontSize: 16, color: TColor.white),
          ),
        ],
      ),
    );
  }

  Widget _buildIncorrectAnswersSection() {
    if (incorrectAnswers.isEmpty) {
      return Container(
        margin: EdgeInsets.symmetric(horizontal: 20),
        padding: EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: TColor.primaryColor1,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Center(
          child: Text(
            'Congratulations! You answered all questions correctly.',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: TColor.white),
            textAlign: TextAlign.center,
          ),
        ),
      );
    }

    return Container(
      margin: EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Questions to Review',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: TColor.white),
          ),
          SizedBox(height: 10),
          ...incorrectAnswers.map((answer) => _buildIncorrectAnswerItem(answer)),
        ],
      ),
    );
  }

  Widget _buildIncorrectAnswerItem(Map<String, dynamic> answer) {
    return Card(
      color: TColor.primaryColor1,
      margin: EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      elevation: 5,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              answer['question'],
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: TColor.white),
            ),
            SizedBox(height: 12),
            _buildAnswerRow('Your answer', answer['userAnswer'], const Color.fromARGB(255, 188, 77, 69)),
            SizedBox(height: 8),
            _buildAnswerRow('Correct answer', answer['correctAnswer'], const Color.fromARGB(255, 119, 201, 122)),
            SizedBox(height: 12),
            Text(
              'Explanation:',
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: TColor.white.withOpacity(0.7)),
            ),
            SizedBox(height: 4),
            Text(
              answer['explanation'],
              style: TextStyle(fontSize: 14, fontStyle: FontStyle.italic, color: TColor.white),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAnswerRow(String label, String answer, Color color) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '$label: ',
          style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: TColor.white.withOpacity(0.7)),
        ),
        Expanded(
          child: Text(
            answer,
            style: TextStyle(fontSize: 14, color: color),
          ),
        ),
      ],
    );
  }
}