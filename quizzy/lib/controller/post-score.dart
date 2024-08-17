import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:quizzy/common/constants.dart';
import 'package:http/http.dart' as http;

class postController {
  static Future<void> postQuizScore(String userId, String quizId, int score) async {
    try {
      Uri url = Uri.parse('$appBaseUrl/api/scores');
      print('Posting score to: $url');
      print('Payload: ${json.encode({
        'userId': userId,
        'quizId': quizId,
        'score': score,
      })}');
      
      final client = http.Client();
      try {
        final request = http.Request('POST', url);
        request.headers['Content-Type'] = 'application/json';
        request.body = json.encode({
          'userId': userId,
          'quizId': quizId,
          'score': score,
        });

        final streamedResponse = await client.send(request).timeout(Duration(seconds: 10));
        final response = await http.Response.fromStream(streamedResponse);

        print('Response status: ${response.statusCode}');
        print('Response headers: ${response.headers}');
        print('Response body: ${response.body}');

        if (response.statusCode == 201) {
          print('Score posted successfully');
        } else if (response.statusCode == 307) {
          final redirectPath = response.headers['location'];
          print('Received redirect to: $redirectPath');
          if (redirectPath != null) {
            // Construct the full redirect URL
            final redirectUrl = Uri.parse(url.origin + redirectPath);
            print('Full redirect URL: $redirectUrl');
            
            // Handle the redirect
            final redirectResponse = await client.post(
              redirectUrl,
              headers: {'Content-Type': 'application/json'},
              body: json.encode({
                'userId': userId,
                'quizId': quizId,
                'score': score,
              }),
            );
            print('Redirect response status: ${redirectResponse.statusCode}');
            print('Redirect response body: ${redirectResponse.body}');
            if (redirectResponse.statusCode == 201) {
              print('Score posted successfully after redirect');
            } else {
              throw HttpException('Failed to post quiz score after redirect. Status code: ${redirectResponse.statusCode}, Body: ${redirectResponse.body}');
            }
          } else {
            throw HttpException('Received 307 redirect without a Location header');
          }
        } else {
          throw HttpException('Failed to post quiz score. Status code: ${response.statusCode}, Body: ${response.body}');
        }
      } finally {
        client.close();
      }
    } on SocketException catch (e) {
      print('Network error: $e');
      throw Exception('Network error. Please check your internet connection.');
    } on TimeoutException catch (e) {
      print('Request timed out: $e');
      throw Exception('Request timed out. Please try again.');
    } on HttpException catch (e) {
      print('HTTP exception: $e');
      throw Exception('HTTP error: ${e.message}');
    } catch (e) {
      print('Unexpected error in postQuizScore: $e');
      throw Exception('An unexpected error occurred: $e');
    }
  }
}