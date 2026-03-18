import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../domain/entities/post_entity.dart';
import '../../l10n/translation_keys.dart';
import '../controllers/post_controller.dart';
import '../widgets/error_view.dart';
import '../widgets/loading_view.dart';
import '../widgets/offline_banner.dart';
import 'new_post_page.dart';

class PostsPage extends StatelessWidget {
  const PostsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final ctrl    = Get.find<PostController>();
    final isDark  = Theme.of(context).brightness == Brightness.dark;
    final sub     = isDark ? Colors.white54 : Colors.black45;
    const teal    = Color(0xFF00C9B1);

    return Scaffold(
      appBar: AppBar(
        title: Obx(() => Text(
          '${TKeys.posts.tr} (${ctrl.posts.length})',
        )),
        actions: [
          Obx(() => ctrl.isLoading.value
              ? const Padding(
              padding: EdgeInsets.all(16),
              child: SizedBox(
                width: 20, height: 20,
                child: CircularProgressIndicator(strokeWidth: 2),
              ))
              : IconButton(
            icon: const Icon(Icons.refresh_rounded),
            onPressed: ctrl.fetchPosts,
          )),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => Get.to(() => const NewPostPage()),
        backgroundColor: teal,
        foregroundColor: Colors.white,
        icon: const Icon(Icons.add_rounded),
        label: Text(TKeys.newPost.tr),
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
              child: RefreshIndicator(
                color: teal,
                onRefresh: ctrl.fetchPosts,
                child: ListView.builder(
                  padding: const EdgeInsets.fromLTRB(16, 16, 16, 96),
                  itemCount: ctrl.posts.length,
                  itemBuilder: (_, i) => _PostCard(
                    post: ctrl.posts[i],
                    ctrl: ctrl,
                    isDark: isDark,
                    sub: sub,
                  ),
                ),
              ),
            ),
          ],
        );
      }),
    );
  }
}

class _PostCard extends StatelessWidget {
  final PostEntity    post;
  final PostController ctrl;
  final bool          isDark;
  final Color         sub;
  const _PostCard({required this.post, required this.ctrl, required this.isDark, required this.sub});

  @override
  Widget build(BuildContext context) {
    const teal = Color(0xFF00C9B1);
    final card = isDark ? const Color(0xFF141A19) : Colors.white;

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: card,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: teal.withOpacity(0.08)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 14, 8, 0),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                  decoration: BoxDecoration(
                    color: teal.withOpacity(0.12),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text('#${post.id}',
                      style: const TextStyle(
                          color: teal, fontSize: 11, fontWeight: FontWeight.w700)),
                ),
                const SizedBox(width: 8),
                Text('${TKeys.user.tr} ${post.userId}',
                    style: TextStyle(color: sub, fontSize: 12)),
                const Spacer(),
                _ActionMenu(post: post, ctrl: ctrl),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 4),
            child: Text(
              post.title,
              style: TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 15,
                color: isDark ? Colors.white : const Color(0xFF0D1F1C),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 14),
            child: Text(
              post.body,
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(color: sub, fontSize: 13, height: 1.5),
            ),
          ),
        ],
      ),
    );
  }
}

class _ActionMenu extends StatelessWidget {
  final PostEntity     post;
  final PostController ctrl;
  const _ActionMenu({required this.post, required this.ctrl});

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<String>(
      icon: Icon(Icons.more_vert_rounded, color: Colors.grey.shade500, size: 20),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      onSelected: (value) {
        if (value == 'edit') {
          Get.to(() => NewPostPage(existingPost: post));
        } else if (value == 'delete') {
          _showDeleteDialog(context);
        }
      },
      itemBuilder: (_) => [
        PopupMenuItem(
          value: 'edit',
          child: Row(children: [
            const Icon(Icons.edit_rounded, size: 18, color: Color(0xFF00C9B1)),
            const SizedBox(width: 10),
            Text(TKeys.editPost.tr),
          ]),
        ),
        PopupMenuItem(
          value: 'delete',
          child: Row(children: [
            Icon(Icons.delete_rounded, size: 18, color: Colors.red.shade400),
            const SizedBox(width: 10),
            Text(TKeys.deletePost.tr,
                style: TextStyle(color: Colors.red.shade400)),
          ]),
        ),
      ],
    );
  }

  void _showDeleteDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Row(children: [
          Icon(Icons.warning_rounded, color: Colors.red.shade400, size: 22),
          const SizedBox(width: 8),
          Text(TKeys.confirmDelete.tr,
              style: const TextStyle(fontSize: 17, fontWeight: FontWeight.w700)),
        ]),
        content: Text(TKeys.deleteMessage.tr,
            style: const TextStyle(fontSize: 14, height: 1.5)),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: Text(TKeys.cancel.tr),
          ),
          FilledButton(
            style: FilledButton.styleFrom(
              backgroundColor: Colors.red.shade600,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            ),
            onPressed: () {
              Get.back();
              ctrl.removePost(post.id);
            },
            child: Text(TKeys.deletePost.tr),
          ),
        ],
      ),
    );
  }
}