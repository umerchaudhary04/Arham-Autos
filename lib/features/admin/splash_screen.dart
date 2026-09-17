import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/security/encryption_key_store.dart';
import '../../core/db/database.dart';
import '../../core/security/auth_provider.dart';
import '../../main.dart';

class SplashScreen extends ConsumerStatefulWidget {
  const SplashScreen({super.key});

  @override
  ConsumerState<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends ConsumerState<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _initApp();
  }

  Future<void> _initApp() async {
    final stopwatch = Stopwatch()..start();

    try {
      final keyStore = ref.read(encryptionKeyStoreProvider);
      
      // DPAPI check
      debugPrint('[SPLASH] Starting DPAPI key check...');
      String? key = await keyStore.loadKey();
      debugPrint('[SPLASH] DPAPI key check complete: ${key != null}');
      
      bool isFirstTime = false;
      if (key == null) {
        // No key found, assume First Time Setup
        // Setup wizard will generate key and initialize DB
        isFirstTime = true;
      } else {
        // Initialize DB with existing key
        debugPrint('[SPLASH] Instantiating AppDatabase...');
        final db = AppDatabase(key);
        
        // WAL check (implicit by opening DB and running a simple query)
        debugPrint('[SPLASH] Starting DB WAL check...');
        final users = await db.select(db.localUsers).get();
        debugPrint('[SPLASH] DB WAL check complete. Users found: ${users.length}');
        if (users.isEmpty) {
          isFirstTime = true;
        }
        
        ref.read(databaseProvider.notifier).setDatabase(db);
      }

      // Ensure splash shows for at least 1.5s
      final elapsed = stopwatch.elapsedMilliseconds;
      if (elapsed < 1500) {
        debugPrint('[SPLASH] Minimum delay...');
        await Future.delayed(Duration(milliseconds: 1500 - elapsed));
        debugPrint('[SPLASH] Minimum delay complete.');
      }

      if (!mounted) return;

      debugPrint('[SPLASH] Setting requiresSetup: $isFirstTime');
      if (isFirstTime) {
        ref.read(requiresSetupProvider.notifier).setRequiresSetup(true);
        // The DB provider is deliberately kept null or uninitialized 
        // until the setup wizard completes.
      } else {
        ref.read(requiresSetupProvider.notifier).setRequiresSetup(false);
      }
      debugPrint('[SPLASH] Setup state updated, routing handled by main.dart Router.');
      
    } catch (e) {
      // DPAPI failure / fallback (e.g. asking for recovery key)
      // For this phase, we stop/log error.
      debugPrint("[SPLASH] DPAPI Error: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.settings, size: 80, color: Colors.teal),
            SizedBox(height: 24),
            Text('Arham Autos', style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold)),
            SizedBox(height: 16),
            CircularProgressIndicator(),
          ],
        ),
      ),
    );
  }
}
