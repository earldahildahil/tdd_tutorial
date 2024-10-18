import 'package:equatable/equatable.dart';

class User extends Equatable {
  const User({
    required this.id,
    required this.name,
    required this.avatar,
    required this.createdAt,
  });

  factory User.empty() => const User(
        id: 0,
        name: '',
        avatar: '',
        createdAt: '',
      );

  final int id;
  final String name;
  final String avatar;
  final String createdAt;

  @override
  List<Object> get props => [
        id,
        name,
        avatar,
        createdAt,
      ];
}
