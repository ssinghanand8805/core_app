import '../repositories/auth_repository.dart';

class ResetPassword {
  final AuthRepository repository;
  ResetPassword(this.repository);
  Future<void> call({required String email, required String otp, required String newPassword}) =>
      repository.resetPassword(email: email, otp: otp, newPassword: newPassword);
}