import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:get/get.dart';
import 'core/enums/user_role.dart';
import 'core/services/app_theme.dart';
import 'core/services/connectivity_service.dart';
import 'core/services/storage_service.dart';
import 'core/services/theme_service.dart';
import 'core/utils/constants.dart';
import 'data/datasources/remote/auth_remote_datasource.dart';
import 'data/repositories/auth_repository_impl.dart';
import 'domain/usecases/forgot_password.dart';
import 'domain/usecases/login.dart';
import 'domain/usecases/logout.dart';
import 'domain/usecases/reset_password.dart';
import 'domain/usecases/verify_otp.dart';
import 'l10n/app_translations.dart';
import 'presentation/controllers/auth_controller.dart';
import 'routes/app_pages.dart';
import 'routes/app_routes.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Get.putAsync(() => StorageService().init());
  await Get.putAsync(() => ThemeService().init());
  await Get.putAsync(() => ConnectivityService().init());

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

  String startRoute = AppRoutes.login;
  if (isLoggedIn) {
    switch (role) {
      case UserRole.admin:
        startRoute = AppRoutes.adminDashboard;
      case UserRole.trainer:
        startRoute = AppRoutes.trainerDashboard;
      case UserRole.user:
        startRoute = AppRoutes.userDashboard;
    }
  }

  final savedLocale = StorageService.to.getString(key: AppConstants.localeKey);
  final locale = _resolveLocale(savedLocale);

  runApp(MyApp(initialLocale: locale, initialRoute: startRoute));
}

Locale _resolveLocale(String? code) {
  switch (code) {
    case 'hi':
      return const Locale('hi', 'IN');
    case 'ar':
      return const Locale('ar', 'SA');
    case 'ur':
      return const Locale('ur', 'PK');
    default:
      return const Locale('en', 'US');
  }
}

class MyApp extends StatelessWidget {
  final Locale initialLocale;
  final String initialRoute;
  const MyApp(
      {super.key, required this.initialLocale, required this.initialRoute});

  @override
  Widget build(BuildContext context) {
    return Obx(() => GetMaterialApp(
          title: 'FitPro',
          debugShowCheckedModeBanner: false,
          theme: AppTheme.lightTheme,
          darkTheme: AppTheme.darkTheme,
          themeMode: ThemeService.to.themeMode,
          translations: AppTranslations(),
          locale: initialLocale,
          fallbackLocale: const Locale('en', 'US'),
          localizationsDelegates: const [
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          supportedLocales: const [
            Locale('en', 'US'),
            Locale('hi', 'IN'),
            Locale('ar', 'SA'),
            Locale('ur', 'PK'),
          ],
          initialRoute: initialRoute,
          getPages: appPages,
          defaultTransition: Transition.cupertino,
          transitionDuration: const Duration(milliseconds: 300),
        ));
  }
}
