import 'package:get/get.dart';
import 'trainer_binding.dart';

class UserDashboardBinding extends Bindings {
  @override
  void dependencies() {
    TrainerBinding().dependencies();
  }
}