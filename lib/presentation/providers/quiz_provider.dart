import 'dart:async';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

import '../../data/models/quiz/quiz_models.dart';

enum QuizStatus { idle, loading, countdown, active, result, error }

enum AnswerStatus { none, correct, incorrect }

class QuizProvider extends ChangeNotifier {
  final Dio _dio = Dio(
    BaseOptions(connectTimeout: const Duration(seconds: 10)),
  );

  // Categories list
  final List<QuizCategory> _categories = const [
    QuizCategory(id: 9, name: 'General Knowledge', icon: '🌍', description: 'Test your world knowledge'),
    QuizCategory(id: 17, name: 'Science & Nature', icon: '🔬', description: 'Biology, Physics, Chemistry'),
    QuizCategory(id: 19, name: 'Math', icon: '➕', description: 'Numbers and equations'),
    QuizCategory(id: 23, name: 'History', icon: '📜', description: 'Events through the ages'),
    QuizCategory(id: 22, name: 'Geography', icon: '🗺️', description: 'Cities, countries, capitals'),
    QuizCategory(id: 11, name: 'Movies', icon: '🎬', description: 'Cinema trivia and facts'),
    QuizCategory(id: 12, name: 'Music', icon: '🎵', description: 'Artists, albums, songs'),
    QuizCategory(id: 21, name: 'Sports', icon: '⚽', description: 'Scores, records, athletes'),
    QuizCategory(id: 18, name: 'Computers', icon: '💻', description: 'Tech and programming '),
    QuizCategory(id: 31, name: 'Anime & Manga', icon: '🎌', description: 'Japanese pop culture'),
  ];

  List<QuizCategory> _mutableCategories = [];

  QuizStatus _status = QuizStatus.idle;
  QuizStatus get status => _status;

  String _errorMessage = '';
  String get errorMessage => _errorMessage;

  List<TriviaQuestion> _questions = [];
  List<TriviaQuestion> get questions => _questions;

  int _currentQuestionIndex = 0;
  int get currentQuestionIndex => _currentQuestionIndex;

  TriviaQuestion? get currentQuestion =>
      _questions.isEmpty ? null : _questions[_currentQuestionIndex];

  int _countdownValue = 3;
  int get countdownValue => _countdownValue;

  int _timerSeconds = 60;
  int get timerSeconds => _timerSeconds;

  Timer? _countdownTimer;
  Timer? _questionTimer;

  AnswerStatus _answerStatus = AnswerStatus.none;
  AnswerStatus get answerStatus => _answerStatus;

  String? _selectedAnswer;
  String? get selectedAnswer => _selectedAnswer;

  int _quizScore = 0;
  int get quizScore => _quizScore;

  int _correctAnswers = 0;
  int get correctAnswers => _correctAnswers;

  QuizCategory? _activeCategory;
  QuizCategory? get activeCategory => _activeCategory;

  List<QuizCategory> get categories => _mutableCategories;

  QuizProvider() {
    _mutableCategories = List.from(_categories);
  }

  Future<void> startQuiz(QuizCategory category) async {
    _activeCategory = category;
    _status = QuizStatus.loading;
    _errorMessage = '';
    _questions = [];
    _currentQuestionIndex = 0;
    _quizScore = 0;
    _correctAnswers = 0;
    _selectedAnswer = null;
    _answerStatus = AnswerStatus.none;
    notifyListeners();

    try {
      final response = await _dio.get(
        'https://opentdb.com/api.php',
        queryParameters: {
          'amount': 10,
          'category': category.id,
          'type': 'multiple',
        },
      );

      final triviaResponse = TriviaResponse.fromJson(
        response.data as Map<String, dynamic>,
      );

      if (triviaResponse.responseCode != 0 || triviaResponse.results.isEmpty) {
        _status = QuizStatus.error;
        _errorMessage = 'Failed to load questions. Please try again.';
        notifyListeners();
        return;
      }

      _questions = triviaResponse.results;
      _startCountdown();
    } on DioException catch (e) {
      _status = QuizStatus.error;
      _errorMessage = 'Network error: ${e.message}';
      notifyListeners();
    } catch (e) {
      _status = QuizStatus.error;
      _errorMessage = 'Unexpected error: $e';
      notifyListeners();
    }
  }

  void _startCountdown() {
    _countdownValue = 3;
    _status = QuizStatus.countdown;
    notifyListeners();

    _countdownTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      _countdownValue--;
      notifyListeners();
      if (_countdownValue <= 0) {
        timer.cancel();
        _beginQuestion();
      }
    });
  }

  void _beginQuestion() {
    _status = QuizStatus.active;
    _timerSeconds = 60;
    _selectedAnswer = null;
    _answerStatus = AnswerStatus.none;
    notifyListeners();

    _questionTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      _timerSeconds--;
      notifyListeners();
      if (_timerSeconds <= 0) {
        timer.cancel();
        _handleTimeUp();
      }
    });
  }

  void _handleTimeUp() {
    _answerStatus = AnswerStatus.incorrect;
    _selectedAnswer = null;
    notifyListeners();
    Future.delayed(const Duration(seconds: 1), () {
      _goToNextQuestion();
    });
  }

  void selectAnswer(String answer) {
    if (_answerStatus != AnswerStatus.none) return;

    _questionTimer?.cancel();
    _selectedAnswer = answer;

    if (answer == currentQuestion?.correctAnswer) {
      _answerStatus = AnswerStatus.correct;
      _quizScore += 10;
      _correctAnswers++;
    } else {
      _answerStatus = AnswerStatus.incorrect;
    }

    notifyListeners();

    Future.delayed(const Duration(seconds: 1), () {
      _goToNextQuestion();
    });
  }

  void _goToNextQuestion() {
    if (_currentQuestionIndex < _questions.length - 1) {
      _currentQuestionIndex++;
      _beginQuestion();
    } else {
      _endQuiz();
    }
  }

  void _endQuiz() {
    _questionTimer?.cancel();
    _countdownTimer?.cancel();

    // Update category score
    final idx = _mutableCategories.indexWhere(
      (c) => c.id == _activeCategory?.id,
    );
    if (idx != -1) {
      _mutableCategories[idx] = _mutableCategories[idx].copyWith(
        score: _quizScore,
      );
    }

    _status = QuizStatus.result;
    notifyListeners();
  }

  void resetQuiz() {
    _questionTimer?.cancel();
    _countdownTimer?.cancel();
    _status = QuizStatus.idle;
    _questions = [];
    _currentQuestionIndex = 0;
    _quizScore = 0;
    _correctAnswers = 0;
    _selectedAnswer = null;
    _answerStatus = AnswerStatus.none;
    _activeCategory = null;
    notifyListeners();
  }

  @override
  void dispose() {
    _questionTimer?.cancel();
    _countdownTimer?.cancel();
    super.dispose();
  }
}
