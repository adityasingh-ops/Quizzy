import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/get_navigation.dart';
import 'package:quizzy/View/Quiz/quiz-grid.dart';
import 'package:quizzy/View/Score/sore-page.dart';
import 'package:quizzy/common/colo_extension.dart';
import 'package:quizzy/common/round_button.dart';
import 'package:quizzy/hooks/get-score.dart';

class MainScreen extends HookWidget {
  const MainScreen({super.key});

  @override
  Widget build(BuildContext context) {
    var media = MediaQuery.of(context).size;
    final scoresHook = useFetchUserScores("adityasingh"); // Replace with actual user ID

    // Calculate total points
    final totalPointsAndAverage = useMemoized(() {
      if (scoresHook.data != null && scoresHook.data.isNotEmpty) {
        int totalScore = scoresHook.data.fold(0, (sum, score) => sum + (score['score'] as int));
        int totalQuizzes = scoresHook.data.length;
        double average = totalScore / totalQuizzes;
        return {
          'totalPoints': totalScore * 4,
          'averageScore': average,
          'totalQuizzes': totalQuizzes,
        };
      }
      return {'totalPoints': 0, 'averageScore': 0.0, 'totalQuizzes': 0};
    }, [scoresHook.data]);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: TColor.primaryColor1,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children:  [
            Icon(Icons.menu,color: TColor.white,),
            Text(
              "Quizzy",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 25,
                color: TColor.white
              ),
            ),
            Icon(Icons.notification_add_rounded,color: TColor.white, )
          ],
        ),
      ),
      body: Container(
        color: TColor.primaryColor1,
        child: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(
              child: Container(
                height: media.width * 0.38,
                decoration: BoxDecoration(
                  gradient: LinearGradient(colors: TColor.primaryG),
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(media.width * 0.060),
                    bottomRight: Radius.circular(media.width * 0.060),
                  ),
                ),
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    Image.asset(
                      "assets/img/bg_dots.png",
                      height: media.width * 0.4,
                      width: double.maxFinite,
                      fit: BoxFit.fitHeight,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 25, horizontal: 25),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Average Quiz Score",
                                style: TextStyle(
                                  color: TColor.white,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                              Text(
                                "Total Quizzes: ${totalPointsAndAverage['totalQuizzes']}",
                                style: TextStyle(
                                  color: TColor.white.withOpacity(0.7),
                                  fontSize: 12,
                                ),
                              ),
                              SizedBox(height: media.width * 0.05),
                              SizedBox(
                                width: 120,
                                height: 35,
                                child: RoundButton(
                                  title: "View More",
                                  type: RoundButtonType.bgSGradient,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w400,
                                  onPressed: () {
                                    Get.to(() => UserScoresPage(userId:"adityasingh"));
                                  },
                                ),
                              )
                            ],
                          ),
                          SizedBox(
                            width: media.width * 0.3,
                            height: media.width * 0.3,
                            child: PieChart(
                              PieChartData(
                                pieTouchData: PieTouchData(
                                  touchCallback: (FlTouchEvent event, pieTouchResponse) {},
                                ),
                                startDegreeOffset: 250,
                                borderData: FlBorderData(show: false),
                                sectionsSpace: 1,
                                centerSpaceRadius: 0,
                                sections: showingSections((totalPointsAndAverage['averageScore'] as double)*10),
                              ),
                            ),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ),
            SliverToBoxAdapter(
              child: SizedBox(height: media.width * 0.05),
            ),
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Trending Quizzes",
                      style: TextStyle(fontSize: 23, fontWeight: FontWeight.bold, color: TColor.white),
                    ),
                    TextButton(
                      onPressed: () {
                        // TODO: Implement view all functionality
                      },
                      child: Text(
                        "View All",
                        style: TextStyle(color: TColor.primaryColor1),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SliverToBoxAdapter(
              child: QuizGridView(),
            ),
            SliverToBoxAdapter(
              child: SizedBox(height: media.width * 0.05),
            ),
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.only(left: 20),
                child: Text("Your Rewards", style: TextStyle(fontSize: 23, fontWeight: FontWeight.bold,color: TColor.white)),
              ),
            ),
            SliverToBoxAdapter(
              child: SizedBox(height: media.width * 0.05),
            ),
            SliverToBoxAdapter(
              child: _buildRewardSystem(context,totalPointsAndAverage['totalPoints'] as int),
            ),
            SliverToBoxAdapter(
              child: SizedBox(height: media.width * 0.05),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRewardSystem(BuildContext context, int totalPoints) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      decoration: BoxDecoration(
        gradient: LinearGradient(colors: TColor.primaryG),
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(color: TColor.white)
        ]
      ),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Your Points",
                      style: TextStyle(
                        color: TColor.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 5),
                    Text(
                      "$totalPoints pts",
                      style: TextStyle(
                        color: TColor.white,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                Icon(
                  Icons.star,
                  color: TColor.white,
                  size: 40,
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: TColor.primaryColor1,
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(15),
                bottomRight: Radius.circular(15),
              ),
              boxShadow:[
                BoxShadow(color: Colors.white)
              ]
            ),
            child: Column(
              children: [
                _buildRewardItem("Free Quiz Attempt", 500, totalPoints),
                SizedBox(height: 10),
                _buildRewardItem("Premium Theme", 1000, totalPoints),
                SizedBox(height: 10),
                _buildRewardItem("Ad-Free Experience", 2000, totalPoints),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRewardItem(String title, int requiredPoints, int currentPoints) {
  bool isUnlocked = currentPoints >= requiredPoints;
  return Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: [
      Row(
        children: [
          Icon(
            isUnlocked ? Icons.lock_open : Icons.lock,
            // Changed from white/primaryColor2 to primaryColor2/gray
            color: isUnlocked ? Colors.white : TColor.darkText,
          ),
          SizedBox(width: 10),
          Text(
            title,
            style: TextStyle(
              // Changed from black/gray to white/darkTextSecondary
              color: isUnlocked ? TColor.white : TColor.darkTextSecondary,
              fontWeight: isUnlocked ? FontWeight.bold : FontWeight.normal,
            ),
          ),
        ],
      ),
      Text(
        "$requiredPoints pts",
        style: TextStyle(
          // Changed from primaryColor1/gray to primaryColor2/darkTextSecondary
          color: isUnlocked ? TColor.white : TColor.darkTextSecondary,
          fontWeight: FontWeight.bold,
        ),
      ),
    ],
  );
}
   List<PieChartSectionData> showingSections(double average) {
    return List.generate(
      2,
      (i) {
        var color0 = TColor.secondaryColor1;

        switch (i) {
          case 0:
            return PieChartSectionData(
              color: color0,
              value: average,
              title: '',
              radius: 55,
              titlePositionPercentageOffset: 0.55,
              badgeWidget: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    '${average.toStringAsFixed(1)}',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    'avg',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            );
          case 1:
            return PieChartSectionData(
              color: Colors.white.withOpacity(0.3),
              value: (100 - average), // Assuming max score is 10
              title: '',
              radius: 45,
              titlePositionPercentageOffset: 0.55,
            );
          default:
            throw Error();
        }
      },
    );
  }
}