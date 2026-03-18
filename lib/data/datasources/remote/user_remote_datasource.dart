import '../../../core/network/dio_client.dart';
import '../../../core/network/api_endpoints.dart';
import '../../../core/error/exceptions.dart';
import '../../models/user_model.dart';

abstract class UserRemoteDataSource {
  Future<List<UserModel>> getUsers();
  Future<UserModel> getUserById(int id);
}

class UserRemoteDataSourceImpl implements UserRemoteDataSource {
  final _dio = DioClient.instance.dio;

  @override
  Future<List<UserModel>> getUsers() async {
    final response = await _dio.get(ApiEndpoints.users);
    if (response.statusCode == 200) {
      return (response.data as List).map((e) => UserModel.fromJson(e)).toList();
    }
    throw ServerException(message: 'Failed to load users', statusCode: response.statusCode);
  }

  @override
  Future<UserModel> getUserById(int id) async {
    final response = await _dio.get(ApiEndpoints.userById(id));
    if (response.statusCode == 200) {
      return UserModel.fromJson(response.data);
    }
    throw ServerException(message: 'Failed to load user', statusCode: response.statusCode);
  }
}