# Product Requirements Document (Revised — v3)
## Arham Autos — Auto Parts Management Suite
### Architecture: Single-Terminal, Fully Offline, SQLite-Only, Desktop-Only

---

## 0. What Changed in This Version

| Area | Change |
|---|---|
| **Van/Spot Sales Module** | **Removed entirely** — no mobile/tablet app, no import mechanism, in this phase. Original legacy problem of "no field sales support" remains only partially addressed and is deferred to a future phase. |
| **Legacy Data Migration** | Formalized as a proper product feature — an **Admin-only in-app "Import Wizard"** (previously just an SDLC activity, not a screen users interact with). |
| **Data Export** | Refined — full report including cost price/margin, restricted to Admin role, every export logged to an audit trail. |
| **Printer / Hardware** | Refined — invoices render as PDF (guarantees correct Urdu rendering) and print silently to a configured default printer; paper width configurable (58mm/80mm); cash drawer explicitly out of scope. |
| **Encryption Key Management** | Refined — hybrid approach: automatic (Windows DPAPI) for daily use, plus a one-time printed Recovery Key generated at setup for disaster recovery. |

*(These decisions came out of the TRD discussion — see `TRD_Arham_Autos.md` for full technical detail. The Project Charter still needs a matching update to remove Van Sales from its Deliverables/Scope — flagging this separately.)*

---

## 1. Problem Statement

Carried over from the legacy MS Access system:
- Business logic (FIFO costing, landed cost, ledger updates) buried in VBA macros — hard to maintain, error-prone.
- No Urdu/RTL interface for counter staff.
- No role-based access control; cost/margin data stored in plain text.

**Resolved by architecture, not engineering:**
- Concurrency/corruption from multiple simultaneous counters — irrelevant now, since only one terminal ever writes to the database.

**Explicitly deferred (not solved in this phase):**
- Field/van sales synchronization. The current system has no van sales component at all; this can be revisited as a future phase once the core desktop system is stable and in use.

---

## 2. Technical Architecture (Summary)

