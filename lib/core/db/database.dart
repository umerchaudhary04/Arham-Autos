import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'dart:io';
import 'daos/parts_dao.dart';
import 'daos/pos_dao.dart';
import 'daos/ledger_dao.dart';
import 'daos/users_dao.dart';
import 'daos/reports_dao.dart';

part 'database.g.dart';

class BackupLog extends Table {
  TextColumn get backupId => text()();
  TextColumn get filePath => text()();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
  IntColumn get sizeBytes => integer().nullable()();
  TextColumn get status => text()();

  @override
  Set<Column> get primaryKey => {backupId};
}

class AuditLog extends Table {
  IntColumn get logId => integer().autoIncrement()();
  TextColumn get userId => text()(); // TODO: References local_users(id)
  TextColumn get actionType => text()();
  TextColumn get targetTable => text().nullable()();
  TextColumn get recordId => text().nullable()();
  TextColumn get oldValue => text().nullable()();
  TextColumn get newValue => text().nullable()();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
}

class MigrationLog extends Table {
  TextColumn get migrationId => text()();
  TextColumn get sourceFile => text()();
  IntColumn get recordsImported => integer().nullable()();
  IntColumn get recordsFlagged => integer().nullable()();
  TextColumn get performedBy => text().nullable()(); // TODO: References local_users(id)
  DateTimeColumn get performedAt => dateTime().withDefault(currentDateAndTime)();

  @override
  Set<Column> get primaryKey => {migrationId};
}

class ParkedCarts extends Table {
  TextColumn get parkedId => text()();
  TextColumn get userId => text()(); // TODO: References local_users(id)
  TextColumn get cartPayloadJson => text()();
  DateTimeColumn get parkedAt => dateTime().withDefault(currentDateAndTime)();

  @override
  Set<Column> get primaryKey => {parkedId};
}

class ReturnsClaims extends Table {
  TextColumn get claimId => text()();
  TextColumn get claimType => text()();
  TextColumn get referenceInvoiceId => text().nullable()(); // TODO: References sales_invoices(invoice_id)
  TextColumn get initiatedBy => text()(); // TODO: References local_users(id)
  TextColumn get status => text().withDefault(const Constant('PENDING_APPROVAL'))();
  TextColumn get refundMethod => text().nullable()();
  TextColumn get approvedBy => text().nullable()();
  DateTimeColumn get approvedAt => dateTime().nullable()();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();

  @override
  Set<Column> get primaryKey => {claimId};
}

class LocalUsers extends Table {
  TextColumn get id => text()();
  TextColumn get fullName => text()();
  TextColumn get username => text()();
  TextColumn get passwordHash => text()();
  TextColumn get pinHash => text()();
  TextColumn get role => text()(); // 'Admin', 'Manager', 'Operator'
  TextColumn get preferredLanguage => text().withDefault(const Constant('en'))();

  @override
  Set<Column> get primaryKey => {id};
}

class AppConfig extends Table {
  TextColumn get configKey => text()();
  TextColumn get configValue => text()();

  @override
  Set<Column> get primaryKey => {configKey};
}

class AutoParts extends Table {
  TextColumn get partId => text()();
  TextColumn get partName => text()();
  TextColumn get oemNumber => text().nullable()();
  TextColumn get model => text().nullable()();
  TextColumn get rackLocation => text().nullable()();
  IntColumn get minReorderLevel => integer().withDefault(const Constant(0))();

  @override
  Set<Column> get primaryKey => {partId};
}

class FifoInventoryBatches extends Table {
  TextColumn get batchId => text()();
  TextColumn get partId => text()(); // References auto_parts(partId)
  IntColumn get originalQuantity => integer()();
  IntColumn get remainingQuantity => integer()();
  RealColumn get unitLandedCost => real()();
  TextColumn get supplierId => text().nullable()(); // References accounts_ledger(accountId)
  DateTimeColumn get receivedAt => dateTime().withDefault(currentDateAndTime)();

  @override
  Set<Column> get primaryKey => {batchId};
}

class AccountsLedger extends Table {
  TextColumn get accountId => text()();
  TextColumn get accountName => text()();
  TextColumn get accountType => text()(); // 'Customer', 'Supplier'
  RealColumn get currentBalance => real().withDefault(const Constant(0.0))();
  RealColumn get creditLimit => real().nullable()();

  @override
  Set<Column> get primaryKey => {accountId};
}

class SalesInvoices extends Table {
  TextColumn get invoiceId => text()();
  TextColumn get customerId => text().nullable()(); // References accounts_ledger(accountId)
  RealColumn get totalAmount => real()();
  RealColumn get discount => real().withDefault(const Constant(0.0))();
  RealColumn get finalAmount => real()();
  TextColumn get createdBy => text()(); // References local_users(id)
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();

  @override
  Set<Column> get primaryKey => {invoiceId};
}

class InvoiceItems extends Table {
  TextColumn get itemId => text()();
  TextColumn get invoiceId => text()(); // References sales_invoices(invoiceId)
  TextColumn get partId => text()(); // References auto_parts(partId)
  TextColumn get batchId => text()(); // References fifo_inventory_batches(batchId)
  IntColumn get quantity => integer()();
  RealColumn get unitPrice => real()();
  RealColumn get unitCogs => real()(); // Cost of Goods Sold from the FIFO batch

  @override
  Set<Column> get primaryKey => {itemId};
}

@DriftDatabase(tables: [
  BackupLog,
  AuditLog,
  MigrationLog,
  ParkedCarts,
  ReturnsClaims,
  LocalUsers,
  AppConfig,
  AutoParts,
  FifoInventoryBatches,
  AccountsLedger,
  SalesInvoices,
  InvoiceItems,
], daos: [
  PartsDao,
  PosDao,
  LedgerDao,
  UsersDao,
  ReportsDao,
])
class AppDatabase extends _$AppDatabase {
  AppDatabase(String encryptionKey, {QueryExecutor? executor}) : super(executor ?? _openConnection(encryptionKey));

  @override
  int get schemaVersion => 1;
}

LazyDatabase _openConnection(String encryptionKey) {
  return LazyDatabase(() async {
    final appData = Platform.environment['APPDATA'] ?? Directory.current.path;
    final appDir = Directory('$appData\\ArhamAutos');
    if (!await appDir.exists()) {
      await appDir.create(recursive: true);
    }
    
    final file = File('${appDir.path}\\arham_autos.db');

    return NativeDatabase.createInBackground(
      file,
      setup: (db) {
        db.execute("PRAGMA key = '$encryptionKey';");
        db.execute("PRAGMA cipher_page_size = 4096;");
        db.execute("PRAGMA journal_mode = WAL;");
        db.execute("PRAGMA synchronous = NORMAL;");
      },
    );
  });
}
