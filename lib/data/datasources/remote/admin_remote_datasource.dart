import '../../../core/network/api_endpoints.dart';
import '../../../core/network/dio_client.dart';
import '../../models/user_model.dart';
import '../../models/trainer_model.dart';
import '../../models/payment_model.dart';
import '../../models/subscription_model.dart';

abstract class AdminRemoteDataSource {
  Future<List<UserModel>> getAllUsers();
  Future<List<TrainerModel>> getAllTrainers();
  Future<List<PaymentModel>> getAllPayments();
  Future<List<SubscriptionModel>> getAllSubscriptions();
  Future<void> addTrainer(Map<String, dynamic> data);
  Future<void> deleteTrainer(int id);
  Future<void> deleteUser(int id);
}

class AdminRemoteDataSourceImpl implements AdminRemoteDataSource {
  final _dio = DioClient.instance.dio;

  @override
  Future<List<UserModel>> getAllUsers() async {
    try {
      final res = await _dio.get(ApiEndpoints.adminUsers);
      return (res.data as List).map((e) => UserModel.fromJson(e)).toList();
    } catch (_) {
      final res = await _dio.get(ApiEndpoints.users);
      return (res.data as List).map((e) => UserModel.fromJson(e)).toList();
    }
  }

  @override
  Future<List<TrainerModel>> getAllTrainers() async {
    try {
      final res = await _dio.get(ApiEndpoints.trainers);
      return (res.data as List).map((e) => TrainerModel.fromJson(e)).toList();
    } catch (_) {
      return TrainerModel.mockList();
    }
  }

  @override
  Future<List<PaymentModel>> getAllPayments() async {
    try {
      final res = await _dio.get(ApiEndpoints.adminPayments);
      return (res.data as List).map((e) => PaymentModel.fromJson(e)).toList();
    } catch (_) {
      return PaymentModel.mockList();
    }
  }

  @override
  Future<List<SubscriptionModel>> getAllSubscriptions() async {
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
  Future<void> addTrainer(Map<String, dynamic> data) async {
    try {
      await _dio.post(ApiEndpoints.trainers, data: data);
    } catch (_) {}
  }

  @override
  Future<void> deleteTrainer(int id) async {
    try {
      await _dio.delete('${ApiEndpoints.trainers}/$id');
    } catch (_) {}
  }

  @override
  Future<void> deleteUser(int id) async {
    try {
      await _dio.delete('${ApiEndpoints.adminUsers}/$id');
    } catch (_) {}
  }
}
