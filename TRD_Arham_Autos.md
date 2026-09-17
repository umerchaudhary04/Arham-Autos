# Technical Requirements Document (TRD)
## Arham Autos — Desktop Auto Parts Management System
**Single-Terminal, Fully Offline, Windows Desktop Only**

---

## 1. Purpose & Scope

This TRD translates the confirmed PRD and Project Charter requirements into concrete technical decisions for the development team. It covers system architecture, technology stack, security/encryption, hardware integration, packaging, and legacy data migration.

**Explicitly confirmed in this document:** the Van/Spot Sales module (mobile tablet app and its import mechanism) has been **removed from scope entirely** for this phase. This is a single Windows desktop application only.

---

## 2. System Architecture Overview

A single, self-contained Flutter Windows desktop application. No client-server split, no network calls, no cloud dependency of any kind. All data lives in one encrypted local SQLite database.

```
+-------------------------------------------------------------+
|                  Flutter Windows Desktop App                 |
|                                                                |
|  +----------------+      +-----------------------------+     |
|  |   UI Layer      |      |   State Management            |     |
|  |  (Screens,       | <--> |   (Riverpod Providers)        |     |
|  |   Widgets)       |      |                                |     |
|  +----------------+      +-----------------------------+     |
|             |                          |                       |
|             v                          v                       |
|  +----------------------------------------------------+       |
|  |   Business Logic Layer                                |       |
|  |   (FIFO Engine, Ledger, RBAC, Audit)                   |       |
|  +----------------------------------------------------+       |
|             |                                                  |
|             v                                                  |
|  +----------------------------------------------------+       |
|  |   Data Access Layer (drift ORM)                        |       |
|  +----------------------------------------------------+       |
|             |                                                  |
|             v                                                  |
|  +----------------------------------------------------+       |
|  |   Encrypted SQLite DB (SQLCipher AES-256, WAL mode)     |       |
|  +----------------------------------------------------+       |
+-------------------------------------------------------------+
             |
             v  (local file system only — no network)
   +------------------+        +---------------------------+
   |  Backup Files      |        |  Windows-driver Printer    |
   |  (local / USB)     |        |  (thermal, via PDF print)  |
   +------------------+        +---------------------------+
```

---

## 3. Technology Stack

| Layer | Choice | Notes |
|---|---|---|
| Framework | Flutter (stable channel), Windows Desktop target only | No mobile build in this phase |
| State Management | **Riverpod** | StateNotifierProvider for mutable state (cart, active invoice); StreamProvider for reactive DB-backed views |
| Local Database | **drift** (ORM over SQLite) | Type-safe queries, built-in schema migration versioning |
| DB Encryption | **SQLCipher** (`sqlcipher_flutter_libs`) | AES-256, WAL mode enabled |
| PDF/Invoice Rendering | `pdf` package | Renders invoice with embedded Urdu Nastaliq font |
| Printing | `printing` package | Silent direct-print to a pre-configured default printer, no OS dialog |
| Barcode Input | None (keyboard-wedge/HID) | Scanner behaves as a keyboard; no SDK integration required |
| File Picker | `file_picker` | Used for Backup/Restore location selection |
| Localization | `flutter_localizations` + `intl` | ARB files (`en.arb`, `ur.arb`); RTL handled natively via Flutter's `Directionality` |
| Desktop Windowing | `window_manager` | Controls window size/title bar for a proper desktop feel |
| Data Export | `excel` / `csv` package | For Admin-only CSV/Excel report export |
| Legacy DB Read | Microsoft Access Database Engine (ACE OLEDB) | Requires the free Access Database Engine Redistributable on the target machine |

---

## 4. Folder / Module Structure (Recommended)

```
/lib
  /features
    /pos            -> Billing/checkout screen, cart state
    /parts          -> Catalog, search, stock
    /ledger         -> Khata accounts, receipts, credit limits
    /purchases      -> GRN, supplier batches
    /returns        -> Returns & claims
    /admin          -> RBAC, users, audit log viewer
    /backup         -> Backup & Restore engine + UI
    /migration      -> Legacy Import Wizard
    /reports        -> Dashboard, CSV/Excel export
  /core
    /db             -> drift schema, DAOs, migrations
    /security       -> encryption key management, RBAC guards
    /printing       -> PDF invoice rendering, print service
    /localization   -> ARB loading, RTL helpers
```

