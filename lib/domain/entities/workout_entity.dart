class WorkoutEntity {
  final int    id;
  final int    userId;
  final int    trainerId;
  final String title;
  final String description;
  final String scheduledAt;
  final String status;

  const WorkoutEntity({
    required this.id,
    required this.userId,
    required this.trainerId,
    required this.title,
    required this.description,
    required this.scheduledAt,
    required this.status,
  });
}