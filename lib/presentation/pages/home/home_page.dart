import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../app/resources/app_colors.dart';
import '../../../app/routes/app_router.dart';
import '../../../app/routes/app_router.gr.dart';
import '../../../data/models/quiz/quiz_models.dart';
import '../../providers/quiz_provider.dart';
import '../../providers/user_session_provider.dart';

@RoutePage()
class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final user = context.watch<UserSessionProvider>().currentUser;
    final quiz = context.watch<QuizProvider>();
    final isWide = MediaQuery.of(context).size.width >= 700;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(child: _buildHeader(context, user, isWide)),
            SliverPadding(
              padding: EdgeInsets.symmetric(
                horizontal: isWide ? 24 : 16,
                vertical: 16,
              ),
              sliver: SliverToBoxAdapter(
                child: Text(
                  'Select a Category',
                  style: TextStyle(
                    fontFamily: 'Metropolis',
                    fontSize: isWide ? 20 : 17,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textColor,
                  ),
                ),
              ),
            ),
            SliverPadding(
              padding: EdgeInsets.symmetric(horizontal: isWide ? 24 : 16),
              sliver: SliverGrid(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: isWide ? 3 : 2,
                  childAspectRatio: isWide ? 1.4 : 1.15,
                  crossAxisSpacing: 14,
                  mainAxisSpacing: 14,
                ),
                delegate: SliverChildBuilderDelegate((context, index) {
                  final category = quiz.categories[index];
                  return _CategoryCard(
                    category: category,
                    onTap: () {
                      context.router.push(QuizRoute(category: category));
                    },
                  );
                }, childCount: quiz.categories.length),
              ),
            ),
            const SliverToBoxAdapter(child: SizedBox(height: 32)),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(
    BuildContext context,
    UserProfile? user,
    bool isWide,
  ) {
    return Container(
      width: double.infinity,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [AppColors.primary, AppColors.primaryLight],
        ),
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(32),
          bottomRight: Radius.circular(32),
        ),
      ),
      padding: EdgeInsets.fromLTRB(
        isWide ? 32 : 20,
        isWide ? 32 : 28,
        isWide ? 32 : 20,
        isWide ? 32 : 28,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          CircleAvatar(
            radius: isWide ? 30 : 24,
            backgroundImage: NetworkImage(
              user?.imageUrl ??
                  'https://api.dicebear.com/7.x/avataaars/png?seed=quiz&backgroundColor=b6e3f4',
            ),
            backgroundColor: AppColors.primaryLight,
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Hello, ${(user?.name ?? 'Alex').split(' ').first} 👋',
                  style: TextStyle(
                    fontFamily: 'Metropolis',
                    fontSize: isWide ? 18 : 15,
                    color: Colors.white70,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  'Ready to quiz?',
                  style: TextStyle(
                    fontFamily: 'Metropolis',
                    fontWeight: FontWeight.bold,
                    fontSize: isWide ? 22 : 18,
                    color: AppColors.white,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              _HeaderBadge(
                icon: Icons.emoji_events_rounded,
                label: '#${user?.rank ?? 3}',
              ),
              const SizedBox(height: 6),
              _HeaderBadge(
                icon: Icons.stars_rounded,
                label: '${user?.score ?? 0} pts',
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _HeaderBadge extends StatelessWidget {
  final IconData icon;
  final String label;

  const _HeaderBadge({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.2),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: AppColors.white, size: 14),
          const SizedBox(width: 4),
          Text(
            label,
            style: const TextStyle(
              fontFamily: 'Metropolis',
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: AppColors.white,
            ),
          ),
        ],
      ),
    );
  }
}

class _CategoryCard extends StatelessWidget {
  final QuizCategory category;
  final VoidCallback onTap;

  const _CategoryCard({required this.category, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final hasProgress = (category.score ?? 0) > 0;
    final progress = category.progressPercent;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(20),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: AppColors.white,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.06),
                blurRadius: 14,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                category.icon,
                style: const TextStyle(fontSize: 28),
              ),
              const SizedBox(height: 6),
              Text(
                category.name,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontFamily: 'Metropolis',
                  fontWeight: FontWeight.bold,
                  fontSize: 13,
                  color: AppColors.textColor,
                ),
              ),
              const Spacer(),
              if (hasProgress) ...[
                Row(
                  children: [
                    Expanded(
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(4),
                        child: LinearProgressIndicator(
                          value: progress,
                          backgroundColor: AppColors.grey300,
                          valueColor: const AlwaysStoppedAnimation(
                            AppColors.primary,
                          ),
                          minHeight: 4,
                        ),
                      ),
                    ),
                    const SizedBox(width: 6),
                    Text(
                      '${(progress * 100).toInt()}%',
                      style: const TextStyle(
                        fontFamily: 'Metropolis',
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                        color: AppColors.primary,
                      ),
                    ),
                  ],
                ),
              ] else ...[
                Row(
                  children: [
                    const Icon(
                      Icons.play_circle_fill_rounded,
                      color: AppColors.primary,
                      size: 14,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      'Start Quiz',
                      style: const TextStyle(
                        fontFamily: 'Metropolis',
                        fontSize: 11,
                        color: AppColors.primary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
