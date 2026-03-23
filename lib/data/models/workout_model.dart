import '../../domain/entities/workout_entity.dart';

class WorkoutModel extends WorkoutEntity {
  const WorkoutModel({
    required super.id,
    required super.userId,
    required super.trainerId,
    required super.title,
    required super.description,
    required super.scheduledAt,
    required super.status,
  });

  factory WorkoutModel.fromJson(Map<String, dynamic> json) => WorkoutModel(
        id: json['id'] as int,
        userId: json['userId'] as int,
        trainerId: json['trainerId'] as int,
        title: json['title'] as String,
        description: json['description'] as String,
        scheduledAt: json['scheduledAt'] as String,
        status: json['status'] as String? ?? 'pending',
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'userId': userId,
        'trainerId': trainerId,
        'title': title,
        'description': description,
        'scheduledAt': scheduledAt,
        'status': status,
      };

  static List<WorkoutModel> mockList(int trainerId) => [
        WorkoutModel(
            id: 1,
            userId: 3,
            trainerId: trainerId,
            title: 'Morning HIIT',
            description: '30 min high intensity cardio',
            scheduledAt: '2025-02-10 07:00',
            status: 'pending'),
        WorkoutModel(
            id: 2,
            userId: 4,
            trainerId: trainerId,
            title: 'Strength Training',
            description: 'Upper body push/pull',
            scheduledAt: '2025-02-11 09:00',
            status: 'completed'),
        WorkoutModel(
            id: 3,
            userId: 5,
            trainerId: trainerId,
            title: 'Core & Flexibility',
            description: 'Yoga + core circuit',
            scheduledAt: '2025-02-12 06:00',
            status: 'pending'),
      ];
}
