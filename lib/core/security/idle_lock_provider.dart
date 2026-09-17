import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'auth_provider.dart';

class IdleLockNotifier extends Notifier<int> {
  Timer? _timer;
  
  @override
  int build() {
    return 300; // Default 5 minutes (300 seconds)
  }

  void updateTimeout(int seconds) {
    state = seconds;
    resetTimer();
  }

  void resetTimer() {
    _timer?.cancel();
    // Only run the timer if the user is currently authenticated and unlocked
    final authState = ref.read(authProvider);
    if (authState.user != null && !authState.isLocked) {
      _timer = Timer(Duration(seconds: state), () {
        ref.read(authProvider.notifier).lock();
      });
    }
  }

  void stopTimer() {
    _timer?.cancel();
  }
}

final idleLockProvider = NotifierProvider<IdleLockNotifier, int>(() => IdleLockNotifier());
