import 'package:get/get.dart';
import '../../data/datasources/remote/trainer_remote_datasource.dart';
import '../../data/repositories/trainer_repository_impl.dart';
import '../../domain/repositories/trainer_repository.dart';
import '../../domain/usecases/assign_workout.dart';
import '../../domain/usecases/get_subscriptions.dart';
import '../../domain/usecases/get_workouts.dart';
import '../../presentation/controllers/trainer_controller.dart';

class TrainerBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<TrainerRepository>(
          () => TrainerRepositoryImpl(remote: TrainerRemoteDataSourceImpl()),
    );
    Get.lazyPut(
          () => TrainerController(
        getWorkoutsUseCase:      GetWorkouts(Get.find()),
        assignWorkoutUseCase:    AssignWorkout(Get.find()),
        getSubscriptionsUseCase: GetSubscriptions(Get.find()),
      ),
    );
  }
}