import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:tdd_tutorial/core/errors/failure.dart';
import 'package:tdd_tutorial/features/authentication/domain/usecases/create_user.dart';
import 'package:tdd_tutorial/features/authentication/domain/usecases/get_users.dart';
import 'package:tdd_tutorial/features/authentication/presentation/cubit/authentication_cubit.dart';

class CreateUserMock extends Mock implements CreateUser {}

class GetUsersMock extends Mock implements GetUsers {}

void main() {
  late CreateUserMock createUser;
  late GetUsersMock getUsers;
  late AuthenticationCubit cubit;

  final tCreateUserParams = CreateUserParams.empty();
  const tApiFailure = ApiFailure(
    message: 'Server Failure',
    statusCode: 400,
  );

  setUp(() {
    createUser = CreateUserMock();
    getUsers = GetUsersMock();
    cubit = AuthenticationCubit(createUser: createUser, getUsers: getUsers);
    registerFallbackValue(tCreateUserParams);
  });

  tearDown(() {
    cubit.close();
  });

  test('initial state should be [AuthenticationInitial]', () async {
    expect(
      cubit.state,
      const AuthenticationInitial(),
    );
  });

  group('createUser', () {
    blocTest<AuthenticationCubit, AuthenticationState>(
      'should emit [CreatingUser, UserCreated] when successful',
      build: () {
        when(() => createUser(any()))
            .thenAnswer((_) async => const Right(null));

        return cubit;
      },
      act: (cubit) => cubit.createUser(
        name: tCreateUserParams.name,
        avatar: tCreateUserParams.avatar,
        createdAt: tCreateUserParams.createdAt,
      ),
      expect: () => const <AuthenticationState>[
        CreatingUser(),
        UserCreated(),
      ],
      verify: (_) {
        verify(() => createUser(tCreateUserParams)).called(1);
        verifyNoMoreInteractions(createUser);
      },
    );

    blocTest<AuthenticationCubit, AuthenticationState>(
      'should emit [CreatingUser, AuthenticationError] when unsuccessful',
      build: () {
        when(() => createUser(any()))
            .thenAnswer((_) async => const Left(tApiFailure));

        return cubit;
      },
      act: (cubit) => cubit.createUser(
        name: tCreateUserParams.name,
        avatar: tCreateUserParams.avatar,
        createdAt: tCreateUserParams.createdAt,
      ),
      expect: () => <AuthenticationState>[
        const CreatingUser(),
        AuthenticationError(tApiFailure.errorMessage),
      ],
      verify: (_) {
        verify(() => createUser(tCreateUserParams)).called(1);
        verifyNoMoreInteractions(createUser);
      },
    );
  });

  group('getUsers', () {
    blocTest<AuthenticationCubit, AuthenticationState>(
      'should emit [GettingUsers, UsersLoaded] when successful',
      build: () {
        when(() => getUsers()).thenAnswer((_) async => const Right([]));

        return cubit;
      },
      act: (cubit) => cubit.getUsers(),
      expect: () => <AuthenticationState>[
        const GettingUsers(),
        const UsersLoaded([]),
      ],
      verify: (_) {
        verify(() => getUsers()).called(1);
        verifyNoMoreInteractions(getUsers);
      },
    );

    blocTest<AuthenticationCubit, AuthenticationState>(
      'should emit [GettingUsers, AuthenticationError] when unsuccessful',
      build: () {
        when(() => getUsers()).thenAnswer((_) async => const Left(tApiFailure));

        return cubit;
      },
      act: (cubit) => cubit.getUsers(),
      expect: () => <AuthenticationState>[
        const GettingUsers(),
        AuthenticationError(tApiFailure.errorMessage),
      ],
      verify: (_) {
        verify(() => getUsers()).called(1);
        verifyNoMoreInteractions(getUsers);
      },
    );
  });
}
