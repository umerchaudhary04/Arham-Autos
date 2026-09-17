import 'dart:math';
import 'package:flutter_test/flutter_test.dart';
import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import '../lib/core/db/database.dart';

void main() {
  late AppDatabase db;
  final random = Random();

  setUp(() {
    db = AppDatabase('test_key', executor: NativeDatabase.memory());
  });

  tearDown(() async {
    await db.close();
  });

  test('Stress Test: 100k SKUs and 50k Ledger Entries Latency', () async {
    // 1. Seed 100k Parts
    print('Seeding 100,000 AutoParts...');
    final parts = <AutoPartsCompanion>[];
    for (int i = 0; i < 100000; i++) {
      parts.add(AutoPartsCompanion.insert(
        partId: 'PART_$i',
        partName: 'Test Part $i',
        oemNumber: Value(random.nextBool() ? 'OEM_${random.nextInt(1000)}' : null),
        model: Value(random.nextBool() ? 'Model_${random.nextInt(100)}' : null),
        rackLocation: Value('A${random.nextInt(10)}-B${random.nextInt(20)}'),
        minReorderLevel: Value(random.nextInt(10)),
      ));
    }
    
    // Batch insert for speed
    await db.batch((batch) {
      batch.insertAll(db.autoParts, parts);
    });
    print('Seeded 100k parts.');

    // 2. Seed 50k Ledger Entries
    print('Seeding 50,000 AccountsLedger entries...');
    final ledgers = <AccountsLedgerCompanion>[];
    for (int i = 0; i < 50000; i++) {
      ledgers.add(AccountsLedgerCompanion.insert(
        accountId: 'ACC_$i',
        accountName: 'Account $i',
        accountType: random.nextBool() ? 'Customer' : 'Supplier',
        currentBalance: Value(random.nextDouble() * 10000),
        creditLimit: Value(random.nextDouble() * 50000),
      ));
    }

    await db.batch((batch) {
      batch.insertAll(db.accountsLedger, ledgers);
    });
    print('Seeded 50k ledger entries.');

    // 3. Test Search Latency
    print('Testing Search Latency for AutoParts...');
    
    final sw = Stopwatch()..start();
    
    final results = await db.partsDao.searchParts('Test Part 9999');
    sw.stop();
    
    print('Search completed in ${sw.elapsedMilliseconds} ms. Found ${results.length} results.');
    
    expect(sw.elapsedMilliseconds, lessThan(200), reason: 'Search latency exceeded 200ms target.');
  });
}
