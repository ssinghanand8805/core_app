import '../../domain/entities/subscription_entity.dart';

class SubscriptionModel extends SubscriptionEntity {
  const SubscriptionModel({
    required super.id,
    required super.userId,
    required super.trainerId,
    required super.plan,
    required super.startDate,
    required super.endDate,
    required super.status,
  });

  factory SubscriptionModel.fromJson(Map<String, dynamic> json) =>
      SubscriptionModel(
        id: json['id'] as int,
        userId: json['userId'] as int,
        trainerId: json['trainerId'] as int,
        plan: json['plan'] as String,
        startDate: json['startDate'] as String,
        endDate: json['endDate'] as String,
        status: json['status'] as String,
      );

  static List<SubscriptionModel> mockList() => [
        const SubscriptionModel(
            id: 1,
            userId: 3,
            trainerId: 2,
            plan: 'Premium',
            startDate: '2025-01-01',
            endDate: '2025-03-31',
            status: 'active'),
        const SubscriptionModel(
            id: 2,
            userId: 4,
            trainerId: 2,
            plan: 'Basic',
            startDate: '2025-02-01',
            endDate: '2025-02-28',
            status: 'expired'),
        const SubscriptionModel(
            id: 3,
            userId: 5,
            trainerId: 2,
            plan: 'Elite',
            startDate: '2025-01-15',
            endDate: '2025-04-15',
            status: 'active'),
      ];
}
