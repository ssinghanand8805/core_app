import '../entities/post_entity.dart';
import '../repositories/post_repository.dart';

class CreatePost {
  final PostRepository repository;
  CreatePost(this.repository);
  Future<PostEntity> call({required int userId, required String title, required String body}) =>
      repository.createPost(userId: userId, title: title, body: body);
}