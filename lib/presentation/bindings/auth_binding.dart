import 'package:get/get.dart';
import '../../data/datasources/remote/auth_remote_datasource.dart';
import '../../data/repositories/auth_repository_impl.dart';
import '../../domain/repositories/auth_repository.dart';
import '../../domain/usecases/forgot_password.dart';
import '../../domain/usecases/login.dart';
import '../../domain/usecases/logout.dart';
import '../../domain/usecases/reset_password.dart';
import '../../domain/usecases/verify_otp.dart';
import '../../presentation/controllers/auth_controller.dart';

class AuthBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AuthRepository>(
          () => AuthRepositoryImpl(remote: AuthRemoteDataSourceImpl()),
    );
    Get.lazyPut(
          () => AuthController(
        loginUseCase:          Login(Get.find()),
        logoutUseCase:         Logout(Get.find()),
        forgotPasswordUseCase: ForgotPassword(Get.find()),
        verifyOtpUseCase:      VerifyOtp(Get.find()),
        resetPasswordUseCase:  ResetPassword(Get.find()),
      ),
    );
  }
}