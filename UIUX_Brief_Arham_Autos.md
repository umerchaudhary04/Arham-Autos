# UI/UX Brief
## Arham Autos Desktop Suite

This brief translates the PRD, TRD, and App Flow documents into design-ready guidance — for whoever builds the actual screens (designer, Stitch, or directly in Flutter).

---

## 1. Project Context

A single Windows desktop application for a single auto-parts shop counter — fully offline, no cloud, no mobile companion app in this phase. Replaces a legacy MS Access system. Bilingual (English/Urdu) with full RTL mirroring for Urdu.

---

## 2. Users & Roles

| Role | Who | Primary Screen Time |
|---|---|---|
| **Operator** | Counter Sales staff | POS Billing (default landing), light use of Parts/Khata (view-only) |
| **Manager** | Store Manager, also covers "Khata/Accounts Officer" duties | Dashboard, Parts, Khata, GRN, Returns approval, Reports (view) |
| **Admin** | Owner/senior staff | Everything — plus Backup/Restore, Legacy Import, Admin Settings |

Design implication: **the same screen (e.g., Dashboard) must render differently per role** — not just hide a menu item, but change actual content (Operator's Dashboard has no profit/margin data at all).

---

## 3. Platform & Technical Constraints

- **Windows 10/11 desktop**, widescreen (design for 1920×1080 base), resizable window.
- **Keyboard-first for POS Billing** — must be 100% operable via Tab/Enter/F-keys; mouse is a convenience, not a requirement, at the counter.
- **Barcode scanner** behaves as rapid keyboard input into whatever field is focused — the active/focused field at any moment matters a lot for UX.
- **Printer output** is a PDF render at 58mm or 80mm width (configurable) — invoice layout should be designed/tested at both widths.
- **Runs on modest hardware** (Intel i3 / 4GB RAM target) — avoid heavy animations, particle effects, blur/glass effects that could cost frame rate.
- **Zero network** — no loading spinners waiting on network calls, ever. Any "loading" state is purely local disk/DB latency (should be near-instant).

---

## 4. Design Principles

1. **Speed over decoration.** This is used under time pressure at a live counter. Every extra click in the POS flow has a real cost.
2. **Clarity for non-technical staff.** No jargon, no hidden gestures — every action should be an obvious, labeled button.
3. **Urdu is not an afterthought.** Both languages must feel equally native — same information density, same polish, correctly mirrored layout, correct Nastaliq rendering.
4. **Sensitive data is visually distinct.** Cost price/margin fields (Admin/Manager only) should be visually distinguishable so it's obvious when something is a "privileged" view.
5. **Destructive actions look dangerous.** Restore-from-backup, stock adjustments, price/discount overrides — these should visually stand apart (color, icon, confirmation weight) from routine actions.

---

## 5. Visual Style Direction

- **Theme:** Light only (no dark mode planned).
- **Primary color:** deep teal/blue — professional, trustworthy.
- **Accent colors:** green (paid/in-stock/approved), amber (low-stock/pending), red (overdue/blocked/rejected).
- **Typography:** clear hierarchy; **large, bold numerals for prices and totals** on the POS screen specifically — this is glanced at quickly, often by the customer too.
- **Component baseline:** Material Design 3 conventions (cards, buttons, inputs, tables) for a modern, native-feeling desktop business app — not a flashy consumer app aesthetic.
- **Iconography:** simple, universally recognizable icons (not text-only) for sidebar nav, given some staff may have limited literacy in either language.

---

## 6. Information Architecture

### Sidebar (persistent, left-aligned in English / right-aligned in Urdu)

| Item | Admin | Manager | Operator |
|---|---|---|---|
| Dashboard | ✓ (full) | ✓ (full) | ✓ (today's sales only) |
| POS Billing | ✓ | ✓ | ✓ |
| Parts Catalog | ✓ (edit) | ✓ (edit) | ✓ (view) |
| Khata Ledger | ✓ | ✓ | ✓ (view) |
| Purchases/GRN | ✓ | ✓ | ✗ |
| Returns & Claims | ✓ (approve) | ✓ (approve) | ✓ (initiate) |
| Reports | ✓ (+export) | ✓ (view) | ✗ |
| Backup & Restore | ✓ | ✗ | ✗ |
| Legacy Import | ✓ | ✗ | ✗ |
| Admin Settings | ✓ | ✗ | ✗ |

### Top Bar
User name + role badge, language toggle (EN/UR), "Switch User" button, notification bell (backup/low-stock alerts), date/time.

---

## 7. Screen-by-Screen UX Notes

### 7.1 Splash Screen
Logo centered, minimal, under 1.5s. No user interaction.

### 7.2 First-Time Setup Wizard *(only ever seen once)*
A guided, non-skippable, multi-step flow:
1. Admin account (name, username, password, **and PIN — all at once**)
2. Language default
3. Recovery Key display — large, monospace, copyable — with a checkbox **and** a "retype last 4 characters" confirmation field before the Continue button activates
4. Backup location picker (mandatory — Continue stays disabled until set)
5. Optional "Import old data now?" branch into the Legacy Import Wizard

### 7.3 Login Screen
Toggle between **PIN pad** (large numeric buttons, touch-friendly) and **Username/Password** (traditional form). Shows the app's default language until a specific user logs in — then instantly switches to that user's saved preference.

### 7.4 Dashboard
- **Admin/Manager view:** KPI cards (Today's Sales, Gross Profit, Receivables, Low Stock count) + low-stock table + recent transactions.
- **Operator view:** a single, simpler "Today's Sales" summary card only — no profit/margin card exists in this view at all (not just hidden — the layout is genuinely different).
- Backup-reminder banner appears here if the last backup is overdue.

### 7.5 POS Billing *(highest design priority — most-used screen)*
- Large search/scan input, always focused by default when the screen loads or a sale completes.
- Cart as a clean table: Item / Qty (editable inline) / Unit Price / Line Total.
- Right-side summary panel: Subtotal, Discount (Admin-PIN gated — show a small lock icon here), Grand Total in **large bold type**, Cash/Credit toggle, Customer selector (appears only for Credit).
- For Cash: an "Amount Tendered" field with auto-calculated "Change Due" shown prominently.
- For Credit: a "Cash Received Now" field (optional, defaults to 0) — remainder auto-shown as "Added to Khata."
- A visible **"Parked Cart" indicator/badge** if the operator has a parked cart waiting from a previous switch — should be impossible to miss.
- Price-override and discount fields, when touched, should trigger a distinct **Admin PIN modal** (not a generic dialog — this should feel like a clear "step-up" moment).
- "Confirm Sale" is the single largest, most visually dominant button on the screen.
- Post-sale: a lightweight success state with a visible **"Reprint"** option (in case the physical print failed).

### 7.6 Parts Catalog
Search bar + filter chips (Category, Rack Location) + results table (Name, OEM #, Stock, Rack, Price). Admin/Manager see an "Adjust Stock" action per row (opens a small form requiring a reason — this should visually signal it's an audited action).

### 7.7 Khata Ledger
Customer/supplier list with balance shown as a small progress bar against credit limit (turns amber/red as it approaches/exceeds the limit). Detail view: transaction history + "Record Payment" button.

### 7.8 GRN / Purchases *(Manager/Admin only)*
Supplier selector → line-item table (Part, Qty, Unit Cost) → a per-line "Landed Cost" input (manual entry, not automatic) → running total → Confirm.

### 7.9 Returns & Claims
Two visually distinct flows:
- **Customer Return:** invoice lookup → item selection → reason → submit (status badge: Pending). Approval screen (Manager/Admin) shows Approve/Reject with a Refund Method choice (Cash / Khata Credit) that only appears on approval.
- **Supplier Warranty Claim:** a separate, simpler Manager/Admin-only form — should not share the same visual flow as customer returns, to avoid confusing the two.

### 7.10 Backup & Restore *(Admin only)*
Status card: "Last backup: [time]" + backup folder size + free disk space, "Backup Now" button. Restore is a separate, clearly more serious-looking section — multi-step wizard with the strong warning text and confirmation step spelled out in Section 8 of the App Flow doc. This screen should look and feel different (e.g., a warning-colored header) from the rest of the app to signal risk.

### 7.11 Legacy Import Wizard *(Admin only)*
A step-indicator wizard (file select → field mapping → validation report → opening stock bulk-entry table with multi-select → summary → confirm). The validation report screen should clearly separate "will be imported" vs "flagged/skipped" so nothing is silently lost from the Admin's view.

### 7.12 Admin Settings
User management (create/edit/deactivate users, assign roles, reset PINs), audit log viewer (filterable by user/action/date), idle-lock timeout configuration.

---

## 8. Key Interaction Patterns (Reusable Across Screens)

| Pattern | When It Appears | Design Note |
|---|---|---|
| **Admin PIN Modal** | Price override, discount, credit limit exceed, stock over-sell attempt | Should look identical everywhere it's used — one consistent, recognizable "step-up" component |
| **Audit-flagged action** | Manual stock adjustment, any override | Small visual marker (icon/label) indicating "this will be logged" |
| **Parked Cart Badge** | POS Billing, after a switch/idle-lock | High-visibility, impossible to miss on return |
| **Low Stock / Backup Overdue Banners** | Dashboard | Non-blocking but persistent until resolved |
| **Destructive Confirmation** | Restore from backup | Heaviest-weight confirmation UI in the app — deliberately slower/harder to trigger accidentally |

---

## 9. Localization / RTL Requirements

- Every screen must mirror correctly for Urdu — sidebar position, table column order, form field alignment, icon direction (e.g., back arrows).
- Language switch must be instant (<100ms) with no app restart.
- Urdu Nastaliq font must render identically on-screen and on the printed PDF invoice.

---

## 10. Accessibility / Usability Requirements

- 100% keyboard-navigable POS checkout (Tab order must be logical and tested).
- Large touch/click targets throughout — assume some counters may eventually use touchscreens even though mouse/keyboard is the primary input today.
- No reliance on color alone to convey state (pair color with icon/label — important given red/green color-blindness is common).

---

## 11. Explicitly Out of Scope for This Design Pass

- No mobile/tablet screens (Van Sales module removed).
- No dark mode.
- No cash drawer UI/trigger.
- No multi-terminal/LAN-aware UI (single terminal only — no "other user is editing this" conflict states needed).
- No cloud account/login screens of any kind.
