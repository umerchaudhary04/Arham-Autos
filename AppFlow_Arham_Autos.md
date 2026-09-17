# App Flow Document
## Arham Autos Desktop Suite — Single-Terminal, Offline

This document captures the complete user-journey and navigation design for the application, as discussed and locked separately from the PRD (which covers *what* the system does) and the TRD (which covers *how* it's technically built).

---

## 1. Boot & Login Flow

### 1.1 Normal Launch

```
Double-click app icon
        |
        v
  Splash Screen (<1.5s)
  - DPAPI unlocks the DB encryption key
  - WAL check, catalog cache warm-up
        |
        v
  [If DPAPI key retrieval fails — e.g. new PC, OS reinstall]
  --> "Enter Recovery Key" screen (fallback path)
        |
        v
  Login Screen (language selector is SKIPPED here — only shown
  at first-time setup; each user's own preferred_language applies
  automatically once they log in)
        |
        v
  PIN (quick) or Username + Password (Admin) login
        |
        v
  Dashboard — content and default landing screen depend on role
  (see Section 2.2)
```

### 1.2 Shift-Change / Switch User

- A **"Switch User"** button lives in the top bar at all times.
- If the current operator has an in-progress POS cart, it is **automatically "parked"** (one parked cart per operator, stored in a `parked_carts` table) and resumes exactly where they left off when they log back in.
- After switching, the app returns to the Login screen — the app itself keeps running (not a full restart).

### 1.3 Idle Auto-Lock

- After a period of inactivity, the app automatically locks and returns to the Login screen.
- Timeout duration is **configurable in Admin Settings** (no hardcoded default forced on the client).
- Any in-progress cart is parked automatically, same as a manual switch.

### 1.4 First-Time Setup Flow (No Database Exists Yet)

```
Splash Screen --> No existing database detected --> Setup Wizard begins
                                                      (cannot be skipped)

STEP 1 — Create Admin Account
  Full Name, Username, Password (+confirm), AND PIN — all set together
  at this step (PIN is available for daily quick login immediately)

STEP 2 — Default Language
  EN or UR — this is the global fallback shown on the Login screen
  before anyone has logged in yet

STEP 3 — Recovery Key Generation
  System generates a random key (BitLocker-style: XXXX-XXXX-XXXX-XXXX-XXXX-XXXX)
  Confirmation required before continuing:
    - Checkbox: "I have saved this key"
    - PLUS: retype the last 4 characters of the key (stronger confirmation)

STEP 4 — Backup Location
  Mandatory — file_picker to choose a local/external backup folder.
  Setup cannot complete without this being set.

STEP 5 — Legacy Data Import (Optional at this point)
  "Import old data now?" --> Yes: Legacy Import Wizard opens (Section 6)
                          --> No: can be done later from Admin Settings
        |
        v
     Dashboard
```

---

## 2. Navigation Structure

### 2.1 Sidebar Access by Role

| Module | Admin | Manager | Operator |
|---|---|---|---|
| Dashboard | Full KPIs (sales, profit, receivables) | Full KPIs | **Today's Sales only** — no profit/margin data shown |
| POS Billing | ✓ | ✓ | ✓ |
| Parts Catalog | Full edit | Full edit | View/search only |
| Khata Ledger | ✓ | ✓ (this is where the "Khata Officer" persona operates — see note below) | View only, no credit limit changes |
| Purchases/GRN | ✓ | ✓ | ✗ |
| Returns & Claims | Approve | Approve | Initiate only |
| Reports | View + Export | View only | ✗ |
| Backup & Restore | ✓ | ✗ | ✗ |
| Legacy Import Wizard | ✓ | ✗ | ✗ |
| Admin Settings (Users/RBAC/Audit Log) | ✓ | ✗ | ✗ |

> **Note:** There is no separate "Accounts/Khata Officer" role in the system's RBAC. That persona from the PRD operates under the **Manager** role.

### 2.2 Default Landing Screen (Role-Dependent)

- **Operator:** lands directly on **POS Billing** after login (skips Dashboard — this is where they spend nearly all their time).
- **Admin / Manager:** land on the **Dashboard**.

### 2.3 Cart Persistence While Navigating

If an Operator has items in the POS cart and clicks away to another sidebar screen (e.g., Parts Catalog to check something), the cart is preserved automatically in memory — no action needed. This is distinct from the "parking" mechanism, which only triggers on a user switch or idle lock.

### 2.4 Top Bar

User name + role display, language toggle, "Switch User" button, a notification bell (backup reminders, low-stock alerts), current date/time.

---

## 3. POS Billing Flow

```
Operator lands on POS Billing (default)
        |
        v
  Empty cart, cursor focused on search/scan field
        |
        v
  Scan barcode  OR  search by name/OEM#/model
        |
        +--> Exact match (scan) --> auto-added to cart, qty 1
        +--> Multiple matches (search) --> list shown, operator selects
        +--> No match --> "Not found" message
        |
        v
  Adjust qty / remove line items
        |
        v
  Select customer (optional for Cash, mandatory for Credit)
        |
        v
  [If Credit] Credit limit check --> if exceeded, Admin PIN required
        |
        v
  [Optional] Apply invoice-level discount --> always requires Admin PIN
        |
        v
  "Confirm Sale"
        |
        v
  DB WRITE (atomic, happens FIRST): FIFO stock deduction, invoice +
  line items created, ledger updated if credit
        |
        v
  Print attempt (PDF render, Urdu-safe, silent direct print)
  --> If printer fails: sale is already saved; "Reprint" available
        |
        v
  Cart resets for next customer
```

**Locked business rules:**
- **Stock over-sell:** hard-blocked — cannot sell more than available stock, no override.
- **Unit price override:** always requires Admin PIN (no free tier).
- **Discount:** invoice-level only (no per-line-item discount); always requires Admin PIN.
- **Payment:** Cash sales use Amount Tendered → auto-calculated Change Due. Credit sales support partial/split payment naturally through the existing `paid_amount` field — any amount not paid immediately is added to the customer's Khata balance.
- **Cancel (pre-confirm):** clears the cart; nothing was ever written to the database.
- **Post-sale corrections:** handled entirely through the separate Returns & Claims flow (Section 5), never inside POS Billing itself.

---

## 4. Parts Catalog Flow

- **Search/View:** available to all roles (also usable directly from the POS search field).
- **Add / Edit part, price changes:** Admin/Manager only.
- **Manual stock adjustment** (e.g., damage, physical count correction): Admin/Manager only, requires a mandatory reason/note, and is logged to `audit_log` under a new `STOCK_ADJUSTMENT` action type.
- **Low stock alerts:** trigger when `current_total_stock` falls below `min_reorder_level`, surfaced on the Dashboard.

---

## 5. Khata Ledger Flow

- Customer/supplier list — searchable by name/phone, sortable by balance.
- Customer detail view — balance, credit limit, full transaction history (invoices + payments).
- **Record Payment** — customer pays cash against an outstanding balance.
- **New customer/account creation.**
- **Credit limit setting/changes:** Admin only.

---

## 6. GRN / Purchase Flow

```
Manager/Admin --> select Supplier --> add line items (part, qty received, unit cost)
              --> Landed cost (freight/customs/handling) entered MANUALLY,
                  per line, by the Admin/Manager creating the GRN
              --> Confirm --> new FIFO batch(es) created, stock increased
```

---

## 7. Returns & Claims Flow

### 7.1 Customer Sales Return

```
Operator --> select original invoice --> select item(s) to return
         --> select reason --> submit (status: PENDING_APPROVAL)
                |
                v
    Manager/Admin --> reviews --> Approve or Reject
                |
                v (if approved)
    Refund method chosen AT APPROVAL TIME: Cash refund OR Khata credit note
    Stock is added back into the ORIGINAL FIFO batch (re-activates it
    if it had previously been exhausted)
```

### 7.2 Supplier Warranty Claim

A separate, simpler flow — **Manager/Admin only**, no Operator initiation step (this is an internal/supplier-facing process, not a counter transaction).

**New schema needed:** `returns_claims` table with a `status` field (`PENDING_APPROVAL`, `APPROVED`, `REJECTED`), plus `approved_by` and `approved_at` — stock/ledger changes only apply once approved.

---

## 8. Backup & Restore Flow

### 8.1 Automatic Backup
Runs silently in the background (default: end of business day, interval configurable). On success, the "Last backup" status quietly updates. On failure (e.g., configured USB not connected), a warning surfaces on the Dashboard.

### 8.2 Manual Backup
Admin clicks "Backup Now" → progress indicator → confirmation: "Saved to [path] at [time]."

### 8.3 Restore (Highest-Risk Operation)

```
Admin --> "Restore from Backup" --> select backup file
       --> PRAGMA integrity_check runs on the selected file
              |
              +--> Fails: error shown, nothing touched, current DB untouched
              +--> Passes:
                     --> System AUTOMATICALLY takes a safety backup
                         of the CURRENT database first
                     --> Strong warning shown: "This will replace ALL
                         current data with the backup from [date]. This
                         cannot be undone unless you have another backup."
                     --> Admin confirms --> DB file swapped --> app reloads
```

---

## 9. Legacy Import Wizard Flow

```
Admin --> select .accdb file
       --> connect via ACE OLEDB (prompts to install the Access
           Database Engine Redistributable if missing)
       --> auto field-mapping proposed --> Admin reviews/adjusts
           any ambiguous mappings
       --> validation pass runs
              --> problematic records are AUTOMATICALLY SKIPPED
                  and listed in a report (import is not blocked,
                  nothing aborts)
       --> Opening Stock Cost entry:
              --> Admin can select MULTIPLE parts and apply one
                  cost to all of them at once (bulk entry), or
                  enter individually where needed
       --> Summary screen: "X records will be imported, Y flagged
           and skipped — review report"
       --> Confirm --> import runs --> logged to migration_log
       --> "Import complete" screen
```

---

## 10. New Schema Items Surfaced by This Flow Discussion

These weren't in the PRD/TRD schema yet and should be added when those documents are next updated:

```sql
-- Parked cart for shift-change / idle-lock (one per operator)
CREATE TABLE parked_carts (
    parked_id TEXT PRIMARY KEY,
    user_id TEXT NOT NULL REFERENCES local_users(id),
    cart_payload_json TEXT NOT NULL,
    parked_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Customer returns & supplier warranty claims, with approval workflow
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

`audit_log.action_type` gains a new value: `'STOCK_ADJUSTMENT'`.

---

## 11. Open Items

- These new tables/fields need to be folded into the PRD's schema section and the TRD's database design section.
- The Project Charter still separately needs its Van Sales references removed (flagged earlier, still pending).
