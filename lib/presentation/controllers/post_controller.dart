import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '../../core/error/exceptions.dart';
import '../../core/services/connectivity_service.dart';
import '../../domain/entities/post_entity.dart';
import '../../domain/usecases/get_posts.dart';
import '../../domain/usecases/create_post.dart';
import '../../domain/usecases/update_post.dart';
import '../../domain/usecases/delete_post.dart';
import '../../l10n/translation_keys.dart';

class PostController extends GetxController {
  final GetPosts    getPosts;
  final CreatePost  createPost;
  final UpdatePost  updatePost;
  final DeletePost  deletePost;

  PostController({
    required this.getPosts,
    required this.createPost,
    required this.updatePost,
    required this.deletePost,
  });

  final posts        = <PostEntity>[].obs;
  final isLoading    = false.obs;
  final isSubmitting = false.obs;
  final isOffline    = false.obs;
  final errorMessage = ''.obs;

  @override
  void onInit() {
    super.onInit();
    fetchPosts();
  }

  Future<void> fetchPosts() async {
    isLoading.value    = true;
    errorMessage.value = '';
    isOffline.value    = !ConnectivityService.to.isConnected;
    try {
      posts.value = await getPosts();
    } on NetworkException catch (e) {
      errorMessage.value = e.message;
      _toast(TKeys.networkError.tr, Colors.orange);
    } on ServerException catch (e) {
      errorMessage.value = e.message;
      _toast(TKeys.serverError.tr, Colors.red);
    } on UnauthorizedException catch (e) {
      errorMessage.value = e.message;
      _toast(TKeys.unauthorized.tr, Colors.red);
    } on RequestTimeoutException catch (e) {
      errorMessage.value = e.message;
      _toast(TKeys.timeout.tr, Colors.orange);
    } on CacheException catch (e) {
      errorMessage.value = e.message;
      _toast(TKeys.noData.tr, Colors.grey);
    } catch (e) {
      errorMessage.value = e.toString();
      _toast(TKeys.error.tr, Colors.red);
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> addPost({required String title, required String body}) async {
    isSubmitting.value = true;
    try {
      final created = await createPost(userId: 1, title: title, body: body);
      posts.insert(0, created);
      _toast(TKeys.postCreated.tr, const Color(0xFF00C9B1));
      Get.back();
    } on ServerException catch (e) {
      _toast(e.message, Colors.red);
    } catch (e) {
      _toast(TKeys.error.tr, Colors.red);
    } finally {
      isSubmitting.value = false;
    }
  }

  Future<void> editPost({required int id, required String title, required String body}) async {
    isSubmitting.value = true;
    try {
      final updated = await updatePost(id: id, title: title, body: body);
      final idx = posts.indexWhere((p) => p.id == id);
      if (idx != -1) posts[idx] = updated;
      _toast(TKeys.postUpdated.tr, const Color(0xFF00C9B1));
      Get.back();
    } on ServerException catch (e) {
      _toast(e.message, Colors.red);
    } catch (e) {
      _toast(TKeys.error.tr, Colors.red);
    } finally {
      isSubmitting.value = false;
    }
  }

  Future<void> removePost(int id) async {
    try {
      await deletePost(id);
      posts.removeWhere((p) => p.id == id);
      _toast(TKeys.postDeleted.tr, Colors.red.shade600);
    } on ServerException catch (e) {
      _toast(e.message, Colors.red);
    } catch (e) {
      _toast(TKeys.error.tr, Colors.red);
    }
  }

  void _toast(String msg, Color color) {
    Fluttertoast.showToast(
      msg: msg,
      backgroundColor: color,
      textColor: Colors.white,
      gravity: ToastGravity.BOTTOM,
      toastLength: Toast.LENGTH_LONG,
    );
  }
}