---

## 5. Database Design

Core schema carries over unchanged from the PRD (`local_users`, `auto_parts`, `fifo_inventory_batches`, `accounts_ledger`, `sales_invoices`, `invoice_items`), plus the following (the original `van_import_staging` table is **removed**, since Van Sales is out of scope):

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

*(`parked_carts` and `returns_claims` were added following the detailed App Flow discussion — see `AppFlow_Arham_Autos.md`. `audit_log.action_type` also gains a `'STOCK_ADJUSTMENT'` value for manual stock corrections.)*

Schema versioning and future migrations are handled through `drift`'s built-in migration system — each app update can carry a schema version bump with an automatic upgrade path run on first launch.

---

## 6. Encryption & Security Architecture

- **Database encryption:** SQLCipher, AES-256, applied to the entire local SQLite file.
- **Key management (Hybrid — locked decision):**
  - Day-to-day: the encryption key is stored via **Windows DPAPI**, so the app unlocks automatically without the user entering a password every launch.
  - At first-time setup, the system generates and displays a **one-time Recovery Key** which the Admin must save physically (print or write down). This is the only way to recover the database if DPAPI's key becomes unavailable (e.g., OS reinstall, disk migration to new hardware).
- **User login:** PIN-based quick login for counter staff, username/password for Admin. *(Note: the original documents specified salted SHA-256 for password hashing — for the TRD, I'd recommend upgrading this to bcrypt or Argon2, which are purpose-built to resist brute-force attacks. Flagging this as an open item in Section 12 rather than changing it unilaterally.)*
- **RBAC:** Role checks (Admin, Manager, Operator) enforced at the business-logic layer before any sensitive action (credit override, price override, data export, audit log access).
- **Audit Trail:** Every RBAC-gated override and every full data export is written to `audit_log`.

---

## 7. Backup & Restore — Technical Specification

- **Trigger:** Automatic, scheduled (default: end of business day), plus a manual "Backup Now" button.
- **Format:** Raw copy of the already-encrypted `.db` file — no re-encryption or export transformation needed, since SQLCipher already secures it at rest.
- **Naming convention:** `arham_backup_YYYY-MM-DD_HHmm.db`
- **Location:** User-configured local path (a different drive/folder on the same PC, or an external USB drive).
- **Retention:** Unlimited — user manages deletion manually. The Backup screen displays total backup folder size and available free disk space so the user can make an informed decision about cleanup.
- **Restore:** Guided wizard — user selects a backup file, system runs `PRAGMA integrity_check` against it before swapping it in, and only commits the swap if the check passes.
- **Non-blocking:** Backup runs on a background isolate/thread so it never freezes the POS/billing UI.

---

## 8. Data Export — Technical Specification

- **Trigger:** Admin-only action (RBAC-gated), from the Reports screen.
- **Content:** Full report including cost price and profit margin (locked decision — no field restriction, since access itself is already restricted to Admin).
- **Format:** `.xlsx` via the `excel` package (or `.csv` as a lighter fallback option).
- **Logging:** Every export action is written to `audit_log` with a timestamp and the exporting Admin's user ID.

---

## 9. Hardware Integration — Technical Specification

### Barcode Scanner
Keyboard-wedge (HID) input — the scanner emits keystrokes into whatever text field currently has focus, terminated by an Enter/Tab keystroke. No SDK, driver, or special package required. The POS billing screen's search/scan field listens for rapid sequential keystrokes to distinguish a scan from manual typing (optional debounce logic for UX polish).

### Thermal / Receipt Printer
- Invoices are rendered as a PDF document using the `pdf` package, with the Urdu Nastaliq font embedded directly in the app (guarantees correct rendering regardless of printer driver font support).
- Printing is done via the `printing` package's **silent direct-print** API to a pre-configured default printer — no OS print dialog interrupts the counter workflow.
- **Paper width:** configurable in Settings — 58mm and 80mm both supported, mapped to different PDF page formats.
- **Cash Drawer:** explicitly out of scope for this phase.

---

## 10. Localization (i18n / RTL) — Technical Approach

- `flutter_localizations` + `intl`, with translated strings in `en.arb` and `ur.arb`.
- RTL layout mirroring handled natively via Flutter's `Directionality` widget — applies to the whole widget tree, including sidebar position, table alignment, and form fields, when Urdu is active.
- A Nastaliq-compatible Urdu font (e.g., Noto Nastaliq Urdu) is bundled as an app asset, used both on-screen and in the PDF invoice renderer, so on-screen and printed Urdu text render consistently.
- Language switch is instant (< 100ms) and requires no app restart — implemented as a Riverpod-provided locale state that the root `MaterialApp` listens to.

---

## 11. Packaging & Deployment

- **Installer:** Inno Setup (chosen over MSIX to avoid file-system sandboxing restrictions, since Backup/Restore needs unrestricted write access to arbitrary local/USB paths).
- **Install layout:** Application binaries in `Program Files`; user data (database, backups, logs) in a separate writable location such as `%APPDATA%\ArhamAutos\` — avoids permission issues and keeps user data intact across reinstalls.
- **Updates:** Fully offline — no auto-update checking. A new version is distributed as a new Inno Setup installer (via USB/file), which replaces only the application binaries and leaves the data folder untouched. On first launch post-update, `drift` runs any pending schema migrations automatically.
- **Code signing:** Not implemented in this phase (single-client, internal tool — users will see and dismiss a one-time Windows SmartScreen warning). Revisit if the software is ever distributed to multiple shops as a commercial product.
- **Dependency bundling:** The installer should check for / bundle the Microsoft Access Database Engine Redistributable, since the Import Wizard depends on it for reading legacy `.accdb` files.

---

## 12. Legacy Data Migration — Technical Approach

- **Interface:** An Admin-only **"Import Wizard"** screen inside the app (not a separate external tool), accessible from Admin Settings.
- **Data source:** Reads the legacy `.accdb` file directly via the ACE OLEDB driver.
- **Process:**
  1. Admin selects the `.accdb` file.
  2. Wizard maps legacy tables/columns to the new schema (`auto_parts`, `accounts_ledger`, `sales_invoices`, etc.), with a review screen for any ambiguous mappings.
  3. Validation pass flags missing/invalid records for manual review before commit — nothing is silently dropped or silently guessed.
  4. **Opening Stock handling:** since the legacy system did not track individual FIFO purchase batches, for each part with existing stock the Admin **manually enters** the opening cost during migration, and the system creates a single "Opening Stock" FIFO batch dated at the migration cutover date.
  5. On completion, a summary is written to `migration_log` (records imported, records flagged, performed by, timestamp).
- **Frequency:** One-time, per deployment — not a recurring sync process.

---

## 13. Non-Functional Technical Requirements (Measurable)

| Requirement | Target | How Measured |
|---|---|---|
| Splash/boot time | < 1.5s | Stopwatch from process start to first interactive frame |
| Invoice line-item render | < 100ms per item | Frame timing during POS cart updates |
| UI frame rate | Locked 60 FPS | On reference hardware: Intel i3, 4GB RAM |
| Parts search | < 200ms | Across a seeded dataset of 100,000+ SKUs |
| Backup completion | Non-blocking | UI remains responsive (60 FPS) during background backup write |
| Language switch | < 100ms | Time from toggle tap to full UI re-render in new language/direction |
| Data-loss on power failure | Zero | WAL mode verified via forced-kill test during active write |

---

## 14. Testing Strategy (Summary)

- **Unit tests:** FIFO batch consumption logic, double-entry ledger balancing, RBAC permission checks, credit-limit enforcement.
- **Integration tests:** drift schema migrations across versions, backup-then-restore round-trip (checksum match), Import Wizard field mapping and validation.
- **Manual QA:** Urdu receipt print output (visual correctness of Nastaliq rendering), barcode scanner input at realistic scan speed, forced power-failure recovery via WAL, full RTL layout mirroring across every screen.

---

## 15. Open Items / Future Considerations

- **Password hashing algorithm:** consider upgrading from SHA-256 (as originally specified) to bcrypt or Argon2 for user login passwords — stronger resistance to brute-force attacks. Not yet confirmed with the client; flagged here for a decision.
- **Code signing certificate:** only needed if this software is later distributed to multiple auto parts shops as a commercial product rather than a single internal deployment.
- **Data archiving policy:** as invoice history grows over years, define an archiving strategy so the working database stays fast near the 100,000-SKU performance target.
- **Van Sales module:** confirmed out of scope for this phase — PRD and Project Charter still need to be updated to formally remove FR-07/FR-11 and the related deliverables/scope lines.
