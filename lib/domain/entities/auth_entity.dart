class AuthEntity {
  final int id;
  final String name;
  final String email;
  final String token;
  final String role;

  const AuthEntity({
    required this.id,
    required this.name,
    required this.email,
    required this.token,
    required this.role,
  });
}
