import '../../../core/network/api_endpoints.dart';
import '../../../core/network/dio_client.dart';
import '../../models/workout_model.dart';
import '../../models/subscription_model.dart';

abstract class TrainerRemoteDataSource {
  Future<List<WorkoutModel>> getAssignedWorkouts();
  Future<List<SubscriptionModel>> getSubscribedUsers();
  Future<void> assignWorkout(Map<String, dynamic> data);
  Future<void> deleteUser(int userId);
}

class TrainerRemoteDataSourceImpl implements TrainerRemoteDataSource {
  final _dio = DioClient.instance.dio;

  @override
  Future<List<WorkoutModel>> getAssignedWorkouts() async {
    try {
      final res = await _dio.get(ApiEndpoints.workouts);
      return (res.data as List).map((e) => WorkoutModel.fromJson(e)).toList();
    } catch (_) {
      return WorkoutModel.mockList(2);
    }
  }

  @override
  Future<List<SubscriptionModel>> getSubscribedUsers() async {
    try {
      final res = await _dio.get(ApiEndpoints.subscriptions);
      return (res.data as List)
          .map((e) => SubscriptionModel.fromJson(e))
          .toList();
    } catch (_) {
      return SubscriptionModel.mockList();
    }
  }

  @override
  Future<void> assignWorkout(Map<String, dynamic> data) async {
    try {
      await _dio.post(ApiEndpoints.workouts, data: data);
    } catch (_) {}
  }

  @override
  Future<void> deleteUser(int userId) async {
    try {
      await _dio.delete('${ApiEndpoints.users}/$userId');
    } catch (_) {}
  }
}
