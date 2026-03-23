import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../l10n/translation_keys.dart';
import '../../controllers/trainer_controller.dart';
import '../../widgets/status_chip.dart';

class MyWorkoutsPage extends StatelessWidget {
  const MyWorkoutsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final ctrl   = TrainerController.to;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final text   = isDark ? Colors.white : const Color(0xFF0D1F1C);
    final sub    = isDark ? Colors.white54 : Colors.black45;
    final bg     = isDark ? const Color(0xFF0A0F0E) : const Color(0xFFF4F7F6);
    const teal   = Color(0xFF00C9B1);

    return Scaffold(
      backgroundColor: bg,
      appBar: AppBar(
        backgroundColor: bg, elevation: 0, surfaceTintColor: Colors.transparent,
        title: Text(TKeys.myWorkouts.tr, style: TextStyle(color: text, fontWeight: FontWeight.w700)),
      ),
      body: Obx(() {
        if (ctrl.isLoading.value) return const Center(child: CircularProgressIndicator(color: teal));
        if (ctrl.workouts.isEmpty) return Center(child: Text(TKeys.noWorkouts.tr, style: TextStyle(color: sub)));
        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: ctrl.workouts.length,
          itemBuilder: (_, i) {
            final w = ctrl.workouts[i];
            return Container(
              margin: const EdgeInsets.only(bottom: 12),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: isDark ? const Color(0xFF141A19) : Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: teal.withOpacity(0.08)),
              ),
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Row(children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                    decoration: BoxDecoration(color: teal.withOpacity(0.12), borderRadius: BorderRadius.circular(6)),
                    child: Text('#${w.id}', style: const TextStyle(color: teal, fontSize: 11, fontWeight: FontWeight.w700)),
                  ),
                  const Spacer(),
                  StatusChip(status: w.status),
                ]),
                const SizedBox(height: 10),
                Text(w.title, style: TextStyle(color: text, fontWeight: FontWeight.w700, fontSize: 16)),
                const SizedBox(height: 4),
                Text(w.description, style: TextStyle(color: sub, fontSize: 13, height: 1.4)),
                const SizedBox(height: 8),
                Row(children: [
                  Icon(Icons.calendar_today_rounded, color: sub, size: 13),
                  const SizedBox(width: 4),
                  Text(w.scheduledAt, style: TextStyle(color: sub, fontSize: 12)),
                ]),
              ]),
            );
          },
        );
      }),
    );
  }
}