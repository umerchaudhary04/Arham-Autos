# Implementation Plan
## Arham Autos Desktop Suite

This plan converts the PRD, TRD, App Flow, and UI/UX Brief into a concrete, sprint-by-sprint execution roadmap. 11 sprints, ~5–5.5 months, single Windows desktop application, fully offline.

---

## 1. Team (from Project Charter)

- Lead Flutter Developer (Desktop)
- Local Database Specialist (SQLite/SQLCipher)
- UI/UX Engineer (i18n & RTL Specialist)
- QA & ISO Verification Tester
- Deployment Specialist

---

## 2. Sprint-by-Sprint Breakdown

### Phase 1 — Requirements & Legacy Reverse Engineering

**Sprint 1**
- Map all legacy `.accdb` tables, query definitions, and VBA macros (FIFO logic, landed cost, ledger updates).
- Confirm ISO 29148 SRS sign-off (already largely captured in the PRD/TRD from our discussions).
- Finalize screen inventory against the UI/UX Brief.

**Sprint 2**
- Finalize `drift` schema definitions from the PRD/TRD schema (including `parked_carts`, `returns_claims`, `backup_log`, `audit_log`, `migration_log`).
- Set up project skeleton per the TRD's folder structure (`/features`, `/core`).
- Set up dev environment, linting, Riverpod provider scaffolding conventions.

**Milestone:** Schema frozen, project skeleton compiles and runs an empty shell app.

---

### Phase 2 — Core Infrastructure

**Sprint 3**
- Integrate `drift` + `sqlcipher_flutter_libs`, WAL mode enabled.
- Build the hybrid encryption key management flow: DPAPI auto-unlock + Recovery Key generation logic (not yet wired to UI).
- Set up `flutter_localizations` + `intl`, ARB files (`en.arb`, `ur.arb`), bundle the Urdu Nastaliq font.

**Sprint 4**
- Build the Backup Engine core logic: scheduled trigger, manual trigger, timestamped file naming, `backup_log` writes, folder-size/free-space calculation.
- Build the Restore core logic: `PRAGMA integrity_check`, automatic safety-backup-before-restore, file swap.
- `window_manager` setup for desktop windowing.

**Milestone:** Encrypted database can be created, backed up, and restored from the command line/test harness (no UI yet).

---

### Phase 3 — Auth, RBAC, Splash & Encryption Bootstrap

**Sprint 5**
- Splash screen (target: renders in <1.5s, validates DB key, warms catalog cache).
- First-Time Setup Wizard: Admin account creation (username/password/PIN together), default language, Recovery Key display with checkbox + retype-last-4-characters confirmation, mandatory backup location picker.
- Login screen: PIN pad + username/password toggle.

