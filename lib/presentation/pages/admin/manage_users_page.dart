import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../l10n/translation_keys.dart';
import '../../controllers/admin_controller.dart';

class ManageUsersPage extends StatelessWidget {
  const ManageUsersPage({super.key});

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
        title: Text(TKeys.manageUsers.tr, style: TextStyle(color: text, fontWeight: FontWeight.w700)),
      ),
      body: Obx(() {
        if (ctrl.isLoading.value) return const Center(child: CircularProgressIndicator(color: Color(0xFF00C9B1)));
        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: ctrl.users.length,
          itemBuilder: (_, i) {
            final u = ctrl.users[i];
            return Container(
              margin: const EdgeInsets.only(bottom: 12),
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: isDark ? const Color(0xFF141A19) : Colors.white,
                borderRadius: BorderRadius.circular(16),
              ),
              child: ListTile(
                contentPadding: EdgeInsets.zero,
                leading: CircleAvatar(
                  backgroundColor: const Color(0xFF00C9B1).withOpacity(0.12),
                  child: Text(u.name[0], style: const TextStyle(color: Color(0xFF00C9B1), fontWeight: FontWeight.w700)),
                ),
                title: Text(u.name, style: TextStyle(color: text, fontWeight: FontWeight.w600)),
                subtitle: Text(u.email, style: TextStyle(color: sub, fontSize: 12)),
                trailing: Text('#${u.id}', style: TextStyle(color: sub, fontSize: 12)),
              ),
            );
          },
        );
      }),
    );
  }
}