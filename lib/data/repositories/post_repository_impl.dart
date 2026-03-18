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
                id: Value(m.id),
                userId: m.userId,
                title: m.title,
                body: m.body,
              ))
          .toList());
      return models;
    } else {
      final cached = await local.getCachedPosts();
      if (cached.isEmpty) throw CacheException(message: 'No cached posts');
      return cached
          .map((c) => PostModel(
                id: c.id,
                userId: c.userId,
                title: c.title,
                body: c.body,
              ))
          .toList();
    }
  }

  @override
  Future<PostEntity> getPostById(int id) => remote.getPostById(id);
}
