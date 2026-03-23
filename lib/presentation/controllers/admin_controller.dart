import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../domain/entities/user_entity.dart';
import '../../domain/entities/trainer_entity.dart';
import '../../domain/entities/payment_entity.dart';
import '../../domain/entities/subscription_entity.dart';
import '../../domain/usecases/get_all_users.dart';
import '../../domain/usecases/get_all_payments.dart';
import '../../domain/usecases/get_all_trainers.dart';
import '../../domain/usecases/get_payments.dart';
import '../../domain/usecases/get_subscriptions.dart';
import '../../l10n/translation_keys.dart';

class AdminController extends GetxController {
  final GetAllUsers    getAllUsersUseCase;
  final GetAllTrainers getAllTrainersUseCase;
  final GetAllPayments getAllPaymentsUseCase;
  final GetSubscriptions getAllSubscriptionsUseCase;

  AdminController({
    required this.getAllUsersUseCase,
    required this.getAllTrainersUseCase,
    required this.getAllPaymentsUseCase,
    required this.getAllSubscriptionsUseCase,
  });

  static AdminController get to => Get.find();

  final users         = <UserEntity>[].obs;
  final trainers      = <TrainerEntity>[].obs;
  final payments      = <PaymentEntity>[].obs;
  final subscriptions = <SubscriptionEntity>[].obs;
  final isLoading     = false.obs;
  final errorMessage  = ''.obs;

  double get totalRevenue =>
      payments.where((p) => p.status == 'paid').fold(0.0, (s, p) => s + p.amount);

  int get activeSubscriptions =>
      subscriptions.where((s) => s.status == 'active').length;

  @override
  void onInit() {
    super.onInit();
    fetchAll();
  }

  Future<void> fetchAll() async {
    isLoading.value    = true;
    errorMessage.value = '';
    try {
      final results = await Future.wait([
        getAllUsersUseCase(),
        getAllTrainersUseCase(),
        getAllPaymentsUseCase(),
        getAllSubscriptionsUseCase(),
      ] as Iterable<Future<dynamic>>);
      users.value         = results[0] as List<UserEntity>;
      trainers.value      = results[1] as List<TrainerEntity>;
      payments.value      = results[2] as List<PaymentEntity>;
      subscriptions.value = results[3] as List<SubscriptionEntity>;
    } catch (e) {
      errorMessage.value = e.toString();
    } finally {
      isLoading.value = false;
    }
  }
}