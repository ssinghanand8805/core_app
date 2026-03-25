import 'package:get/get.dart';
import '../../data/datasources/local/app_database.dart';
import '../../data/datasources/local/post_local_datasource.dart';
import '../../data/datasources/remote/post_remote_datasource.dart';
import '../../data/repositories/post_repository_impl.dart';
import '../../domain/repositories/post_repository.dart';
import '../../domain/usecases/create_post.dart';
import '../../domain/usecases/delete_post.dart';
import '../../domain/usecases/get_posts.dart';
import '../../domain/usecases/update_post.dart';
import '../../presentation/controllers/post_controller.dart';

class PostBinding extends Bindings {
  final AppDatabase db;
  PostBinding(this.db);

  @override
  void dependencies() {
    Get.lazyPut<PostRepository>(
          () => PostRepositoryImpl(
        remote: PostRemoteDataSourceImpl(),
        local:  PostLocalDataSourceImpl(db),
      ),
    );
    Get.lazyPut(
          () => PostController(
        getPosts:   GetPosts(Get.find()),
        createPost: CreatePost(Get.find()),
        updatePost: UpdatePost(Get.find()),
        deletePost: DeletePost(Get.find()),
      ),
    );
  }
}