import '../../domain/entities/trainer_entity.dart';

class TrainerModel extends TrainerEntity {
  const TrainerModel({
    required super.id,
    required super.name,
    required super.email,
    required super.specialty,
    required super.phone,
  });

  factory TrainerModel.fromJson(Map<String, dynamic> json) => TrainerModel(
        id: json['id'] as int,
        name: json['name'] as String,
        email: json['email'] as String,
        specialty: json['specialty'] as String? ?? 'General Fitness',
        phone: json['phone'] as String? ?? '',
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'email': email,
        'specialty': specialty,
        'phone': phone,
      };

  static List<TrainerModel> mockList() => [
        const TrainerModel(
            id: 1,
            name: 'Rahul Sharma',
            email: 'rahul@gym.com',
            specialty: 'Strength & Conditioning',
            phone: '9876543210'),
        const TrainerModel(
            id: 2,
            name: 'Priya Verma',
            email: 'priya@gym.com',
            specialty: 'Yoga & Flexibility',
            phone: '9876543211'),
        const TrainerModel(
            id: 3,
            name: 'Ahmed Khan',
            email: 'ahmed@gym.com',
            specialty: 'HIIT & Cardio',
            phone: '9876543212'),
      ];
}
