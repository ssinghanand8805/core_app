import '../entities/auth_entity.dart';
import '../repositories/auth_repository.dart';

class Login {
  final AuthRepository repository;
  Login(this.repository);
  Future<AuthEntity> call({required String email, required String password}) =>
      repository.login(email: email, password: password);
}