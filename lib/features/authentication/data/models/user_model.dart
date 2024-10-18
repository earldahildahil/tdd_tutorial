import 'dart:convert';

import 'package:tdd_tutorial/core/utils/typedef.dart';
import 'package:tdd_tutorial/features/authentication/domain/entities/user.dart';

class UserModel extends User {
  const UserModel({
    required super.id,
    required super.name,
    required super.avatar,
    required super.createdAt,
  });

  factory UserModel.fromJson(String json) {
    final map = jsonDecode(json) as DataMap;

    return UserModel.fromMap(map);
  }

  factory UserModel.fromMap(DataMap map) {
    final id = map['id'] as String;

    return UserModel(
      id: int.parse(id),
      name: map['name'] as String,
      avatar: map['avatar'] as String,
      createdAt: map['createdAt'] as String,
    );
  }

  factory UserModel.empty() {
    return const UserModel(
      id: 0,
      name: '',
      avatar: '',
      createdAt: '',
    );
  }

  UserModel copyWith({
    int? id,
    String? name,
    String? avatar,
    String? createdAt,
  }) {
    return UserModel(
      id: id ?? this.id,
      name: name ?? this.name,
      avatar: avatar ?? this.avatar,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  DataMap toMap() {
    return {
      'id': id.toString(),
      'name': name,
      'avatar': avatar,
      'createdAt': createdAt,
    };
  }

  String toJson() => jsonEncode(toMap());
}
