import 'package:get_it/get_it.dart';
import 'package:http/http.dart' as http;
import 'package:tdd_tutorial/features/authentication/data/datasources/authentication_remote_datasource.dart';
import 'package:tdd_tutorial/features/authentication/data/repositories/authentication_repository_impl.dart';
import 'package:tdd_tutorial/features/authentication/domain/repositories/authentication_repository.dart';
import 'package:tdd_tutorial/features/authentication/domain/usecases/create_user.dart';
import 'package:tdd_tutorial/features/authentication/domain/usecases/get_users.dart';
import 'package:tdd_tutorial/features/authentication/presentation/cubit/authentication_cubit.dart';

final sl = GetIt.instance;

Future<void> init() async {
  sl.registerFactory(
    () => AuthenticationCubit(
      createUser: sl(),
      getUsers: sl(),
    ),
  );
  sl.registerLazySingleton(() => CreateUser(sl()));
  sl.registerLazySingleton(() => GetUsers(sl()));
  sl.registerLazySingleton<AuthenticationRepository>(
      () => AuthenticationRepositoryImpl(sl()));
  sl.registerLazySingleton<AuthenticationRemoteDatasource>(
      () => AuthenticationRemoteDatasourceImpl(sl()));
  sl.registerLazySingleton(() => http.Client());
}
