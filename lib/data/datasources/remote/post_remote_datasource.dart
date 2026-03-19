import '../../../core/network/dio_client.dart';
import '../../../core/network/api_endpoints.dart';
import '../../../core/error/exceptions.dart';
import '../../models/post_model.dart';

abstract class PostRemoteDataSource {
  Future<List<PostModel>> getPosts();
  Future<PostModel> getPostById(int id);
  Future<PostModel> createPost(
      {required int userId, required String title, required String body});
  Future<PostModel> updatePost(
      {required int id, required String title, required String body});
  Future<void> deletePost(int id);
}

class PostRemoteDataSourceImpl implements PostRemoteDataSource {
  final _dio = DioClient.instance.dio;

  @override
  Future<List<PostModel>> getPosts() async {
    final res = await _dio.get(ApiEndpoints.posts);
    if (res.statusCode == 200) {
      return (res.data as List).map((e) => PostModel.fromJson(e)).toList();
    }
    throw ServerException(
        message: 'Failed to load posts', statusCode: res.statusCode);
  }

  @override
  Future<PostModel> getPostById(int id) async {
    final res = await _dio.get(ApiEndpoints.postById(id));
    if (res.statusCode == 200) return PostModel.fromJson(res.data);
    throw ServerException(
        message: 'Failed to load post', statusCode: res.statusCode);
  }

  @override
  Future<PostModel> createPost(
      {required int userId,
      required String title,
      required String body}) async {
    final res = await _dio.post(ApiEndpoints.posts, data: {
      'userId': userId,
      'title': title,
      'body': body,
    });
    if (res.statusCode == 201) return PostModel.fromJson(res.data);
    throw ServerException(
        message: 'Failed to create post', statusCode: res.statusCode);
  }

  @override
  Future<PostModel> updatePost(
      {required int id, required String title, required String body}) async {
    final res = await _dio.put(ApiEndpoints.postById(id), data: {
      'id': id,
      'title': title,
      'body': body,
    });
    if (res.statusCode == 200) return PostModel.fromJson(res.data);
    throw ServerException(
        message: 'Failed to update post', statusCode: res.statusCode);
  }

  @override
  Future<void> deletePost(int id) async {
    final res = await _dio.delete(ApiEndpoints.postById(id));
    if (res.statusCode != 200 && res.statusCode != 204) {
      throw ServerException(
          message: 'Failed to delete post', statusCode: res.statusCode);
    }
  }
}
