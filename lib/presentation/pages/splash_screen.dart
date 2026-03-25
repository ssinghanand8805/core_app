import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../core/enums/user_role.dart';
import '../../data/datasources/remote/auth_remote_datasource.dart';
import '../../domain/usecases/forgot_password.dart';
import '../../domain/usecases/login.dart';
import '../../domain/usecases/logout.dart';
import '../../domain/usecases/reset_password.dart';
import '../../domain/usecases/verify_otp.dart';
import '../../routes/app_routes.dart';
import '../../data/repositories/auth_repository_impl.dart';
import '../controllers/auth_controller.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {

  @override
  void initState() {
    super.initState();
    _navigate();
  }

  Future<void> _navigate() async {
    await Future.delayed(const Duration(seconds: 2));

    final authRepo = AuthRepositoryImpl(remote: AuthRemoteDataSourceImpl());

    Get.put(AuthController(
      loginUseCase: Login(authRepo),
      logoutUseCase: Logout(authRepo),
      forgotPasswordUseCase: ForgotPassword(authRepo),
      verifyOtpUseCase: VerifyOtp(authRepo),
      resetPasswordUseCase: ResetPassword(authRepo),
    ));

    final isLoggedIn = await authRepo.isLoggedIn();
    final role = await authRepo.getCurrentRole();

    if (!isLoggedIn) {
      Get.offAllNamed(AppRoutes.login);
      return;
    }

    switch (role) {
      case UserRole.admin:
        Get.offAllNamed(AppRoutes.adminDashboard);
        break;
      case UserRole.trainer:
        Get.offAllNamed(AppRoutes.trainerDashboard);
        break;
      case UserRole.user:
        Get.offAllNamed(AppRoutes.userDashboard);
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Theme.of(context).colorScheme.primary,
              Colors.black,
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: const Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Logo
            Icon(
              Icons.fitness_center,
              size: 80,
              color: Colors.white,
            ),
            SizedBox(height: 20),

            // App Name
            Text(
              "FitPro",
              style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
                color: Colors.white,
                letterSpacing: 1.2,
              ),
            ),

            SizedBox(height: 10),

            Text(
              "Train Hard. Stay Strong.",
              style: TextStyle(
                color: Colors.white70,
                fontSize: 14,
              ),
            ),

            SizedBox(height: 40),

            CircularProgressIndicator(color: Colors.white),
          ],
        ),
      ),
    );
  }
}