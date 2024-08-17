import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:http/http.dart' as http;
import 'package:quizzy/common/constants.dart';
import 'package:quizzy/hooks/hook-result.dart';
import 'dart:convert';

FetchHook useFetchUserScores(String userId) {
  final scores = useState<List<dynamic>>([]);
  final isLoading = useState<bool>(false);
  final error = useState<Exception?>(null);

  Future<void> fetchScores() async {
    isLoading.value = true;
    try {
      Uri url = Uri.parse('$appBaseUrl/api/scores/user/$userId');
      final response = await http.get(url);
      if (response.statusCode == 200) {
        scores.value = json.decode(response.body);
      } else {
        throw Exception('Failed to load user scores');
      }
    } catch (e) {
      print(e);
      error.value = e is Exception ? e : Exception(e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  useEffect(() {
    fetchScores();
    return null;
  }, const []);

  void refetch() {
    isLoading.value = true;
    fetchScores();
  }

  return FetchHook(
    data: scores.value,
    isLoading: isLoading.value,
    error: error.value,
    refetch: refetch,
  );
}