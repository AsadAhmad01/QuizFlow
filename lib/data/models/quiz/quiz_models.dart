import 'dart:math';

class QuizCategory {
  final int id;
  final String name;
  final String icon;
  final String description;
  final int? score;
  final int totalQuestions;

  const QuizCategory({
    required this.id,
    required this.name,
    required this.icon,
    required this.description,
    this.score,
    this.totalQuestions = 10,
  });

  int get maxScore => totalQuestions * 10;

  double get progressPercent =>
      totalQuestions == 0 ? 0 : (score ?? 0) / maxScore;

  QuizCategory copyWith({int? score}) {
    return QuizCategory(
      id: id,
      name: name,
      icon: icon,
      description: description,
      score: score ?? this.score,
      totalQuestions: totalQuestions,
    );
  }
}

class TriviaQuestion {
  final String category;
  final String type;
  final String difficulty;
  final String question;
  final String correctAnswer;
  final List<String> incorrectAnswers;
  late final List<String> allAnswers;

  TriviaQuestion({
    required this.category,
    required this.type,
    required this.difficulty,
    required this.question,
    required this.correctAnswer,
    required this.incorrectAnswers,
  }) {
    final shuffled = [...incorrectAnswers, correctAnswer]..shuffle(Random());
    allAnswers = shuffled;
  }

  factory TriviaQuestion.fromJson(Map<String, dynamic> json) {
    return TriviaQuestion(
      category: json['category'] as String,
      type: json['type'] as String,
      difficulty: json['difficulty'] as String,
      question: _decodeHtml(json['question'] as String),
      correctAnswer: _decodeHtml(json['correct_answer'] as String),
      incorrectAnswers:
          (json['incorrect_answers'] as List)
              .map((e) => _decodeHtml(e as String))
              .toList(),
    );
  }

  static String _decodeHtml(String input) {
    return input
        .replaceAll('&amp;', '&')
        .replaceAll('&lt;', '<')
        .replaceAll('&gt;', '>')
        .replaceAll('&quot;', '"')
        .replaceAll('&#039;', "'")
        .replaceAll('&ldquo;', '"')
        .replaceAll('&rdquo;', '"')
        .replaceAll('&lsquo;', "'")
        .replaceAll('&rsquo;', "'")
        .replaceAll('&mdash;', '—')
        .replaceAll('&ndash;', '–')
        .replaceAll('&hellip;', '...')
        .replaceAll('&deg;', '°')
        .replaceAll('&eacute;', 'é')
        .replaceAll('&egrave;', 'è')
        .replaceAll('&agrave;', 'à')
        .replaceAll('&ocirc;', 'ô')
        .replaceAll('&uuml;', 'ü')
        .replaceAll('&ouml;', 'ö')
        .replaceAll('&auml;', 'ä')
        .replaceAll('&ntilde;', 'ñ')
        .replaceAll('&ccedil;', 'ç');
  }
}

class TriviaResponse {
  final int responseCode;
  final List<TriviaQuestion> results;

  TriviaResponse({required this.responseCode, required this.results});

  factory TriviaResponse.fromJson(Map<String, dynamic> json) {
    return TriviaResponse(
      responseCode: json['response_code'] as int,
      results:
          (json['results'] as List)
              .map((q) => TriviaQuestion.fromJson(q as Map<String, dynamic>))
              .toList(),
    );
  }
}

class RankedUser {
  final int rank;
  final String name;
  final String imageUrl;
  final int score;
  final String email;

  const RankedUser({
    required this.rank,
    required this.name,
    required this.imageUrl,
    required this.score,
    required this.email,
  });
}

class UserProfile {
  final String name;
  final String email;
  final String imageUrl;
  int rank;
  int score;

  UserProfile({
    required this.name,
    required this.email,
    required this.imageUrl,
    required this.rank,
    required this.score,
  });
}
