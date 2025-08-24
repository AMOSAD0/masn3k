import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../core/constants.dart';
import '../features/inventory/presentation/bloc/inventory_bloc.dart';
import '../features/inventory/presentation/pages/inventory_page.dart';
import '../features/dashboard/presentation/bloc/dashboard_bloc.dart';
import '../features/dashboard/presentation/pages/index.dart';
import '../features/production/presentation/pages/index.dart';
import '../features/sales/presentation/pages/index.dart';
import '../features/accounting/presentation/pages/index.dart';
import '../features/workers/presentation/pages/index.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  int _selectedIndex = 0;

  final List<Widget> _pages = [
    const DashboardHomePage(),
    const InventoryPage(),
    const ProductionPage(),
    const SalesPage(),
    const AccountingPage(),
    const WorkersPage(),
  ];

  @override
  void initState() {
    super.initState();
    // Load initial data
    context.read<InventoryBloc>().add(LoadInventorySummary());
    context.read<DashboardBloc>().add(LoadDashboardSummary());
    context.read<DashboardBloc>().add(LoadRecentActivity());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppConstants.appName),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {
              // TODO: Navigate to settings
            },
          ),
        ],
      ),
      body: _pages[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: _selectedIndex,
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.dashboard),
            label: AppStrings.dashboard,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.inventory),
            label: AppStrings.inventory,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.precision_manufacturing),
            label: AppStrings.production,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.point_of_sale),
            label: AppStrings.sales,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.account_balance),
            label: AppStrings.accounting,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.people),
            label: AppStrings.workers,
          ),
        ],
      ),
    );
  }
}
