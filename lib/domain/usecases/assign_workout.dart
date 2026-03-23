import '../entities/workout_entity.dart';
import '../repositories/trainer_repository.dart';

class AssignWorkout {
  final TrainerRepository repository;
  AssignWorkout(this.repository);
  Future<void> call(WorkoutEntity workout) => repository.assignWorkout(workout);
}