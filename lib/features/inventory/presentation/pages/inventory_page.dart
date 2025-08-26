import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/constants.dart';
import '../../domain/entities/item.dart';
import '../bloc/inventory_bloc.dart';
import '../widgets/add_item_dialog.dart';
import '../widgets/add_transaction_dialog.dart';
import '../widgets/item_card.dart';

class InventoryPage extends StatefulWidget {
  const InventoryPage({super.key});

  @override
  State<InventoryPage> createState() => _InventoryPageState();
}

class _InventoryPageState extends State<InventoryPage>
    with TickerProviderStateMixin {
  late TabController _tabController;
  final TextEditingController _searchController = TextEditingController();
  late List items = [];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    context.read<InventoryBloc>().add(LoadItems());
  }

  @override
  void dispose() {
    _tabController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(AppStrings.inventory),
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: 'جميع العناصر'),
            Tab(text: 'منخفضة المخزون'),
            Tab(text: 'التقارير'),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              _showSearchDialog();
            },
          ),
        ],
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildAllItemsTab(),
          _buildLowStockTab(),
          _buildReportsTab(),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _showAddItemDialog();
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildAllItemsTab() {
    return BlocBuilder<InventoryBloc, InventoryState>(
      builder: (context, state) {
        if (state is InventoryLoading) {
          return const Center(child: CircularProgressIndicator());
        } else if (state is ItemsLoaded) {
          if (state.items.isEmpty) {
            return const Center(child: Text('لا توجد عناصر في المخزون'));
          }
          items = state.items;
          return ListView.builder(
            padding: const EdgeInsets.all(AppConstants.defaultPadding),
            itemCount: state.items.length,
            itemBuilder: (context, index) {
              final item = state.items[index];
              return ItemCard(
                item: item,
                onEdit: () => _showEditItemDialog(item),
                onDelete: () => _showDeleteItemDialog(item),
                onViewTransactions: () => _showItemTransactions(item),
                onAddTransaction: () => _showAddTransactionDialog(item),
              );
            },
          );
        } else if (items.isNotEmpty) {
          return ListView.builder(
            padding: const EdgeInsets.all(AppConstants.defaultPadding),
            itemCount: items.length,
            itemBuilder: (context, index) {
              final item = items[index];
              return ItemCard(
                item: item,
                onEdit: () => _showEditItemDialog(item),
                onDelete: () => _showDeleteItemDialog(item),
                onViewTransactions: () => _showItemTransactions(item),
                onAddTransaction: () => _showAddTransactionDialog(item),
              );
            },
          );
        } else if (state is InventoryError) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.error, size: 64, color: Colors.red),
                const SizedBox(height: AppConstants.defaultPadding),
                Text(state.message),
                const SizedBox(height: AppConstants.defaultPadding),
                ElevatedButton(
                  onPressed: () {
                    context.read<InventoryBloc>().add(LoadItems());
                  },
                  child: const Text('إعادة المحاولة'),
                ),
              ],
            ),
          );
        }
        return const SizedBox.shrink();
      },
    );
  }

  Widget _buildLowStockTab() {
    return BlocBuilder<InventoryBloc, InventoryState>(
      builder: (context, state) {
        if (state is InventoryLoading) {
          return const Center(child: CircularProgressIndicator());
        } else if (state is LowStockItemsLoaded) {
          if (state.items.isEmpty) {
            return const Center(child: Text('لا توجد عناصر منخفضة المخزون'));
          }
          return ListView.builder(
            padding: const EdgeInsets.all(AppConstants.defaultPadding),
            itemCount: state.items.length,
            itemBuilder: (context, index) {
              final item = state.items[index];
              return ItemCard(
                item: item,
                onEdit: () => _showEditItemDialog(item),
                onDelete: () => _showDeleteItemDialog(item),
                onViewTransactions: () => _showItemTransactions(item),
                onAddTransaction: () => _showAddTransactionDialog(item),
                showWarning: true,
              );
            },
          );
        } else if (state is InventoryError) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.error, size: 64, color: Colors.red),
                const SizedBox(height: AppConstants.defaultPadding),
                Text(state.message),
                const SizedBox(height: AppConstants.defaultPadding),
                ElevatedButton(
                  onPressed: () {
                    context.read<InventoryBloc>().add(LoadLowStockItems());
                  },
                  child: const Text('إعادة المحاولة'),
                ),
              ],
            ),
          );
        }
        return const SizedBox.shrink();
      },
    );
  }

  Widget _buildReportsTab() {
    return BlocBuilder<InventoryBloc, InventoryState>(
      builder: (context, state) {
        return SingleChildScrollView(
          padding: const EdgeInsets.all(AppConstants.defaultPadding),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Summary Card
              if (state is InventorySummaryLoaded) ...[
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(AppConstants.defaultPadding),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'ملخص المخزون',
                          style: Theme.of(context).textTheme.titleLarge
                              ?.copyWith(fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: AppConstants.defaultPadding),
                        Row(
                          children: [
                            Expanded(
                              child: _buildSummaryItem(
                                'إجمالي العناصر',
                                '${state.summary['total_items'] ?? 0}',
                                Icons.inventory,
                              ),
                            ),
                            Expanded(
                              child: _buildSummaryItem(
                                'القيمة الإجمالية',
                                '${state.summary['total_value']?.toStringAsFixed(2) ?? '0'} ريال',
                                Icons.attach_money,
                              ),
                            ),
                            Expanded(
                              child: _buildSummaryItem(
                                'منخفضة المخزون',
                                '${state.summary['low_stock_items'] ?? 0}',
                                Icons.warning,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: AppConstants.defaultPadding),
              ],

              // Reports Buttons
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(AppConstants.defaultPadding),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'التقارير',
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: AppConstants.defaultPadding),
                      Wrap(
                        spacing: AppConstants.smallPadding,
                        runSpacing: AppConstants.smallPadding,
                        children: [
                          ElevatedButton.icon(
                            onPressed: () => _showStockMovementReport(),
                            icon: const Icon(Icons.trending_up),
                            label: const Text('تقرير حركة المخزون'),
                          ),
                          ElevatedButton.icon(
                            onPressed: () => _showLowStockReport(),
                            icon: const Icon(Icons.warning),
                            label: const Text('تقرير المخزون المنخفض'),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildSummaryItem(String title, String value, IconData icon) {
    return Column(
      children: [
        Icon(icon, size: 32, color: Colors.blue),
        const SizedBox(height: AppConstants.smallPadding),
        Text(
          value,
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        Text(
          title,
          style: const TextStyle(fontSize: 12),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  void _showSearchDialog() {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text('بحث في المخزون'),
            content: TextField(
              controller: _searchController,
              decoration: const InputDecoration(
                labelText: 'اسم العنصر أو المورد',
                border: OutlineInputBorder(),
              ),
              onSubmitted: (query) {
                if (query.isNotEmpty) {
                  context.read<InventoryBloc>().add(SearchItems(query));
                }
                Navigator.of(context).pop();
              },
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text(AppStrings.cancel),
              ),
              ElevatedButton(
                onPressed: () {
                  if (_searchController.text.isNotEmpty) {
                    context.read<InventoryBloc>().add(
                      SearchItems(_searchController.text),
                    );
                  }
                  Navigator.of(context).pop();
                },
                child: const Text(AppStrings.search),
              ),
            ],
          ),
    );
  }

  void _showAddItemDialog() {
    showDialog(context: context, builder: (context) => const AddItemDialog());
  }

  void _showEditItemDialog(Item item) {
    showDialog(
      context: context,
      builder: (context) => AddItemDialog(item: item),
    );
  }

  void _showDeleteItemDialog(Item item) {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text('تأكيد الحذف'),
            content: Text('هل أنت متأكد من حذف "${item.name}"؟'),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text(AppStrings.cancel),
              ),
              ElevatedButton(
                onPressed: () {
                  context.read<InventoryBloc>().add(DeleteItem(item.id!, item));
                  Navigator.of(context).pop();
                },
                style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                child: const Text(AppStrings.delete),
              ),
            ],
          ),
    );
  }

  void _showItemTransactions(Item item) {
    context.read<InventoryBloc>().add(LoadItemTransactions(item.id!));
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: Text('معاملات ${item.name}'),
            content: SizedBox(
              width: double.maxFinite,
              height: 400,
              child: BlocBuilder<InventoryBloc, InventoryState>(
                builder: (context, state) {
                  if (state is InventoryLoading) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (state is ItemTransactionsLoaded) {
                    if (state.transactions.isEmpty) {
                      return const Center(child: Text('لا توجد معاملات'));
                    }
                    return ListView.builder(
                      itemCount: state.transactions.length,
                      itemBuilder: (context, index) {
                        final transaction = state.transactions[index];
                        return ListTile(
                          title: Text(transaction.type.name),
                          subtitle: Text('الكمية: ${transaction.quantity}'),
                          trailing: Text(
                            transaction.createdAt.toString().substring(0, 16),
                          ),
                        );
                      },
                    );
                  }
                  return const SizedBox.shrink();
                },
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text(AppStrings.close),
              ),
            ],
          ),
    );
  }

  void _showAddTransactionDialog(Item item) {
    showDialog(
      context: context,
      builder: (context) => AddTransactionDialog(item: item),
    );
  }

  void _showStockMovementReport() {
    final now = DateTime.now();
    final startDate = DateTime(now.year, now.month - 1, now.day);
    context.read<InventoryBloc>().add(LoadStockMovementReport(startDate, now));

    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text('تقرير حركة المخزون'),
            content: SizedBox(
              width: double.maxFinite,
              height: 400,
              child: BlocBuilder<InventoryBloc, InventoryState>(
                builder: (context, state) {
                  if (state is InventoryLoading) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (state is StockMovementReportLoaded) {
                    if (state.report.isEmpty) {
                      return const Center(child: Text('لا توجد بيانات'));
                    }
                    return SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: DataTable(
                        columns: const [
                          DataColumn(label: Text('العنصر')),
                          DataColumn(label: Text('الوارد')),
                          DataColumn(label: Text('المنصرف')),
                          DataColumn(label: Text('المخزون الحالي')),
                        ],
                        rows:
                            state.report.map((row) {
                              return DataRow(
                                cells: [
                                  DataCell(Text(row['item_name'] ?? '')),
                                  DataCell(Text('${row['incoming'] ?? 0}')),
                                  DataCell(Text('${row['outgoing'] ?? 0}')),
                                  DataCell(
                                    Text('${row['current_stock'] ?? 0}'),
                                  ),
                                ],
                              );
                            }).toList(),
                      ),
                    );
                  }
                  return const SizedBox.shrink();
                },
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text(AppStrings.close),
              ),
            ],
          ),
    );
  }

  void _showLowStockReport() {
    context.read<InventoryBloc>().add(LoadLowStockReport());

    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text('تقرير المخزون المنخفض'),
            content: SizedBox(
              width: double.maxFinite,
              height: 400,
              child: BlocBuilder<InventoryBloc, InventoryState>(
                builder: (context, state) {
                  if (state is InventoryLoading) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (state is LowStockReportLoaded) {
                    if (state.report.isEmpty) {
                      return const Center(
                        child: Text('لا توجد عناصر منخفضة المخزون'),
                      );
                    }
                    return SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: DataTable(
                        columns: const [
                          DataColumn(label: Text('العنصر')),
                          DataColumn(label: Text('المخزون الحالي')),
                          DataColumn(label: Text('الحد الأدنى')),
                          DataColumn(label: Text('النقص')),
                          DataColumn(label: Text('قيمة النقص')),
                        ],
                        rows:
                            state.report.map((row) {
                              return DataRow(
                                cells: [
                                  DataCell(Text(row['name'] ?? '')),
                                  DataCell(Text('${row['quantity'] ?? 0}')),
                                  DataCell(Text('${row['min_quantity'] ?? 0}')),
                                  DataCell(Text('${row['shortage'] ?? 0}')),
                                  DataCell(
                                    Text(
                                      '${row['shortage_value']?.toStringAsFixed(2) ?? '0'} ريال',
                                    ),
                                  ),
                                ],
                              );
                            }).toList(),
                      ),
                    );
                  }
                  return const SizedBox.shrink();
                },
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text(AppStrings.close),
              ),
            ],
          ),
    );
  }
}
