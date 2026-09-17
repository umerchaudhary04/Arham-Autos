# Arham Autos Desktop Suite

Arham Autos Desktop Suite is a fully offline, high-performance Windows desktop application built for managing auto parts inventory, point-of-sale (POS) billing, supplier goods receipt notes (GRN), customer khata (ledger) accounts, and advanced multi-role access control. 

Designed for speed and reliability, this application strictly runs locally on Windows without requiring any internet connection. It is engineered with robust data encryption and a seamless keyboard-first workflow, ensuring rapid checkout and inventory management for the auto parts retail business.

## Key Features

*   **Offline-First & Secure:** Data is stored locally using SQLite in WAL mode with SQLCipher AES-256 encryption. The encryption keys are securely managed via Windows DPAPI.
*   **Keyboard-Wedge Barcode & POS:** Lightning-fast POS billing flow built for 100% keyboard-first navigation (Tab/Enter/F-keys) combined with seamless barcode scanner integration.
*   **FIFO Inventory Engine:** Automatic exact Cost of Goods Sold (COGS) tracking utilizing a strict First-In-First-Out batch logic.
*   **Khata Ledger Management:** Complete ledger management for both Customers and Suppliers, supporting instant credit adjustments and tracking.
*   **Role-Based Access Control (RBAC):** Three strict tiers of authorization:
    *   **Admin:** Full access, configuration, legacy imports, backup/restore, and data exports.
    *   **Manager:** Can manage inventory, adjust stock, handle GRN, approve returns, and view limited reports.
    *   **Operator:** Strictly POS billing and basic customer lookups.
*   **Seamless Localization:** Fully supports English and Urdu (Nastaliq) with instant RTL mirroring without requiring an app restart.
*   **Silent PDF Printing:** Invoices are dynamically generated as PDF files and printed directly and silently to the default thermal/A4 printer, bypassing OS dialogs.
*   **Legacy MS Access Migration:** Built-in "Import Wizard" reading directly from a legacy `.accdb` file via the ACE OLEDB driver to seamlessly import older records.
*   **Robust Backup & Restore:** Features an integrated system to generate localized DB backups and safely restore them via a strictly audited process utilizing `PRAGMA integrity_check`.

## Technology Stack

*   **Framework:** [Flutter](https://flutter.dev/) (Windows Desktop Target)
*   **State Management:** [Riverpod](https://riverpod.dev/) (`flutter_riverpod`, `riverpod_annotation`)
*   **Local Database / ORM:** [Drift](https://drift.simonbinder.eu/) (SQLite)
*   **Database Encryption:** `sqlcipher_flutter_libs`
*   **Security:** `flutter_secure_storage` (Windows Credential Manager / DPAPI)
*   **PDF Generation & Printing:** `pdf` and `printing`
*   **Data Export:** `csv` & `excel`
*   **Desktop Windowing:** `window_manager`
*   **Localization:** `flutter_localizations` & `intl`

## Getting Started

### Prerequisites
*   Flutter SDK (^3.11.4)
*   Windows 10/11 OS for deployment/testing.
*   Microsoft Access Database Engine 2016 64-bit Redistributable (Required for the Legacy Import feature via ACE OLEDB).

### Setup Instructions
1.  **Clone the Repository:**
    ```cmd
    git clone https://github.com/umerchaudhary04/Arham-Autos.git
    cd Arham-Autos
    ```
2.  **Install Dependencies:**
    ```cmd
    flutter pub get
    ```
3.  **Generate Riverpod & Drift Code:**
    ```cmd
    flutter pub run build_runner build --delete-conflicting-outputs
    ```
4.  **Run the App (Windows):**
    ```cmd
    flutter run -d windows
    ```

## Building for Production

To create a release build for Windows:
```cmd
flutter build windows
```
The application installer is configured using **Inno Setup** to correctly bundle dependencies, place binaries in `Program Files`, and store persistent data (database, backups) in `%APPDATA%\ArhamAutos`.

## Security Notes
*   Ensure that the target Windows machine is secured as the encryption key relies on DPAPI tied to the active Windows User Account.
*   Always keep the uniquely generated BitLocker-style recovery key safely stored.

---
**Developer:** Umer Asghar | Flutter Developer
