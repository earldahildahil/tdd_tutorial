import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:tdd_tutorial/features/authentication/domain/repositories/authentication_repository.dart';
import 'package:tdd_tutorial/features/authentication/domain/usecases/create_user.dart';

import 'authentication_repository_mock.dart';

void main() {
  late AuthenticationRepository repository;
  late CreateUser usecase;

  setUp(() {
    repository = AuthenticationRepositoryMock();
    usecase = CreateUser(repository);
  });

  test(
    'should call the [AuthenticationRepository.createUser]',
    () async {
      // Arrange
      when(() => repository.createUser(
            name: any(named: 'name'),
            avatar: any(named: 'avatar'),
            createdAt: any(named: 'createdAt'),
          )).thenAnswer((_) async => const Right(null));

      final params = CreateUserParams.empty();

      // Act
      final result = await usecase(params);

      // Assert
      expect(
        result,
        const Right(null),
      );
      verify(() => repository.createUser(
            name: params.name,
            avatar: params.avatar,
            createdAt: params.createdAt,
          )).called(1);
      verifyNoMoreInteractions(repository);
    },
  );
}
