import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../app/resources/app_colors.dart';
import '../../../data/models/quiz/quiz_models.dart';
import '../../providers/user_session_provider.dart';

@RoutePage()
class RankingPage extends StatelessWidget {
  const RankingPage({super.key});

  static final List<RankedUser> _rankedUsers = [
    RankedUser(
      rank: 1,
      name: 'Sophie Williams',
      imageUrl: 'https://api.dicebear.com/7.x/avataaars/png?seed=sophie&backgroundColor=ffdfbf',
      score: 980,
      email: 'sophie@example.com',
    ),
    RankedUser(
      rank: 2,
      name: 'Marcus Chen',
      imageUrl: 'https://api.dicebear.com/7.x/avataaars/png?seed=marcus&backgroundColor=c0aede',
      score: 870,
      email: 'marcus@example.com',
    ),
    RankedUser(
      rank: 3,
      name: 'Alex Johnson',
      imageUrl: 'https://api.dicebear.com/7.x/avataaars/png?seed=quiz&backgroundColor=b6e3f4',
      score: 760,
      email: 'test@gmail.com',
    ),
    RankedUser(
      rank: 4,
      name: 'Priya Kapoor',
      imageUrl: 'https://api.dicebear.com/7.x/avataaars/png?seed=priya&backgroundColor=d1f4cc',
      score: 690,
      email: 'priya@example.com',
    ),
    RankedUser(
      rank: 5,
      name: 'James Carter',
      imageUrl: 'https://api.dicebear.com/7.x/avataaars/png?seed=james&backgroundColor=ffd5dc',
      score: 620,
      email: 'james@example.com',
    ),
    RankedUser(
      rank: 6,
      name: 'Luisa Mendez',
      imageUrl: 'https://api.dicebear.com/7.x/avataaars/png?seed=luisa&backgroundColor=ffdfbf',
      score: 550,
      email: 'luisa@example.com',
    ),
    RankedUser(
      rank: 7,
      name: 'Amir Hosseini',
      imageUrl: 'https://api.dicebear.com/7.x/avataaars/png?seed=amir&backgroundColor=c0aede',
      score: 480,
      email: 'amir@example.com',
    ),
    RankedUser(
      rank: 8,
      name: 'Yuki Tanaka',
      imageUrl: 'https://api.dicebear.com/7.x/avataaars/png?seed=yuki&backgroundColor=b6e3f4',
      score: 410,
      email: 'yuki@example.com',
    ),
    RankedUser(
      rank: 9,
      name: 'David Okafor',
      imageUrl: 'https://api.dicebear.com/7.x/avataaars/png?seed=david&backgroundColor=d1f4cc',
      score: 340,
      email: 'david@example.com',
    ),
    RankedUser(
      rank: 10,
      name: 'Elena Volkov',
      imageUrl: 'https://api.dicebear.com/7.x/avataaars/png?seed=elena&backgroundColor=ffd5dc',
      score: 270,
      email: 'elena@example.com',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final currentUser = context.watch<UserSessionProvider>().currentUser;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Container(
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
              padding: const EdgeInsets.fromLTRB(24, 32, 24, 32),
              child: const Column(
                children: [
                  Text(
                    'Leaderboard',
                    style: TextStyle(
                      fontFamily: 'Metropolis',
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: AppColors.white,
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    'Top quiz performers this month',
                    style: TextStyle(
                      fontFamily: 'Metropolis',
                      fontSize: 13,
                      color: Colors.white70,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 8),

            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                itemCount: _rankedUsers.length,
                itemBuilder: (context, index) {
                  final rankedUser = _rankedUsers[index];
                  final isCurrentUser =
                      rankedUser.email == currentUser?.email;

                  return _RankTile(
                    user: rankedUser,
                    isCurrentUser: isCurrentUser,
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _RankTile extends StatelessWidget {
  final RankedUser user;
  final bool isCurrentUser;

  const _RankTile({required this.user, required this.isCurrentUser});

  @override
  Widget build(BuildContext context) {
    final Color rankColor;
    if (user.rank == 1) {
      rankColor = const Color(0xFFFFD700);
    } else if (user.rank == 2) {
      rankColor = const Color(0xFFC0C0C0);
    } else if (user.rank == 3) {
      rankColor = const Color(0xFFCD7F32);
    } else {
      rankColor = AppColors.grey500;
    }

    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      margin: const EdgeInsets.symmetric(vertical: 5),
      decoration: BoxDecoration(
        color: isCurrentUser ? AppColors.primary.withOpacity(0.08) : AppColors.white,
        borderRadius: BorderRadius.circular(16),
        border: isCurrentUser
            ? Border.all(color: AppColors.primary, width: 2)
            : null,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        leading: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              width: 28,
              child: Text(
                user.rank <= 3 ? _rankEmoji(user.rank) : '#${user.rank}',
                style: TextStyle(
                  fontSize: user.rank <= 3 ? 20 : 14,
                  fontWeight: FontWeight.bold,
                  color: rankColor,
                ),
              ),
            ),
            const SizedBox(width: 8),
            CircleAvatar(
              radius: 24,
              backgroundImage: NetworkImage(user.imageUrl),
              backgroundColor: AppColors.primaryLight,
            ),
          ],
        ),
        title: Row(
          children: [
            Text(
              user.name,
              style: TextStyle(
                fontFamily: 'Metropolis',
                fontWeight: FontWeight.bold,
                fontSize: 14,
                color: isCurrentUser ? AppColors.primary : AppColors.textColor,
              ),
            ),
            if (isCurrentUser) ...[
              const SizedBox(width: 6),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color: AppColors.primary,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const Text(
                  'You',
                  style: TextStyle(
                    fontFamily: 'Metropolis',
                    fontSize: 10,
                    color: AppColors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ],
        ),
        trailing: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              '${user.score} pts',
              style: TextStyle(
                fontFamily: 'Metropolis',
                fontWeight: FontWeight.bold,
                fontSize: 15,
                color: isCurrentUser ? AppColors.primary : AppColors.textColor,
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _rankEmoji(int rank) {
    switch (rank) {
      case 1:
        return '🥇';
      case 2:
        return '🥈';
      case 3:
        return '🥉';
      default:
        return '#$rank';
    }
  }
}
