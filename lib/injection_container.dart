import 'package:RoseAI/domain/usecase/parse_health_data_usecase.dart';
import 'package:RoseAI/presentation/bloc/auth_bloc.dart';
import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';

import 'app/utils/shared_prefs_helper.dart';
import 'data/datasources/auth_remote_data_source.dart';
import 'data/repository/auth_repository_impl.dart';
import 'domain/repository/auth_repository.dart';
import 'domain/usecase/LoginUser_usecase.dart';

final sl = GetIt.instance;

Future<void> init() async {
  // Core - using a placeholder base URL since auth is handled locally
  final dio = Dio(
    BaseOptions(
      baseUrl: 'https://api.example.com',
      headers: {'Content-Type': 'application/json'},
      validateStatus: (status) => status != null && status < 500,
      connectTimeout: const Duration(seconds: 60),
      receiveTimeout: const Duration(seconds: 60),
      sendTimeout: const Duration(seconds: 60),
    ),
  );

  // Add interceptor to add token dynamically
  dio.interceptors.add(
    InterceptorsWrapper(
      onRequest: (options, handler) {
        final token = SharedPrefsHelper.getToken();
        if (token != null && token.isNotEmpty) {
          options.headers['Authorization'] = 'Bearer $token';
        } else {
          options.headers.remove('Authorization');
        }
        handler.next(options); // continue
      },
    ),
  );

  sl.registerLazySingleton(() => dio);

  // Data Source
  sl.registerLazySingleton<AuthRemoteDataSource>(
    () => AuthRemoteDataSourceImpl(sl()),
  );

  // Repository
  sl.registerLazySingleton<AuthRepository>(() => AuthRepositoryImpl(sl()));

  // Use Cases
  sl.registerLazySingleton(() => LoginUser(sl()));
  sl.registerLazySingleton(() => ParseHealthDataUseCase(sl()));

  // Bloc
  sl.registerFactory(() => AuthBloc(loginUser: sl()));
}