**Sprint 6**
- RBAC framework: Admin / Manager / Operator role checks wired into navigation and action gating.
- Per-user `preferred_language` — auto-switch on login.
- Idle auto-lock (configurable timeout in Admin Settings).
- Shift-change "Switch User" flow + `parked_carts` (one per operator, auto-park/resume).
- Sidebar navigation shell with role-based item visibility (per the UI/UX Brief's table).

**Milestone:** A user can go through first-time setup, log in/out, switch users with a parked cart, and see a role-appropriate (empty) sidebar and Dashboard shell.

---

### Phase 4 — Core Business Modules

**Sprint 7**
- Parts Catalog & Search (multi-attribute: OEM #, name, model, rack location).
- FIFO Inventory Engine (batch consumption logic, COGS calculation).
- Manual stock adjustment (Admin/Manager only, mandatory reason, `audit_log` write with `STOCK_ADJUSTMENT`).

**Sprint 8**
- POS Billing screen — the highest-priority screen:
  - Scan/search → cart → qty/price editing
  - Hard stock-limit block (no oversell)
  - Admin PIN modal (reusable component) for price override, discount, and credit-limit-exceed cases
  - Invoice-level discount only
  - Cash flow: Amount Tendered + Change Due
  - Credit flow: customer selection, partial/split payment via `paid_amount`, remainder to Khata
  - Commit-then-print sequence (DB write first, PDF render + silent print second, Reprint option)
  - Cart persistence across sidebar navigation

**Sprint 9**
- Khata Ledger: customer/supplier list, balance/credit-limit progress indicator, transaction history, Record Payment, credit limit management (Admin only).
- Purchases/GRN: supplier selection, line items, manual per-line landed cost entry, new FIFO batch creation.
- Returns & Claims: Operator-initiate → Manager/Admin-approve workflow for customer returns (refund method chosen at approval: cash or Khata credit; stock returns to original FIFO batch); separate Manager/Admin-only Supplier Warranty Claim flow.

**Milestone:** A full sale can be rung up, printed, and reflected correctly in stock and ledger; a return can be initiated and approved end-to-end.

---

### Phase 5 — Legacy Import Wizard & Hardware Integration

**Sprint 10**
- Legacy Import Wizard: `.accdb` connection via ACE OLEDB, auto field-mapping + review screen, validation pass with auto-skip-and-report for flagged records, bulk opening-stock-cost entry (multi-select + apply), summary screen, `migration_log` write.
- Hardware integration: PDF invoice rendering with embedded Urdu font, silent direct-print via the `printing` package, 58mm/80mm configurable paper width, barcode scanner (keyboard-wedge) input handling and testing.
- Dashboard & Reports: role-based KPI views (Operator sees Today's Sales only; Admin/Manager see full KPIs), low-stock and backup-overdue banners.
- Data Export: Admin-only CSV/Excel export (full report, cost/margin included), logged to `audit_log`.
- Admin Settings: user management, audit log viewer, idle-lock timeout configuration.

**Milestone:** Feature-complete build — every FR in the PRD is implemented and manually walkable end-to-end.

---

### Phase 6 — QA, Packaging & Launch

**Sprint 11+**
- Full regression pass against the PRD's Verification & Test Plan:
  1. Urdu/RTL hot-swap test
  2. FIFO cost calculation test (₨19,500 COGS scenario)
  3. Credit limit enforcer + Admin PIN override + audit log verification
  4. Backup & Restore drill (forced power-failure + WAL recovery; restore-from-backup with safety-backup verification)
  5. Legacy Migration Import test (sample `.accdb`, flagged-record handling, opening-stock batch creation)
- Stress testing at 100,000+ SKUs (search latency, POS render latency, 60 FPS on Intel i3/4GB RAM reference hardware).
- Inno Setup installer build; bundle/check for the Access Database Engine Redistributable dependency.
- User Acceptance Testing (UAT) with actual Arham Autos counter staff — this is where keyboard-navigation and Urdu-fluency assumptions get validated against real usage.
- Legacy data cutover: run the Import Wizard against the real production `.accdb`, verify against a manual spot-check of key accounts/balances.
- Production launch / go-live.

**Milestone:** Signed-off launch build installed on the shop's terminal, legacy system retired.

---

## 3. Dependencies & Critical Path

- **Encryption (Sprint 3) must land before any screen touches real data** — nothing downstream should be built against an unencrypted dev database that later needs retrofitting.
- **RBAC (Sprint 6) must land before POS Billing (Sprint 8)** — the Admin PIN modal pattern is used throughout POS Billing and Returns, so it needs to exist and be stable first.
- **Backup Engine (Sprint 4) should exist before real data entry begins in QA** — so test data itself is protected and restorable during development.
- **FIFO Engine (Sprint 7) must precede POS Billing (Sprint 8) and GRN (Sprint 9)** — both depend on correct batch consumption/creation logic.
- **Legacy Import Wizard (Sprint 10) depends on the final schema being frozen (Sprint 2)** — any late schema changes ripple into the field-mapping logic.

---

## 4. Risk Areas to Watch

- **Access Database Engine Redistributable compatibility** — confirm 32-bit vs 64-bit driver matches the target Windows installs before Sprint 10; mismatches are a common real-world snag with legacy `.accdb` access.
- **Urdu Nastaliq rendering on thermal printers** — the PDF-render approach (Section 9 of the TRD) mitigates this, but should be visually verified early (Sprint 10) on the actual printer hardware the shop will use, not just on-screen.
- **Opening-stock cost entry fatigue** — the bulk-entry tool helps, but if the legacy catalog has thousands of SKUs, budget real time in Sprint 10/11 for the Admin to actually complete this during migration rehearsal, not just at go-live.
- **Idle-lock/parked-cart UX** — since these are new patterns (not in the original legacy system), flag for extra attention during UAT to make sure staff don't lose work unexpectedly.

---

## 5. Definition of Done (Per Phase)

| Phase | Done When |
|---|---|
| 1 | Schema frozen and reviewed; legacy logic fully mapped on paper |
| 2 | Encrypted DB + backup/restore work via test harness, no UI needed |
| 3 | First-time setup → login → role-based empty shell works end-to-end |
| 4 | A sale can be rung up, printed, and correctly reflected in stock/ledger; a return can complete its approval cycle |
| 5 | Every FR in the PRD is implemented and manually walkable |
| 6 | Full test plan passes, installer built, real legacy data migrated and spot-checked, staff trained |
