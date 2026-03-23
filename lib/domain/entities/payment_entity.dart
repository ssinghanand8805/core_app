class PaymentEntity {
  final int id;
  final int userId;
  final double amount;
  final String status;
  final String method;
  final String paidAt;

  const PaymentEntity({
    required this.id,
    required this.userId,
    required this.amount,
    required this.status,
    required this.method,
    required this.paidAt,
  });
}
