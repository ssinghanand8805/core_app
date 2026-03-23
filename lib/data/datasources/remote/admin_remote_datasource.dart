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
}
