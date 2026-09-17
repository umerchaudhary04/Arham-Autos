import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

abstract class EncryptionKeyStore {
  Future<void> saveKey(String key);
  Future<String?> loadKey();
  String generateRecoveryKey();
}

class DpapiKeyStore implements EncryptionKeyStore {
  final FlutterSecureStorage _secureStorage = const FlutterSecureStorage();
  static const _keyName = 'arham_autos_db_key';

  @override
  Future<void> saveKey(String key) async {
    await _secureStorage.write(key: _keyName, value: key);
  }

  @override
  Future<String?> loadKey() async {
    return await _secureStorage.read(key: _keyName);
  }

  @override
  String generateRecoveryKey() {
    // Generate a BitLocker-style key: XXXX-XXXX-XXXX-XXXX-XXXX-XXXX
    // We'll just generate random characters for this purpose.
    const chars = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789';
    final random = List.generate(24, (index) => chars[(DateTime.now().microsecondsSinceEpoch + index) % chars.length]);
    final buffer = StringBuffer();
    for (int i = 0; i < random.length; i++) {
      if (i > 0 && i % 4 == 0) buffer.write('-');
      buffer.write(random[i]);
    }
    return buffer.toString();
  }
}

class InMemoryKeyStore implements EncryptionKeyStore {
  String? _key;

  @override
  Future<void> saveKey(String key) async {
    _key = key;
  }

  @override
  Future<String?> loadKey() async {
    return _key;
  }

  @override
  String generateRecoveryKey() {
    return 'TEST-1234-ABCD-5678-EFGH-9012';
  }
}

// Default to Dpapi for the real app. Overridden in tests.
final encryptionKeyStoreProvider = Provider<EncryptionKeyStore>((ref) {
  return DpapiKeyStore();
});
