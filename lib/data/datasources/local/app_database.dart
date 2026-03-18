import 'dart:io';
import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;

part 'app_database.g.dart';

class PostsTable extends Table {
  IntColumn get id     => integer()();
  IntColumn get userId => integer()();
  TextColumn get title => text()();
  TextColumn get body  => text()();

  @override
  Set<Column> get primaryKey => {id};
}

class UsersTable extends Table {
  IntColumn get id       => integer()();
  TextColumn get name    => text()();
  TextColumn get username => text()();
  TextColumn get email   => text()();
  TextColumn get phone   => text()();
  TextColumn get website => text()();

  @override
  Set<Column> get primaryKey => {id};
}

@DriftDatabase(tables: [PostsTable, UsersTable])
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());

  @override
  int get schemaVersion => 1;

  Future<List<PostsTableData>> getAllPosts() => select(postsTable).get();
  Future<void> insertPosts(List<PostsTableCompanion> posts) async {
    await batch((b) => b.insertAllOnConflictUpdate(postsTable, posts));
  }

  Future<List<UsersTableData>> getAllUsers() => select(usersTable).get();
  Future<void> insertUsers(List<UsersTableCompanion> users) async {
    await batch((b) => b.insertAllOnConflictUpdate(usersTable, users));
  }

  Future<void> clearPosts() => delete(postsTable).go();
  Future<void> clearUsers() => delete(usersTable).go();
}

LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    final dir = await getApplicationDocumentsDirectory();
    final file = File(p.join(dir.path, 'app_db.sqlite'));
    return NativeDatabase.createInBackground(file);
  });
}