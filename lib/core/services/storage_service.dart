import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class StorageService extends GetxService {
  static StorageService get to => Get.find();
  late SharedPreferences _prefs;

  Future<StorageService> init() async {
    _prefs = await SharedPreferences.getInstance();
    return this;
  }

  Future<void> setString({required String key, required String value}) async {
    await _prefs.setString(key, value);
  }

  String? getString({required String key}) => _prefs.getString(key);

  Future<void> setBool({required String key, required bool value}) async {
    await _prefs.setBool(key, value);
  }

  bool? getBool({required String key}) => _prefs.getBool(key);

  Future<void> remove({required String key}) async {
    await _prefs.remove(key);
  }

  Future<void> clearAll() async {
    await _prefs.clear();
  }
}