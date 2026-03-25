import '../../domain/entities/trainer_entity.dart';
import '../../domain/entities/user_entity.dart';
import '../../domain/entities/payment_entity.dart';
import '../../domain/entities/subscription_entity.dart';
import '../../domain/repositories/admin_repository.dart';
import '../datasources/remote/admin_remote_datasource.dart';
import '../models/trainer_model.dart';

class AdminRepositoryImpl implements AdminRepository {
  final AdminRemoteDataSource remote;
  AdminRepositoryImpl({required this.remote});

  @override
  Future<List<UserEntity>> getAllUsers() => remote.getAllUsers();
  @override
  Future<List<TrainerEntity>> getAllTrainers() => remote.getAllTrainers();
  @override
  Future<List<PaymentEntity>> getAllPayments() => remote.getAllPayments();
  @override
  Future<List<SubscriptionEntity>> getAllSubscriptions() =>
      remote.getAllSubscriptions();

  @override
  Future<void> addTrainer(TrainerEntity trainer) =>
      remote.addTrainer((trainer as TrainerModel).toJson());

  @override
  Future<void> deleteTrainer(int id) => remote.deleteTrainer(id);

  @override
  Future<void> deleteUser(int id) => remote.deleteUser(id);
}
