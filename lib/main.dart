import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:get/get.dart';

import 'core/services/app_theme.dart';
import 'core/services/connectivity_service.dart';
import 'core/services/storage_service.dart';
import 'core/services/theme_service.dart';
import 'core/utils/constants.dart';
import 'l10n/app_translations.dart';
import 'routes/app_pages.dart';
import 'routes/app_routes.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  try {
    await Get.putAsync(() => StorageService().init());
    await Get.putAsync(() => ThemeService().init());
    await Get.putAsync(() => ConnectivityService().init());
  } catch (e) {
    debugPrint("Service init error: $e");
  }

  final savedLocale =
  StorageService.to.getString(key: AppConstants.localeKey);

  runApp(MyApp(initialLocale: _resolveLocale(savedLocale)));
}

/// Clean locale resolver
Locale _resolveLocale(String? code) {
  if (code == null) return const Locale('en', 'US');
  return Locale(code);
}

class MyApp extends StatelessWidget {
  final Locale initialLocale;

  const MyApp({super.key, required this.initialLocale});

  @override
  Widget build(BuildContext context) {
    final themeService = ThemeService.to;

    return GetMaterialApp(
      title: 'Scalable App',
      debugShowCheckedModeBanner: false,

      /// Theme
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: themeService.themeMode,

      /// Localization
      translations: AppTranslations(),
      locale: Get.locale ?? initialLocale,
      fallbackLocale: const Locale('en', 'US'),

      supportedLocales: const [
        Locale('en', 'US'),
        Locale('hi'),
        Locale('ar'),
        Locale('ur'),
      ],

      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],

      /// Routing
      initialRoute: AppRoutes.dashboard,
      getPages: appPages,

      /// Navigation animation
      defaultTransition: Transition.cupertino,
      transitionDuration: const Duration(milliseconds: 300),
    );
  }
}