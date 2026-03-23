import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../l10n/translation_keys.dart';
import '../../controllers/admin_controller.dart';

class ManageTrainersPage extends StatelessWidget {
  const ManageTrainersPage({super.key});

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
        title: Text(TKeys.manageTrainers.tr, style: TextStyle(color: text, fontWeight: FontWeight.w700)),
      ),
      body: Obx(() {
        if (ctrl.isLoading.value) return const Center(child: CircularProgressIndicator(color: Color(0xFF00C9B1)));
        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: ctrl.trainers.length,
          itemBuilder: (_, i) {
            final t = ctrl.trainers[i];
            return Container(
              margin: const EdgeInsets.only(bottom: 12),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: isDark ? const Color(0xFF141A19) : Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: const Color(0xFFFF6B35).withOpacity(0.10)),
              ),
              child: Row(children: [
                CircleAvatar(
                  radius: 22, backgroundColor: const Color(0xFFFF6B35).withOpacity(0.12),
                  child: Text(t.name[0], style: const TextStyle(color: Color(0xFFFF6B35), fontWeight: FontWeight.w700)),
                ),
                const SizedBox(width: 14),
                Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Text(t.name, style: TextStyle(color: text, fontWeight: FontWeight.w600, fontSize: 15)),
                  Text(t.specialty, style: const TextStyle(color: Color(0xFFFF6B35), fontSize: 12, fontWeight: FontWeight.w600)),
                  Text(t.email, style: TextStyle(color: sub, fontSize: 12)),
                ])),
              ]),
            );
          },
        );
      }),
    );
  }
}