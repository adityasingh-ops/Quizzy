import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:http/http.dart' as http;
import 'package:quizzy/common/constants.dart';
import 'dart:convert';

import 'package:quizzy/hooks/hook-result.dart';

FetchHook usePostQuizScore(String userId, String quizId, int score) {
  final isLoading = useState<bool>(false);
  final error = useState<Exception?>(null);
  final result = useState<Map<String, dynamic>?>(null);

  Future<void> postScore() async {
    isLoading.value = true;
    try {
      Uri url = Uri.parse('$appBaseUrl/api/scores');
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'userId': userId,
          'quizId': quizId,
          'score': score,
        }),
      );
      if (response.statusCode == 201) {
        result.value = json.decode(response.body);
      } else {
        throw Exception('Failed to post quiz score');
      }
    } catch (e) {
      print(e);
      error.value = e is Exception ? e : Exception(e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  useEffect(() {
    postScore();
    return null;
  }, const []);

  return FetchHook(
    data: result.value,
    isLoading: isLoading.value,
    error: error.value,
    refetch: postScore,
  );
}