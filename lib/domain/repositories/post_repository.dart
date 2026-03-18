import '../entities/post_entity.dart';

abstract class PostRepository {
  Future<List<PostEntity>> getPosts();
  Future<PostEntity>       getPostById(int id);
  Future<PostEntity>       createPost({required int userId, required String title, required String body});
  Future<PostEntity>       updatePost({required int id, required String title, required String body});
  Future<void>             deletePost(int id);
}