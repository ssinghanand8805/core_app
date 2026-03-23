import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../l10n/translation_keys.dart';
import '../../../routes/app_routes.dart';
import '../../controllers/admin_controller.dart';
import '../../controllers/auth_controller.dart';
import '../../widgets/stat_card.dart';
import '../../widgets/status_chip.dart';

class AdminDashboard extends StatelessWidget {
  const AdminDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    final ctrl   = AdminController.to;
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
          Text('${TKeys.welcomeBack.tr}, ${auth.currentUser.value?.name ?? 'Admin'} 👋',
              style: TextStyle(color: text, fontSize: 20, fontWeight: FontWeight.w700)),
          const SizedBox(height: 4),
          Text(TKeys.admin.tr.toUpperCase(),
              style: const TextStyle(color: Color(0xFF00C9B1), fontSize: 11,
                  fontWeight: FontWeight.w700, letterSpacing: 1.5)),
          const SizedBox(height: 24),

          ctrl.isLoading.value
              ? const Center(child: CircularProgressIndicator(color: Color(0xFF00C9B1)))
              : GridView.count(
            crossAxisCount: 2, crossAxisSpacing: 12, mainAxisSpacing: 12,
            shrinkWrap: true, physics: const NeverScrollableScrollPhysics(),
            childAspectRatio: 1.1,
            children: [
              StatCard(label: TKeys.totalUsers.tr,    value: ctrl.users.length.toString(),         icon: Icons.people_rounded,          color: const Color(0xFF00C9B1)),
              StatCard(label: TKeys.totalTrainers.tr, value: ctrl.trainers.length.toString(),      icon: Icons.fitness_center_rounded,  color: const Color(0xFFFF6B35)),
              StatCard(label: TKeys.totalRevenue.tr,  value: '₹${ctrl.totalRevenue.toStringAsFixed(0)}', icon: Icons.currency_rupee_rounded, color: const Color(0xFF7C3AED)),
              StatCard(label: TKeys.activeSubsCount.tr, value: ctrl.activeSubscriptions.toString(), icon: Icons.card_membership_rounded, color: Colors.orange),
            ],
          ),

          const SizedBox(height: 28),
          Row(children: [
            Text(TKeys.allPayments.tr,
                style: TextStyle(color: text, fontSize: 16, fontWeight: FontWeight.w700)),
            const Spacer(),
            TextButton(
              onPressed: () => Get.toNamed(AppRoutes.allPayments),
              child: Text('See All', style: TextStyle(color: const Color(0xFF00C9B1), fontSize: 12)),
            ),
          ]),
          const SizedBox(height: 8),
          ...ctrl.payments.take(5).map((p) => Container(
            margin: const EdgeInsets.only(bottom: 10),
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: isDark ? const Color(0xFF141A19) : Colors.white,
              borderRadius: BorderRadius.circular(14),
            ),
            child: Row(children: [
              CircleAvatar(
                radius: 18, backgroundColor: const Color(0xFF00C9B1).withOpacity(0.12),
                child: Text('U${p.userId}', style: const TextStyle(color: Color(0xFF00C9B1), fontSize: 10, fontWeight: FontWeight.w700)),
              ),
              const SizedBox(width: 12),
              Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text('User #${p.userId}', style: TextStyle(color: text, fontWeight: FontWeight.w600, fontSize: 14)),
                Text(p.method, style: TextStyle(color: sub, fontSize: 12)),
              ])),
              Column(crossAxisAlignment: CrossAxisAlignment.end, children: [
                Text('₹${p.amount.toStringAsFixed(0)}', style: TextStyle(color: text, fontWeight: FontWeight.w700)),
                StatusChip(status: p.status),
              ]),
            ]),
          )),
        ],
      ),
    ));
  }
}