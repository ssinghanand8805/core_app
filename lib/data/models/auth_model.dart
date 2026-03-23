import '../../domain/entities/auth_entity.dart';

class AuthModel extends AuthEntity {
  const AuthModel({
    required super.id,
    required super.name,
    required super.email,
    required super.token,
    required super.role,
  });

  factory AuthModel.fromJson(Map<String, dynamic> json) {
    final user = json['user'] as Map<String, dynamic>? ?? json;
    return AuthModel(
      id: user['id'] as int,
      name: user['name'] as String,
      email: user['email'] as String,
      token: json['token'] as String? ?? '',
      role: user['role'] as String? ?? 'user',
    );
  }

  factory AuthModel.mock({required String email, required String role}) =>
      AuthModel(
          id: 1,
          name: 'Demo ${role}',
          email: email,
          token: 'mock_token_123',
          role: role);
}
