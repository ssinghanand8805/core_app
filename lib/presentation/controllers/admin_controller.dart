import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
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
import '../../domain/usecases/add_trainer.dart';
import '../../domain/usecases/delete_trainer.dart';
import '../../domain/usecases/delete_user.dart';
import '../../data/models/trainer_model.dart';
import '../../l10n/translation_keys.dart';

class AdminController extends GetxController {
  final GetAllUsers     getAllUsersUseCase;
  final GetAllTrainers  getAllTrainersUseCase;
  final GetAllPayments  getAllPaymentsUseCase;
  final GetSubscriptions getAllSubscriptionsUseCase;
  final AddTrainer      addTrainerUseCase;
  final DeleteTrainer   deleteTrainerUseCase;
  final DeleteUser      deleteUserUseCase;

  AdminController({
    required this.getAllUsersUseCase,
    required this.getAllTrainersUseCase,
    required this.getAllPaymentsUseCase,
    required this.getAllSubscriptionsUseCase,
    required this.addTrainerUseCase,
    required this.deleteTrainerUseCase,
    required this.deleteUserUseCase,
  });

  static AdminController get to => Get.find();

  final users         = <UserEntity>[].obs;
  final trainers      = <TrainerEntity>[].obs;
  final payments      = <PaymentEntity>[].obs;
  final subscriptions = <SubscriptionEntity>[].obs;
  final isLoading     = false.obs;
  final isSubmitting  = false.obs;
  final errorMessage  = ''.obs;

  final nameCtrl      = TextEditingController();
  final emailCtrl     = TextEditingController();
  final phoneCtrl     = TextEditingController();
  final specialtyCtrl = TextEditingController();
  final addFormKey    = GlobalKey<FormState>();

  @override
  void onInit() {
    super.onInit();
    fetchAll();
  }

  @override
  void onClose() {
    nameCtrl.dispose();
    emailCtrl.dispose();
    phoneCtrl.dispose();
    specialtyCtrl.dispose();
    super.onClose();
  }

  double get totalRevenue =>
      payments.where((p) => p.status == 'paid').fold(0.0, (s, p) => s + p.amount);

  int get activeSubscriptions =>
      subscriptions.where((s) => s.status == 'active').length;

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

  Future<void> submitAddTrainer() async {
    if (!addFormKey.currentState!.validate()) return;
    isSubmitting.value = true;
    try {
      final trainer = TrainerModel(
        id:        trainers.length + 100,
        name:      nameCtrl.text.trim(),
        email:     emailCtrl.text.trim(),
        phone:     phoneCtrl.text.trim(),
        specialty: specialtyCtrl.text.trim(),
      );
      await addTrainerUseCase(trainer);
      trainers.add(trainer);
      _clearForm();
      Get.back();
      _toast('Trainer added successfully', const Color(0xFF00C9B1));
    } catch (_) {
      _toast(TKeys.error.tr, Colors.red);
    } finally {
      isSubmitting.value = false;
    }
  }

  Future<void> removeTrainer(int id) async {
    try {
      await deleteTrainerUseCase(id);
      trainers.removeWhere((t) => t.id == id);
      _toast('Trainer removed', Colors.red.shade600);
    } catch (_) {
      _toast(TKeys.error.tr, Colors.red);
    }
  }

  Future<void> removeUser(int id) async {
    try {
      await deleteUserUseCase(id);
      users.removeWhere((u) => u.id == id);
      _toast('User removed', Colors.red.shade600);
    } catch (_) {
      _toast(TKeys.error.tr, Colors.red);
    }
  }

  void _clearForm() {
    nameCtrl.clear();
    emailCtrl.clear();
    phoneCtrl.clear();
    specialtyCtrl.clear();
  }

  void _toast(String msg, Color color) {
    Fluttertoast.showToast(
      msg: msg, backgroundColor: color,
      textColor: Colors.white, gravity: ToastGravity.BOTTOM,
    );
  }
}