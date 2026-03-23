import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../domain/repositories/trainer_repository.dart';
import '../../../l10n/translation_keys.dart';
import '../../../routes/app_routes.dart';
import '../../controllers/auth_controller.dart';
import '../../controllers/trainer_controller.dart';
import '../../widgets/status_chip.dart';

class UserDashboard extends StatelessWidget {
  const UserDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    final ctrl = TrainerController.to;
    final auth = AuthController.to;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final sub = isDark ? Colors.white54 : Colors.black45;
    final text = isDark ? Colors.white : const Color(0xFF0D1F1C);
    const teal = Color(0xFF00C9B1);

    return Obx(() => RefreshIndicator(
          color: teal,
          onRefresh: ctrl.fetchAll,
          child: ListView(
            padding: const EdgeInsets.fromLTRB(20, 0, 20, 32),
            children: [
              const SizedBox(height: 4),
              Text(
                  '${TKeys.welcomeBack.tr}, ${auth.currentUser.value?.name ?? 'User'} 🏋️',
                  style: TextStyle(
                      color: text, fontSize: 20, fontWeight: FontWeight.w700)),
              const SizedBox(height: 4),
              Text(TKeys.user.tr.toUpperCase(),
                  style: const TextStyle(
                      color: Color(0xFF7C3AED),
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 1.5)),
              const SizedBox(height: 24),
              if (ctrl.subscriptions.isNotEmpty)
                _ActivePlanCard(
                    sub: ctrl.subscriptions.first, isDark: isDark, text: text),
              const SizedBox(height: 20),
              Row(children: [
                Text(TKeys.myWorkouts.tr,
                    style: TextStyle(
                        color: text,
                        fontSize: 16,
                        fontWeight: FontWeight.w700)),
                const Spacer(),
                TextButton(
                  onPressed: () => Get.toNamed(AppRoutes.myWorkouts),
                  child: const Text('See All',
                      style: TextStyle(color: teal, fontSize: 12)),
                ),
              ]),
              const SizedBox(height: 8),
              ctrl.isLoading.value
                  ? const Center(child: CircularProgressIndicator(color: teal))
                  : ctrl.workouts.isEmpty
                      ? Center(
                          child: Text(TKeys.noWorkouts.tr,
                              style: TextStyle(color: sub)))
                      : Column(
                          children: ctrl.workouts
                              .take(3)
                              .map((w) => Container(
                                    margin: const EdgeInsets.only(bottom: 10),
                                    padding: const EdgeInsets.all(14),
                                    decoration: BoxDecoration(
                                      color: isDark
                                          ? const Color(0xFF141A19)
                                          : Colors.white,
                                      borderRadius: BorderRadius.circular(14),
                                      border: Border.all(
                                          color: teal.withOpacity(0.08)),
                                    ),
                                    child: Row(children: [
                                      Container(
                                        padding: const EdgeInsets.all(10),
                                        decoration: BoxDecoration(
                                          color: teal.withOpacity(0.12),
                                          borderRadius:
                                              BorderRadius.circular(10),
                                        ),
                                        child: const Icon(
                                            Icons.fitness_center_rounded,
                                            color: teal,
                                            size: 18),
                                      ),
                                      const SizedBox(width: 12),
                                      Expanded(
                                          child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                            Text(w.title,
                                                style: TextStyle(
                                                    color: text,
                                                    fontWeight: FontWeight.w600,
                                                    fontSize: 14)),
                                            Text(w.scheduledAt,
                                                style: TextStyle(
                                                    color: sub, fontSize: 12)),
                                          ])),
                                      StatusChip(status: w.status),
                                    ]),
                                  ))
                              .toList(),
                        ),
              const SizedBox(height: 16),
              _QuickLinks(isDark: isDark, text: text),
            ],
          ),
        ));
  }
}

class _ActivePlanCard extends StatelessWidget {
  final dynamic sub;
  final bool isDark;
  final Color text;
  const _ActivePlanCard(
      {required this.sub, required this.isDark, required this.text});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
            colors: [Color(0xFF00C9B1), Color(0xFF00A896)]),
        borderRadius: BorderRadius.circular(18),
      ),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(children: [
          const Icon(Icons.card_membership_rounded,
              color: Colors.white70, size: 18),
          const SizedBox(width: 8),
          Text('Active Plan',
              style: const TextStyle(
                  color: Colors.white70,
                  fontSize: 12,
                  fontWeight: FontWeight.w600)),
          const Spacer(),
          StatusChip(status: sub.status),
        ]),
        const SizedBox(height: 8),
        Text(sub.plan,
            style: const TextStyle(
                color: Colors.white,
                fontSize: 22,
                fontWeight: FontWeight.w800)),
        const SizedBox(height: 4),
        Text('${sub.startDate} → ${sub.endDate}',
            style: const TextStyle(color: Colors.white70, fontSize: 12)),
      ]),
    );
  }
}

class _QuickLinks extends StatelessWidget {
  final bool isDark;
  final Color text;
  const _QuickLinks({required this.isDark, required this.text});

  @override
  Widget build(BuildContext context) {
    final items = [
      {
        'icon': Icons.fitness_center_rounded,
        'label': TKeys.myWorkouts.tr,
        'route': AppRoutes.myWorkouts,
        'color': const Color(0xFF00C9B1)
      },
      {
        'icon': Icons.card_membership_rounded,
        'label': TKeys.subscription.tr,
        'route': AppRoutes.subscription,
        'color': const Color(0xFF7C3AED)
      },
      {
        'icon': Icons.receipt_long_rounded,
        'label': TKeys.paymentHistory.tr,
        'route': AppRoutes.paymentHistory,
        'color': Colors.orange
      },
    ];
    return Row(
      children: items
          .map((item) => Expanded(
                child: GestureDetector(
                  onTap: () => Get.toNamed(item['route'] as String),
                  child: Container(
                    margin: const EdgeInsets.symmetric(horizontal: 4),
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    decoration: BoxDecoration(
                      color: isDark ? const Color(0xFF141A19) : Colors.white,
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(
                          color: (item['color'] as Color).withOpacity(0.15)),
                    ),
                    child: Column(children: [
                      Icon(item['icon'] as IconData,
                          color: item['color'] as Color, size: 24),
                      const SizedBox(height: 6),
                      Text(item['label'] as String,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              color: text,
                              fontSize: 10,
                              fontWeight: FontWeight.w600)),
                    ]),
                  ),
                ),
              ))
          .toList(),
    );
  }
}
