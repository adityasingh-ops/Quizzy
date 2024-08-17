import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:http/http.dart' as http;
import 'package:quizzy/common/constants.dart';
import 'package:quizzy/hooks/hook-result.dart';
import 'package:quizzy/models/quiz-question-model.dart';

FetchHook useFetchQuizQuestions(String quizId) {
  final questions = useState<List<QuizQuestionModel>?>(null);
  final isLoading = useState<bool>(false);
  final error = useState<Exception?>(null);

  Future<void> fetchData() async {
    isLoading.value = true;
    try {
      print("sdfonwondtoifnsfoizdgnoiewmrosgdnop"+quizId);
      Uri url = Uri.parse('$appBaseUrl/api/questions/quiz/$quizId');
      final response = await http.get(url);
      if (response.statusCode == 200) {
        questions.value = quizQuestionModelFromJson(response.body);
      } else {
        throw Exception('Failed to load quiz questions');
      }
    } catch (e) {
      print(e);
      error.value = e as Exception;
    } finally {
      isLoading.value = false;
    }
  }

  useEffect(() {
    fetchData();
    return null;
  }, const []);

  return FetchHook(
    data: questions.value,
    isLoading: isLoading.value,
    error: error.value,
    refetch: fetchData,
  );
}