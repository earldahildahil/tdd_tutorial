import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:tdd_tutorial/core/utils/typedef.dart';
import 'package:tdd_tutorial/features/authentication/data/models/user_model.dart';

import '../../../../fixtures/fixture_reader.dart';

void main() {
  final tModel = UserModel.empty();
  final tJson = fixture('user_empty.json');
  final tMap = jsonDecode(tJson) as DataMap;

  test('should be a subclass of [User] entity', () {
    // Assert
    expect(tModel, isA<UserModel>());
  });

  group('fromMap', () {
    test('should return a valid UserModel from Map', () {
      // Act
      final result = UserModel.fromMap(tMap);

      // Assert
      expect(result, equals(tModel));
    });
  });

  group('fromJson', () {
    test('should return a valid UserModel from JSON', () {
      // Act
      final result = UserModel.fromJson(tJson);

      // Assert
      expect(result, equals(tModel));
    });
  });

  group('toMap', () {
    test('should return a valid Map from UserModel', () {
      // Act
      final result = tModel.toMap();

      // Assert
      expect(result, equals(tMap));
    });
  });

  group('toJson', () {
    test('should return a valid JSON string from UserModel', () {
      // Act
      final result = tModel.toJson();

      // Assert
      expect(result, equals(tJson));
    });
  });

  group('copyWith', () {
    test('should return a copy of UserModel', () {
      // Act
      final result = tModel.copyWith(
        name: 'John Doe',
      );

      // Assert
      expect(result.name, equals('John Doe'));
    });
  });
}
