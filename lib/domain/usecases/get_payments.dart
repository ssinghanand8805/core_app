import '../entities/payment_entity.dart';
import '../repositories/admin_repository.dart';

class GetAllPayments {
  final AdminRepository repository;
  GetAllPayments(this.repository);
  Future<List<PaymentEntity>> call() => repository.getAllPayments();
}
