import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:tdd_tutorial/features/authentication/domain/entities/user.dart';
import 'package:tdd_tutorial/features/authentication/domain/repositories/authentication_repository.dart';
import 'package:tdd_tutorial/features/authentication/domain/usecases/get_users.dart';

import 'authentication_repository_mock.dart';

void main() {
  late AuthenticationRepository repository;
  late GetUsers usecase;

  setUp(() {
    repository = AuthenticationRepositoryMock();
    usecase = GetUsers(repository);
  });

  final emptyResponse = [
    User.empty(),
  ];

  test(
      'should call [AuthenticationRepository.getUsers] and return [List<User>]',
      () async {
    // Arrange

    when(() => repository.getUsers())
        .thenAnswer((_) async => Right(emptyResponse));

    // Act
    final result = await usecase();

    // Assert
    expect(
      result,
      Right(emptyResponse),
    );
    verify(() => repository.getUsers()).called(1);
    verifyNoMoreInteractions(repository);
  });
}
