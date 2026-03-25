import 'package:get/get.dart';
import '../../data/datasources/local/app_database.dart';
import '../../data/datasources/local/user_local-datasource.dart';
import '../../data/datasources/remote/user_remote_datasource.dart';
import '../../data/repositories/user_repository_impl.dart';
import '../../domain/repositories/user_repository.dart';
import '../../domain/usecases/get_users.dart';
import '../../presentation/controllers/user_controller.dart';

class UserBinding extends Bindings {
  final AppDatabase db;
  UserBinding(this.db);

  @override
  void dependencies() {
    Get.lazyPut<UserRepository>(
          () => UserRepositoryImpl(
        remote: UserRemoteDataSourceImpl(),
        local:  UserLocalDataSourceImpl(db),
      ),
    );
    Get.lazyPut(() => UserController(getUsers: GetUsers(Get.find())));
  }
}