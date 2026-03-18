import 'package:drift/drift.dart';
import 'app_database.dart';

abstract class PostLocalDataSource {
  Future<List<PostsTableData>> getCachedPosts();
  Future<void> cachePosts(List<PostsTableCompanion> posts);
  Future<PostsTableData> savePost(
      {required int userId, required String title, required String body});
  Future<void> updatePost(
      {required int id, required String title, required String body});
  Future<void> deletePost(int id);
}

class PostLocalDataSourceImpl implements PostLocalDataSource {
  final AppDatabase db;
  PostLocalDataSourceImpl(this.db);

  @override
  Future<List<PostsTableData>> getCachedPosts() => db.getAllPosts();

  @override
  Future<void> cachePosts(List<PostsTableCompanion> posts) =>
      db.insertPosts(posts);

  @override
  Future<PostsTableData> savePost({
    required int userId,
    required String title,
    required String body,
  }) async {
    final id = await db.insertPost(PostsTableCompanion.insert(
      userId: userId,
      title: title,
      body: body,
    ));
    final all = await db.getAllPosts();
    return all.firstWhere((p) => p.id == id);
  }

  @override
  Future<void> updatePost({
    required int id,
    required String title,
    required String body,
  }) =>
      db.updatePost(PostsTableCompanion(
        id: Value(id),
        title: Value(title),
        body: Value(body),
      ));

  @override
  Future<void> deletePost(int id) => db.deletePost(id);
}
