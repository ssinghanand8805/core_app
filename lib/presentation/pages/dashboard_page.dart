import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../core/services/connectivity_service.dart';
import '../../core/services/theme_service.dart';
import '../../l10n/translation_keys.dart';
import '../../routes/app_routes.dart';
import '../controllers/post_controller.dart';
import '../controllers/user_controller.dart';
import '../widgets/offline_banner.dart';

class DashboardPage extends StatelessWidget {
  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    final postCtrl = Get.find<PostController>();
    final userCtrl = Get.find<UserController>();
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textColor = isDark ? Colors.white : const Color(0xFF0D1F1C);
    final subColor = isDark ? Colors.white54 : Colors.black45;
    const teal = Color(0xFF00C9B1);

    return Scaffold(
      appBar: AppBar(
        title: Text(TKeys.dashboard.tr),
        actions: [
          Obx(() => IconButton(
                icon: Icon(ThemeService.to.isDark
                    ? Icons.light_mode_rounded
                    : Icons.dark_mode_rounded),
                onPressed: ThemeService.to.toggleTheme,
              )),
          IconButton(
            icon: const Icon(Icons.settings_rounded),
            onPressed: () => Get.toNamed(AppRoutes.settings),
          ),
        ],
      ),
      body: Obx(() {
        final isOffline = !ConnectivityService.to.isConnected;
        return Column(
          children: [
            if (isOffline) const OfflineBanner(),
            Expanded(
              child: RefreshIndicator(
                color: teal,
                onRefresh: () async {
                  await postCtrl.fetchPosts();
                  await userCtrl.fetchUsers();
                },
                child: ListView(
                  padding: const EdgeInsets.all(20),
                  children: [
                    Text(TKeys.apiStatus.tr,
                        style: TextStyle(
                            fontSize: 11,
                            letterSpacing: 1.2,
                            fontWeight: FontWeight.w600,
                            color: subColor)),
                    const SizedBox(height: 8),
                    Obx(() => _StatusCard(
                          isOnline: ConnectivityService.to.isConnected,
                          isDark: isDark,
                          textColor: textColor,
                        )),
                    const SizedBox(height: 24),
                    Text(TKeys.posts.tr,
                        style: TextStyle(
                            fontSize: 11,
                            letterSpacing: 1.2,
                            fontWeight: FontWeight.w600,
                            color: subColor)),
                    const SizedBox(height: 8),
                    Obx(() => _StatCard(
                          icon: Icons.article_rounded,
                          label: TKeys.totalPosts.tr,
                          value: postCtrl.isLoading.value
                              ? '...'
                              : postCtrl.posts.length.toString(),
                          color: teal,
                          isDark: isDark,
                          textColor: textColor,
                          subColor: subColor,
                          onTap: () => Get.toNamed(AppRoutes.posts),
                          isOffline: postCtrl.isOffline.value,
                        )),
                    const SizedBox(height: 12),
                    Text(TKeys.users.tr,
                        style: TextStyle(
                            fontSize: 11,
                            letterSpacing: 1.2,
                            fontWeight: FontWeight.w600,
                            color: subColor)),
                    const SizedBox(height: 8),
                    Obx(() => _StatCard(
                          icon: Icons.people_rounded,
                          label: TKeys.totalUsers.tr,
                          value: userCtrl.isLoading.value
                              ? '...'
                              : userCtrl.users.length.toString(),
                          color: const Color(0xFF6C63FF),
                          isDark: isDark,
                          textColor: textColor,
                          subColor: subColor,
                          onTap: () => Get.toNamed(AppRoutes.users),
                          isOffline: userCtrl.isOffline.value,
                        )),
                    const SizedBox(height: 28),
                    Text('Quick Actions'.toUpperCase(),
                        style: TextStyle(
                            fontSize: 11,
                            letterSpacing: 1.2,
                            fontWeight: FontWeight.w600,
                            color: subColor)),
                    const SizedBox(height: 8),
                    _QuickActions(isDark: isDark, textColor: textColor),
                    const SizedBox(height: 28),
                    _LocaleInfo(
                        isDark: isDark,
                        textColor: textColor,
                        subColor: subColor),
                  ],
                ),
              ),
            ),
          ],
        );
      }),
    );
  }
}

class _StatusCard extends StatelessWidget {
  final bool isOnline;
  final bool isDark;
  final Color textColor;
  const _StatusCard(
      {required this.isOnline, required this.isDark, required this.textColor});

