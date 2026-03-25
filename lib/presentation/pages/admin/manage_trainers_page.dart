import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../l10n/translation_keys.dart';
import '../../../routes/app_routes.dart';
import '../../controllers/admin_controller.dart';
import '../../widgets/gym_button.dart';
import '../../widgets/gym_text_field.dart';

class ManageTrainersPage extends StatelessWidget {
  const ManageTrainersPage({super.key});

  @override
  Widget build(BuildContext context) {
    final ctrl = AdminController.to;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final text = isDark ? Colors.white : const Color(0xFF0D1F1C);
    final sub = isDark ? Colors.white54 : Colors.black45;
    final bg = isDark ? const Color(0xFF0A0F0E) : const Color(0xFFF4F7F6);
    const teal = Color(0xFF00C9B1);
    const orange = Color(0xFFFF6B35);

    return Scaffold(
      backgroundColor: bg,
      appBar: AppBar(
        backgroundColor: bg,
        elevation: 0,
        surfaceTintColor: Colors.transparent,
        title: Text(TKeys.manageTrainers.tr,
            style: TextStyle(
                color: text, fontWeight: FontWeight.w700, fontSize: 18)),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 12),
            child: GestureDetector(
              onTap: () =>
                  _showAddTrainerSheet(context, ctrl, isDark, text, sub),
              child: Container(
                padding:
                const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                decoration: BoxDecoration(
                  gradient:
                  const LinearGradient(colors: [teal, Color(0xFF00A896)]),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Row(mainAxisSize: MainAxisSize.min, children: [
                  Icon(Icons.add_rounded, color: Colors.white, size: 16),
                  SizedBox(width: 4),
                  Text('Add',
                      style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w700,
                          fontSize: 13)),
                ]),
              ),
            ),
          ),
        ],
      ),
      body: Obx(() {
        if (ctrl.isLoading.value) {
          return const Center(child: CircularProgressIndicator(color: teal));
        }
        if (ctrl.trainers.isEmpty) {
          return Center(
              child: Column(mainAxisSize: MainAxisSize.min, children: [
                Icon(Icons.fitness_center_rounded,
                    size: 64, color: isDark ? Colors.white12 : Colors.black12),
                const SizedBox(height: 12),
                Text('No trainers yet', style: TextStyle(color: sub, fontSize: 15)),
              ]));
        }
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
                borderRadius: BorderRadius.circular(18),
                border: Border.all(color: orange.withOpacity(0.10)),
              ),
              child: Row(children: [
                Container(
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                        colors: [Color(0xFFFF6B35), Color(0xFFFF8C42)],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight),
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Center(
                      child: Text(t.name[0],
                          style: const TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.w800))),
                ),
                const SizedBox(width: 14),
                Expanded(
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(t.name,
                              style: TextStyle(
                                  color: text,
                                  fontWeight: FontWeight.w700,
                                  fontSize: 15)),
                          const SizedBox(height: 2),
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 8, vertical: 2),
                            decoration: BoxDecoration(
                              color: orange.withOpacity(0.10),
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Text(t.specialty,
                                style: const TextStyle(
                                    color: orange,
                                    fontSize: 11,
                                    fontWeight: FontWeight.w600)),
                          ),
                          const SizedBox(height: 4),
                          Row(children: [
                            Icon(Icons.email_outlined, size: 11, color: sub),
                            const SizedBox(width: 4),
                            Text(t.email,
                                style: TextStyle(color: sub, fontSize: 11)),
                          ]),
                          Row(children: [
                            Icon(Icons.phone_outlined, size: 11, color: sub),
                            const SizedBox(width: 4),
                            Text(t.phone,
                                style: TextStyle(color: sub, fontSize: 11)),
                          ]),
                        ])),
                GestureDetector(
                  onTap: () =>
                      _confirmDelete(context, ctrl, t.id, t.name, isDark),
                  child: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.red.withOpacity(0.08),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Icon(Icons.delete_outline_rounded,
                        color: Colors.red.shade400, size: 18),
                  ),
                ),
              ]),
            );
          },
        );
      }),
    );
  }

  void _showAddTrainerSheet(BuildContext ctx, AdminController ctrl, bool isDark,
      Color text, Color sub) {
    showModalBottomSheet(
      context: ctx,
      isScrollControlled: true,
      backgroundColor: isDark ? const Color(0xFF141A19) : Colors.white,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(24))),
      builder: (_) => Padding(
        padding: EdgeInsets.fromLTRB(
            24, 24, 24, MediaQuery.of(ctx).viewInsets.bottom + 24),
        child: Form(
          key: ctrl.addFormKey,
          child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(children: [
                  Text('Add Trainer',
                      style: TextStyle(
                          color: text,
                          fontSize: 18,
                          fontWeight: FontWeight.w700)),
                  const Spacer(),
                  GestureDetector(
                    onTap: () => Get.back(),
                    child: Icon(Icons.close_rounded, color: sub),
                  ),
                ]),
                const SizedBox(height: 20),
                GymTextField(
                    controller: ctrl.nameCtrl,
                    hintText: 'Full Name',
                    prefixIcon: Icons.person_outline_rounded,
                    validator: (v) => v!.isEmpty ? 'Required' : null),
                const SizedBox(height: 12),
                GymTextField(
                    controller: ctrl.emailCtrl,
                    hintText: 'Email',
                    prefixIcon: Icons.email_outlined,
                    keyboardType: TextInputType.emailAddress,
                    validator: (v) => v!.isEmpty ? 'Required' : null),
                const SizedBox(height: 12),
                GymTextField(
                    controller: ctrl.specialtyCtrl,
                    hintText: 'Specialty',
                    prefixIcon: Icons.fitness_center_rounded,
                    validator: (v) => v!.isEmpty ? 'Required' : null),
                const SizedBox(height: 12),
                GymTextField(
                    controller: ctrl.phoneCtrl,
                    hintText: 'Phone',
                    prefixIcon: Icons.phone_outlined,
                    keyboardType: TextInputType.phone,
                    validator: (v) => v!.isEmpty ? 'Required' : null),
                const SizedBox(height: 24),
                Obx(() => GymButton(
                  label: 'Add Trainer',
                  isLoading: ctrl.isSubmitting.value,
                  onPressed: ctrl.submitAddTrainer,
                  icon: Icons.person_add_rounded,
                )),
              ]),
        ),
      ),
    );
  }

  void _confirmDelete(BuildContext ctx, AdminController ctrl, int id,
      String name, bool isDark) {
    showDialog(
      context: ctx,
      builder: (_) => AlertDialog(
        backgroundColor: isDark ? const Color(0xFF141A19) : Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Row(children: [
          Icon(Icons.warning_rounded, color: Colors.red.shade400, size: 22),
          const SizedBox(width: 8),
          const Text('Remove Trainer',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700)),
        ]),
        content: Text('Remove $name from the team?',
            style: const TextStyle(fontSize: 14, height: 1.5)),
        actions: [
          TextButton(onPressed: () => Get.back(), child: Text(TKeys.cancel.tr)),
          FilledButton(
            style: FilledButton.styleFrom(
              backgroundColor: Colors.red.shade600,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)),
            ),
            onPressed: () {
              Get.back();
              ctrl.removeTrainer(id);
            },
            child: const Text('Remove'),
          ),
        ],
      ),
    );
  }
}
