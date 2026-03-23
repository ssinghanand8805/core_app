import '../entities/workout_entity.dart';
import '../repositories/trainer_repository.dart';

class GetWorkouts {
  final TrainerRepository repository;
  GetWorkouts(this.repository);
  Future<List<WorkoutEntity>> call() => repository.getAssignedWorkouts();
}