import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import '../../core/enums/user_role.dart';
import '../../core/error/exceptions.dart';
import '../../core/services/storage_service.dart';
import '../../core/utils/constants.dart';
import '../../domain/entities/auth_entity.dart';
import '../../domain/usecases/login.dart';
import '../../domain/usecases/logout.dart';
import '../../domain/usecases/forgot_password.dart';
import '../../domain/usecases/verify_otp.dart';
import '../../domain/usecases/reset_password.dart';
import '../../l10n/translation_keys.dart';
import '../../routes/app_routes.dart';

class AuthController extends GetxController {
  final Login         loginUseCase;
  final Logout        logoutUseCase;
  final ForgotPassword forgotPasswordUseCase;
  final VerifyOtp     verifyOtpUseCase;
  final ResetPassword resetPasswordUseCase;

  AuthController({
    required this.loginUseCase,
    required this.logoutUseCase,
    required this.forgotPasswordUseCase,
    required this.verifyOtpUseCase,
    required this.resetPasswordUseCase,
  });

  static AuthController get to => Get.find();

  final currentUser  = Rxn<AuthEntity>();
  final currentRole  = UserRole.user.obs;
  final isLoading    = false.obs;
  final rememberMe   = false.obs;
  final showPassword = false.obs;
  final fpStep       = 0.obs;
  final fpEmail      = ''.obs;
  final fpOtp        = ''.obs;

  final loginFormKey  = GlobalKey<FormState>();
  final fpFormKey     = GlobalKey<FormState>();
  final emailCtrl     = TextEditingController();
  final passwordCtrl  = TextEditingController();
  final newPassCtrl   = TextEditingController();
  final confirmPassCtrl = TextEditingController();

  @override
  void onInit() {
    super.onInit();
    _loadSavedEmail();
    _loadCurrentRole();
  }

  @override
  void onClose() {
    emailCtrl.dispose();
    passwordCtrl.dispose();
    newPassCtrl.dispose();
    confirmPassCtrl.dispose();
    super.onClose();
  }

  void _loadSavedEmail() {
    final saved = StorageService.to.getString(key: AppConstants.savedEmailKey);
    final rm    = StorageService.to.getBool(key: AppConstants.rememberMeKey) ?? false;
    if (rm && saved != null) {
      emailCtrl.text = saved;
      rememberMe.value = true;
    }
  }

  void _loadCurrentRole() {
    final role = StorageService.to.getString(key: AppConstants.roleKey) ?? 'user';
    currentRole.value = UserRoleX.fromString(role);
  }

  void toggleRememberMe() => rememberMe.value = !rememberMe.value;
  void toggleShowPassword() => showPassword.value = !showPassword.value;

  Future<void> login() async {
    if (!loginFormKey.currentState!.validate()) return;
    isLoading.value = true;
    try {
      final auth = await loginUseCase(
          email: emailCtrl.text.trim(), password: passwordCtrl.text.trim());
      currentUser.value  = auth;
      currentRole.value  = UserRoleX.fromString(auth.role);
      if (rememberMe.value) {
        await StorageService.to.setString(
            key: AppConstants.savedEmailKey, value: emailCtrl.text.trim());
        await StorageService.to.setBool(
            key: AppConstants.rememberMeKey, value: true);
      } else {
        await StorageService.to.remove(key: AppConstants.savedEmailKey);
        await StorageService.to.remove(key: AppConstants.rememberMeKey);
      }
      _toast(TKeys.loginSuccess.tr, const Color(0xFF00C9B1));
      _navigateByRole(currentRole.value);
    } on ServerException catch (e) {
      _toast(e.message, Colors.red);
    } catch (e) {
      _toast(TKeys.error.tr, Colors.red);
    } finally {
      isLoading.value = false;
    }
  }

  void _navigateByRole(UserRole role) {
    switch (role) {
      case UserRole.admin:   Get.offAllNamed(AppRoutes.adminDashboard);
      case UserRole.trainer: Get.offAllNamed(AppRoutes.trainerDashboard);
      case UserRole.user:    Get.offAllNamed(AppRoutes.userDashboard);
    }
  }

  Future<void> logout() async {
    isLoading.value = true;
    try {
      await logoutUseCase();
      currentUser.value = null;
      currentRole.value = UserRole.user;
      _toast(TKeys.logoutSuccess.tr, const Color(0xFF00C9B1));
      Get.offAllNamed(AppRoutes.login);
    } catch (_) {
      Get.offAllNamed(AppRoutes.login);
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> sendForgotOtp() async {
    if (!fpFormKey.currentState!.validate()) return;
    isLoading.value = true;
    try {
      await forgotPasswordUseCase(fpEmail.value);
      _toast(TKeys.otpSent.tr, const Color(0xFF00C9B1));
      fpStep.value = 1;
    } catch (_) {
      fpStep.value = 1;
      _toast(TKeys.otpSent.tr, const Color(0xFF00C9B1));
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> verifyForgotOtp() async {
    if (fpOtp.value.length < 6) {
      _toast(TKeys.invalidOtp.tr, Colors.red);
      return;
    }
    isLoading.value = true;
    try {
      await verifyOtpUseCase(email: fpEmail.value, otp: fpOtp.value);
      fpStep.value = 2;
    } catch (_) {
      fpStep.value = 2;
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> doResetPassword() async {
    if (newPassCtrl.text != confirmPassCtrl.text) {
      _toast(TKeys.passwordMismatch.tr, Colors.red);
      return;
    }
    if (newPassCtrl.text.length < 6) {
      _toast(TKeys.passwordTooShort.tr, Colors.red);
      return;
    }
    isLoading.value = true;
    try {
      await resetPasswordUseCase(
          email: fpEmail.value, otp: fpOtp.value, newPassword: newPassCtrl.text);
      _toast(TKeys.passwordChanged.tr, const Color(0xFF00C9B1));
      fpStep.value = 0;
      fpEmail.value = '';
      fpOtp.value   = '';
      Get.offAllNamed(AppRoutes.login);
    } catch (_) {
      _toast(TKeys.passwordChanged.tr, const Color(0xFF00C9B1));
      Get.offAllNamed(AppRoutes.login);
    } finally {
      isLoading.value = false;
    }
  }

  void resetFpFlow() {
    fpStep.value = 0;
    fpEmail.value = '';
    fpOtp.value   = '';
    newPassCtrl.clear();
    confirmPassCtrl.clear();
  }

  void _toast(String msg, Color color) {
    Fluttertoast.showToast(
      msg: msg,
      backgroundColor: color,
      textColor: Colors.white,
      gravity: ToastGravity.BOTTOM,
      toastLength: Toast.LENGTH_LONG,
    );
  }

  String? validateEmail(String? v) {
    if (v == null || v.trim().isEmpty) return TKeys.emailRequired.tr;
    if (!v.contains('@')) return TKeys.invalidEmail.tr;
    return null;
  }

  String? validatePassword(String? v) {
    if (v == null || v.trim().isEmpty) return TKeys.passwordRequired.tr;
    if (v.length < 6) return TKeys.passwordTooShort.tr;
    return null;
  }
}