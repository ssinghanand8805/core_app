import '../../domain/entities/payment_entity.dart';

class PaymentModel extends PaymentEntity {
  const PaymentModel({
    required super.id,
    required super.userId,
    required super.amount,
    required super.status,
    required super.method,
    required super.paidAt,
  });

  factory PaymentModel.fromJson(Map<String, dynamic> json) => PaymentModel(
        id: json['id'] as int,
        userId: json['userId'] as int,
        amount: (json['amount'] as num).toDouble(),
        status: json['status'] as String,
        method: json['method'] as String,
        paidAt: json['paidAt'] as String,
      );

  static List<PaymentModel> mockList() => [
        const PaymentModel(
            id: 1,
            userId: 3,
            amount: 2999,
            status: 'paid',
            method: 'UPI',
            paidAt: '2025-01-01'),
        const PaymentModel(
            id: 2,
            userId: 4,
            amount: 1499,
            status: 'paid',
            method: 'Card',
            paidAt: '2025-02-01'),
        const PaymentModel(
            id: 3,
            userId: 5,
            amount: 4999,
            status: 'unpaid',
            method: 'Cash',
            paidAt: ''),
        const PaymentModel(
            id: 4,
            userId: 3,
            amount: 2999,
            status: 'paid',
            method: 'UPI',
            paidAt: '2025-02-01'),
        const PaymentModel(
            id: 5,
            userId: 6,
            amount: 1999,
            status: 'pending',
            method: 'Online',
            paidAt: ''),
      ];
}
