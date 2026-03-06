import 'package:auto_route/auto_route.dart';
import 'app_router.gr.dart';

@AutoRouterConfig(replaceInRouteName: 'Screen|Page,Route')
class AppRouter extends RootStackRouter {
  AppRouter();

  @override
  List<AutoRoute> get routes => [
    AutoRoute(page: SplashRoute.page, initial: true),
    AutoRoute(page: LoginRoute.page),
    AutoRoute(page: MainRoute.page, children: [
      AutoRoute(page: ProfileRoute.page),
      AutoRoute(page: HomeRoute.page, initial: true),
      AutoRoute(page: RankingRoute.page),
    ]),
    AutoRoute(page: QuizRoute.page),
  ];
}
