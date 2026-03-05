// dart format width=80
// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// AutoRouterGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:auto_route/auto_route.dart' as _i9;
import 'package:flutter/material.dart' as _i10;
import 'package:RoseAI/data/models/quiz/quiz_models.dart' as _i11;
import 'package:RoseAI/presentation/pages/home/home_page.dart' as _i1;
import 'package:RoseAI/presentation/pages/login_page.dart' as _i2;
import 'package:RoseAI/presentation/pages/main_screen_page.dart' as _i3;
import 'package:RoseAI/presentation/pages/profile/profile_page.dart' as _i4;
import 'package:RoseAI/presentation/pages/quiz/quiz_page.dart' as _i5;
import 'package:RoseAI/presentation/pages/ranking/ranking_page.dart' as _i6;
import 'package:RoseAI/presentation/pages/splash_page.dart' as _i7;
import 'package:RoseAI/presentation/pages/welcome_page.dart' as _i8;

/// generated route for
/// [_i1.HomePage]
class HomeRoute extends _i9.PageRouteInfo<void> {
  const HomeRoute({List<_i9.PageRouteInfo>? children})
    : super(HomeRoute.name, initialChildren: children);

  static const String name = 'HomeRoute';

  static _i9.PageInfo page = _i9.PageInfo(
    name,
    builder: (data) {
      return const _i1.HomePage();
    },
  );
}

/// generated route for
/// [_i2.LoginPage]
class LoginRoute extends _i9.PageRouteInfo<void> {
  const LoginRoute({List<_i9.PageRouteInfo>? children})
    : super(LoginRoute.name, initialChildren: children);

  static const String name = 'LoginRoute';

  static _i9.PageInfo page = _i9.PageInfo(
    name,
    builder: (data) {
      return const _i2.LoginPage();
    },
  );
}

/// generated route for
/// [_i3.MainScreen]
class MainRoute extends _i9.PageRouteInfo<void> {
  const MainRoute({List<_i9.PageRouteInfo>? children})
    : super(MainRoute.name, initialChildren: children);

  static const String name = 'MainRoute';

  static _i9.PageInfo page = _i9.PageInfo(
    name,
    builder: (data) {
      return const _i3.MainScreen();
    },
  );
}

/// generated route for
/// [_i4.ProfilePage]
class ProfileRoute extends _i9.PageRouteInfo<void> {
  const ProfileRoute({List<_i9.PageRouteInfo>? children})
    : super(ProfileRoute.name, initialChildren: children);

  static const String name = 'ProfileRoute';

  static _i9.PageInfo page = _i9.PageInfo(
    name,
    builder: (data) {
      return const _i4.ProfilePage();
    },
  );
}

/// generated route for
/// [_i5.QuizPage]
class QuizRoute extends _i9.PageRouteInfo<QuizRouteArgs> {
  QuizRoute({
    _i10.Key? key,
    required _i11.QuizCategory category,
    List<_i9.PageRouteInfo>? children,
  }) : super(
         QuizRoute.name,
         args: QuizRouteArgs(key: key, category: category),
         initialChildren: children,
       );

  static const String name = 'QuizRoute';

  static _i9.PageInfo page = _i9.PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<QuizRouteArgs>();
      return _i5.QuizPage(key: args.key, category: args.category);
    },
  );
}

class QuizRouteArgs {
  const QuizRouteArgs({this.key, required this.category});

  final _i10.Key? key;

  final _i11.QuizCategory category;

  @override
  String toString() {
    return 'QuizRouteArgs{key: $key, category: $category}';
  }
}

/// generated route for
/// [_i6.RankingPage]
class RankingRoute extends _i9.PageRouteInfo<void> {
  const RankingRoute({List<_i9.PageRouteInfo>? children})
    : super(RankingRoute.name, initialChildren: children);

  static const String name = 'RankingRoute';

  static _i9.PageInfo page = _i9.PageInfo(
    name,
    builder: (data) {
      return const _i6.RankingPage();
    },
  );
}

/// generated route for
/// [_i7.SplashPage]
class SplashRoute extends _i9.PageRouteInfo<void> {
  const SplashRoute({List<_i9.PageRouteInfo>? children})
    : super(SplashRoute.name, initialChildren: children);

  static const String name = 'SplashRoute';

  static _i9.PageInfo page = _i9.PageInfo(
    name,
    builder: (data) {
      return const _i7.SplashPage();
    },
  );
}

/// generated route for
/// [_i8.WelcomePage]
class WelcomeRoute extends _i9.PageRouteInfo<void> {
  const WelcomeRoute({List<_i9.PageRouteInfo>? children})
    : super(WelcomeRoute.name, initialChildren: children);

  static const String name = 'WelcomeRoute';

  static _i9.PageInfo page = _i9.PageInfo(
    name,
    builder: (data) {
      return const _i8.WelcomePage();
    },
  );
}
