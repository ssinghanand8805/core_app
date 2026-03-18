import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '../../core/error/exceptions.dart';
import '../../core/services/connectivity_service.dart';
import '../../domain/entities/post_entity.dart';
import '../../domain/usecases/get_posts.dart';
import '../../l10n/translation_keys.dart';
import '../widgets/toast.dart';

class PostController extends GetxController {
  final GetPosts getPosts;
  PostController({required this.getPosts});

  final posts = <PostEntity>[].obs;
  final isLoading = false.obs;
  final isOffline = false.obs;
  final errorMessage = ''.obs;

  @override
  void onInit() {
    super.onInit();
    fetchPosts();
  }

  Future<void> fetchPosts() async {
    isLoading.value = true;
    errorMessage.value = '';
    isOffline.value = !ConnectivityService.to.isConnected;

    try {
      posts.value = await getPosts();
    } on NetworkException catch (e) {
      errorMessage.value = e.message;
      AppToast.show(TKeys.networkError.tr, type: ToastType.warning);
    } on ServerException catch (e) {
      errorMessage.value = e.message;
      AppToast.show(TKeys.serverError.tr, type: ToastType.error);
    } on UnauthorizedException catch (e) {
      errorMessage.value = e.message;
      AppToast.show(TKeys.unauthorized.tr, type: ToastType.error);
    } on RequestTimeoutException catch (e) {
      errorMessage.value = e.message;
      AppToast.show(TKeys.timeout.tr, type: ToastType.warning);
    } on CacheException catch (e) {
      errorMessage.value = e.message;
      AppToast.show(TKeys.noData.tr, type: ToastType.info);
    } catch (e) {
      errorMessage.value = e.toString();
      AppToast.show(TKeys.error.tr, type: ToastType.error);
    } finally {
      isLoading.value = false;
    }
  }
}
