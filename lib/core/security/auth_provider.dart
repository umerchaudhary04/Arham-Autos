import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/db/database.dart';

class DatabaseNotifier extends Notifier<AppDatabase?> {
  @override
  AppDatabase? build() => null;
  void setDatabase(AppDatabase db) => state = db;
}

final databaseProvider = NotifierProvider<DatabaseNotifier, AppDatabase?>(
  () => DatabaseNotifier(),
);

// Model for the authenticated user
class AuthState {
  final LocalUser? user;
  final bool isLocked;

  const AuthState({this.user, this.isLocked = true});

  AuthState copyWith({LocalUser? user, bool? isLocked}) {
    return AuthState(
      user: user ?? this.user,
      isLocked: isLocked ?? this.isLocked,
    );
  }
}

class AuthNotifier extends Notifier<AuthState> {
  @override
  AuthState build() {
    return const AuthState();
  }

  Future<bool> loginWithPin(String pin) async {
    final db = ref.read(databaseProvider);
    if (db == null) return false;

    // In a real implementation we'd hash the pin and compare.
    // For now we'll do a mock verification.
    final users = await db.select(db.localUsers).get();
    final user = users.where((u) => u.pinHash == pin).firstOrNull;

    if (user != null) {
      state = AuthState(user: user, isLocked: false);
      return true;
    }
    return false;
  }

  Future<bool> loginWithPassword(String username, String password) async {
    final db = ref.read(databaseProvider);
    if (db == null) return false;

    // In a real implementation we'd hash the password.
    final users = await db.select(db.localUsers).get();
    final user = users
        .where((u) => u.username == username && u.passwordHash == password)
        .firstOrNull;

    if (user != null) {
      state = AuthState(user: user, isLocked: false);
      return true;
    }
    return false;
  }

  void logout() {
    state = const AuthState(user: null, isLocked: true);
  }

  void lock() {
    state = state.copyWith(isLocked: true);
  }

  void switchUser() {
    // which effectively acts as locked, waiting for another PIN.
    // Parked cart logic will be triggered by UI/Flow.
    state = const AuthState(user: null, isLocked: true);
  }

  void updateUserLanguage(String lang) {
    if (state.user != null) {
      state = AuthState(isLocked: state.isLocked, user: state.user!.copyWith(preferredLanguage: lang));
    }
  }
}

final authProvider = NotifierProvider<AuthNotifier, AuthState>(
  () => AuthNotifier(),
);
