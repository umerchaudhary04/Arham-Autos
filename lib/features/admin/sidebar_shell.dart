import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/security/auth_provider.dart';
import '../../core/db/database.dart';
import '../reports/dashboard_screen.dart';
import '../pos/pos_billing_screen.dart';
import '../parts/parts_catalog_screen.dart';
import '../ledger/khata_ledger_screen.dart';
import '../purchases/grn_screen.dart';
import '../reports/reports_screen.dart';
import '../import/import_wizard_screen.dart';
import '../returns/returns_claims_screen.dart';
import '../admin/backup_restore_screen.dart';
import '../gl/gl_screen.dart';
import '../hr/hr_screen.dart';
import 'settings_screen.dart';

class SidebarShell extends ConsumerStatefulWidget {
  const SidebarShell({super.key});

  @override
  ConsumerState<SidebarShell> createState() => _SidebarShellState();
}

class _SidebarShellState extends ConsumerState<SidebarShell> {
  int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    // Default landing screen based on role
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final user = ref.read(authProvider).user;
      if (user?.role == 'Operator') {
        setState(() => _selectedIndex = 1); // POS Billing
      }
    });
  }

  void _switchUser() async {
    final user = ref.read(authProvider).user;
    if (user != null) {
      final db = ref.read(databaseProvider);

      // Save parked cart (Mock payload for now, real cart serialization comes in Phase 4)
      await db
          ?.into(db.parkedCarts)
          .insertOnConflictUpdate(
            ParkedCartsCompanion.insert(
              parkedId: 'cart_${user.id}',
              userId: user.id,
              cartPayloadJson: '{"items": []}',
            ),
          );
    }
    ref.read(authProvider.notifier).switchUser();
  }

  @override
  Widget build(BuildContext context) {
    final user = ref.watch(authProvider).user;
    if (user == null) return const SizedBox.shrink();

    final isAdmin = user.role == 'Admin';
    final isManager = user.role == 'Manager' || isAdmin;

    final navItems = <_NavItem>[
      _NavItem(
        icon: Icons.dashboard,
        label: 'Dashboard',
        screen: const DashboardScreen(),
      ),
      _NavItem(
        icon: Icons.point_of_sale,
        label: 'POS Billing',
        screen: const PosBillingScreen(),
      ),
      _NavItem(
        icon: Icons.inventory_2,
        label: 'Parts Catalog',
        screen: const PartsCatalogScreen(),
      ),
      _NavItem(
        icon: Icons.book,
        label: 'Khata Ledger',
        screen: const KhataLedgerScreen(),
      ),
      if (isManager)
        _NavItem(
          icon: Icons.local_shipping,
          label: 'Purchases / GRN',
          screen: const GrnScreen(),
        ),
      _NavItem(
        icon: Icons.assignment_return,
        label: 'Returns & Claims',
        screen: const ReturnsClaimsScreen(),
      ),
      if (isManager)
        _NavItem(
          icon: Icons.analytics,
          label: 'Reports',
          screen: const ReportsScreen(),
        ),
      if (isManager)
        _NavItem(
          icon: Icons.account_balance,
          label: 'Accounts & Expenses',
          screen: const GlScreen(),
        ),
      if (isManager)
        _NavItem(
          icon: Icons.people,
          label: 'Employees',
          screen: const HrScreen(),
        ),
      if (isAdmin)
        _NavItem(
          icon: Icons.backup,
          label: 'Backup & Restore',
          screen: const BackupRestoreScreen(),
        ),
      if (isAdmin)
        _NavItem(
          icon: Icons.import_export,
          label: 'Legacy Import Wizard',
          screen: const ImportWizardScreen(),
        ),
      if (isAdmin)
        _NavItem(
          icon: Icons.settings,
          label: 'Settings',
          screen: const SettingsScreen(),
        ),
    ];

    // Ensure selected index is valid
    if (_selectedIndex >= navItems.length) {
      _selectedIndex = 0;
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('${user.fullName} (${user.role})'),
        actions: [
          IconButton(
            icon: const Icon(Icons.swap_horiz),
            tooltip: 'Switch User',
            onPressed: _switchUser,
          ),
          IconButton(
            icon: const Icon(Icons.lock),
            tooltip: 'Lock',
            onPressed: () => ref.read(authProvider.notifier).lock(),
          ),
        ],
      ),
      body: Row(
        children: [
          NavigationRail(
            selectedIndex: _selectedIndex,
            onDestinationSelected: (idx) =>
                setState(() => _selectedIndex = idx),
            labelType: NavigationRailLabelType.all,
            destinations: navItems
                .map(
                  (item) => NavigationRailDestination(
                    icon: Icon(item.icon),
                    label: Text(item.label),
                  ),
                )
                .toList(),
          ),
          const VerticalDivider(thickness: 1, width: 1),
          Expanded(child: navItems[_selectedIndex].screen),
        ],
      ),
    );
  }
}

class _NavItem {
  final IconData icon;
  final String label;
  final Widget screen;
  _NavItem({required this.icon, required this.label, required this.screen});
}

class _PlaceholderScreen extends StatelessWidget {
  final String title;
  const _PlaceholderScreen(this.title);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(title, style: Theme.of(context).textTheme.headlineMedium),
    );
  }
}
