import '../repositories/admin_repository.dart';

class DeleteTrainer {
  final AdminRepository repository;
  DeleteTrainer(this.repository);
  Future<void> call(int id) => repository.deleteTrainer(id);
}