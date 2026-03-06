import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../app/resources/app_colors.dart';
import '../../../data/models/quiz/quiz_models.dart';
import '../../providers/quiz_provider.dart';
import '../../providers/user_session_provider.dart';

@RoutePage()
class QuizPage extends StatefulWidget {
  final QuizCategory category;

  const QuizPage({super.key, required this.category});

  @override
  State<QuizPage> createState() => _QuizPageState();
}

class _QuizPageState extends State<QuizPage>
    with SingleTickerProviderStateMixin {
  late AnimationController _countdownController;

  @override
  void initState() {
    super.initState();
    _countdownController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 700),
    );

    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<QuizProvider>().startQuiz(widget.category);
    });
  }

  @override
  void dispose() {
    _countdownController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        if (!didPop) {
          _showQuitDialog(context);
        }
      },
      child: Scaffold(
        backgroundColor: AppColors.background,
        body: Consumer<QuizProvider>(
          builder: (context, quiz, _) {
            return switch (quiz.status) {
              QuizStatus.loading => const _LoadingView(),
              QuizStatus.countdown => _CountdownView(value: quiz.countdownValue),
              QuizStatus.active => _QuizActiveView(quiz: quiz),
              QuizStatus.result => _ResultView(
                quiz: quiz,
                onDone: () {
                  // Update user score
                  context
                      .read<UserSessionProvider>()
                      .addScore(quiz.quizScore);
                  quiz.resetQuiz();
                  context.router.pop();
                },
              ),
              QuizStatus.error => _ErrorView(
                message: quiz.errorMessage,
                onRetry: () => quiz.startQuiz(widget.category),
                onBack: () {
                  quiz.resetQuiz();
                  context.router.pop();
                },
              ),
              _ => const SizedBox(),
            };
          },
        ),
      ),
    );
  }

  void _showQuitDialog(BuildContext context) {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            title: const Text(
              'Quit Quiz?',
              style: TextStyle(
                fontFamily: 'Metropolis',
                fontWeight: FontWeight.bold,
              ),
            ),
            content: const Text(
              'Your progress will be lost. Are you sure you want to exit?',
              style: TextStyle(fontFamily: 'Metropolis'),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Continue'),
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                  context.read<QuizProvider>().resetQuiz();
                  context.router.pop();
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.error,
                  foregroundColor: AppColors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text('Quit'),
              ),
            ],
          ),
    );
  }
}

class _LoadingView extends StatelessWidget {
  const _LoadingView();

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(color: AppColors.primary),
          SizedBox(height: 24),
          Text(
            'Loading Questions...',
            style: TextStyle(
              fontFamily: 'Metropolis',
              fontSize: 16,
              color: AppColors.textColor,
            ),
          ),
        ],
      ),
    );
  }
}

class _CountdownView extends StatelessWidget {
  final int value;

