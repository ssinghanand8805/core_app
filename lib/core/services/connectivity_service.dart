import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:get/get.dart';
import '../utils/logger.dart';

class ConnectivityService extends GetxService {
  static ConnectivityService get to => Get.find();
  final _isConnected = true.obs;

  bool get isConnected => _isConnected.value;

  Future<ConnectivityService> init() async {
    final result = await Connectivity().checkConnectivity();
    _updateStatus(result);
    Connectivity().onConnectivityChanged.listen(_updateStatus);
    return this;
  }

  void _updateStatus(List<ConnectivityResult> results) {
    _isConnected.value = results.any((r) => r != ConnectivityResult.none);
    AppLogger.info('Connectivity: ${_isConnected.value ? "Online" : "Offline"}');
  }
}