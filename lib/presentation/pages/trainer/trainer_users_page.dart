import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../l10n/translation_keys.dart';
import '../../controllers/trainer_controller.dart';
import '../../widgets/status_chip.dart';

class TrainerUsersPage extends StatelessWidget {
  const TrainerUsersPage({super.key});

  @override
  Widget build(BuildContext context) {
    final ctrl = TrainerController.to;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final text = isDark ? Colors.white : const Color(0xFF0D1F1C);
    final sub = isDark ? Colors.white54 : Colors.black45;
    final bg = isDark ? const Color(0xFF0A0F0E) : const Color(0xFFF4F7F6);
    const orange = Color(0xFFFF6B35);

    return Scaffold(
      backgroundColor: bg,
      appBar: AppBar(
        backgroundColor: bg,
        elevation: 0,
        surfaceTintColor: Colors.transparent,
        title: Obx(() => Text(
              '${TKeys.subscribedUsers.tr} (${ctrl.subscriptions.length})',
              style: TextStyle(
                  color: text, fontWeight: FontWeight.w700, fontSize: 18),
            )),
      ),
      body: Obx(() {
        if (ctrl.isLoading.value)
          return const Center(child: CircularProgressIndicator(color: orange));
        if (ctrl.subscriptions.isEmpty) {
          return Center(
              child: Column(mainAxisSize: MainAxisSize.min, children: [
            Icon(Icons.group_off_rounded,
                size: 64, color: isDark ? Colors.white12 : Colors.black12),
            const SizedBox(height: 12),
            Text(TKeys.noSubscriptions.tr,
                style: TextStyle(color: sub, fontSize: 15)),
          ]));
        }
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
                borderRadius: BorderRadius.circular(18),
                border: Border.all(color: orange.withOpacity(0.08)),
              ),
              child: Row(children: [
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                        colors: [Color(0xFFFF6B35), Color(0xFFFF8C42)]),
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Center(
                      child: Text('U${s.userId}',
                          style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w800,
                              fontSize: 12))),
                ),
                const SizedBox(width: 14),
                Expanded(
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                      Text('User #${s.userId}',
                          style: TextStyle(
                              color: text,
                              fontWeight: FontWeight.w700,
                              fontSize: 15)),
                      const SizedBox(height: 4),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 2),
                        decoration: BoxDecoration(
                            color: orange.withOpacity(0.10),
                            borderRadius: BorderRadius.circular(6)),
                        child: Text(s.plan,
                            style: const TextStyle(
                                color: orange,
                                fontSize: 11,
                                fontWeight: FontWeight.w600)),
                      ),
                      const SizedBox(height: 4),
                      Text('${s.startDate} → ${s.endDate}',
                          style: TextStyle(color: sub, fontSize: 11)),
                    ])),
                Column(crossAxisAlignment: CrossAxisAlignment.end, children: [
                  StatusChip(status: s.status),
                  const SizedBox(height: 8),
                  GestureDetector(
                    onTap: () =>
                        _confirmDelete(context, ctrl, s.userId, isDark),
                    child: Container(
                      padding: const EdgeInsets.all(6),
                      decoration: BoxDecoration(
                        color: Colors.red.withOpacity(0.08),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Icon(Icons.person_remove_outlined,
                          color: Colors.red.shade400, size: 16),
                    ),
                  ),
                ]),
              ]),
            );
          },
        );
      }),
    );
  }

  void _confirmDelete(
      BuildContext ctx, TrainerController ctrl, int userId, bool isDark) {
    showDialog(
      context: ctx,
      builder: (_) => AlertDialog(
        backgroundColor: isDark ? const Color(0xFF141A19) : Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Row(children: [
          Icon(Icons.warning_rounded, color: Colors.red.shade400, size: 22),
          const SizedBox(width: 8),
          const Text('Remove User',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700)),
        ]),
        content: Text('Remove User #$userId from your training list?',
            style: const TextStyle(fontSize: 14, height: 1.5)),
        actions: [
          TextButton(onPressed: () => Get.back(), child: Text(TKeys.cancel.tr)),
          FilledButton(
            style: FilledButton.styleFrom(
                backgroundColor: Colors.red.shade600,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10))),
            onPressed: () {
              Get.back();
              ctrl.deleteSubscribedUser(userId);
            },
            child: const Text('Remove'),
          ),
        ],
      ),
    );
  }
}
