import 'package:clean_architecture/core/network/network_info.dart';
import 'package:clean_architecture/core/util/input_converter.dart';
import 'package:clean_architecture/features/number_trivia/data/datasources/number_trivia_local_data_source.dart';
import 'package:clean_architecture/features/number_trivia/data/datasources/number_trivia_remote_data_source.dart';
import 'package:clean_architecture/features/number_trivia/data/repositories/number_trivia_repository_impl.dart';
import 'package:clean_architecture/features/number_trivia/domain/repositories/number_trivia_repository.dart';
import 'package:clean_architecture/features/number_trivia/domain/usecases/get_concrete_number_trivia.dart';
import 'package:clean_architecture/features/number_trivia/presentation/bloc/number_trivia_bloc.dart';
import 'package:data_connection_checker/data_connection_checker.dart';
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

import 'features/number_trivia/domain/usecases/get_random_number_trivia.dart';

final _getIt = GetIt.instance;

Future<void> init() async {
  //! Features - Number Trivia
  // Bloc
  _getIt.registerFactory(
    () => NumberTriviaBloc(
      concrete: _getIt(),
      random: _getIt(),
      inputConverter: _getIt(),
    ),
  );

  // Use cases
  _getIt.registerLazySingleton(() => GetConcreteNumberTrivia(_getIt()));
  _getIt.registerLazySingleton(() => GetRandomNumberTrivia(_getIt()));

  //Repository
  _getIt.registerLazySingleton<NumberTriviaRepository>(
    () => NumberTriviaRepositoryImpl(
      remoteDataSource: _getIt(),
      localDataSource: _getIt(),
      networkInfo: _getIt(),
    ),
  );

  // Data Sources
  _getIt.registerLazySingleton<NumberTriviaRemoteDataSource>(
    () => NumberTriviaRemoteDataSourceImpl(client: _getIt()),
  );

  _getIt.registerLazySingleton<NumberTriviaLocalDataSource>(
    () => NumberTriviaLocalDataSourceImpl(sharedPreferences: _getIt()),
  );

  //! Core
  _getIt.registerLazySingleton(() => InputConverter());
  _getIt.registerLazySingleton<NetworkInfo>(() => NetworkInfoImpl(_getIt()));

  //! External
  final sharedPreferences = await SharedPreferences.getInstance();
  _getIt.registerLazySingleton(() => sharedPreferences);
  _getIt.registerLazySingleton(() => http.Client);
  _getIt.registerLazySingleton(() => DataConnectionChecker());
}
