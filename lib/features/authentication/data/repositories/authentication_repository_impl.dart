import 'package:dartz/dartz.dart';
import 'package:tdd_tutorial/core/errors/exceptions.dart';
import 'package:tdd_tutorial/core/errors/failure.dart';
import 'package:tdd_tutorial/core/utils/typedef.dart';
import 'package:tdd_tutorial/features/authentication/data/datasources/authentication_remote_datasource.dart';
import 'package:tdd_tutorial/features/authentication/domain/entities/user.dart';
import 'package:tdd_tutorial/features/authentication/domain/repositories/authentication_repository.dart';

class AuthenticationRepositoryImpl implements AuthenticationRepository {
  final AuthenticationRemoteDatasource remoteDatasource;

  AuthenticationRepositoryImpl(this.remoteDatasource);

  @override
  ResultVoid createUser({
    required String name,
    required String avatar,
    required String createdAt,
  }) async {
    try {
      await remoteDatasource.createUser(
        name: name,
        avatar: avatar,
        createdAt: createdAt,
      );

      return const Right(null);
    } on ApiException catch (e) {
      return Left(ApiFailure.fromException(e));
    }
  }

  @override
  ResultFuture<List<User>> getUsers() async {
    try {
      final users = await remoteDatasource.getUsers();

      return Right(users);
    } on ApiException catch (e) {
      return Left(ApiFailure.fromException(e));
    }
  }
}
