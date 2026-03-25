import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import '../../domain/entities/workout_entity.dart';
import '../../domain/entities/subscription_entity.dart';
import '../../domain/usecases/get_workouts.dart';
import '../../domain/usecases/assign_workout.dart';
import '../../domain/usecases/get_subscriptions.dart';
import '../../l10n/translation_keys.dart';
import '../../data/models/workout_model.dart';

class TrainerController extends GetxController {
  final GetWorkouts getWorkoutsUseCase;
  final AssignWorkout assignWorkoutUseCase;
  final GetSubscriptions getSubscriptionsUseCase;

  TrainerController({
    required this.getWorkoutsUseCase,
    required this.assignWorkoutUseCase,
    required this.getSubscriptionsUseCase,
  });

  static TrainerController get to => Get.find();

  final workouts = <WorkoutEntity>[].obs;
  final subscriptions = <SubscriptionEntity>[].obs;
  final isLoading = false.obs;
  final isSubmitting = false.obs;
  final errorMessage = ''.obs;

  final titleCtrl = TextEditingController();
  final descCtrl = TextEditingController();
  final userIdCtrl = TextEditingController();
  final scheduledCtrl = TextEditingController();
  final assignFormKey = GlobalKey<FormState>();

  @override
  void onInit() {
    super.onInit();
    fetchAll();
  }

  // @override
  // void onClose() {
  //   titleCtrl.dispose();
  //   descCtrl.dispose();
  //   userIdCtrl.dispose();
  //   scheduledCtrl.dispose();
  //   super.onClose();
  // }

  Future<void> fetchAll() async {
    isLoading.value = true;
    errorMessage.value = '';
    try {
      final results = await Future.wait([
        getWorkoutsUseCase(),
        getSubscriptionsUseCase(),
      ]);
      workouts.value = results[0] as List<WorkoutEntity>;
      subscriptions.value = results[1] as List<SubscriptionEntity>;
    } catch (e) {
      errorMessage.value = e.toString();
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> submitAssignWorkout() async {
    if (!assignFormKey.currentState!.validate()) return;
    isSubmitting.value = true;
    try {
      final workout = WorkoutModel(
        id: 0,
        userId: int.tryParse(userIdCtrl.text) ?? 0,
        trainerId: 2,
        title: titleCtrl.text.trim(),
        description: descCtrl.text.trim(),
        scheduledAt: scheduledCtrl.text.trim(),
        status: 'pending',
      );
      await assignWorkoutUseCase(workout);
      workouts.insert(0, workout);
      _clearForm();
      Get.back();
      _toast(TKeys.workoutsAssigned.tr, const Color(0xFF00C9B1));
    } catch (_) {
      _toast(TKeys.error.tr, Colors.red);
    } finally {
      isSubmitting.value = false;
    }
  }

  void deleteSubscribedUser(int userId) {
    subscriptions.removeWhere((s) => s.userId == userId);
    _toast('User removed from your list', Colors.red.shade600);
  }

  void _clearForm() {
    titleCtrl.clear();
    descCtrl.clear();
    userIdCtrl.clear();
    scheduledCtrl.clear();
  }

  void _toast(String msg, Color color) {
    Fluttertoast.showToast(
      msg: msg,
      backgroundColor: color,
      textColor: Colors.white,
      gravity: ToastGravity.BOTTOM,
    );
  }
}
