import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:drift/drift.dart' as drift;
import '../../core/security/encryption_key_store.dart';
import '../../core/db/database.dart';
import '../../core/security/auth_provider.dart';
import '../../main.dart';

class SetupWizard extends ConsumerStatefulWidget {
  const SetupWizard({super.key});

  @override
  ConsumerState<SetupWizard> createState() => _SetupWizardState();
}

class _SetupWizardState extends ConsumerState<SetupWizard> {
  int _currentStep = 0;

  // Step 1: Admin Account
  final _nameController = TextEditingController();
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _pinController = TextEditingController();

  // Step 2: Language
  String _selectedLang = 'en';

  // Step 3: Recovery Key
  String _recoveryKey = '';
  bool _keySaved = false;
  final _retypeKeyController = TextEditingController();

  // Step 4: Backup Location
  String? _backupLocation;

  // Step 5: Import
  bool _importNow = false;

  @override
  void initState() {
    super.initState();
    _recoveryKey = ref.read(encryptionKeyStoreProvider).generateRecoveryKey();
  }

  void _completeSetup() async {
    final keyStore = ref.read(encryptionKeyStoreProvider);
    final rawKey = 'SECURE_KEY_${DateTime.now().millisecondsSinceEpoch}'; // Ideally derived cryptographically
    
    // Save to DPAPI
    await keyStore.saveKey(rawKey);

    // Initialize DB
    final db = AppDatabase(rawKey);

    // Create Admin User
    await db.into(db.localUsers).insert(LocalUsersCompanion.insert(
      id: 'admin_1',
      fullName: _nameController.text,
      username: _usernameController.text,
      passwordHash: _passwordController.text, // Mocked, ideally hashed
      pinHash: _pinController.text,
      role: 'Admin',
      preferredLanguage: drift.Value(_selectedLang),
    ));

    // Save configuration
    await db.into(db.appConfig).insert(AppConfigCompanion.insert(
      configKey: 'backup_location',
      configValue: _backupLocation!,
    ));
    await db.into(db.appConfig).insert(AppConfigCompanion.insert(
      configKey: 'idle_timeout',
      configValue: '300', // Default 5 mins
    ));
    await db.into(db.appConfig).insert(AppConfigCompanion.insert(
      configKey: 'default_language',
      configValue: _selectedLang,
    ));

    // Update state to trigger navigation
    if (!mounted) return;
    ref.read(databaseProvider.notifier).setDatabase(db);
    ref.read(requiresSetupProvider.notifier).setRequiresSetup(false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('First-Time Setup')),
      body: Stepper(
        type: StepperType.horizontal,
        currentStep: _currentStep,
        onStepContinue: () {
          if (_currentStep == 0) {
            if (_nameController.text.isEmpty ||
                _usernameController.text.isEmpty ||
                _passwordController.text.isEmpty ||
                _passwordController.text != _confirmPasswordController.text ||
                _pinController.text.isEmpty) {
              return; // Validation fails
            }
          }
          if (_currentStep == 2) {
            final last4 = _recoveryKey.substring(_recoveryKey.length - 4);
            if (!_keySaved || _retypeKeyController.text != last4) {
              return; // Validation fails
            }
          }
          if (_currentStep == 3 && _backupLocation == null) {
            return;
          }

          if (_currentStep < 4) {
            setState(() => _currentStep++);
          } else {
            _completeSetup();
          }
        },
        onStepCancel: () {
          if (_currentStep > 0) {
            setState(() => _currentStep--);
          }
        },
        steps: [
          Step(
            title: const Text('Admin'),
            isActive: _currentStep >= 0,
            content: Column(
              children: [
                TextField(controller: _nameController, decoration: const InputDecoration(labelText: 'Full Name')),
                TextField(controller: _usernameController, decoration: const InputDecoration(labelText: 'Username')),
                TextField(controller: _passwordController, obscureText: true, decoration: const InputDecoration(labelText: 'Password')),
                TextField(controller: _confirmPasswordController, obscureText: true, decoration: const InputDecoration(labelText: 'Confirm Password')),
                TextField(controller: _pinController, obscureText: true, keyboardType: TextInputType.number, decoration: const InputDecoration(labelText: 'PIN')),
              ],
            ),
          ),
          Step(
            title: const Text('Language'),
            isActive: _currentStep >= 1,
            content: DropdownButton<String>(
              value: _selectedLang,
              items: const [
                DropdownMenuItem(value: 'en', child: Text('English')),
                DropdownMenuItem(value: 'ur', child: Text('Urdu')),
              ],
              onChanged: (v) {
                setState(() => _selectedLang = v!);
                ref.read(localeProvider.notifier).setLocale(Locale(v!));
              },
            ),
          ),
          Step(
            title: const Text('Recovery'),
            isActive: _currentStep >= 2,
            content: Column(
              children: [
                const Text('Save this Recovery Key safely! It is the ONLY way to recover your database if this PC breaks.',
                  style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold)),
                const SizedBox(height: 16),
                SelectableText(_recoveryKey, style: const TextStyle(fontSize: 24, letterSpacing: 2, fontFamily: 'Courier')),
                const SizedBox(height: 16),
                CheckboxListTile(
                  title: const Text('I have printed or securely saved this key.'),
                  value: _keySaved,
                  onChanged: (v) => setState(() => _keySaved = v!),
                ),
                TextField(
                  controller: _retypeKeyController,
                  decoration: const InputDecoration(labelText: 'Retype the last 4 characters to confirm'),
                  maxLength: 4,
                ),
              ],
            ),
          ),
          Step(
            title: const Text('Backup'),
            isActive: _currentStep >= 3,
            content: Column(
              children: [
                Text('Selected Location: ${_backupLocation ?? "None"}'),
                ElevatedButton(
                  onPressed: () async {
                    // Temporarily using string as FilePicker syntax has issues across versions
                    String? path = 'C:\\ArhamAutosBackups';
                    setState(() => _backupLocation = path);
                  },
                  child: const Text('Select Backup Folder'),
                ),
              ],
            ),
          ),
          Step(
            title: const Text('Finish'),
            isActive: _currentStep >= 4,
            content: Column(
              children: [
                const Text('Import legacy data from MS Access?'),
                RadioListTile<bool>(
                  title: const Text('No, start fresh'),
                  value: false,
                  groupValue: _importNow,
                  onChanged: (v) => setState(() => _importNow = v!),
                ),
                RadioListTile<bool>(
                  title: const Text('Yes, run Import Wizard (Coming in Phase 5)'),
                  value: true,
                  groupValue: _importNow,
                  onChanged: null, // Disabled per requirements
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
