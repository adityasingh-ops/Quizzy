import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:get/get.dart';
import 'package:quizzy/View/Quiz/quiz-result-screen.dart';
import 'dart:async';
import 'package:quizzy/common/colo_extension.dart';
import 'package:quizzy/controller/post-score.dart';
import 'package:quizzy/hooks/fetch-question.dart';
import 'package:quizzy/models/quiz-question-model.dart';

class QuizScreen extends HookWidget {
  final String quizId;
  final String quizName;

  const QuizScreen({Key? key, required this.quizId, required this.quizName}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final hookResult = useFetchQuizQuestions(quizId);
    final questions = hookResult.data;
    final isLoading = hookResult.isLoading;
    final error = hookResult.error;

    final currentQuestionIndex = useState(0);
    final selectedAnswer = useState<int?>(null);
    final timer = useState<int>(0);
    final timerController = useRef<Timer?>(null);
    final score = useState(0);
    final isTimerLow = useState(false);
    final incorrectAnswers = useState<List<Map<String, dynamic>>>([]);


    void startTimer() {
      timerController.value?.cancel();
      if (questions != null && questions.isNotEmpty) {
        timer.value = questions[currentQuestionIndex.value].timerDuration;
        isTimerLow.value = false;
        timerController.value = Timer.periodic(Duration(seconds: 1), (Timer t) {
          if (timer.value > 0) {
            timer.value--;
            if (timer.value <= 5) {
              isTimerLow.value = !isTimerLow.value; // Toggle for blinking effect
            }
          } else {
            t.cancel();
            WidgetsBinding.instance.addPostFrameCallback((_) {
              // moveToNextQuestion();
            });
          }
        });
      }
    }
        int calculateTotalTime(List<QuizQuestionModel> questions) {
      return questions.fold(0, (sum, question) => sum + question.timerDuration);
    }
    // Declare moveToNextQuestion before useEffect
    void moveToNextQuestion() {
      timerController.value?.cancel();
      if (questions != null && currentQuestionIndex.value < questions.length - 1) {
        final currentQuestion = questions[currentQuestionIndex.value];
        if (selectedAnswer.value != null && selectedAnswer.value != currentQuestion.correctAnswer) {
          incorrectAnswers.value.add({
            'question': currentQuestion.text,
            'userAnswer': currentQuestion.options[selectedAnswer.value!],
            'correctAnswer': currentQuestion.options[currentQuestion.correctAnswer],
            'explanation': currentQuestion.explanation,
          });
        }
        currentQuestionIndex.value++;
        selectedAnswer.value = null;
        startTimer();
      } else {
        // Add the last question if it's incorrect
        if (questions != null) {
          final currentQuestion = questions[currentQuestionIndex.value];
          if (selectedAnswer.value != null && selectedAnswer.value != currentQuestion.correctAnswer) {
            incorrectAnswers.value.add({
              'question': currentQuestion.text,
              'userAnswer': currentQuestion.options[selectedAnswer.value!],
              'correctAnswer': currentQuestion.options[currentQuestion.correctAnswer],
              'explanation': currentQuestion.explanation,
            });
          }
          postController.postQuizScore('adityasingh', quizId, score.value).then((value) {
            Get.off(() => QuizResultScreen(
            quizName: quizName,
            score: score.value,
            totalQuestions: questions.length,
            incorrectAnswers: incorrectAnswers.value,
            timeTaken: calculateTotalTime(questions),
          ));
          });
          // Quiz completed, navigate to results screen
          
        }
      }
    }



    useEffect(() {
      if (questions != null && questions.isNotEmpty) {
        startTimer();
      }
      return () {
        timerController.value?.cancel();
      };
    }, [questions]);

    void showProgressDialog() {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Quiz Progress'),
            content: Text('Questions completed: ${currentQuestionIndex.value + 1}\nQuestions remaining: ${(questions?.length ?? 0) - (currentQuestionIndex.value + 1)}'),
            actions: <Widget>[
              TextButton(
                child: Text('Close'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
    }

    if (isLoading) {
      return Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    if (error != null) {
      return Scaffold(body: Center(child: Text('Error: ${error.toString()}')));
    }

    if (questions == null || questions.isEmpty) {
      return Scaffold(body: Center(child: Text('No questions available')));
    }

    final currentQuestion = questions[currentQuestionIndex.value];

    return Scaffold(
      appBar: AppBar(
        title: Text('Quiz: $quizName',style:TextStyle(color: TColor.white, fontWeight: FontWeight.bold),),
        backgroundColor: TColor.primaryColor1,
        actions: [
          IconButton(
            icon: Icon(Icons.info_outline),
            onPressed: showProgressDialog,
          ),
        ],
      ),
      body: SafeArea(
        child: GestureDetector(
          child: Container(
            color: TColor.primaryColor1,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  LinearProgressIndicator(
                    value: (currentQuestionIndex.value + 1) / questions.length,
                    backgroundColor: Colors.grey[300],
                    valueColor: AlwaysStoppedAnimation<Color>(TColor.primaryColor2),
                  ),
                  SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Question ${currentQuestionIndex.value + 1} of ${questions.length}',
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: TColor.white),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(height: 10),
                  AnimatedContainer(
                    duration: Duration(milliseconds: 300),
                    padding: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                    decoration: BoxDecoration(
                      color: timer.value <= 5 ? (isTimerLow.value ? Colors.red.withOpacity(0.1) : Colors.transparent) : Colors.transparent,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Container(
                      padding: EdgeInsets.all(5),
                    decoration: BoxDecoration(
                   color: TColor.secondaryColor1,
                   borderRadius: BorderRadius.circular(30)
                      ),
                      child: Text(
                        ' ⏰    ${timer.value}s ',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: timer.value <= 5 ? Colors.red : Colors.white,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                    ],
                  ),
                  
                  SizedBox(height: 20),
                  Card(
                    shadowColor: TColor.white,
                    color: TColor.primaryColor1,
                    elevation: 4,
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Text(
                        currentQuestion.text,
                        style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: TColor.white),
                      ),
                    ),
                  ),
                  SizedBox(height: 20),
                  Expanded(
                    child: ListView.builder(
                      itemCount: currentQuestion.options.length,
                      itemBuilder: (context, index) {
                        final option = currentQuestion.options[index];
                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8.0),
                          child: AnimatedContainer(
                            duration: Duration(milliseconds: 300),
                            child: ElevatedButton(
                              onPressed: () {
                                selectedAnswer.value = index;
                                if (index == currentQuestion.correctAnswer) {
                                  score.value++;
                                }
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: selectedAnswer.value == index ? TColor.secondaryColor1 : Colors.white,
                                foregroundColor: selectedAnswer.value == index ? Colors.white : TColor.secondaryColor1,
                                elevation: selectedAnswer.value == index ? 8 : 2,
                                padding: EdgeInsets.symmetric(vertical: 16, horizontal: 24),
                                shadowColor: TColor.white,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(30),
                                  side: BorderSide(color: TColor.primaryColor1),
                                ),
                              ),
                              child: Text(option, style: TextStyle(fontSize: 16)),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: selectedAnswer.value != null ? moveToNextQuestion : null,
                    child: Text(currentQuestionIndex.value < questions.length - 1 ? 'Next Question' : 'Finish Quiz'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: TColor.secondaryColor1,
                      foregroundColor: Colors.white,
                      shadowColor: TColor.white,
                      padding: EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                      disabledBackgroundColor: Colors.grey,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}