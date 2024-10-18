import 'dart:convert';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:mocktail/mocktail.dart';
import 'package:tdd_tutorial/core/errors/exceptions.dart';
import 'package:tdd_tutorial/features/authentication/data/datasources/authentication_remote_datasource.dart';
import 'package:tdd_tutorial/features/authentication/data/models/user_model.dart';

class ClientMock extends Mock implements http.Client {}

void main() {
  late http.Client client;
  late AuthenticationRemoteDatasource datasource;

  setUp(() {
    client = ClientMock();
    datasource = AuthenticationRemoteDatasourceImpl(client);
    registerFallbackValue(Uri());
  });

  group('createUser', () {
    const name = 'John Doe';
    const avatar = 'https://avatar.com/johndoe';
    const createdAt = '2021-09-01';

    const invalidEmailMessage = 'Invalid email address';
    const invalidEmailStatusCode = 400;

    test('should complete successfully when the status code is 200 or 201',
        () async {
      // Arrange
      when(() => client.post(
            any(),
            body: any(named: 'body'),
            headers: {
              HttpHeaders.contentTypeHeader: 'application/json',
            },
          )).thenAnswer(
        (_) async => http.Response(
          'User created successfully',
          201,
        ),
      );

      // Act
      final methodCall = datasource.createUser;

      // Assert
      expect(
          methodCall(
            name: name,
            avatar: avatar,
            createdAt: createdAt,
          ),
          completes);

      verify(() => client.post(
            Uri.https(
              kBaseUrl,
              kCreateUsersEndpoint,
            ),
            body: jsonEncode(
              {
                'name': name,
                'avatar': avatar,
                'createdAt': createdAt,
              },
            ),
            headers: {
              HttpHeaders.contentTypeHeader: 'application/json',
            },
          )).called(1);

      verifyNoMoreInteractions(client);
    });

    test('should throw [ApiException] when the status code is not 200 or 201',
        () async {
      // Arrange
      when(() => client.post(
            any(),
            body: any(named: 'body'),
            headers: {
              HttpHeaders.contentTypeHeader: 'application/json',
            },
          )).thenAnswer((_) async => http.Response(
            invalidEmailMessage,
            invalidEmailStatusCode,
          ));

      // Act
      final methodCall = datasource.createUser;

      expect(
        () async => methodCall(
          name: name,
          avatar: avatar,
          createdAt: createdAt,
        ),
        throwsA(const ApiException(
          message: invalidEmailMessage,
          statusCode: invalidEmailStatusCode,
        )),
      );

      verify(() => client.post(
            Uri.https(
              kBaseUrl,
              kCreateUsersEndpoint,
            ),
            body: jsonEncode({
              'name': name,
              'avatar': avatar,
              'createdAt': createdAt,
            }),
            headers: {
              HttpHeaders.contentTypeHeader: 'application/json',
            },
          )).called(1);

      verifyNoMoreInteractions(client);
    });
  });

  group('getUsers', () {
    final tUser = UserModel.empty();

    const serverDownMessage = 'Server is down';
    const serverDownStatusCode = 500;

    test('should return [List<UserModel>] when the status code is 200',
        () async {
      // Arrange
      when(() => client.get(any())).thenAnswer((_) async => http.Response(
            jsonEncode([tUser.toMap()]),
            200,
          ));

      // Act
      final result = await datasource.getUsers();

      // Assert
      expect(result, equals([tUser]));

      verify(() => client.get(Uri.https(
            kBaseUrl,
            kGetUsersEndpoint,
          ))).called(1);

      verifyNoMoreInteractions(client);
    });

    test('should throw [ApiException] when the status code is not 200 or 201',
        () async {
      // Arrange
      when(() => client.get(any())).thenAnswer((_) async => http.Response(
            serverDownMessage,
            serverDownStatusCode,
          ));

      // Act
      final methodCall = datasource.getUsers;

      expect(
        () async => methodCall(),
        throwsA(const ApiException(
          message: serverDownMessage,
          statusCode: serverDownStatusCode,
        )),
      );

      verify(() => client.get(
            Uri.https(
              kBaseUrl,
              kGetUsersEndpoint,
            ),
          )).called(1);

      verifyNoMoreInteractions(client);
    });
  });
}
