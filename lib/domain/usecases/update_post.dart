import '../entities/post_entity.dart';
import '../repositories/post_repository.dart';

class UpdatePost {
  final PostRepository repository;
  UpdatePost(this.repository);
  Future<PostEntity> call({required int id, required String title, required String body}) =>
      repository.updatePost(id: id, title: title, body: body);
}