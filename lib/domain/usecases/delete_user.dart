import '../repositories/admin_repository.dart';

class DeleteUser {
  final AdminRepository repository;
  DeleteUser(this.repository);
  Future<void> call(int id) => repository.deleteUser(id);
}