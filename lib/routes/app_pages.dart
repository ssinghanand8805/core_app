import 'package:get/get.dart';
import '../data/datasources/local/app_database.dart';
import '../data/datasources/local/post_local_datasource.dart';
import '../data/datasources/local/user_local-datasource.dart';
import '../data/datasources/remote/post_remote_datasource.dart';
import '../data/datasources/remote/user_remote_datasource.dart';
import '../data/repositories/post_repository_impl.dart';
import '../data/repositories/user_repository_impl.dart';
import '../domain/repositories/post_repository.dart';
import '../domain/repositories/user_repository.dart';
import '../domain/usecases/get_posts.dart';
import '../domain/usecases/get_users.dart';
import '../presentation/controllers/post_controller.dart';
import '../presentation/controllers/user_controller.dart';
import '../presentation/pages/dashboard_page.dart';
import '../presentation/pages/posts_page.dart';
import '../presentation/pages/settings-page.dart';
import '../presentation/pages/users_page.dart';
import 'app_routes.dart';

final _db = AppDatabase();

List<GetPage> get appPages => [
  GetPage(
    name: AppRoutes.dashboard,
    page: () => const DashboardPage(),
    binding: BindingsBuilder(() {
      Get.lazyPut<PostRepository>(() => PostRepositoryImpl(
        remote: PostRemoteDataSourceImpl(),
        local: PostLocalDataSourceImpl(_db),
      ));

      Get.lazyPut<UserRepository>(() => UserRepositoryImpl(
        remote: UserRemoteDataSourceImpl(),
        local: UserLocalDataSourceImpl(_db),
      ));

      Get.lazyPut(() => GetPosts(Get.find<PostRepository>()));
      Get.lazyPut(() => GetUsers(Get.find<UserRepository>()));

      Get.lazyPut(() => PostController(getPosts: Get.find()));
      Get.lazyPut(() => UserController(getUsers: Get.find()));
    }),
  ),
  GetPage(
    name: AppRoutes.posts,
    page: () => const PostsPage(),

  ),
  GetPage(
    name: AppRoutes.users,
    page: () => const UsersPage(),
  ),
  GetPage(
    name: AppRoutes.settings,
    page: () => const SettingsPage(),
  ),
];