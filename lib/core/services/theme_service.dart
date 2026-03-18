import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../utils/constants.dart';
import 'storage_service.dart';

class ThemeService extends GetxService {
  static ThemeService get to => Get.find();
  final _themeMode = ThemeMode.system.obs;

  ThemeMode get themeMode => _themeMode.value;
  bool get isDark => _themeMode.value == ThemeMode.dark ||
      (_themeMode.value == ThemeMode.system &&
          WidgetsBinding.instance.platformDispatcher.platformBrightness == Brightness.dark);

  Future<ThemeService> init() async {
    final saved = StorageService.to.getString(key: AppConstants.themeKey);
    if (saved == 'dark') {
      _themeMode.value = ThemeMode.dark;
    } else if (saved == 'light') {
      _themeMode.value = ThemeMode.light;
    } else {
      _themeMode.value = ThemeMode.system;
    }
    return this;
  }

  void setTheme(ThemeMode mode) {
    _themeMode.value = mode;
    Get.changeThemeMode(mode);
    final key = mode == ThemeMode.dark ? 'dark' : mode == ThemeMode.light ? 'light' : 'system';
    StorageService.to.setString(key: AppConstants.themeKey, value: key);
  }

  void toggleTheme() {
    setTheme(isDark ? ThemeMode.light : ThemeMode.dark);
  }
}