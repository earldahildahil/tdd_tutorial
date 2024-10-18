import 'package:equatable/equatable.dart';
import 'package:tdd_tutorial/core/usecase/usecase.dart';
import 'package:tdd_tutorial/core/utils/typedef.dart';
import 'package:tdd_tutorial/features/authentication/domain/repositories/authentication_repository.dart';

class CreateUser implements UsecaseWithParams<void, CreateUserParams> {
  const CreateUser(this._repository);

  final AuthenticationRepository _repository;

  @override
  ResultFuture<void> call(params) {
    return _repository.createUser(
      name: params.name,
      avatar: params.avatar,
      createdAt: params.createdAt,
    );
  }
}

class CreateUserParams extends Equatable {
  const CreateUserParams({
    required this.name,
    required this.avatar,
    required this.createdAt,
  });

  factory CreateUserParams.empty() => const CreateUserParams(
        name: '',
        avatar: '',
        createdAt: '',
      );

  final String name;
  final String avatar;
  final String createdAt;

  @override
  List<Object> get props => [
        name,
        avatar,
        createdAt,
      ];
}
