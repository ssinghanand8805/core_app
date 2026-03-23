class SubscriptionEntity {
  final int id;
  final int userId;
  final int trainerId;
  final String plan;
  final String startDate;
  final String endDate;
  final String status;

  const SubscriptionEntity({
    required this.id,
    required this.userId,
    required this.trainerId,
    required this.plan,
    required this.startDate,
    required this.endDate,
    required this.status,
  });
}
