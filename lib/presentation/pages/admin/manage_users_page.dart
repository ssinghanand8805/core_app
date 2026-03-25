import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../l10n/translation_keys.dart';
import '../../../routes/app_routes.dart';
import '../../controllers/admin_controller.dart';

class ManageUsersPage extends StatelessWidget {
  const ManageUsersPage({super.key});

  @override
  Widget build(BuildContext context) {
    final ctrl = AdminController.to;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final text = isDark ? Colors.white : const Color(0xFF0D1F1C);
    final sub = isDark ? Colors.white54 : Colors.black45;
    final bg = isDark ? const Color(0xFF0A0F0E) : const Color(0xFFF4F7F6);
    const teal = Color(0xFF00C9B1);

    return Scaffold(
      backgroundColor: bg,
      appBar: AppBar(
        backgroundColor: bg,
        elevation: 0,
        surfaceTintColor: Colors.transparent,
        title: Obx(() => Text(
          '${TKeys.manageUsers.tr} (${ctrl.users.length})',
          style: TextStyle(
              color: text, fontWeight: FontWeight.w700, fontSize: 18),
        )),
      ),
      body: Obx(() {
        if (ctrl.isLoading.value) {
          return const Center(child: CircularProgressIndicator(color: teal));
        }
        return RefreshIndicator(
          color: teal,
          onRefresh: ctrl.fetchAll,
          child: ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: ctrl.users.length,
            itemBuilder: (_, i) {
              final u = ctrl.users[i];
              return GestureDetector(
                onTap: () => Get.toNamed(AppRoutes.userDetail, arguments: u),
                child: Container(
                  margin: const EdgeInsets.only(bottom: 12),
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: isDark ? const Color(0xFF141A19) : Colors.white,
                    borderRadius: BorderRadius.circular(18),
                    border: Border.all(color: teal.withOpacity(0.08)),
                  ),
                  child: Row(children: [
                    Container(
                      width: 48,
                      height: 48,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            teal.withOpacity(0.8),
                            const Color(0xFF00A896)
                          ],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: Center(
                          child: Text(u.name[0],
                              style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 18,
                                  fontWeight: FontWeight.w800))),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(u.name,
                                  style: TextStyle(
                                      color: text,
                                      fontWeight: FontWeight.w700,
                                      fontSize: 15)),
                              const SizedBox(height: 2),
                              Text(u.email,
                                  style: TextStyle(color: sub, fontSize: 12)),
                              Text('@${u.username}',
                                  style: const TextStyle(
                                      color: teal,
                                      fontSize: 11,
                                      fontWeight: FontWeight.w600)),
                            ])),
                    Row(children: [
                      const Icon(Icons.chevron_right_rounded,
                          color: teal, size: 18),
                      const SizedBox(width: 4),
                      GestureDetector(
                        onTap: () =>
                            _confirmDelete(context, ctrl, u.id, u.name, isDark),
                        child: Container(
                          padding: const EdgeInsets.all(6),
                          decoration: BoxDecoration(
                            color: Colors.red.withOpacity(0.08),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Icon(Icons.delete_outline_rounded,
                              color: Colors.red.shade400, size: 16),
                        ),
                      ),
                    ]),
                  ]),
                ),
              );
            },
          ),
        );
      }),
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
          const Text('Remove User',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700)),
        ]),
        content: Text('Remove $name permanently?',
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
              ctrl.removeUser(id);
            },
            child: const Text('Remove'),
          ),
        ],
      ),
    );
  }
}
