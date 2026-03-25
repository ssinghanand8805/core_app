import '../entities/trainer_entity.dart';
import '../repositories/admin_repository.dart';

class AddTrainer {
  final AdminRepository repository;
  AddTrainer(this.repository);
  Future<void> call(TrainerEntity trainer) => repository.addTrainer(trainer);
}