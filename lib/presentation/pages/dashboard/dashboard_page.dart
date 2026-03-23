import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/enums/user_role.dart';
import '../../controllers/auth_controller.dart';
import '../../controllers/admin_controller.dart';
import '../../controllers/trainer_controller.dart';
import '../drawer/full_screen_drawer.dart';
import 'admin_dashboard.dart';
import 'trainer_dashboard.dart';
import 'user_dashboard.dart';

class DashboardPage extends StatelessWidget {
  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    final auth = AuthController.to;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor:
          isDark ? const Color(0xFF0A0F0E) : const Color(0xFFF4F7F6),
      appBar: AppBar(
        backgroundColor:
            isDark ? const Color(0xFF0A0F0E) : const Color(0xFFF4F7F6),
        elevation: 0,
        surfaceTintColor: Colors.transparent,
        leading: IconButton(
          icon: Icon(Icons.menu_rounded,
              color: isDark ? Colors.white : const Color(0xFF0D1F1C)),
          onPressed: () => Get.to(() => const FullScreenDrawer(),
              transition: Transition.leftToRightWithFade),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.settings_rounded,
                color: isDark ? Colors.white54 : Colors.black38),
            onPressed: () => Get.toNamed('/settings'),
          ),
        ],
      ),
      body: Obx(() {
        switch (auth.currentRole.value) {
          case UserRole.admin:
            return const AdminDashboard();
          case UserRole.trainer:
            return const TrainerDashboard();
          case UserRole.user:
            return const UserDashboard();
        }
      }),
    );
  }
}
