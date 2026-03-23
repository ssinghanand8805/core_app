import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../l10n/translation_keys.dart';
import '../../controllers/trainer_controller.dart';
import '../../widgets/status_chip.dart';
import '../../../data/models/payment_model.dart';

class PaymentHistoryPage extends StatelessWidget {
  const PaymentHistoryPage({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark  = Theme.of(context).brightness == Brightness.dark;
    final text    = isDark ? Colors.white : const Color(0xFF0D1F1C);
    final sub     = isDark ? Colors.white54 : Colors.black45;
    final bg      = isDark ? const Color(0xFF0A0F0E) : const Color(0xFFF4F7F6);
    final payments = PaymentModel.mockList();

    return Scaffold(
      backgroundColor: bg,
      appBar: AppBar(
        backgroundColor: bg, elevation: 0, surfaceTintColor: Colors.transparent,
        title: Text(TKeys.paymentHistory.tr, style: TextStyle(color: text, fontWeight: FontWeight.w700)),
      ),
      body: payments.isEmpty
          ? Center(child: Text(TKeys.noPayments.tr, style: TextStyle(color: sub)))
          : ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: payments.length,
        itemBuilder: (_, i) {
          final p = payments[i];
          return Container(
            margin: const EdgeInsets.only(bottom: 12),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: isDark ? const Color(0xFF141A19) : Colors.white,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Row(children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: const Color(0xFF00C9B1).withOpacity(0.12),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(Icons.currency_rupee_rounded, color: Color(0xFF00C9B1), size: 18),
              ),
              const SizedBox(width: 14),
              Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text('₹${p.amount.toStringAsFixed(0)}',
                    style: TextStyle(color: text, fontWeight: FontWeight.w700, fontSize: 16)),
                Text('${p.method} · ${p.paidAt.isEmpty ? "Pending" : p.paidAt}',
                    style: TextStyle(color: sub, fontSize: 12)),
              ])),
              StatusChip(status: p.status),
            ]),
          );
        },
      ),
    );
  }
}