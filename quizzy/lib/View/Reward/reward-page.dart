import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:get/get.dart';
import 'package:quizzy/common/colo_extension.dart';
import 'package:quizzy/common/round_button.dart';
import 'package:quizzy/hooks/get-score.dart';

class RewardPage extends HookWidget {

  const RewardPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: TColor.primaryColor1,
        child: SafeArea(
          child: Column(
            children: [
              _buildHeader(),
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                    color: TColor.secondaryColor1,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(30),
                      topRight: Radius.circular(30),
                    ),
                  ),
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        _buildPointsCard(),
                        _buildAvailableRewards(),
                        _buildRewardHistory(),
                        _buildTermsAndConditions(),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: EdgeInsets.all(20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
            icon: Icon(Icons.arrow_back, color: TColor.white),
            onPressed: () => Get.back(),
          ),
          Text(
            'Rewards',
            style: TextStyle(
              color: TColor.white,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          IconButton(
            icon: Icon(Icons.info_outline, color: TColor.white),
            onPressed: () {
              // Show info dialog
            },
          ),
        ],
      ),
    );
  }

  Widget _buildPointsCard() {
    final scoresHook = useFetchUserScores("adityasingh"); // Replace with actual user ID

    // Calculate total points
    final totalPoints = useMemoized(() {
      if (scoresHook.data != null) {
        int totalScore = scoresHook.data.fold(0, (sum, score) => sum + (score['score'] as int));
        return totalScore * 4;
      }
      return 0;
    }, [scoresHook.data]);
    return Container(
      margin: EdgeInsets.all(20),
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(colors: TColor.primaryG),
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
            'Your Points',
            style: TextStyle(
              color: TColor.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 10),
          Text(
            '$totalPoints',
            style: TextStyle(
              color: TColor.white,
              fontSize: 36,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 10),
          Text(
            'Keep quizzing to earn more!',
            style: TextStyle(
              color: TColor.white.withOpacity(0.8),
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAvailableRewards() {
    final scoresHook = useFetchUserScores("adityasingh"); // Replace with actual user ID

    // Calculate total points
    final totalPoints = useMemoized(() {
      if (scoresHook.data != null) {
        int totalScore = scoresHook.data.fold(0, (sum, score) => sum + (score['score'] as int));
        return totalScore * 4;
      }
      return 0;
    }, [scoresHook.data]);
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Available Rewards',
            style: TextStyle(
              color: TColor.white,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 10),
          _buildRewardItem('Free Quiz Attempt', 500, totalPoints),
          _buildRewardItem('Premium Theme', 1000, totalPoints),
          _buildRewardItem('Ad-Free Experience', 2000, totalPoints),
        ],
      ),
    );
  }

  Widget _buildRewardItem(String title, int requiredPoints, int currentPoints) {
    bool isUnlocked = currentPoints >= requiredPoints;
    return Container(
      margin: EdgeInsets.only(bottom: 10),
      padding: EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: TColor.primaryColor1.withOpacity(0.3),
        borderRadius: BorderRadius.circular(15),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(
                  color: TColor.white,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 5),
              Text(
                '$requiredPoints points',
                style: TextStyle(
                  color: TColor.white.withOpacity(0.7),
                  fontSize: 14,
                ),
              ),
            ],
          ),
          ElevatedButton(
            
            onPressed: isUnlocked ? () {} : null,
            child: Text(isUnlocked ? 'Redeem' : 'Locked',style: TextStyle(color: TColor.white),),
            style: ElevatedButton.styleFrom(
              backgroundColor: TColor.white,
              iconColor: isUnlocked ? TColor.secondaryColor2 : Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRewardHistory() {
    return Container(
      margin: EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Reward History',
            style: TextStyle(
              color: TColor.white,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 10),
          _buildHistoryItem('Free Quiz Attempt', '2023-08-15'),
          _buildHistoryItem('Premium Theme', '2023-07-30'),
        ],
      ),
    );
  }

  Widget _buildHistoryItem(String reward, String date) {
    return Container(
      margin: EdgeInsets.only(bottom: 10),
      padding: EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: TColor.primaryColor1.withOpacity(0.3),
        borderRadius: BorderRadius.circular(15),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            reward,
            style: TextStyle(
              color: TColor.white,
              fontSize: 16,
            ),
          ),
          Text(
            date,
            style: TextStyle(
              color: TColor.white.withOpacity(0.7),
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTermsAndConditions() {
    return Container(
      margin: EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Terms and Conditions',
            style: TextStyle(
              color: TColor.white,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 10),
          Text(
            '1. Points are earned by completing quizzes.\n'
            '2. Rewards are subject to availability.\n'
            '3. Points cannot be transferred or exchanged for cash.\n'
            '4. Quizzy reserves the right to modify or cancel rewards at any time.\n'
            '5. Abuse of the reward system may result in account suspension.',
            style: TextStyle(
              color: TColor.white.withOpacity(0.8),
              fontSize: 14,
            ),
          ),
          SizedBox(height: 20),
          Center(
            child: RoundButton(
              title: 'I Agree',
              onPressed: () {
                // Handle agreement action
              },
            ),
          ),
        ],
      ),
    );
  }
}