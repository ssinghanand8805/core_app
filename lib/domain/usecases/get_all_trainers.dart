import '../entities/trainer_entity.dart';
import '../repositories/admin_repository.dart';

class GetAllTrainers {
  final AdminRepository repository;
  GetAllTrainers(this.repository);
  Future<List<TrainerEntity>> call() => repository.getAllTrainers();
}