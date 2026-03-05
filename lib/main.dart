import 'package:RoseAI/data/models/quiz/quiz_models.dart';
import 'package:RoseAI/domain/usecase/LoginUser_usecase.dart';
import 'package:RoseAI/domain/usecase/parse_health_data_usecase.dart';
import 'package:RoseAI/injection_container.dart';
import 'package:RoseAI/presentation/providers/quiz_provider.dart';
import 'package:RoseAI/presentation/providers/user_session_provider.dart';
import 'package:RoseAI/presentation/viewModels/AuthViewModel.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import 'app/routes/app_router.dart';

final _appRouter = AppRouter();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await EasyLocalization.ensureInitialized();

  await init();

  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
    DeviceOrientation.landscapeLeft,
    DeviceOrientation.landscapeRight,
  ]);

  runApp(
    EasyLocalization(
      supportedLocales: const [Locale('en'), Locale('es')],
      path: 'assets/lang',
      fallbackLocale: const Locale('en'),
      child: MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (_) => UserSessionProvider()),
          ChangeNotifierProvider(create: (_) => QuizProvider()),
          ChangeNotifierProvider(
            create: (_) => AuthViewModel(
              loginUser: sl<LoginUser>(),
              parseHealthData: sl<ParseHealthDataUseCase>(),
            ),
          ),
        ],
        child: const MyApp(),
      ),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'QuizFlow',
      debugShowCheckedModeBanner: false,
      locale: context.locale,
      supportedLocales: context.supportedLocales,
      localizationsDelegates: context.localizationDelegates,
      theme: ThemeData(
        fontFamily: 'Metropolis',
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xff058487),
          brightness: Brightness.light,
        ),
        useMaterial3: true,
      ),
      routerConfig: _appRouter.config(),
    );
  }
}
