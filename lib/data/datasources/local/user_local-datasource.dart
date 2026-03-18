import 'app_database.dart';

abstract class UserLocalDataSource {
  Future<List<UsersTableData>> getCachedUsers();
  Future<void> cacheUsers(List<UsersTableCompanion> users);
}

class UserLocalDataSourceImpl implements UserLocalDataSource {
  final AppDatabase db;
  UserLocalDataSourceImpl(this.db);

  @override
  Future<List<UsersTableData>> getCachedUsers() => db.getAllUsers();

  @override
  Future<void> cacheUsers(List<UsersTableCompanion> users) => db.insertUsers(users);
}