import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:http/http.dart' as http;
import 'package:quizzy/common/constants.dart';
import 'package:quizzy/hooks/hook-result.dart';
import 'package:quizzy/models/quiz-model.dart';
import 'dart:convert';

FetchHook useFetchQuiz(String quizId) {
  final quiz = useState<QuizModel?>(null);
  final isLoading = useState<bool>(false);
  final error = useState<Exception?>(null);

  Future<void> fetchData() async {
    isLoading.value = true;
    try {
      Uri url = Uri.parse('$appBaseUrl/api/quizzes/$quizId');
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        quiz.value = QuizModel.fromJson(jsonData);
      } else {
        throw Exception('Failed to load quiz');
      }
    } catch (e) {
      print(e);
      error.value = e is Exception ? e : Exception(e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  useEffect(() {
    fetchData();
    return null;
  }, const []);
  
  void refetch() {
    isLoading.value = true;
    fetchData();
  }

  return FetchHook(
      data: quiz.value,
      isLoading: isLoading.value,
      error: error.value,
      refetch: refetch);
}