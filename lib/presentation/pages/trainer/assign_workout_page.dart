import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../l10n/translation_keys.dart';
import '../../controllers/trainer_controller.dart';
import '../../widgets/gym_button.dart';
import '../../widgets/gym_text_field.dart';

class AssignWorkoutPage extends StatelessWidget {
  const AssignWorkoutPage({super.key});

  @override
  Widget build(BuildContext context) {
    final ctrl   = TrainerController.to;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bg     = isDark ? const Color(0xFF0A0F0E) : const Color(0xFFF4F7F6);

    return Scaffold(
      backgroundColor: bg,
      appBar: AppBar(
        backgroundColor: bg, elevation: 0, surfaceTintColor: Colors.transparent,
        title: Text(TKeys.assignWorkout.tr,
            style: TextStyle(color: isDark ? Colors.white : const Color(0xFF0D1F1C),
                fontWeight: FontWeight.w700)),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: ctrl.assignFormKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _Label(label: TKeys.userId.tr, isDark: isDark),
              const SizedBox(height: 8),
              GymTextField(
                controller:   ctrl.userIdCtrl,
                hintText:     TKeys.assignTo.tr,
                prefixIcon:   Icons.person_outline_rounded,
                keyboardType: TextInputType.number,
                validator:    (v) => (v == null || v.isEmpty) ? 'Required' : null,
              ),
              const SizedBox(height: 16),
              _Label(label: TKeys.title.tr, isDark: isDark),
              const SizedBox(height: 8),
              GymTextField(
                controller: ctrl.titleCtrl,
                hintText:   'e.g. Morning HIIT',
                prefixIcon: Icons.fitness_center_rounded,
                validator:  (v) => (v == null || v.isEmpty) ? TKeys.titleRequired.tr : null,
              ),
              const SizedBox(height: 16),
              _Label(label: TKeys.description.tr, isDark: isDark),
              const SizedBox(height: 8),
              GymTextField(
                controller: ctrl.descCtrl,
                hintText:   'Describe the workout...',
                prefixIcon: Icons.description_outlined,
                maxLines:   4,
                validator:  (v) => (v == null || v.isEmpty) ? TKeys.bodyRequired.tr : null,
              ),
              const SizedBox(height: 16),
              _Label(label: TKeys.scheduledAt.tr, isDark: isDark),
              const SizedBox(height: 8),
              GymTextField(
                controller:   ctrl.scheduledCtrl,
                hintText:     'YYYY-MM-DD HH:MM',
                prefixIcon:   Icons.calendar_today_rounded,
                keyboardType: TextInputType.datetime,
                validator:    (v) => (v == null || v.isEmpty) ? 'Required' : null,
              ),
              const SizedBox(height: 32),
              Obx(() => GymButton(
                label:     TKeys.assignWorkout.tr,
                isLoading: ctrl.isSubmitting.value,
                onPressed: ctrl.submitAssignWorkout,
                icon:      Icons.send_rounded,
              )),
            ],
          ),
        ),
      ),
    );
  }
}

class _Label extends StatelessWidget {
  final String label;
  final bool   isDark;
  const _Label({required this.label, required this.isDark});

  @override
  Widget build(BuildContext context) => Text(
    label.toUpperCase(),
    style: TextStyle(
      fontSize: 11, letterSpacing: 1.2, fontWeight: FontWeight.w700,
      color: isDark ? Colors.white38 : Colors.black38,
    ),
  );
}