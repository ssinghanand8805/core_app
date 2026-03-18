import '../../../core/network/dio_client.dart';
import '../../../core/network/api_endpoints.dart';
import '../../../core/error/exceptions.dart';
import '../../models/post_model.dart';

abstract class PostRemoteDataSource {
  Future<List<PostModel>> getPosts();
  Future<PostModel> getPostById(int id);
}

class PostRemoteDataSourceImpl implements PostRemoteDataSource {
  final _dio = DioClient.instance.dio;

  @override
  Future<List<PostModel>> getPosts() async {
    final response = await _dio.get(ApiEndpoints.posts);
    if (response.statusCode == 200) {
      return (response.data as List).map((e) => PostModel.fromJson(e)).toList();
    }
    throw ServerException(message: 'Failed to load posts', statusCode: response.statusCode);
  }

  @override
  Future<PostModel> getPostById(int id) async {
    final response = await _dio.get(ApiEndpoints.postById(id));
    if (response.statusCode == 200) {
      return PostModel.fromJson(response.data);
    }
    throw ServerException(message: 'Failed to load post', statusCode: response.statusCode);
  }
}