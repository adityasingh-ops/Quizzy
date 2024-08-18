import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:http/http.dart' as http;
import 'package:quizzy/common/constants.dart';
import 'package:quizzy/hooks/hook-result.dart';
import 'package:quizzy/models/quiz-model.dart';

FetchHook useFetchAllQuizes() {
  final quizlist = useState<List<QuizModel>?>(null);
  final isLoading = useState<bool>(false);
  final error = useState<Exception?>(null);

  Future<void> fetchData() async{
    isLoading.value = true;
    try {
      Uri url = Uri.parse('$appBaseUrl/api/quizzes/');
      final response = await http.get(url);
      if (response.statusCode == 200) {
        quizlist.value = quizModelFromJson(response.body);
      } else {
        
      }
    } catch (e) {
      error.value = e as Exception;
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
      data: quizlist.value,
      isLoading: isLoading.value,
      error: error.value,
      refetch: refetch);
}
