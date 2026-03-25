import 'package:get/get.dart';
import '../../data/datasources/remote/admin_remote_datasource.dart';
import '../../data/repositories/admin_repository_impl.dart';
import '../../domain/repositories/admin_repository.dart';
import '../../domain/usecases/add_trainer.dart';
import '../../domain/usecases/delete_trainer.dart';
import '../../domain/usecases/delete_user.dart';
import '../../domain/usecases/get_all_payments.dart';
import '../../domain/usecases/get_all_trainers.dart';
import '../../domain/usecases/get_all_users.dart';
import '../../domain/usecases/get_payments.dart';
import '../../domain/usecases/get_subscriptions.dart';
import '../../presentation/controllers/admin_controller.dart';

class AdminBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AdminRepository>(
          () => AdminRepositoryImpl(remote: AdminRemoteDataSourceImpl()),
    );
    Get.lazyPut(
          () => AdminController(
        getAllUsersUseCase:         GetAllUsers(Get.find()),
        getAllTrainersUseCase:      GetAllTrainers(Get.find()),
        getAllPaymentsUseCase:      GetAllPayments(Get.find()),
        getAllSubscriptionsUseCase: GetSubscriptions(Get.find()),
        addTrainerUseCase:         AddTrainer(Get.find()),
        deleteTrainerUseCase:      DeleteTrainer(Get.find()),
        deleteUserUseCase:         DeleteUser(Get.find()),
      ),
    );
  }
}