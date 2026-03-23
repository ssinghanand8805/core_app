import '../../domain/entities/workout_entity.dart';
import '../../domain/entities/subscription_entity.dart';
import '../../domain/repositories/trainer_repository.dart';
import '../datasources/remote/trainer_remote_datasource.dart';
import '../models/workout_model.dart';

class TrainerRepositoryImpl implements TrainerRepository {
  final TrainerRemoteDataSource remote;
  TrainerRepositoryImpl({required this.remote});

  @override
  Future<List<WorkoutEntity>> getAssignedWorkouts() => remote.getAssignedWorkouts();

  @override
  Future<List<SubscriptionEntity>> getSubscribedUsers() => remote.getSubscribedUsers();

  @override
  Future<void> assignWorkout(WorkoutEntity w) => remote.assignWorkout((w as WorkoutModel).toJson());
}