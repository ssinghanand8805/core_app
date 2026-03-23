import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../l10n/translation_keys.dart';
import '../../controllers/trainer_controller.dart';
import '../../widgets/status_chip.dart';

class TrainerUsersPage extends StatelessWidget {
  const TrainerUsersPage({super.key});

  @override
  Widget build(BuildContext context) {
    final ctrl   = TrainerController.to;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final text   = isDark ? Colors.white : const Color(0xFF0D1F1C);
    final sub    = isDark ? Colors.white54 : Colors.black45;
    final bg     = isDark ? const Color(0xFF0A0F0E) : const Color(0xFFF4F7F6);

    return Scaffold(
      backgroundColor: bg,
      appBar: AppBar(
        backgroundColor: bg, elevation: 0, surfaceTintColor: Colors.transparent,
        title: Text(TKeys.subscribedUsers.tr,
            style: TextStyle(color: text, fontWeight: FontWeight.w700)),
      ),
      body: Obx(() {
        if (ctrl.isLoading.value) return const Center(child: CircularProgressIndicator(color: Color(0xFF00C9B1)));
        if (ctrl.subscriptions.isEmpty) return Center(child: Text(TKeys.noSubscriptions.tr, style: TextStyle(color: sub)));
        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: ctrl.subscriptions.length,
          itemBuilder: (_, i) {
            final s = ctrl.subscriptions[i];
            return Container(
              margin: const EdgeInsets.only(bottom: 12),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: isDark ? const Color(0xFF141A19) : Colors.white,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Row(children: [
                CircleAvatar(
                  radius: 22, backgroundColor: const Color(0xFFFF6B35).withOpacity(0.12),
                  child: Text('U${s.userId}', style: const TextStyle(color: Color(0xFFFF6B35), fontWeight: FontWeight.w700, fontSize: 11)),
                ),
                const SizedBox(width: 14),
                Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Text('User #${s.userId}', style: TextStyle(color: text, fontWeight: FontWeight.w600, fontSize: 15)),
                  Text('${s.plan} · ${s.startDate} → ${s.endDate}', style: TextStyle(color: sub, fontSize: 12)),
                ])),
                StatusChip(status: s.status),
              ]),
            );
          },
        );
      }),
    );
  }
}