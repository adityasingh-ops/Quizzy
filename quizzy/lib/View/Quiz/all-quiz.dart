import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:get/get.dart';
import 'package:quizzy/View/Quiz/quiz-detail.dart';
import 'package:quizzy/common/colo_extension.dart';
import 'package:quizzy/hooks/fetch-quiz.dart';

class QuizTile extends HookWidget {
  const QuizTile({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final hookResult = useFetchAllQuizes();
    final quizzes = hookResult.data;
    final isLoading = hookResult.isLoading;
    final error = hookResult.error;

    final selectedFilter = useState<String?>(null);

    if (isLoading) {
      return Center(child: CircularProgressIndicator());
    }

    if (error != null) {
      return Center(child: Text('Error: $error'));
    }

    if (quizzes == null) {
      return Center(child: Text('No quiz data available'));
    }

    final filteredQuizzes = selectedFilter.value == null
        ? quizzes
        : quizzes.where((quiz) => quiz.difficulty.toLowerCase() == selectedFilter.value!.toLowerCase()).toList();

    return Scaffold(
      appBar: AppBar(
        backgroundColor: TColor.primaryColor1,
        title: Center(
          child: Text(
            "Quizzy",
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
              child: ListView.builder(
                itemCount: filteredQuizzes.length,
                itemBuilder: (context, index) {
                  final quizItem = filteredQuizzes[index];
                  return _buildQuizItem(context, quizItem);
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

  Widget _buildQuizItem(BuildContext context, dynamic quizItem) {
    return GestureDetector(
      onTap: () {
        Get.to(() => SpecificQuizDetail(quizId: quizItem.id));
      },
      child: Container(
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
                imageUrl: quizItem.imageUrl,
                height: 120,
                width: 120,
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
                      quizItem.name,
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
                      quizItem.description,
                      style: TextStyle(
                        fontSize: 14,
                        color: TColor.gray,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    SizedBox(height: 8),
                    Row(
                      children: [
                        Icon(Icons.question_answer, size: 16, color: TColor.white),
                        SizedBox(width: 4),
                        Text(
                          '${quizItem.questionCount} Questions',
                          style: TextStyle(
                            fontSize: 14,
                            color: TColor.white,
                          ),
                        ),
                        Spacer(),
                        Container(
                          padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: _getDifficultyColor(quizItem.difficulty),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            quizItem.difficulty,
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
      ),
    );
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