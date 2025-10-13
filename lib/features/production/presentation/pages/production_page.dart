import 'package:flutter/material.dart';
import 'package:masn3k/core/constants.dart';
import 'package:masn3k/features/production/presentation/dialogs/create_machine_dialog.dart';
import 'package:masn3k/features/production/presentation/dialogs/log_breakdown_dialog.dart';
import 'package:masn3k/features/production/presentation/dialogs/log_maintenance_dialog.dart';
import 'package:masn3k/features/production/presentation/model/machien_ui_model.dart';
import 'package:masn3k/features/production/presentation/model/order_ui_model.dart';
import 'package:masn3k/features/production/presentation/widgets/machine_list_item.dart';
import 'package:masn3k/features/production/presentation/widgets/order_list.dart';
import 'package:masn3k/features/production/presentation/widgets/status_filter_chips.dart';
import 'package:masn3k/features/production/presentation/widgets/inventory_info_card.dart';
import 'package:masn3k/features/production/presentation/widgets/machine_actions_bar.dart';
import 'package:masn3k/features/production/presentation/dialogs/create_order_dialog.dart';

class ProductionPage extends StatefulWidget {
  const ProductionPage({super.key});

  @override
  State<ProductionPage> createState() => _ProductionPageState();
}

class _ProductionPageState extends State<ProductionPage>
    with TickerProviderStateMixin {
  late TabController _tabController;

  // UI-only demo state (no backend)
  OrderStatus? _filter;
  final List<OrderUiModel> _orders = [
    OrderUiModel(
      machine: 'آلة 1',
      product: 'منتج A',
      qty: 100,
      status: OrderStatus.pending,
    ),
    OrderUiModel(
      machine: 'آلة 2',
      product: 'منتج B',
      qty: 50,
      status: OrderStatus.inProgress,
    ),
  ];
  final List<MachineUiModel> _machines = [
    MachineUiModel(name: 'آلة 1', location: 'الخط 1', status: 'active'),
    MachineUiModel(name: 'آلة 2', location: 'الخط 2', status: 'maintenance'),
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(AppStrings.production),
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: 'الإنتاج'),
            Tab(text: 'الآلات'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [_buildOrdersTab(), _buildMachinesTab()],
      ),
      floatingActionButton: _buildFAB(),
    );
  }

  Widget _buildFAB() {
    return FloatingActionButton(
      onPressed: () => _tabController.index == 0
          ? _showCreateOrderDialog()
          : _showCreateMachineDialog(),
      child: const Icon(Icons.add),
    );
  }

  Widget _buildOrdersTab() {
    final orders = _filter == null
        ? _orders
        : _orders.where((o) => o.status == _filter).toList();

    return Column(
      children: [
        StatusFilterChips(
          currentFilter: _filter,
          onFilterChanged: (filter) => setState(() => _filter = filter),
        ),
        const InventoryInfoCard(),
        const SizedBox(height: 8),
        Expanded(
          child: orders.isEmpty
              ? const Center(child: Text('لا توجد أوامر'))
              : ListView.separated(
                  itemCount: orders.length,
                  separatorBuilder: (_, __) => const Divider(height: 1),
                  itemBuilder: (context, index) {
                    return OrderListItem(
                      order: orders[index],
                      onStart: () => setState(
                        () => orders[index].status = OrderStatus.inProgress,
                      ),
                      onComplete: () => setState(
                        () => orders[index].status = OrderStatus.completed,
                      ),
                      onEdit: () =>
                          _showCreateOrderDialog(existing: orders[index]),
                      onCancel: () =>
                          setState(() => _orders.remove(orders[index])),
                    );
                  },
                ),
        ),
      ],
    );
  }

  Widget _buildMachinesTab() {
    return Column(
      children: [
        MachineActionsBar(
          onAddMachine: _showCreateMachineDialog,
          onLogBreakdown: _showLogBreakdownDialog,
          onLogMaintenance: _showLogMaintenanceDialog,
        ),
        const Divider(height: 1),
        Expanded(
          child: ListView.separated(
            itemCount: _machines.length,
            separatorBuilder: (_, __) => const Divider(height: 1),
            itemBuilder: (context, index) {
              return MachineListItem(
                machine: _machines[index],
                onEdit: () =>
                    _showCreateMachineDialog(existing: _machines[index]),
                onDelete: () =>
                    setState(() => _machines.remove(_machines[index])),
              );
            },
          ),
        ),
      ],
    );
  }

  void _showCreateOrderDialog({OrderUiModel? existing}) {
    showDialog(
      context: context,
      builder: (_) => CreateOrderDialog(
        existing: existing,
        machines: _machines.map((m) => m.name).toList(),
        onSave: (order) {
          setState(() {
            if (existing != null) {
              final index = _orders.indexOf(existing);
              _orders[index] = order;
            } else {
              _orders.add(order);
            }
          });
        },
      ),
    );
  }

  void _showCreateMachineDialog({MachineUiModel? existing}) {
    showDialog(
      context: context,
      builder: (_) => CreateMachineDialog(
        existing: existing,
        onSave: (machine) {
          setState(() {
            if (existing != null) {
              final index = _machines.indexOf(existing);
              _machines[index] = machine;
            } else {
              _machines.add(machine);
            }
          });
        },
      ),
    );
  }

  void _showLogBreakdownDialog() {
    showDialog(
      context: context,
      builder: (_) => LogBreakdownDialog(
        machines: _machines.map((m) => m.name).toList(),
        onSave: () {
          // Handle breakdown logging
        },
      ),
    );
  }

  void _showLogMaintenanceDialog() {
    showDialog(
      context: context,
      builder: (_) => LogMaintenanceDialog(
        machines: _machines.map((m) => m.name).toList(),
        onSave: () {
          // Handle maintenance logging
        },
      ),
    );
  }
}
