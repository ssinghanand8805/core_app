import 'app_database.dart';

abstract class PostLocalDataSource {
  Future<List<PostsTableData>> getCachedPosts();
  Future<void> cachePosts(List<PostsTableCompanion> posts);
}

class PostLocalDataSourceImpl implements PostLocalDataSource {
  final AppDatabase db;
  PostLocalDataSourceImpl(this.db);

  @override
  Future<List<PostsTableData>> getCachedPosts() => db.getAllPosts();

  @override
  Future<void> cachePosts(List<PostsTableCompanion> posts) => db.insertPosts(posts);
}