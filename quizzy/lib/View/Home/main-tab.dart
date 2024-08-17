import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/get_navigation.dart';
import 'package:quizzy/View/Home/main-screen.dart';
import 'package:quizzy/View/Quiz/all-quiz.dart';
import 'package:quizzy/View/Reward/reward-page.dart';
import 'package:quizzy/View/Score/sore-page.dart';
import 'package:quizzy/common/colo_extension.dart';
import 'package:quizzy/common/tab_button.dart';

class MainTabView extends StatefulWidget {
  const MainTabView({super.key});

  @override
  State<MainTabView> createState() => _MainTabViewState();
}

class _MainTabViewState extends State<MainTabView> {
  int selectedTab = 0;
  Widget currentTab = const MainScreen();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: TColor.darkBackground,
      body: PageStorage(bucket: PageStorageBucket(), child: currentTab),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButtonAnimator: FloatingActionButtonAnimator.scaling,
      floatingActionButton: SizedBox(
        width: 70,
        height: 70,
        child: InkWell(
          onTap: () {
            Get.to(() => RewardPage());
          },
          child: Container(
            width: 65,
            height: 65,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  TColor.primaryColor1,
                  TColor.primaryColor2,
                ],
              ),
              borderRadius: BorderRadius.circular(35),
              boxShadow: const [
                BoxShadow(
                  color: Colors.black12,
                  blurRadius: 2,
                )
              ],
            ),
            child: Icon(Icons.quiz_sharp, color: TColor.white, size: 40,),
          ),
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        color: TColor.primaryColor1,
        child: Container(
          decoration: BoxDecoration(
            // Changed from black to darkSurface
            color: TColor.secondaryColor1,
            boxShadow: const [
              BoxShadow(color: Colors.black12, blurRadius: 2, offset: Offset(0, -2)),
            ],
            borderRadius: BorderRadius.circular(10)
          ),
          height: kToolbarHeight,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              TabButton(
                icon: Icons.dashboard_outlined,
                selectIcon: Icons.dashboard,
                isActive: selectedTab == 0,
                onTap: () {
                  setState(() {
                    selectedTab = 0;
                    currentTab = const MainScreen();
                  });
                },
              ),
              TabButton(
                icon: Icons.local_activity_outlined,
                selectIcon: Icons.local_activity,
                isActive: selectedTab == 1,
                onTap: () {
                  setState(() {
                    selectedTab = 1;
                    currentTab =  const QuizTile();
                  });
                },
              ),
              const SizedBox(width: 40),
              TabButton(
                icon: Icons.score_outlined,
                selectIcon: Icons.score,
                isActive: selectedTab == 2,
                onTap: () {
                  setState(() {
                    selectedTab = 2;
                    currentTab = const UserScoresPage(userId:"adityasingh");
                  });
                },
              ),
              TabButton(
                icon: Icons.person,
                selectIcon:Icons.person,
                isActive: selectedTab == 3,
                onTap: () {
                  setState(() {
                    selectedTab = 3;
                    currentTab = const MainScreen();
                  });
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}