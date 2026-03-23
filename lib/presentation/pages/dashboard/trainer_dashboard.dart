import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../l10n/translation_keys.dart';
import '../../../routes/app_routes.dart';
import '../../controllers/auth_controller.dart';
import '../../controllers/trainer_controller.dart';
import '../../widgets/stat_card.dart';
import '../../widgets/status_chip.dart';

class TrainerDashboard extends StatelessWidget {
  const TrainerDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    final ctrl   = TrainerController.to;
    final auth   = AuthController.to;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final sub    = isDark ? Colors.white54 : Colors.black45;
    final text   = isDark ? Colors.white : const Color(0xFF0D1F1C);

    return Obx(() => RefreshIndicator(
      color: const Color(0xFF00C9B1),
      onRefresh: ctrl.fetchAll,
      child: ListView(
        padding: const EdgeInsets.fromLTRB(20, 0, 20, 32),
        children: [
          const SizedBox(height: 4),
          Text('${TKeys.welcomeBack.tr}, ${auth.currentUser.value?.name ?? 'Trainer'} 💪',
              style: TextStyle(color: text, fontSize: 20, fontWeight: FontWeight.w700)),
          const SizedBox(height: 4),
          Text(TKeys.trainer.tr.toUpperCase(),
              style: const TextStyle(color: Color(0xFFFF6B35), fontSize: 11,
                  fontWeight: FontWeight.w700, letterSpacing: 1.5)),
          const SizedBox(height: 24),

          ctrl.isLoading.value
              ? const Center(child: CircularProgressIndicator(color: Color(0xFF00C9B1)))
              : Row(children: [
            Expanded(child: StatCard(label: TKeys.workoutsAssigned.tr, value: ctrl.workouts.length.toString(), icon: Icons.assignment_rounded, color: const Color(0xFF00C9B1))),
            const SizedBox(width: 12),
            Expanded(child: StatCard(label: TKeys.subscribedUsers.tr, value: ctrl.subscriptions.length.toString(), icon: Icons.group_rounded, color: const Color(0xFFFF6B35))),
          ]),

          const SizedBox(height: 28),
          Row(children: [
            Text(TKeys.myWorkouts.tr,
                style: TextStyle(color: text, fontSize: 16, fontWeight: FontWeight.w700)),
            const Spacer(),
            TextButton(
              onPressed: () => Get.toNamed(AppRoutes.assignWorkout),
              child: Text('+ Assign', style: TextStyle(color: const Color(0xFF00C9B1), fontSize: 12)),
            ),
          ]),
          const SizedBox(height: 8),
          ...ctrl.workouts.take(5).map((w) => Container(
            margin: const EdgeInsets.only(bottom: 10),
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: isDark ? const Color(0xFF141A19) : Colors.white,
              borderRadius: BorderRadius.circular(14),
            ),
            child: Row(children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: const Color(0xFF00C9B1).withOpacity(0.12),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(Icons.fitness_center_rounded, color: Color(0xFF00C9B1), size: 18),
              ),
              const SizedBox(width: 12),
              Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text(w.title, style: TextStyle(color: text, fontWeight: FontWeight.w600, fontSize: 14)),
                Text('User #${w.userId} · ${w.scheduledAt}', style: TextStyle(color: sub, fontSize: 12)),
              ])),
              StatusChip(status: w.status),
            ]),
          )),
        ],
      ),
    ));
  }
}