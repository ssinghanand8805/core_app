import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../l10n/translation_keys.dart';
import '../controllers/user_controller.dart';
import '../widgets/error_view.dart';
import '../widgets/loading_view.dart';
import '../widgets/offline_banner.dart';

class UsersPage extends StatelessWidget {
  const UsersPage({super.key});

  @override
  Widget build(BuildContext context) {
    final ctrl = Get.find<UserController>();
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final subColor = isDark ? Colors.white54 : Colors.black45;

    return Scaffold(
      appBar: AppBar(
        title: Text(TKeys.users.tr),
        actions: [
          Obx(() => ctrl.isLoading.value
              ? const Padding(
              padding: EdgeInsets.all(16),
              child: SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2)))
              : IconButton(
            icon: const Icon(Icons.refresh_rounded),
            onPressed: ctrl.fetchUsers,
          )),
        ],
      ),
      body: Obx(() {
        if (ctrl.isLoading.value && ctrl.users.isEmpty) return const LoadingView();
        if (ctrl.errorMessage.isNotEmpty && ctrl.users.isEmpty) {
          return ErrorView(message: ctrl.errorMessage.value, onRetry: ctrl.fetchUsers);
        }
        return Column(
          children: [
            if (ctrl.isOffline.value) const OfflineBanner(),
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: ctrl.users.length,
                itemBuilder: (_, i) {
                  final user = ctrl.users[i];
                  return Card(
                    margin: const EdgeInsets.only(bottom: 12),
                    child: ListTile(
                      contentPadding: const EdgeInsets.all(16),
                      leading: CircleAvatar(
                        backgroundColor: const Color(0xFF00C9B1).withOpacity(0.15),
                        child: Text(user.name[0],
                            style: const TextStyle(
                                color: Color(0xFF00C9B1), fontWeight: FontWeight.w700)),
                      ),
                      title: Text(user.name,
                          style: const TextStyle(fontWeight: FontWeight.w600)),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 4),
                          Text('@${user.username}',
                              style: const TextStyle(
                                  color: Color(0xFF00C9B1), fontSize: 12)),
                          Text(user.email,
                              style: TextStyle(color: subColor, fontSize: 12)),
                        ],
                      ),
                      trailing: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.phone_rounded, size: 14, color: subColor),
                          const SizedBox(height: 2),
                          Text(user.phone.split(' ').first,
                              style: TextStyle(color: subColor, fontSize: 10)),
                        ],
                      ),
                      isThreeLine: true,
                    ),
                  );
                },
              ),
            ),
          ],
        );
      }),
    );
  }
}