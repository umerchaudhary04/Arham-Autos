# Arham Autos Modernization — Project Charter (Revised)
**Document Status:** Draft | In Review | Approved

---

## Executive Summary

Our plan is to modernize the legacy MS Access application (Zaib Ali Autos) into **Arham Autos** — a robust, bilingual (English/Urdu) Flutter-based desktop suite running **entirely offline on a local SQLite database**, on a single Windows terminal. By replacing fragile legacy business logic with a reliable, zero-network-dependency system, we eliminate current operational bottlenecks and secure sensitive financial data on-premises — with **no dependency on internet connectivity, cloud infrastructure, or third-party hosting of any kind.** *(Field/van sales support is out of scope for this phase — see Scope and Exclusion.)*

---

## Project Goal

**SMART:** Develop, test, and launch a complete, **fully offline** auto parts management suite for a single Windows terminal — featuring zero-latency local SQLite billing, an automated local Backup & Restore engine, and an Admin-only Legacy Data Import Wizard — replacing the legacy MS Access system with zero operational downtime across an **11-sprint (approx. 5–5.5 month)** execution timeline, at **zero ongoing cloud infrastructure cost.**

---

## Deliverables

1. Native Windows Desktop App (Flutter) for POS Counter & Administration — single terminal, fully offline. *(No mobile/tablet component in this phase.)*
2. Localized Dual-Language Engine (Urdu RTL and English LTR), capable of hot-swapping under 100ms.
3. **Local Backup & Restore Engine** — automated scheduled backups to local/external storage, plus a guided restore wizard with an automatic safety-backup before any restore. *(Replaces the original cloud sync engine.)*
4. **Legacy Data Import Wizard** — Admin-only in-app tool to import data from the legacy `.accdb` file, with field mapping, validation, and manual opening-stock cost entry. *(Replaces the original CRDT sync worker.)*
5. Comprehensive Business Modules: Auto Parts Catalog, FIFO Inventory Valuation, Customer/Supplier Khata Ledger, Purchase & GRN, and Returns & Claims with an Operator-initiate/Manager-approve workflow.
6. **Audit Trail Logging** for sensitive Admin-PIN override actions, stock adjustments, and data exports.
7. Fully documented App Flow (navigation, roles, screen-by-screen journeys) and UI/UX Brief.
8. ISO/IEC/IEEE 29148:2018 Compliant Software Requirements Specification (SRS) and Documentation.

---

## Business Case / Background

**Why are we doing this?**

The legacy Zaib Ali Autos system (2-tier MS Access .accdb) suffers from unstructured business logic embedded in VBA macros, missing multi-language support, and file-locking crashes from concurrent counter access. Modernizing to **Arham Autos** — a single-terminal Flutter application backed entirely by a local, encrypted SQLite database — removes the concurrency/corruption problem **by architectural design** (only one terminal ever writes to the database), delivers instant startup times (< 1.5s), and establishes Role-Based Access Control (RBAC) to secure sensitive cost price and margin data. Because the system requires no cloud infrastructure, it also removes all ongoing hosting costs and any dependency on internet connectivity for daily operations.

---

## Benefits & Costs

**Benefits:**
- Zero-data-loss guarantee during power outages via Write-Ahead Logging (WAL).
- Concurrency and database corruption issues eliminated by architecture (single terminal, single writer) rather than requiring conflict-resolution engineering.
- Accurate, automated First-In-First-Out (FIFO) COGS calculations and double-entry ledger integrity.
- Immediate UI accessibility for diverse staff through instant English/Urdu layout switching.
- **Zero recurring cloud or hosting costs** — no PostgreSQL server, no subscription fees, no internet dependency for any core function.
- **Full data ownership** — all business, pricing, and customer data stays physically on the shop's own machine.

**Costs:**
- Development and engineering resources across an 11-sprint agile roadmap.
- Database migration and legacy VBA reverse-engineering analysis.
- Software packaging (MSIX / Inno Setup) and deployment operations.
- Ongoing owner responsibility: maintaining a backup discipline (external drives, periodic off-site copy), since there is no cloud redundancy to fall back on.

*(Note: the original "Cloud infrastructure hosting" cost line has been removed — no longer applicable.)*

**Budget needed:** To be determined during Phase 1 Requirements Elicitation & Legacy Deconstruction.

---

## Scope and Exclusion

**In-Scope:** Desktop POS system development (single terminal), SQLite local database encryption (SQLCipher), English/Urdu localization engine, legacy MS Access data migration via an in-app Import Wizard, local Backup & Restore engine, Returns & Claims approval workflow, audit logging, native Windows packaging.

**Out-of-Scope:** Consumer-facing eCommerce website; **mobile/tablet Van or Spot Sales module of any kind**; cloud hosting or any PostgreSQL/remote database; multi-terminal or LAN-based concurrent access; real-time or automatic sync between devices; cash drawer hardware integration; procurement of physical hardware (Windows PCs, tablets, thermal printers, barcode scanners, external backup drives); external human resources or payroll management modules.

---

## Project Team

**Project Sponsor:** Executive Management, Arham Autos
**Project Lead:** Project Manager
**Project Team:** Lead Flutter Developer (Desktop), **Local Database Specialist (SQLite/SQLCipher)**, UI/UX Engineer (i18n & RTL Specialist), QA & ISO Verification Tester, Deployment Specialist.
**Additional Stakeholders:** Counter Sales Executives, Parts Store Managers, Accounts/Khata Officers.

*(Notes: "Database Architect (SQLite/PostgreSQL)" has been replaced with "Local Database Specialist (SQLite/SQLCipher)" — the PostgreSQL responsibility no longer exists. "Lead Flutter Developer (Desktop & Mobile)" is now Desktop-only. "Spot/Van Sales Drivers" removed as a stakeholder — no van module in this phase. The Accounts/Khata Officer persona operates under the system's Manager role — there is no separate RBAC role for it.)*

---

## Measuring Success

**What is acceptable:**
- App renders the splash screen in under 1.5s while validating SQLite encryption keys — with no network check of any kind performed.
- Invoice line-item rendering processes in under 100ms at a locked 60 FPS UI performance on standard Intel Core i3 hardware.
- Search queries retrieve available stock and pricing across 100,000+ SKUs in < 200ms.
- Automated local backup completes successfully on its configured schedule without blocking or freezing POS operations.
- Restoring from a backup automatically takes a safety backup of the current database first, and only proceeds after `PRAGMA integrity_check` passes on the selected backup file.
- Customer returns cannot affect stock or ledger balances until explicitly approved by a Manager or Admin.
- System securely prevents credit sales exceeding a customer's max credit limit without an Admin PIN override, and every such override is recorded in the audit trail.

*(Note: the original CRDT sync and Van Sales import success metrics have been removed — no longer applicable.)*
