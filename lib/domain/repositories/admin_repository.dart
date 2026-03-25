import '../entities/user_entity.dart';
import '../entities/trainer_entity.dart';
import '../entities/payment_entity.dart';
import '../entities/subscription_entity.dart';

abstract class AdminRepository {
  Future<List<UserEntity>>         getAllUsers();
  Future<List<TrainerEntity>>      getAllTrainers();
  Future<List<PaymentEntity>>      getAllPayments();
  Future<List<SubscriptionEntity>> getAllSubscriptions();
  Future<void>                     addTrainer(TrainerEntity trainer);
  Future<void>                     deleteTrainer(int id);
  Future<void>                     deleteUser(int id);
}