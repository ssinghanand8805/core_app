import '../entities/post_entity.dart';
import '../repositories/post_repository.dart';

class GetPosts {
  final PostRepository repository;
  GetPosts(this.repository);

  Future<List<PostEntity>> call() => repository.getPosts();
}