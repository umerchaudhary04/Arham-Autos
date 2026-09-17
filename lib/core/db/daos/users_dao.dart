import 'package:drift/drift.dart';
import '../database.dart';

part 'users_dao.g.dart';

@DriftAccessor(tables: [LocalUsers])
class UsersDao extends DatabaseAccessor<AppDatabase> with _$UsersDaoMixin {
  UsersDao(AppDatabase db) : super(db);

  Future<List<LocalUser>> getAllUsers() => select(localUsers).get();
  
  Future<int> insertUser(LocalUsersCompanion user) => into(localUsers).insert(user);
  
  Future<bool> updateUser(LocalUser user) => update(localUsers).replace(user);
  
  Future<int> deleteUser(String id) => (delete(localUsers)..where((u) => u.id.equals(id))).go();
}
