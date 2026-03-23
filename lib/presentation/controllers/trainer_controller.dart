import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import '../../core/error/exceptions.dart';
import '../../domain/entities/workout_entity.dart';
import '../../domain/entities/subscription_entity.dart';
import '../../domain/usecases/get_workouts.dart';
import '../../domain/usecases/assign_workout.dart';
import '../../domain/usecases/get_subscriptions.dart';
import '../../l10n/translation_keys.dart';
import '../../data/models/workout_model.dart';

class TrainerController extends GetxController {
  final GetWorkouts getWorkouts;
  final AssignWorkout assignWorkout;
  final GetSubscriptions getSubscriptions;

  TrainerController({
    required this.getWorkouts,
    required this.assignWorkout,
    required this.getSubscriptions,
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

  @override
  void onClose() {
    titleCtrl.dispose();
    descCtrl.dispose();
    userIdCtrl.dispose();
    scheduledCtrl.dispose();
    super.onClose();
  }

  Future<void> fetchAll() async {
    isLoading.value = true;
    errorMessage.value = '';
    try {
      final results = await Future.wait([getWorkouts(), getSubscriptions()]);
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
      await assignWorkout(workout);
      workouts.insert(0, workout);
      _toast(TKeys.workoutsAssigned.tr, const Color(0xFF00C9B1));
      titleCtrl.clear();
      descCtrl.clear();
      userIdCtrl.clear();
      scheduledCtrl.clear();
      Get.back();
    } catch (e) {
      _toast(TKeys.error.tr, Colors.red);
    } finally {
      isSubmitting.value = false;
    }
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
