import 'package:get/get.dart';
import 'admin_binding.dart';
import 'trainer_binding.dart';

class AdminDashboardBinding extends Bindings {
  @override
  void dependencies() {
    AdminBinding().dependencies();
    TrainerBinding().dependencies();
  }
}