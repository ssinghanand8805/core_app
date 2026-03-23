import '../entities/workout_entity.dart';
import '../entities/subscription_entity.dart';

abstract class TrainerRepository {
  Future<List<WorkoutEntity>> getAssignedWorkouts();
  Future<List<SubscriptionEntity>> getSubscribedUsers();
  Future<void> assignWorkout(WorkoutEntity workout);
}
