import 'package:drift/drift.dart';

import '../../core/error/exceptions.dart';
import '../../core/services/connectivity_service.dart';
import '../../domain/entities/user_entity.dart';
import '../../domain/repositories/user_repository.dart';
import '../datasources/local/app_database.dart';
import '../datasources/local/user_local-datasource.dart';
import '../datasources/remote/user_remote_datasource.dart';
import '../models/user_model.dart';

class UserRepositoryImpl implements UserRepository {
  final UserRemoteDataSource remote;
  final UserLocalDataSource local;

  UserRepositoryImpl({required this.remote, required this.local});

  @override
  Future<List<UserEntity>> getUsers() async {
    if (ConnectivityService.to.isConnected) {
      final models = await remote.getUsers();
      await local.cacheUsers(models.map((m) => UsersTableCompanion.insert(
        id: Value(m.id), name: m.name, username: m.username,
        email: m.email, phone: m.phone, website: m.website,
      )).toList());
      return models;
    } else {
      final cached = await local.getCachedUsers();
      if (cached.isEmpty) throw CacheException(message: 'No cached users');
      return cached.map((c) => UserModel(
        id: c.id, name: c.name, username: c.username,
        email: c.email, phone: c.phone, website: c.website,
      )).toList();
    }
  }

  @override
  Future<UserEntity> getUserById(int id) => remote.getUserById(id);
}