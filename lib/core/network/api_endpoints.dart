class ApiEndpoints {
  static const String posts = '/posts';
  static const String users = '/users';
  static const String comments = '/comments';

  static String postById(int id) => '/posts/$id';
  static String userById(int id) => '/users/$id';
}