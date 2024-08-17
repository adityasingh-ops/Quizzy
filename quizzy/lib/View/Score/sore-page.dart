import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:quizzy/hooks/fetch-specific-quiz.dart';
import 'package:quizzy/hooks/get-score.dart';
import 'package:quizzy/common/colo_extension.dart';
import 'package:intl/intl.dart';

class UserScoresPage extends HookWidget {
  final String userId;

  const UserScoresPage({Key? key, required this.userId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final scoresHook = useFetchUserScores("adityasingh");
    final selectedFilter = useState<String?>(null);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: TColor.primaryColor1,
        title: Center(
          child: Text(
            "My Quiz Scores",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 25,
              color: TColor.white,
            ),
          ),
        ),
      ),
      body: Container(
        color: TColor.primaryColor1,
        child: Column(
          children: [
            _buildFilterSection(selectedFilter),
            Expanded(
              child: scoresHook.isLoading
                  ? Center(child: CircularProgressIndicator(color: TColor.white))
                  : scoresHook.error != null
                      ? Center(child: Text('Error: ${scoresHook.error}', style: TextStyle(color: TColor.white)))
                      : ListView.builder(
                          itemCount: scoresHook.data.length,
                          itemBuilder: (context, index) {
                            final score = scoresHook.data[index];
                            return _QuizScoreCard(score: score);
                          },
                        ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFilterSection(ValueNotifier<String?> selectedFilter) {
    return Container(
      height: 50,
      margin: EdgeInsets.symmetric(vertical: 10),
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: [
          _buildFilterChip('All', null, selectedFilter),
          _buildFilterChip('Easy', 'Easy', selectedFilter),
          _buildFilterChip('Medium', 'Medium', selectedFilter),
          _buildFilterChip('Hard', 'Hard', selectedFilter),
        ],
      ),
    );
  }

  Widget _buildFilterChip(String label, String? value, ValueNotifier<String?> selectedFilter) {
    final isSelected = selectedFilter.value == value;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4),
      child: FilterChip(
        label: Text(label),
        selected: isSelected,
        onSelected: (bool selected) {
          selectedFilter.value = selected ? value : null;
        },
        backgroundColor: TColor.lightGray,
        selectedColor: TColor.primaryColor1.withOpacity(0.2),
        labelStyle: TextStyle(
          color: isSelected ? TColor.primaryColor1 : TColor.gray,
          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
        ),
      ),
    );
  }
}

class _QuizScoreCard extends HookWidget {
  final Map<String, dynamic> score;

  const _QuizScoreCard({Key? key, required this.score}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final quizHook = useFetchQuiz(score['quizId']);

    return Container(
      margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      height: 130,
      decoration: BoxDecoration(
        color: TColor.primaryColor1,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.white.withOpacity(0.7),
            spreadRadius: 1,
            blurRadius: 3,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(12),
              bottomLeft: Radius.circular(12),
            ),
            child: CachedNetworkImage(
              imageUrl: quizHook.data?.imageUrl ?? '',
              height: 130,
              width: 130,
              fit: BoxFit.cover,
              placeholder: (context, url) => Container(
                color: Colors.grey[300],
                child: Image.asset(
                  'assets/img/quiz.jpg',
                  fit: BoxFit.cover,
                ),
              ),
              errorWidget: (context, url, error) => Container(
                color: Colors.grey[300],
                child: Image.asset(
                  'assets/img/quiz.jpg',
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    quizHook.data?.name ?? 'Loading Quiz Name...',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: TColor.white,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: 4),
                  Text(
                    'Score: ${score['score']} / ${quizHook.data?.questionCount ?? '?'}',
                    style: TextStyle(fontSize: 16, color: TColor.white),
                  ),
                  SizedBox(height: 8),
                  if (quizHook.data != null)
                    LinearProgressIndicator(
                      value: score['score'] / quizHook.data!.questionCount,
                      backgroundColor: Colors.grey[300],
                      valueColor: AlwaysStoppedAnimation<Color>(_getColorForScore(score['score'] / quizHook.data!.questionCount)),
                    ),
                  SizedBox(height: 4),
                  Row(
                    children: [
                      if (quizHook.data != null)
                        Text(
                          '${((score['score'] / quizHook.data!.questionCount) * 100).toStringAsFixed(1)}%',
                          style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: TColor.white),
                        ),
                      Spacer(),
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: _getDifficultyColor(quizHook.data?.difficulty ?? ''),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          quizHook.data?.difficulty ?? '',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Color _getColorForScore(double scorePercentage) {
    if (scorePercentage > 0.7) return Colors.green;
    if (scorePercentage > 0.4) return Colors.orange;
    return Colors.red;
  }

  Color _getDifficultyColor(String difficulty) {
    switch (difficulty.toLowerCase()) {
      case 'easy':
        return Colors.green;
      case 'medium':
        return Colors.orange;
      case 'hard':
        return Colors.red;
      default:
        return TColor.gray;
    }
  }
}