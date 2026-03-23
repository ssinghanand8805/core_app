import '../repositories/auth_repository.dart';

class VerifyOtp {
  final AuthRepository repository;
  VerifyOtp(this.repository);
  Future<void> call({required String email, required String otp}) =>
      repository.verifyOtp(email: email, otp: otp);
}