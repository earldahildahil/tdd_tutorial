import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:tdd_tutorial/core/errors/exceptions.dart';
import 'package:tdd_tutorial/core/errors/failure.dart';
import 'package:tdd_tutorial/features/authentication/data/datasources/authentication_remote_datasource.dart';
import 'package:tdd_tutorial/features/authentication/data/repositories/authentication_repository_impl.dart';
import 'package:tdd_tutorial/features/authentication/domain/entities/user.dart';

import 'authentication_remote_datasource_mock.dart';

void main() {
  late AuthenticationRemoteDatasource remoteDatasource;
  late AuthenticationRepositoryImpl repositoryImpl;

  setUp(() {
    remoteDatasource = AuthenticationRemoteDatasourceMock();
    repositoryImpl = AuthenticationRepositoryImpl(remoteDatasource);
  });

  const tException = ApiException(
    message: 'Unknown Error Occurred',
    statusCode: 500,
  );

  group('createUser', () {
    test(
        'should call the [RemoteDataSource.createUser] and complete '
        'successfully when the call to the remote source '
        'is successful', () async {
      // arrange
      when(() => remoteDatasource.createUser(
            name: any(named: 'name'),
            avatar: any(named: 'avatar'),
            createdAt: any(named: 'createdAt'),
          )).thenAnswer((_) async => Future.value());

      const name = 'name';
      const avatar = 'avatar';
      const createdAt = 'createdAt';

      // act
      final result = await repositoryImpl.createUser(
        name: name,
        avatar: avatar,
        createdAt: createdAt,
      );

      // assert
      expect(result, const Right(null));
      verify(
        () => remoteDatasource.createUser(
          name: name,
          avatar: avatar,
          createdAt: createdAt,
        ),
      ).called(1);
      verifyNoMoreInteractions(remoteDatasource);
    });
    test(
        'should return [ApiFailure] when the call to the remote source is unsuccessful',
        () async {
      // arrange
      when(() => remoteDatasource.createUser(
            name: any(named: 'name'),
            avatar: any(named: 'avatar'),
            createdAt: any(named: 'createdAt'),
          )).thenThrow(tException);

      const name = 'name';
      const avatar = 'avatar';
      const createdAt = 'createdAt';

      // act
      final result = await repositoryImpl.createUser(
        name: name,
        avatar: avatar,
        createdAt: createdAt,
      );

      // assert
      expect(
        result,
        equals(
          Left(
            ApiFailure(
              message: tException.message,
              statusCode: tException.statusCode,
            ),
          ),
        ),
      );
      verify(
        () => remoteDatasource.createUser(
          name: name,
          avatar: avatar,
          createdAt: createdAt,
        ),
      ).called(1);
      verifyNoMoreInteractions(remoteDatasource);
    });
  });

  group('getUsers', () {
    test(
        'should call the [RemoteDataSource.getUsers] and return [List<User>]'
        ' when call to remote source is successful ', () async {
      // arrange
      when(() => remoteDatasource.getUsers()).thenAnswer((_) async => []);

      // act
      final result = await repositoryImpl.getUsers();

      // assert
      expect(result, isA<Right<dynamic, List<User>>>());
      verify(() => remoteDatasource.getUsers()).called(1);
      verifyNoMoreInteractions(remoteDatasource);
    });
    test(
        'should return [ApiFailure] when the call to the remote source is unsuccessful',
        () async {
      // arrange
      when(() => remoteDatasource.getUsers()).thenThrow(tException);

      // act
      final result = await repositoryImpl.getUsers();

      // assert
      expect(
        result,
        equals(
          Left(
            ApiFailure(
              message: tException.message,
              statusCode: tException.statusCode,
            ),
          ),
        ),
      );
      verify(() => remoteDatasource.getUsers()).called(1);
      verifyNoMoreInteractions(remoteDatasource);
    });
  });
}
