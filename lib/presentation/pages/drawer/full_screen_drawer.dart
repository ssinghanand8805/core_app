import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/enums/user_role.dart';
import '../../../l10n/translation_keys.dart';
import '../../../routes/app_routes.dart';
import '../../controllers/auth_controller.dart';
import '../../widgets/role_badge.dart';

class _DrawerItem {
  final String route;
  final IconData icon;
  final String label;
  const _DrawerItem(
      {required this.route, required this.icon, required this.label});
}

class FullScreenDrawer extends StatefulWidget {
  const FullScreenDrawer({super.key});
  @override
  State<FullScreenDrawer> createState() => _FullScreenDrawerState();
}

class _FullScreenDrawerState extends State<FullScreenDrawer>
    with SingleTickerProviderStateMixin {
  late AnimationController _ac;
  late Animation<double> _fade;

  @override
  void initState() {
    super.initState();
    _ac = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 400));
    _fade = CurvedAnimation(parent: _ac, curve: Curves.easeOut);
    _ac.forward();
  }

  @override
  void dispose() {
    _ac.dispose();
    super.dispose();
  }

  List<_DrawerItem> _menuItems(UserRole role) {
    switch (role) {
      case UserRole.admin:
        return [
          _DrawerItem(
              route: AppRoutes.adminDashboard,
              icon: Icons.dashboard_rounded,
              label: TKeys.dashboard.tr),
          _DrawerItem(
              route: AppRoutes.manageUsers,
              icon: Icons.people_rounded,
              label: TKeys.manageUsers.tr),
          _DrawerItem(
              route: AppRoutes.manageTrainers,
              icon: Icons.fitness_center_rounded,
              label: TKeys.manageTrainers.tr),
          _DrawerItem(
              route: AppRoutes.allPayments,
              icon: Icons.payment_rounded,
              label: TKeys.allPayments.tr),
        ];
      case UserRole.trainer:
        return [
          _DrawerItem(
              route: AppRoutes.trainerDashboard,
              icon: Icons.dashboard_rounded,
              label: TKeys.dashboard.tr),
          _DrawerItem(
              route: AppRoutes.trainerUsers,
              icon: Icons.group_rounded,
              label: TKeys.myTrainees.tr),
          _DrawerItem(
              route: AppRoutes.assignWorkout,
              icon: Icons.assignment_rounded,
              label: TKeys.assignWorkout.tr),
        ];
      case UserRole.user:
        return [
          _DrawerItem(
              route: AppRoutes.userDashboard,
              icon: Icons.dashboard_rounded,
              label: TKeys.dashboard.tr),
          _DrawerItem(
              route: AppRoutes.myWorkouts,
              icon: Icons.fitness_center_rounded,
              label: TKeys.myWorkouts.tr),
          _DrawerItem(
              route: AppRoutes.subscription,
              icon: Icons.card_membership_rounded,
              label: TKeys.subscription.tr),
          _DrawerItem(
              route: AppRoutes.paymentHistory,
              icon: Icons.receipt_long_rounded,
              label: TKeys.paymentHistory.tr),
        ];
    }
  }

  @override
  Widget build(BuildContext context) {
    final ctrl = AuthController.to;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bg = isDark ? const Color(0xFF0A0F0E) : const Color(0xFFF4F7F6);
    const teal = Color(0xFF00C9B1);

    return Scaffold(
      backgroundColor: bg,
      body: SafeArea(
        child: Obx(() {
          final role = ctrl.currentRole.value;
          final items = _menuItems(role);
          final name =
              ctrl.currentUser.value?.name ?? (StorageService_to_helper());
          return Column(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(24, 20, 24, 0),
                child: Row(
                  children: [
                    const Spacer(),
                    IconButton(
                      onPressed: () => Get.back(),
                      icon: Icon(
                        Icons.close_rounded,
                        color: isDark ? Colors.white54 : Colors.black38,
                        size: 26,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              CircleAvatar(
                radius: 40,
                backgroundColor: teal.withOpacity(0.15),
                child: Text(
                  name.isNotEmpty ? name[0].toUpperCase() : 'U',
                  style: const TextStyle(
                      color: teal, fontSize: 32, fontWeight: FontWeight.w700),
                ),
              ),
              const SizedBox(height: 12),
              Text(name,
                  style: TextStyle(
                    color: isDark ? Colors.white : const Color(0xFF0D1F1C),
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                    letterSpacing: -0.3,
                  )),
              const SizedBox(height: 8),
              RoleBadge(role: role),
              const SizedBox(height: 32),
              Divider(color: isDark ? Colors.white12 : Colors.black12),
              const SizedBox(height: 16),
              Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  itemCount: items.length,
                  itemBuilder: (_, i) {
                    final item = items[i];
                    final current = Get.currentRoute == item.route;
                    return FadeTransition(
                      opacity: _fade,
                      child: SlideTransition(
                        position: Tween<Offset>(
                          begin: Offset(0, 0.1 * (i + 1)),
                          end: Offset.zero,
                        ).animate(CurvedAnimation(
                          parent: _ac,
                          curve: Interval(0.1 * i, 1.0, curve: Curves.easeOut),
                        )),
                        child: GestureDetector(
                          onTap: () {
                            Get.back();
                            if (!current) Get.toNamed(item.route);
                          },
                          child: Container(
                            margin: const EdgeInsets.only(bottom: 6),
                            padding: const EdgeInsets.symmetric(
                                vertical: 14, horizontal: 20),
                            decoration: BoxDecoration(
                              color: current
                                  ? teal.withOpacity(0.10)
                                  : Colors.transparent,
                              borderRadius: BorderRadius.circular(14),
                              border: current
                                  ? Border.all(color: teal.withOpacity(0.30))
                                  : null,
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(item.icon,
                                    color: current
                                        ? teal
                                        : (isDark
                                            ? Colors.white54
                                            : Colors.black45),
                                    size: 22),
                                const SizedBox(width: 14),
                                Text(item.label,
                                    style: TextStyle(
                                      color: current
                                          ? teal
                                          : (isDark
                                              ? Colors.white
                                              : const Color(0xFF0D1F1C)),
                                      fontSize: 17,
                                      fontWeight: current
                                          ? FontWeight.w700
                                          : FontWeight.w500,
                                    )),
                              ],
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
              Divider(color: isDark ? Colors.white12 : Colors.black12),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
                child: Column(
                  children: [
                    _BottomTile(
                      icon: Icons.settings_rounded,
                      label: TKeys.settings.tr,
                      isDark: isDark,
                      onTap: () {
                        Get.back();
                        Get.toNamed(AppRoutes.settings);
                      },
                    ),
                    const SizedBox(height: 4),
                    _BottomTile(
                      icon: Icons.logout_rounded,
                      label: TKeys.logout.tr,
                      isDark: isDark,
                      color: Colors.red.shade400,
                      onTap: () {
                        Get.back();
                        ctrl.logout();
                      },
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 8),
            ],
          );
        }),
      ),
    );
  }

  String StorageService_to_helper() {
    try {
      final n = Get.find<dynamic>(tag: 'storage')?.getString(key: 'user_name');
      return n ?? 'User';
    } catch (_) {
      return 'User';
    }
  }
}

class _BottomTile extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool isDark;
  final Color? color;
  final VoidCallback onTap;
  const _BottomTile(
      {required this.icon,
      required this.label,
      required this.isDark,
      required this.onTap,
      this.color});

  @override
  Widget build(BuildContext context) {
    final c = color ?? (isDark ? Colors.white70 : Colors.black54);
    return GestureDetector(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: c, size: 20),
            const SizedBox(width: 12),
            Text(label,
                style: TextStyle(
                    color: c, fontSize: 15, fontWeight: FontWeight.w500)),
          ],
        ),
      ),
    );
  }
}