- **Local Persistence Layer:** SQLite via `drift`, WAL mode, SQLCipher AES-256 encryption.
- **Zero network dependency** — the app must function indefinitely with networking hardware fully disabled.
- **Encryption key:** Hybrid — Windows DPAPI unlocks the database automatically for daily use; a one-time **Recovery Key** is generated and shown once at first setup, which the Admin must save physically (print/write down) for disaster recovery.
- **Backup Engine:** Automatic scheduled backups (default: end of day) plus manual "Backup Now," writing a timestamped raw copy of the encrypted `.db` file to a user-chosen local/USB location. Retention is unlimited and user-managed; the app displays backup folder size and free disk space as a courtesy.
- **Legacy Migration:** A one-time, Admin-only **Import Wizard** inside the app reads the old `.accdb` file (via the Access Database Engine), maps fields to the new schema, flags anything ambiguous for manual review, and lets the Admin manually enter opening stock cost per part (since the legacy system didn't track FIFO batches).

*(Full technical detail — package choices, schema, folder structure — lives in the TRD, not repeated here.)*

---

## 3. Suggestions / Recommendations (Carried Forward + New)

1. **Backup & Restore as a first-class module** — with in-app reminders if no backup has been taken recently.
2. **Audit Log** — every Admin-PIN override and every full data export is logged with user, timestamp, and before/after values.
3. **Van Import Reconciliation** — *(no longer applicable; module removed)*.
4. **Data export for the accountant** — full CSV/Excel export (cost/margin included), Admin-only, since there's no cloud dashboard an external accountant could log into.
5. **Database integrity checks** — periodic `PRAGMA integrity_check`, and an automatic backup taken immediately before any schema migration/app update.
6. **Data archiving strategy** *(still open)* — define a policy for invoices older than N years so the working database stays fast as it approaches the 100,000-SKU performance target.
7. **Password hashing upgrade** *(still open)* — consider bcrypt/Argon2 over SHA-256 for user login passwords; flagged in the TRD for a decision, not yet confirmed.

---

## 4. Revised SDLC Roadmap

```
+-----------------------------------------------------------------------------------+
|                 ARHAM AUTOS — OFFLINE SINGLE-TERMINAL ROADMAP (v3)                |
+-----------------------------------------------------------------------------------+
| Phase 1: Requirements & Legacy VBA Reverse Engineering        (Sprints 1-2)       |
| Phase 2: Core Infra — i18n (Urdu/EN), SQLite Schema, Backup Engine (Sprints 3-4)  |
| Phase 3: Auth, RBAC, Splash & Encryption Bootstrap             (Sprints 5-6)       |
| Phase 4: Core Modules — Parts, FIFO, POS, Khata Ledger, GRN    (Sprints 7-9)       |
| Phase 5: Legacy Import Wizard + Hardware Integration            (Sprint 10)        |
| Phase 6: QA, Backup/Restore Drills, Inno Setup Packaging, Launch (Sprint 11+)      |
+-----------------------------------------------------------------------------------+
```

*(Van Sales sprint fully removed — no replacement phase needed, since the Import Wizard is smaller in scope than the original van sync engineering.)*

---

## 5. Product Overview

- **Product Name:** Arham Autos Desktop Suite
- **Target Audience:** Counter Sales Operator, Parts/Store Manager, Accounts/Khata Officer
- **Target Platform:** One Windows 10/11 desktop terminal — **no mobile/tablet component in this phase**

## 5.1 User Personas

| Persona | Needs |
|---|---|
| Counter Sales Operator | Fast OEM/model-based part search, instant stock check, thermal invoice printing, full Urdu UI |
| Store/Inventory Manager | Real-time FIFO valuation, low-stock alerts, rack/shelf management, supplier purchases |
| Accounts/Khata Officer | Customer credit balances, daily cashbook, double-entry ledger integrity, exportable reports |

*(Spot/Van Sales Driver persona removed from this phase's scope — deferred to a future phase if the van module is revisited.)*

## 5.2 Application Workflow

```
+------------------+     +------------------+     +------------------+     +------------------+
|   Windows Launch | --> |  Splash Screen   | --> | Language Selector| --> |  Authentication  |
| (App Executable) |     | (Verify SQLite)  |     | (Urdu RTL / EN)  |     | (User PIN/Pass)  |
+------------------+     +------------------+     +------------------+     +------------------+
                                                                                    |
                                                                                    v
                                                  +------------------+     +------------------+
                                                  | Core Modules Nav | <-- |  Main Dashboard  |
                                                  | (Sidebar Access) |     | (KPIs & Alerts)  |
                                                  +------------------+     +------------------+
                                                            |
        +---------------+---------------+---------------+---------------+---------------+
        |               |               |               |               |               |
        v               v               v               v               v               v
   +--------+     +--------+     +--------+     +--------+     +--------+     +--------+
   | Parts  |     | POS    |     | Khata  |     | GRN/   |     | Backup/|     | Reports/
   | & FIFO |     | Billing|     | Ledger |     | Purch. |     | Restore|     | Export |
   +--------+     +--------+     +--------+     +--------+     +--------+     +--------+
```

## 5.3 Functional Requirements

| ID | Module | Feature Description | Priority |
|---|---|---|---|
| FR-01 | Boot & Splash | App renders splash screen under 1.5s, validates SQLite encryption key, loads catalog cache. No network check of any kind. | High |
| FR-02 | Language & RTL | English/Urdu (Nastaliq/RTL). Instant UI switch without restart. | High |
| FR-03 | Parts Catalog & Search | Multi-attribute search: Part Name, OEM #, Manufacturer, Engine Code, Model Year, Rack/Shelf. | High |
| FR-04 | FIFO Inventory Engine | Automatic FIFO batch consumption on sale, exact COGS calculation. | High |
| FR-05 | Counter POS & Billing | Keyboard-driven billing, barcode scan (keyboard-wedge), thermal print via PDF render (Urdu-safe), 58mm/80mm configurable paper, cash/credit toggle, discounts. No cash drawer. | High |
| FR-06 | Customer Khata & Ledger | Double-entry accounting, credit limits, daily cashbook (Rojnamcha), receipts. | High |
| FR-07 | Purchase & GRN | Goods Received Note logging, landed cost allocation, new FIFO batch creation. | High |
| FR-08 | Returns & Claims | Customer returns: Operator initiates, Manager/Admin approves (refund method chosen at approval — cash or Khata credit; stock restored to original FIFO batch). Supplier warranty claims: separate Manager/Admin-only flow. | Medium |
| FR-09 | Backup & Restore Engine | Automated scheduled local backups (configurable interval/location); manual "Restore from Backup" wizard; backup folder size/free space display. | High |
| FR-10 | Legacy Data Import Wizard | Admin-only in-app wizard to import data from the legacy `.accdb` file: field mapping, validation, manual opening-stock cost entry per part. | High |
| FR-11 | Dashboard & Reports | Daily Sales, FIFO Gross Profit, Receivables, Low Stock Alerts, Cashbook Summary. | High |
| FR-12 | Data Export | Admin-only export of full reports (including cost/margin) to CSV/Excel; every export logged to the audit trail. | Medium |
| FR-13 | Audit Trail | Log every Admin-PIN override (credit bypass, price override) and every data export, with user, timestamp, before/after values. | Medium |
| FR-14 | Navigation & RBAC | Sidebar filtered by role (Admin, Manager, Operator). | High |

*(FR numbering has been fully renumbered in this version — the old FR-07/FR-11 for Van Sales no longer exist; FR-10 is a new addition for the Import Wizard.)*

## 5.4 Non-Functional Requirements

- **Zero network dependency:** All core functions must work indefinitely with networking hardware fully disabled.
- **Performance:** Invoice line-item rendering < 100ms; 60 FPS UI on Intel i3/4GB RAM.
- **Security:** AES-256 SQLCipher for the local DB; hybrid DPAPI + printed Recovery Key for encryption key management; PIN-based quick login.
- **Usability:** 100% keyboard-navigable POS checkout (Tab/Enter/F-keys).
- **Reliability:** Zero data loss on sudden power outage via SQLite WAL mode.
- **Backup non-blocking:** Scheduled backup must run in the background without freezing POS operations.
- **Data durability:** Since there is no cloud copy, the app must actively surface backup status/reminders to the user.

---

## 6. SRS Additions (ISO/IEC/IEEE 29148:2018)

- **SRS-DATA-001:** The system shall perform an automatic local backup of the database at a user-configured interval (default: end of business day) to a user-specified **local** storage location. No network or cloud storage destination shall be supported or required.
- **SRS-DATA-002:** The system shall provide a guided "Restore from Backup" flow that runs `PRAGMA integrity_check` on the selected backup before committing the restore.
- **SRS-DATA-003:** The system shall record every Admin-PIN-override action and every full data export in an audit log, capturing user ID, timestamp, action type, and (for overrides) before/after values.
- **SRS-MIGRATE-001:** The system shall provide an Admin-only Import Wizard capable of reading a legacy `.accdb` file, mapping its tables/fields to the current schema, and flagging any record that cannot be automatically mapped for manual review before commit.
- **SRS-MIGRATE-002:** For each part with existing stock at time of migration, the system shall require the Admin to manually enter an opening cost, and shall create a single "Opening Stock" FIFO batch dated at the migration cutover date.

*(SRS-SYNC-* and the original SRS-DATA-002 for Van import have been removed — no longer applicable. All other original SRS items — SRS-LOCAL-*, SRS-PART-*, SRS-FIFO-*, SRS-POS-*, SRS-LEDGER-* — remain unchanged.)*

---

## 7. Local SQLite Schema (Delta from Original Legacy-Era Design)

**Removed:** `sync_queue` (CRDT-era), `van_import_staging` (Van Sales-era).

**Added:**

```sql
-- Automated Backup History
CREATE TABLE backup_log (
    backup_id TEXT PRIMARY KEY,
    file_path TEXT NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    size_bytes INTEGER,
    status TEXT NOT NULL -- 'SUCCESS', 'FAILED'
);

-- Admin Override / Sensitive Action Audit Trail
CREATE TABLE audit_log (
    log_id INTEGER PRIMARY KEY AUTOINCREMENT,
    user_id TEXT NOT NULL REFERENCES local_users(id),
    action_type TEXT NOT NULL, -- e.g. 'CREDIT_LIMIT_OVERRIDE', 'PRICE_OVERRIDE', 'DATA_EXPORT'
    table_name TEXT,
    record_id TEXT,
    old_value TEXT,
    new_value TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- One-Time Legacy Migration Log
CREATE TABLE migration_log (
    migration_id TEXT PRIMARY KEY,
    source_file TEXT NOT NULL,
    records_imported INTEGER,
    records_flagged INTEGER,
    performed_by TEXT REFERENCES local_users(id),
    performed_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Parked Cart for Shift-Change / Idle-Lock (one per operator)
CREATE TABLE parked_carts (
    parked_id TEXT PRIMARY KEY,
    user_id TEXT NOT NULL REFERENCES local_users(id),
    cart_payload_json TEXT NOT NULL,
    parked_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Customer Returns & Supplier Warranty Claims (Approval Workflow)
CREATE TABLE returns_claims (
    claim_id TEXT PRIMARY KEY,
    claim_type TEXT NOT NULL, -- 'CUSTOMER_RETURN', 'SUPPLIER_WARRANTY'
    reference_invoice_id TEXT REFERENCES sales_invoices(invoice_id),
    initiated_by TEXT NOT NULL REFERENCES local_users(id),
    status TEXT DEFAULT 'PENDING_APPROVAL', -- 'PENDING_APPROVAL', 'APPROVED', 'REJECTED'
    refund_method TEXT, -- 'CASH', 'KHATA_CREDIT' (set at approval time)
    approved_by TEXT REFERENCES local_users(id),
    approved_at TIMESTAMP,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);
```

*(`parked_carts` and `returns_claims` were added following the detailed App Flow discussion — see `AppFlow_Arham_Autos.md`. The `audit_log.action_type` field also gains a new value, `'STOCK_ADJUSTMENT'`, for manual stock corrections — no schema change needed since it's a free-text field.)*

**Unchanged tables:** `local_users`, `auto_parts`, `fifo_inventory_batches`, `accounts_ledger`, `sales_invoices`, `invoice_items`.

---

## 8. Verification & Test Plan

1. **Urdu & RTL Hot-Swap Test** — trigger language toggle during an active POS transaction; verify layout mirrors correctly within 100ms with no state loss.
2. **FIFO Inventory Cost Calculation Test** — two purchase batches (10 pcs @ ₨1,200; 10 pcs @ ₨1,500); checkout 15 pcs; verify COGS = ₨19,500 and 5 pcs remain in the second batch.
3. **Customer Credit (Khata) Limit Enforcer Test** — set a ₨50,000 limit, accumulate ₨48,000 balance, attempt a ₨5,000 credit sale; verify the system blocks it and requires Admin PIN override, and that the override is logged to `audit_log`.
4. **Backup & Restore Drill** — force-close the app mid-transaction to simulate a power failure; verify WAL recovers to the last consistent state on next launch. Separately, restore from a known backup and verify all data matches via checksum with zero discrepancy.
5. **Legacy Migration Import Test** — run the Import Wizard against a sample `.accdb` file; verify correct field mapping, that invalid/ambiguous records are flagged (not silently dropped), and that opening-stock FIFO batches are created correctly using Admin-entered costs.

*(The original "USB Van Import Test" has been removed — no longer applicable.)*

---

## 9. Open Questions

- **Password hashing algorithm:** upgrade from SHA-256 to bcrypt/Argon2 for user login passwords? (Flagged in TRD, not yet confirmed.)
- **Data archiving policy:** what's the cutoff for archiving old invoices as the database grows over years?
- **Code signing:** only relevant if this software is ever distributed to multiple auto parts shops commercially rather than used internally by Arham Autos alone.
- **Project Charter:** still needs a matching update to remove Van Sales from Deliverables/Scope, so all three documents (PRD, Charter, TRD) stay consistent.
