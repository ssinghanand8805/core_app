import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../l10n/translation_keys.dart';
import '../../controllers/admin_controller.dart';
import '../../widgets/status_chip.dart';

class AllPaymentsPage extends StatelessWidget {
  const AllPaymentsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final ctrl   = AdminController.to;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final text   = isDark ? Colors.white : const Color(0xFF0D1F1C);
    final sub    = isDark ? Colors.white54 : Colors.black45;
    final bg     = isDark ? const Color(0xFF0A0F0E) : const Color(0xFFF4F7F6);

    return Scaffold(
      backgroundColor: bg,
      appBar: AppBar(
        backgroundColor: bg, elevation: 0, surfaceTintColor: Colors.transparent,
        title: Text(TKeys.allPayments.tr, style: TextStyle(color: text, fontWeight: FontWeight.w700)),
      ),
      body: Obx(() {
        if (ctrl.isLoading.value) return const Center(child: CircularProgressIndicator(color: Color(0xFF00C9B1)));
        return Column(children: [
          Container(
            margin: const EdgeInsets.all(16),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              gradient: const LinearGradient(colors: [Color(0xFF00C9B1), Color(0xFF00A896)]),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Row(children: [
              const Icon(Icons.currency_rupee_rounded, color: Colors.white, size: 24),
              const SizedBox(width: 10),
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text(TKeys.totalRevenue.tr, style: const TextStyle(color: Colors.white70, fontSize: 12)),
                Text('₹${ctrl.totalRevenue.toStringAsFixed(0)}',
                    style: const TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.w800)),
              ]),
            ]),
          ),
          Expanded(child: ListView.builder(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
            itemCount: ctrl.payments.length,
            itemBuilder: (_, i) {
              final p = ctrl.payments[i];
              return Container(
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
                    Text('₹${p.amount.toStringAsFixed(0)}', style: TextStyle(color: text, fontWeight: FontWeight.w700, fontSize: 15)),
                    Text('${p.method} · ${p.paidAt.isEmpty ? "—" : p.paidAt}', style: TextStyle(color: sub, fontSize: 12)),
                  ])),
                  StatusChip(status: p.status),
                ]),
              );
            },
          )),
        ]);
      }),
    );
  }
}