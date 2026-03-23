import '../entities/user_entity.dart';
import '../repositories/admin_repository.dart';

class GetAllUsers {
  final AdminRepository repository;
  GetAllUsers(this.repository);
  Future<List<UserEntity>> call() => repository.getAllUsers();
}