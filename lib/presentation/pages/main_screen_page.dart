import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';

import '../../app/resources/app_colors.dart';
import '../../app/routes/app_router.gr.dart';

@RoutePage()
class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  MainScreenState createState() => MainScreenState();
}

class MainScreenState extends State<MainScreen> {
  int _currentIndex = 1; // Default to Home tab

  final List<_TabItem> _tabs = const [
    _TabItem(icon: Icons.person_outline_rounded, activeIcon: Icons.person_rounded, label: 'Profile'),
    _TabItem(icon: Icons.home_outlined, activeIcon: Icons.home_rounded, label: 'Home'),
    _TabItem(icon: Icons.leaderboard_outlined, activeIcon: Icons.leaderboard_rounded, label: 'Ranking'),
  ];

  final List<PageRouteInfo> _routes = [
    const ProfileRoute(),
    const HomeRoute(),
    const RankingRoute(),
  ];

  @override
  Widget build(BuildContext context) {
    final isWide = MediaQuery.of(context).size.width >= 700;

    return AutoTabsRouter(
      routes: _routes,
      builder: (context, child) {
        final tabsRouter = AutoTabsRouter.of(context);

        // Sync local index with tabs router
        if (_currentIndex != tabsRouter.activeIndex) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            setState(() {
              _currentIndex = tabsRouter.activeIndex;
            });
          });
        }

        if (isWide) {
          return _buildWideLayout(context, child, tabsRouter);
        } else {
          return _buildMobileLayout(context, child, tabsRouter);
        }
      },
    );
  }

  Widget _buildMobileLayout(
    BuildContext context,
    Widget child,
    TabsRouter tabsRouter,
  ) {
    return Scaffold(
      body: child,
      bottomNavigationBar: _buildBottomNavBar(tabsRouter),
    );
  }

  Widget _buildWideLayout(
    BuildContext context,
    Widget child,
    TabsRouter tabsRouter,
  ) {
    return Scaffold(
      body: Row(
        children: [
          // Side navigation rail for wide screens
          NavigationRail(
            selectedIndex: tabsRouter.activeIndex,
            onDestinationSelected: (index) {
              tabsRouter.setActiveIndex(index);
              setState(() => _currentIndex = index);
            },
            labelType: NavigationRailLabelType.all,
            backgroundColor: AppColors.white,
            selectedIconTheme: const IconThemeData(color: AppColors.primary),
            unselectedIconTheme: const IconThemeData(color: AppColors.grey500),
            selectedLabelTextStyle: const TextStyle(
              color: AppColors.primary,
              fontFamily: 'Metropolis',
              fontWeight: FontWeight.bold,
              fontSize: 12,
            ),
            unselectedLabelTextStyle: const TextStyle(
              color: AppColors.grey500,
              fontFamily: 'Metropolis',
              fontSize: 12,
            ),
            indicatorColor: AppColors.primary.withOpacity(0.12),
            destinations: _tabs
                .map(
                  (tab) => NavigationRailDestination(
                    icon: Icon(tab.icon),
                    selectedIcon: Icon(tab.activeIcon),
                    label: Text(tab.label),
                  ),
                )
                .toList(),
          ),
          const VerticalDivider(width: 1, thickness: 1, color: AppColors.lightGrey),
          Expanded(child: child),
        ],
      ),
    );
  }

  Widget _buildBottomNavBar(TabsRouter tabsRouter) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 16,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: List.generate(_tabs.length, (index) {
              final tab = _tabs[index];
              final isActive = tabsRouter.activeIndex == index;
              return _NavBarItem(
                icon: tab.icon,
                activeIcon: tab.activeIcon,
                label: tab.label,
                isActive: isActive,
                onTap: () {
                  tabsRouter.setActiveIndex(index);
                  setState(() => _currentIndex = index);
                },
              );
            }),
          ),
        ),
      ),
    );
  }
}

class _TabItem {
  final IconData icon;
  final IconData activeIcon;
  final String label;

  const _TabItem({
    required this.icon,
    required this.activeIcon,
    required this.label,
  });
}

class _NavBarItem extends StatelessWidget {
  final IconData icon;
  final IconData activeIcon;
  final String label;
  final bool isActive;
  final VoidCallback onTap;

  const _NavBarItem({
    required this.icon,
    required this.activeIcon,
    required this.label,
    required this.isActive,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 6),
        decoration: BoxDecoration(
          color: isActive ? AppColors.primary.withOpacity(0.1) : Colors.transparent,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            AnimatedSwitcher(
              duration: const Duration(milliseconds: 200),
              child: Icon(
                isActive ? activeIcon : icon,
                key: ValueKey(isActive),
                color: isActive ? AppColors.primary : AppColors.grey500,
                size: 24,
              ),
            ),
            const SizedBox(height: 3),
            Text(
              label,
              style: TextStyle(
                fontFamily: 'Metropolis',
                fontSize: 11,
                fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
                color: isActive ? AppColors.primary : AppColors.grey500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
