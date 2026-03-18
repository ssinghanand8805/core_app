import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../l10n/translation_keys.dart';
import '../controllers/post_controller.dart';
import '../widgets/error_view.dart';
import '../widgets/loading_view.dart';
import '../widgets/offline_banner.dart';

class PostsPage extends StatelessWidget {
  const PostsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final ctrl = Get.find<PostController>();
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final subColor = isDark ? Colors.white54 : Colors.black45;

    return Scaffold(
      appBar: AppBar(
        title: Text(TKeys.posts.tr),
        actions: [
          Obx(() => ctrl.isLoading.value
              ? const Padding(
              padding: EdgeInsets.all(16),
              child: SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2)))
              : IconButton(
            icon: const Icon(Icons.refresh_rounded),
            onPressed: ctrl.fetchPosts,
          )),
        ],
      ),
      body: Obx(() {
        if (ctrl.isLoading.value && ctrl.posts.isEmpty) return const LoadingView();
        if (ctrl.errorMessage.isNotEmpty && ctrl.posts.isEmpty) {
          return ErrorView(message: ctrl.errorMessage.value, onRetry: ctrl.fetchPosts);
        }
        return Column(
          children: [
            if (ctrl.isOffline.value) const OfflineBanner(),
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: ctrl.posts.length,
                itemBuilder: (_, i) {
                  final post = ctrl.posts[i];
                  return Card(
                    margin: const EdgeInsets.only(bottom: 12),
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(children: [
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                              decoration: BoxDecoration(
                                color: const Color(0xFF00C9B1).withOpacity(0.15),
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: Text('#${post.id}',
                                  style: const TextStyle(
                                      color: Color(0xFF00C9B1),
                                      fontSize: 11,
                                      fontWeight: FontWeight.w700)),
                            ),
                            const SizedBox(width: 8),
                            Text('User ${post.userId}',
                                style: TextStyle(color: subColor, fontSize: 12)),
                          ]),
                          const SizedBox(height: 8),
                          Text(post.title,
                              style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 15)),
                          const SizedBox(height: 6),
                          Text(post.body,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(color: subColor, fontSize: 13, height: 1.4)),
                        ],
                      ),
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