  @override
  Widget build(BuildContext context) {
    final color = isOnline ? const Color(0xFF00C9B1) : Colors.orange;
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF141A19) : Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: color.withOpacity(0.12),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(
              isOnline ? Icons.wifi_rounded : Icons.wifi_off_rounded,
              color: color,
              size: 22,
            ),
          ),
          const SizedBox(width: 14),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                isOnline ? TKeys.online.tr : TKeys.offline.tr,
                style: TextStyle(
                    color: color, fontWeight: FontWeight.w700, fontSize: 15),
              ),
              Text(
                isOnline
                    ? 'Connected to internet'
                    : 'No internet — showing cache',
                style:
                    TextStyle(color: textColor.withOpacity(0.5), fontSize: 12),
              ),
            ],
          ),
          const Spacer(),
          Container(
            width: 10,
            height: 10,
            decoration: BoxDecoration(
                color: color,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(color: color.withOpacity(0.4), blurRadius: 6)
                ]),
          ),
        ],
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final Color color;
  final bool isDark;
  final Color textColor;
  final Color subColor;
  final VoidCallback onTap;
  final bool isOffline;

  const _StatCard({
    required this.icon,
    required this.label,
    required this.value,
    required this.color,
    required this.isDark,
    required this.textColor,
    required this.subColor,
    required this.onTap,
    required this.isOffline,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: isDark ? const Color(0xFF141A19) : Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: color.withOpacity(0.15)),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: color.withOpacity(0.12),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, color: color, size: 24),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(label, style: TextStyle(color: subColor, fontSize: 12)),
                  const SizedBox(height: 2),
                  Text(value,
                      style: TextStyle(
                          color: textColor,
                          fontSize: 28,
                          fontWeight: FontWeight.w700)),
                  if (isOffline)
                    Row(children: [
                      Icon(Icons.wifi_off_rounded,
                          size: 11, color: Colors.orange.shade600),
                      const SizedBox(width: 4),
                      Text(TKeys.offlineData.tr,
                          style: TextStyle(
                              fontSize: 10, color: Colors.orange.shade600)),
                    ]),
                ],
              ),
            ),
            Icon(Icons.chevron_right_rounded, color: subColor),
          ],
        ),
      ),
    );
  }
}

class _QuickActions extends StatelessWidget {
  final bool isDark;
  final Color textColor;
  const _QuickActions({required this.isDark, required this.textColor});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
            child: _ActionTile(
          icon: Icons.article_rounded,
          label: TKeys.posts.tr,
          color: const Color(0xFF00C9B1),
          isDark: isDark,
          textColor: textColor,
          onTap: () => Get.toNamed(AppRoutes.posts),
        )),
        const SizedBox(width: 12),
        Expanded(
            child: _ActionTile(
          icon: Icons.people_rounded,
          label: TKeys.users.tr,
          color: const Color(0xFF6C63FF),
          isDark: isDark,
          textColor: textColor,
          onTap: () => Get.toNamed(AppRoutes.users),
        )),
        const SizedBox(width: 12),
        Expanded(
            child: _ActionTile(
          icon: Icons.settings_rounded,
          label: TKeys.settings.tr,
          color: Colors.orange,
          isDark: isDark,
          textColor: textColor,
          onTap: () => Get.toNamed(AppRoutes.settings),
        )),
      ],
    );
  }
}

class _ActionTile extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  final bool isDark;
  final Color textColor;
  final VoidCallback onTap;
  const _ActionTile(
      {required this.icon,
      required this.label,
      required this.color,
      required this.isDark,
      required this.textColor,
      required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          color: isDark ? const Color(0xFF141A19) : Colors.white,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: color.withOpacity(0.15)),
        ),
        child: Column(
          children: [
            Icon(icon, color: color, size: 28),
            const SizedBox(height: 8),
            Text(label,
                style: TextStyle(
                    color: textColor,
                    fontSize: 12,
                    fontWeight: FontWeight.w600)),
          ],
        ),
      ),
    );
  }
}

class _LocaleInfo extends StatelessWidget {
  final bool isDark;
  final Color textColor;
  final Color subColor;
  const _LocaleInfo(
      {required this.isDark, required this.textColor, required this.subColor});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF141A19) : Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFF00C9B1).withOpacity(0.15)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Current Locale & Theme',
              style: TextStyle(
                  color: textColor, fontWeight: FontWeight.w600, fontSize: 14)),
          const SizedBox(height: 12),
          Row(children: [
            _InfoChip(
              label: 'Locale: ${Get.locale?.toLanguageTag() ?? 'en-US'}',
              color: const Color(0xFF00C9B1),
            ),
            const SizedBox(width: 8),
            Obx(() => _InfoChip(
                  label:
                      'Theme: ${ThemeService.to.isDark ? TKeys.dark.tr : TKeys.light.tr}',
                  color: const Color(0xFF6C63FF),
                )),
          ]),
        ],
      ),
    );
  }
}

class _InfoChip extends StatelessWidget {
  final String label;
  final Color color;
  const _InfoChip({required this.label, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: color.withOpacity(0.10),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withOpacity(0.25)),
      ),
      child: Text(label,
          style: TextStyle(
              color: color, fontSize: 11, fontWeight: FontWeight.w600)),
    );
  }
}
