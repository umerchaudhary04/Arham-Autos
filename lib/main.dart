import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'core/localization/l10n/app_localizations.dart';
import 'package:window_manager/window_manager.dart';

import 'core/security/auth_provider.dart';
import 'core/security/idle_lock_provider.dart';
import 'features/admin/splash_screen.dart';
import 'features/admin/setup_wizard.dart';
import 'features/admin/login_screen.dart';
import 'features/admin/sidebar_shell.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await windowManager.ensureInitialized();

  WindowOptions windowOptions = const WindowOptions(
    size: Size(1280, 720),
    center: true,
    backgroundColor: Colors.transparent,
    skipTaskbar: false,
    titleBarStyle: TitleBarStyle.normal,
    title: 'Arham Autos Desktop Suite',
  );
  windowManager.waitUntilReadyToShow(windowOptions, () async {
    await windowManager.show();
    await windowManager.focus();
  });

  runApp(const ProviderScope(child: MyApp()));
}

class LocaleNotifier extends Notifier<Locale> {
  @override
  Locale build() => const Locale('en');
  void setLocale(Locale l) => state = l;
}

final localeProvider = NotifierProvider<LocaleNotifier, Locale>(
  () => LocaleNotifier(),
);

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Determine user locale preference if logged in, else default
    final authState = ref.watch(authProvider);
    final locale = authState.user != null
        ? Locale(authState.user!.preferredLanguage)
        : ref.watch(localeProvider);

    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: () => ref.read(idleLockProvider.notifier).resetTimer(),
      onPanDown: (_) => ref.read(idleLockProvider.notifier).resetTimer(),
      child: MaterialApp(
        title: 'Arham Autos',
        locale: locale,
        localizationsDelegates: const [
          AppLocalizations.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: const [Locale('en', ''), Locale('ur', '')],
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.teal),
          useMaterial3: true,
        ),
        home: const AuthRouter(),
      ),
    );
  }
}

class AuthRouter extends ConsumerWidget {
  const AuthRouter({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authProvider);
    final db = ref.watch(databaseProvider);

    // We assume Splash sets the DB and if DB is new, we should go to Setup.
    // For now we rely on a provider flag.
    final requiresSetup = ref.watch(requiresSetupProvider);
    if (requiresSetup) {
      return const SetupWizard();
    }

    if (db == null) {
      return const SplashScreen();
    }

    if (authState.isLocked || authState.user == null) {
      return const LoginScreen();
    }

    return const SidebarShell();
  }
}

class RequiresSetupNotifier extends Notifier<bool> {
  @override
  bool build() => false;
  void setRequiresSetup(bool v) => state = v;
}

final requiresSetupProvider = NotifierProvider<RequiresSetupNotifier, bool>(
  () => RequiresSetupNotifier(),
);
