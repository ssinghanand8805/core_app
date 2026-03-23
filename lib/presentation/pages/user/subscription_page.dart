
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../l10n/translation_keys.dart';
import '../../controllers/trainer_controller.dart';
import '../../widgets/status_chip.dart';

class SubscriptionPage extends StatelessWidget {
  const SubscriptionPage({super.key});

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
        title: Text(TKeys.subscription.tr, style: TextStyle(color: text, fontWeight: FontWeight.w700)),
      ),
      body: Obx(() {
        if (ctrl.subscriptions.isEmpty) return Center(child: Text(TKeys.noSubscriptions.tr, style: TextStyle(color: sub)));
        final s = ctrl.subscriptions.first;
        return ListView(
          padding: const EdgeInsets.all(20),
          children: [
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                gradient: const LinearGradient(colors: [Color(0xFF00C9B1), Color(0xFF00A896)]),
                borderRadius: BorderRadius.circular(20),
                boxShadow: [BoxShadow(color: const Color(0xFF00C9B1).withOpacity(0.3), blurRadius: 20, offset: const Offset(0, 8))],
              ),
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Row(children: [
                  const Icon(Icons.card_membership_rounded, color: Colors.white70, size: 20),
                  const SizedBox(width: 8),
                  Text(TKeys.myPlan.tr, style: const TextStyle(color: Colors.white70, fontSize: 12, fontWeight: FontWeight.w600)),
                  const Spacer(),
                  StatusChip(status: s.status),
                ]),
                const SizedBox(height: 12),
                Text(s.plan, style: const TextStyle(color: Colors.white, fontSize: 28, fontWeight: FontWeight.w800)),
                const SizedBox(height: 8),
                Text('Trainer #${s.trainerId}', style: const TextStyle(color: Colors.white70, fontSize: 13)),
              ]),
            ),
            const SizedBox(height: 20),
            _InfoRow(label: TKeys.status.tr, value: s.status, text: text, sub: sub, isDark: isDark),
            _InfoRow(label: 'Start Date', value: s.startDate, text: text, sub: sub, isDark: isDark),
            _InfoRow(label: 'End Date',   value: s.endDate,   text: text, sub: sub, isDark: isDark),
          ],
        );
      }),
    );
  }
}

class _InfoRow extends StatelessWidget {
  final String label, value;
  final Color text, sub;
  final bool isDark;
  const _InfoRow({required this.label, required this.value, required this.text, required this.sub, required this.isDark});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF141A19) : Colors.white,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(children: [
        Text(label, style: TextStyle(color: sub, fontSize: 13)),
        const Spacer(),
        Text(value, style: TextStyle(color: text, fontWeight: FontWeight.w600, fontSize: 13)),
      ]),
    );
  }
}