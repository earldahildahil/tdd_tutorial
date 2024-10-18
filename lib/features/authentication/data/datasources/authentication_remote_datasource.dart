import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:tdd_tutorial/core/errors/exceptions.dart';
import 'package:tdd_tutorial/core/utils/typedef.dart';
import 'package:tdd_tutorial/features/authentication/data/models/user_model.dart';

abstract class AuthenticationRemoteDatasource {
  Future<void> createUser({
    required String name,
    required String avatar,
    required String createdAt,
  });

  Future<List<UserModel>> getUsers();
}

const kBaseUrl = '6709c75eaf1a3998baa252e2.mockapi.io';
const kCreateUsersEndpoint = '/api/v1/users';
const kGetUsersEndpoint = '/api/v1/users';

class AuthenticationRemoteDatasourceImpl
    implements AuthenticationRemoteDatasource {
  const AuthenticationRemoteDatasourceImpl(this._client);

  final http.Client _client;

  @override
  Future<void> createUser({
    required String name,
    required String avatar,
    required String createdAt,
  }) async {
    try {
      final response = await _client.post(
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
      );

      if (response.statusCode != 200 && response.statusCode != 201) {
        throw ApiException(
          message: response.body,
          statusCode: response.statusCode,
        );
      }
    } on ApiException {
      rethrow;
    } catch (e) {
      throw ApiException(
        message: e.toString(),
        statusCode: 505,
      );
    }
  }

  @override
  Future<List<UserModel>> getUsers() async {
    try {
      final response = await _client.get(Uri.https(
        kBaseUrl,
        kGetUsersEndpoint,
      ));

      if (response.statusCode != 200) {
        throw ApiException(
          message: response.body,
          statusCode: response.statusCode,
        );
      } else {
        final List<dynamic> users = jsonDecode(response.body);

        return users.map((user) => UserModel.fromMap(user as DataMap)).toList();
      }
    } on ApiException {
      rethrow;
    } catch (e) {
      throw ApiException(
        message: e.toString(),
        statusCode: 505,
      );
    }
  }
}
