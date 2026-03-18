import 'package:drift/drift.dart';
import '../../core/error/exceptions.dart';
import '../../core/services/connectivity_service.dart';
import '../../domain/entities/post_entity.dart';
import '../../domain/repositories/post_repository.dart';
import '../datasources/local/app_database.dart';
import '../datasources/local/post_local_datasource.dart';
import '../datasources/remote/post_remote_datasource.dart';
import '../models/post_model.dart';

class PostRepositoryImpl implements PostRepository {
  final PostRemoteDataSource remote;
  final PostLocalDataSource local;

  PostRepositoryImpl({required this.remote, required this.local});

  @override
  Future<List<PostEntity>> getPosts() async {
    if (ConnectivityService.to.isConnected) {
      final models = await remote.getPosts();
      await local.cachePosts(models
          .map((m) => PostsTableCompanion.insert(
              userId: m.userId, title: m.title, body: m.body))
          .toList());
      return models;
    }
    final cached = await local.getCachedPosts();
    if (cached.isEmpty) throw CacheException(message: 'No cached posts');
    return cached
        .map((c) =>
            PostModel(id: c.id, userId: c.userId, title: c.title, body: c.body))
        .toList();
  }

  @override
  Future<PostEntity> getPostById(int id) => remote.getPostById(id);

  @override
  Future<PostEntity> createPost({
    required int userId,
    required String title,
    required String body,
  }) async {
    if (ConnectivityService.to.isConnected) {
      try {
        final apiPost =
            await remote.createPost(userId: userId, title: title, body: body);
        await local.savePost(
            userId: apiPost.userId, title: apiPost.title, body: apiPost.body);
        return apiPost;
      } catch (_) {
        final saved =
            await local.savePost(userId: userId, title: title, body: body);
        return PostModel(
            id: saved.id,
            userId: saved.userId,
            title: saved.title,
            body: saved.body);
      }
    }
    final saved =
        await local.savePost(userId: userId, title: title, body: body);
    return PostModel(
        id: saved.id,
        userId: saved.userId,
        title: saved.title,
        body: saved.body);
  }

  @override
  Future<PostEntity> updatePost({
    required int id,
    required String title,
    required String body,
  }) async {
    if (ConnectivityService.to.isConnected) {
      try {
        final updated =
            await remote.updatePost(id: id, title: title, body: body);
        await local.updatePost(
            id: id, title: updated.title, body: updated.body);
        return updated;
      } catch (_) {
        await local.updatePost(id: id, title: title, body: body);
      }
    } else {
      await local.updatePost(id: id, title: title, body: body);
    }
    return PostModel(id: id, userId: 1, title: title, body: body);
  }

  @override
  Future<void> deletePost(int id) async {
    if (ConnectivityService.to.isConnected) {
      try {
        await remote.deletePost(id);
      } catch (_) {}
    }
    await local.deletePost(id);
  }
}
