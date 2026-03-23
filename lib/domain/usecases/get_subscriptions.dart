import '../entities/subscription_entity.dart';
import '../repositories/trainer_repository.dart';

class GetSubscriptions {
  final TrainerRepository repository;
  GetSubscriptions(this.repository);
  Future<List<SubscriptionEntity>> call() => repository.getSubscribedUsers();
}