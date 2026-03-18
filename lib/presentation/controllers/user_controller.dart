import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '../../core/error/exceptions.dart';
import '../../core/services/connectivity_service.dart';
import '../../domain/entities/user_entity.dart';
import '../../domain/usecases/get_users.dart';
import '../../l10n/translation_keys.dart';

class UserController extends GetxController {
  final GetUsers getUsers;
  UserController({required this.getUsers});

  final users = <UserEntity>[].obs;
  final isLoading = false.obs;
  final isOffline = false.obs;
  final errorMessage = ''.obs;

  @override
  void onInit() {
    super.onInit();
    fetchUsers();
  }

  Future<void> fetchUsers() async {
    isLoading.value = true;
    errorMessage.value = '';
    isOffline.value = !ConnectivityService.to.isConnected;

    try {
      users.value = await getUsers();
    } on NetworkException catch (e) {
      errorMessage.value = e.message;
      _showToast(TKeys.networkError.tr, Colors.orange);
    } on ServerException catch (e) {
      errorMessage.value = e.message;
      _showToast(TKeys.serverError.tr, Colors.red);
    } on CacheException catch (e) {
      errorMessage.value = e.message;
      _showToast(TKeys.noData.tr, Colors.grey);
    } catch (e) {
      errorMessage.value = e.toString();
      _showToast(TKeys.error.tr, Colors.red);
    } finally {
      isLoading.value = false;
    }
  }

  void _showToast(String msg, Color color) {
    Fluttertoast.showToast(
      msg: msg,
      backgroundColor: color,
      textColor: Colors.white,
      gravity: ToastGravity.BOTTOM,
      toastLength: Toast.LENGTH_LONG,
    );
  }
}