  const _CountdownView({required this.value});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [AppColors.primary, AppColors.primaryDark],
        ),
      ),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Get Ready!',
              style: TextStyle(
                fontFamily: 'Metropolis',
                fontSize: 24,
                fontWeight: FontWeight.w500,
                color: Colors.white70,
              ),
            ),
            const SizedBox(height: 40),
            AnimatedSwitcher(
              duration: const Duration(milliseconds: 350),
              transitionBuilder: (child, animation) => ScaleTransition(
                scale: animation,
                child: child,
              ),
              child: Text(
                value > 0 ? '$value' : 'GO!',
                key: ValueKey(value),
                style: TextStyle(
                  fontFamily: 'Metropolis',
                  fontSize: value > 0 ? 120 : 70,
                  fontWeight: FontWeight.bold,
                  color: AppColors.white,
                  shadows: [
                    Shadow(
                      color: Colors.black.withOpacity(0.3),
                      blurRadius: 20,
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 40),
            const Text(
              'Quiz is about to start!',
              style: TextStyle(
                fontFamily: 'Metropolis',
                fontSize: 16,
                color: Colors.white54,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _QuizActiveView extends StatelessWidget {
  final QuizProvider quiz;

  const _QuizActiveView({required this.quiz});

  @override
  Widget build(BuildContext context) {
    final question = quiz.currentQuestion;
    if (question == null) return const SizedBox();

    final isWide = MediaQuery.of(context).size.width >= 700;
    final totalQ = quiz.questions.length;
    final currentQ = quiz.currentQuestionIndex + 1;
    final progress = currentQ / totalQ;
    final timerProgress = quiz.timerSeconds / 60;
    final timerColor = quiz.timerSeconds > 30
        ? AppColors.success
        : quiz.timerSeconds > 10
            ? AppColors.warning
            : AppColors.error;

    return SafeArea(
      child: Column(
        children: [
          // Top bar with progress
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            decoration: const BoxDecoration(
              color: AppColors.white,
              boxShadow: [
                BoxShadow(
                  color: Color(0x0D000000),
                  blurRadius: 8,
                  offset: Offset(0, 2),
                ),
              ],
            ),
            child: Column(
              children: [
                Row(
                  children: [
                    GestureDetector(
                      onTap: () {
                        showDialog(
                          context: context,
                          builder: (ctx) => AlertDialog(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                            title: const Text(
                              'Quit Quiz?',
                              style: TextStyle(fontFamily: 'Metropolis', fontWeight: FontWeight.bold),
                            ),
                            content: const Text(
                              'Your progress will be lost.',
                              style: TextStyle(fontFamily: 'Metropolis'),
                            ),
                            actions: [
                              TextButton(
                                onPressed: () => Navigator.pop(ctx),
                                child: const Text('Continue'),
                              ),
                              ElevatedButton(
                                onPressed: () {
                                  Navigator.pop(ctx);
                                  quiz.resetQuiz();
                                  context.router.pop();
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: AppColors.error,
                                  foregroundColor: AppColors.white,
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                                ),
                                child: const Text('Quit'),
                              ),
                            ],
                          ),
                        );
                      },
                      child: const Icon(
                        Icons.close_rounded,
                        color: AppColors.grey500,
                        size: 22,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Question $currentQ/$totalQ',
                                style: const TextStyle(
                                  fontFamily: 'Metropolis',
                                  fontSize: 13,
                                  fontWeight: FontWeight.w600,
                                  color: AppColors.grey700,
                                ),
                              ),
                              Text(
                                '${(progress * 100).toInt()}%',
                                style: const TextStyle(
                                  fontFamily: 'Metropolis',
                                  fontSize: 13,
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.primary,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 6),
                          ClipRRect(
                            borderRadius: BorderRadius.circular(4),
                            child: LinearProgressIndicator(
                              value: progress,
                              backgroundColor: AppColors.grey300,
                              valueColor: const AlwaysStoppedAnimation(AppColors.primary),
                              minHeight: 6,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 12),
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: AppColors.primary.withOpacity(0.1),
                        shape: BoxShape.circle,
                      ),
                      child: Text(
                        '${quiz.quizScore}',
                        style: const TextStyle(
                          fontFamily: 'Metropolis',
                          fontWeight: FontWeight.bold,
                          color: AppColors.primary,
                          fontSize: 13,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          // Main question area
          Expanded(
            child: SingleChildScrollView(
              padding: EdgeInsets.symmetric(
                horizontal: isWide ? 80 : 20,
                vertical: 20,
              ),
              child: Center(
                child: ConstrainedBox(
                  constraints: BoxConstraints(
                    maxWidth: isWide ? 700 : double.infinity,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Category badge
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.primary.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          question.category.split(':').last.trim(),
                          style: const TextStyle(
                            fontFamily: 'Metropolis',
                            fontSize: 12,
                            color: AppColors.primary,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      // Question text
                      Text(
                        question.question,
                        style: TextStyle(
                          fontFamily: 'Metropolis',
                          fontSize: isWide ? 22 : 17,
                          fontWeight: FontWeight.bold,
                          color: AppColors.textColor,
                          height: 1.4,
                        ),
                      ),
                      const SizedBox(height: 32),
                      // Answer options
                      ...question.allAnswers.map((answer) {
                        return _AnswerOption(
                          answer: answer,
                          quiz: quiz,
                          correctAnswer: question.correctAnswer,
                        );
                      }),
                      // Feedback label
                      if (quiz.answerStatus != AnswerStatus.none) ...[
                        const SizedBox(height: 20),
                        Center(
                          child: AnimatedSwitcher(
                            duration: const Duration(milliseconds: 300),
                            child: _FeedbackLabel(
                              key: ValueKey(quiz.answerStatus),
                              status: quiz.answerStatus,
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              ),
            ),
          ),

          // Timer bar at bottom
          Container(
            padding: const EdgeInsets.fromLTRB(20, 12, 20, 20),
            decoration: const BoxDecoration(
              color: AppColors.white,
              boxShadow: [
                BoxShadow(
                  color: Color(0x0D000000),
                  blurRadius: 8,
                  offset: Offset(0, -2),
                ),
              ],
            ),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.timer_outlined,
                      color: timerColor,
                      size: 18,
                    ),
                    const SizedBox(width: 6),
                    Text(
                      '${quiz.timerSeconds}s',
                      style: TextStyle(
                        fontFamily: 'Metropolis',
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                        color: timerColor,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                ClipRRect(
                  borderRadius: BorderRadius.circular(6),
                  child: TweenAnimationBuilder<double>(
                    tween: Tween<double>(begin: timerProgress, end: timerProgress),
                    duration: const Duration(milliseconds: 500),
                    builder: (context, value, child) {
                      return LinearProgressIndicator(
                        value: timerProgress,
                        backgroundColor: AppColors.grey300,
                        valueColor: AlwaysStoppedAnimation<Color>(timerColor),
                        minHeight: 8,
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _AnswerOption extends StatelessWidget {
  final String answer;
  final QuizProvider quiz;
  final String correctAnswer;

  const _AnswerOption({
    required this.answer,
    required this.quiz,
    required this.correctAnswer,
  });

  @override
  Widget build(BuildContext context) {
    final isSelected = quiz.selectedAnswer == answer;
    final answered = quiz.answerStatus != AnswerStatus.none;
    final isCorrect = answer == correctAnswer;

    Color borderColor = AppColors.grey300;
    Color bgColor = AppColors.white;
    Color textColor = AppColors.textColor;
    Widget? trailingIcon;

    if (answered) {
      if (isCorrect) {
        borderColor = AppColors.success;
        bgColor = AppColors.success.withOpacity(0.08);
        textColor = AppColors.successDark;
        trailingIcon = const Icon(
          Icons.check_circle_rounded,
          color: AppColors.success,
          size: 22,
        );
      } else if (isSelected && !isCorrect) {
        borderColor = AppColors.error;
        bgColor = AppColors.error.withOpacity(0.08);
        textColor = AppColors.error;
        trailingIcon = const Icon(
          Icons.cancel_rounded,
          color: AppColors.error,
          size: 22,
        );
      }
    }

    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: borderColor,
            width: (answered && (isCorrect || isSelected)) ? 2 : 1.5,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.04),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            borderRadius: BorderRadius.circular(16),
            onTap: answered ? null : () => quiz.selectAnswer(answer),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      answer,
                      style: TextStyle(
                        fontFamily: 'Metropolis',
                        fontSize: 14,
                        fontWeight:
                            (answered && (isCorrect || isSelected))
                                ? FontWeight.bold
                                : FontWeight.w500,
                        color: textColor,
                        height: 1.3,
                      ),
                    ),
                  ),
                  if (trailingIcon != null) ...[
                    const SizedBox(width: 8),
                    trailingIcon,
                  ],
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _FeedbackLabel extends StatelessWidget {
  final AnswerStatus status;

  const _FeedbackLabel({super.key, required this.status});

  @override
  Widget build(BuildContext context) {
    final isCorrect = status == AnswerStatus.correct;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
      decoration: BoxDecoration(
        color: isCorrect
            ? AppColors.success.withOpacity(0.12)
            : AppColors.error.withOpacity(0.12),
        borderRadius: BorderRadius.circular(30),
        border: Border.all(
          color: isCorrect ? AppColors.success : AppColors.error,
          width: 1.5,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            isCorrect
                ? Icons.check_circle_outline_rounded
                : Icons.cancel_outlined,
            color: isCorrect ? AppColors.success : AppColors.error,
            size: 20,
          ),
          const SizedBox(width: 8),
          Text(
            isCorrect ? 'Correct! +10 pts' : 'Incorrect!',
            style: TextStyle(
              fontFamily: 'Metropolis',
              fontWeight: FontWeight.bold,
              fontSize: 15,
              color: isCorrect ? AppColors.successDark : AppColors.error,
            ),
          ),
        ],
      ),
    );
  }
}

class _ResultView extends StatelessWidget {
  final QuizProvider quiz;
  final VoidCallback onDone;

  const _ResultView({required this.quiz, required this.onDone});

  @override
  Widget build(BuildContext context) {
    final total = quiz.questions.length;
    final correct = quiz.correctAnswers;
    final score = quiz.quizScore;
    final percentage = total == 0 ? 0 : (correct / total * 100).round();

    final Color resultColor;
    final String resultEmoji;
    final String resultTitle;

    if (percentage >= 80) {
      resultColor = AppColors.success;
      resultEmoji = '🏆';
      resultTitle = 'Excellent!';
    } else if (percentage >= 50) {
      resultColor = AppColors.warning;
      resultEmoji = '👍';
      resultTitle = 'Good Job!';
    } else {
      resultColor = AppColors.error;
      resultEmoji = '😔';
      resultTitle = 'Keep Practicing!';
    }

    return SafeArea(
      child: Column(
        children: [
          // Header
          Container(
            width: double.infinity,
            padding: const EdgeInsets.fromLTRB(20, 24, 20, 36),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  resultColor,
                  resultColor.withOpacity(0.7),
                ],
              ),
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(32),
                bottomRight: Radius.circular(32),
              ),
            ),
            child: Column(
              children: [
                Text(resultEmoji, style: const TextStyle(fontSize: 60)),
                const SizedBox(height: 12),
                Text(
                  resultTitle,
                  style: const TextStyle(
                    fontFamily: 'Metropolis',
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: AppColors.white,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  quiz.activeCategory?.name ?? 'Quiz',
                  style: const TextStyle(
                    fontFamily: 'Metropolis',
                    fontSize: 15,
                    color: Colors.white70,
                  ),
                ),
              ],
            ),
          ),
          
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: Column(
                children: [
                  const SizedBox(height: 8),
                  // Stats grid
                  Row(
                    children: [
                      Expanded(
                        child: _ResultStat(
                          label: 'Score',
                          value: '$score pts',
                          icon: Icons.stars_rounded,
                          color: AppColors.primary,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _ResultStat(
                          label: 'Correct',
                          value: '$correct/$total',
                          icon: Icons.check_circle_outline_rounded,
                          color: AppColors.success,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                        child: _ResultStat(
                          label: 'Accuracy',
                          value: '$percentage%',
                          icon: Icons.track_changes_rounded,
                          color: resultColor,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _ResultStat(
                          label: 'Wrong',
                          value: '${total - correct}/$total',
                          icon: Icons.cancel_outlined,
                          color: AppColors.error,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 32),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: onDone,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        foregroundColor: AppColors.white,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        elevation: 0,
                      ),
                      child: const Text(
                        'Back to Home',
                        style: TextStyle(
                          fontFamily: 'Metropolis',
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ResultStat extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;
  final Color color;

  const _ResultStat({
    required this.label,
    required this.value,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: 28),
          const SizedBox(height: 8),
          Text(
            value,
            style: TextStyle(
              fontFamily: 'Metropolis',
              fontWeight: FontWeight.bold,
              fontSize: 20,
              color: color,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: const TextStyle(
              fontFamily: 'Metropolis',
              fontSize: 12,
              color: AppColors.grey500,
            ),
          ),
        ],
      ),
    );
  }
}

class _ErrorView extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;
  final VoidCallback onBack;

  const _ErrorView({
    required this.message,
    required this.onRetry,
    required this.onBack,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.wifi_off_rounded,
              size: 72,
              color: AppColors.grey300,
            ),
            const SizedBox(height: 20),
            const Text(
              'Failed to Load Questions',
              style: TextStyle(
                fontFamily: 'Metropolis',
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: AppColors.textColor,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              message,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontFamily: 'Metropolis',
                fontSize: 14,
                color: AppColors.grey500,
              ),
            ),
            const SizedBox(height: 32),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: onBack,
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                    ),
                    child: const Text(
                      'Go Back',
                      style: TextStyle(fontFamily: 'Metropolis'),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton(
                    onPressed: onRetry,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      foregroundColor: AppColors.white,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                      elevation: 0,
                    ),
                    child: const Text(
                      'Try Again',
                      style: TextStyle(
                        fontFamily: 'Metropolis',
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
