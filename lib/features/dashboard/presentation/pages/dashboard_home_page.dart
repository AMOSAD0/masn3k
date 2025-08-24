import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/constants.dart';
import '../../../inventory/presentation/bloc/inventory_bloc.dart';
import '../bloc/dashboard_bloc.dart';
import '../../domain/entities/dashboard_summary.dart';

class DashboardHomePage extends StatelessWidget {
  const DashboardHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: [
        BlocListener<DashboardBloc, DashboardState>(
          listener: (context, state) {
            if (state is DashboardError) {
              ScaffoldMessenger.of(
                context,
              ).showSnackBar(SnackBar(content: Text(state.message)));
            }
          },
        ),
      ],
      child: BlocBuilder<DashboardBloc, DashboardState>(
        builder: (context, dashboardState) {
          return BlocBuilder<InventoryBloc, InventoryState>(
            builder: (context, inventoryState) {
              return SingleChildScrollView(
                padding: const EdgeInsets.all(AppConstants.defaultPadding),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Welcome Section
                    Card(
                      child: Padding(
                        padding: const EdgeInsets.all(
                          AppConstants.largePadding,
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'مرحباً بك في نظام إدارة المصنع',
                              style: Theme.of(context).textTheme.headlineSmall
                                  ?.copyWith(fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(height: AppConstants.smallPadding),
                            Text(
                              'إدارة شاملة للمخزون والإنتاج والمبيعات والمحاسبة والعمال',
                              style: Theme.of(context).textTheme.bodyLarge,
                            ),
                          ],
                        ),
                      ),
                    ),

                    const SizedBox(height: AppConstants.defaultPadding),

                    // Quick Stats
                    // if (inventoryState is InventorySummaryLoaded) ...[
                    //   _buildQuickStats(context, inventoryState.summary),
                    //   const SizedBox(height: AppConstants.defaultPadding),
                    // ],

                    // Dashboard Overview Cards
                    if (dashboardState is DashboardSummaryLoaded) ...[
                      _buildDashboardOverview(context, dashboardState.summary),
                    ] else ...[
                      _buildDashboardOverview(context, null),
                    ],

                    const SizedBox(height: AppConstants.defaultPadding),

                    // Quick Actions
                    _buildQuickActions(context),

                    const SizedBox(height: AppConstants.defaultPadding),

                    // Recent Activity
                    if (dashboardState is RecentActivityLoaded) ...[
                      _buildRecentActivity(context, dashboardState.activities),
                    ] else ...[
                      _buildRecentActivity(context, null),
                    ],
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }

  Widget _buildQuickStats(BuildContext context, Map<String, dynamic> summary) {
    return Row(
      children: [
        Expanded(
          child: _buildStatCard(
            context,
            'إجمالي العناصر',
            '${summary['total_items'] ?? 0}',
            Icons.inventory,
            Colors.blue,
          ),
        ),
        const SizedBox(width: AppConstants.smallPadding),
        Expanded(
          child: _buildStatCard(
            context,
            'القيمة الإجمالية',
            '${summary['total_value']?.toStringAsFixed(2) ?? '0'} ريال',
            Icons.attach_money,
            Colors.green,
          ),
        ),
        const SizedBox(width: AppConstants.smallPadding),
        Expanded(
          child: _buildStatCard(
            context,
            'العناصر منخفضة المخزون',
            '${summary['low_stock_items'] ?? 0}',
            Icons.warning,
            Colors.orange,
          ),
        ),
      ],
    );
  }

  Widget _buildStatCard(
    BuildContext context,
    String title,
    String value,
    IconData icon,
    Color color,
  ) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppConstants.defaultPadding),
        child: Column(
          children: [
            Icon(icon, size: 32, color: color),
            const SizedBox(height: AppConstants.smallPadding),
            Text(
              value,
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
            const SizedBox(height: AppConstants.smallPadding),
            Text(
              title,
              style: Theme.of(context).textTheme.bodyMedium,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildQuickActions(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppConstants.defaultPadding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'إجراءات سريعة',
              style: Theme.of(
                context,
              ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: AppConstants.defaultPadding),
            Wrap(
              spacing: AppConstants.smallPadding,
              runSpacing: AppConstants.smallPadding,
              children: [
                _buildActionButton(
                  context,
                  'إضافة عنصر',
                  Icons.add_box,
                  Colors.blue,
                  () {
                    // TODO: Navigate to add item
                  },
                ),
                _buildActionButton(
                  context,
                  'طلب إنتاج',
                  Icons.precision_manufacturing,
                  Colors.green,
                  () {
                    // TODO: Navigate to add production order
                  },
                ),
                _buildActionButton(
                  context,
                  'بيع جديد',
                  Icons.point_of_sale,
                  Colors.orange,
                  () {
                    // TODO: Navigate to add sale
                  },
                ),
                _buildActionButton(
                  context,
                  'تسجيل حضور',
                  Icons.person_add,
                  Colors.purple,
                  () {
                    // TODO: Navigate to attendance
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActionButton(
    BuildContext context,
    String title,
    IconData icon,
    Color color,
    VoidCallback onPressed,
  ) {
    return ElevatedButton.icon(
      onPressed: onPressed,
      icon: Icon(icon, color: Colors.white),
      label: Text(title, style: const TextStyle(color: Colors.white)),
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
        padding: const EdgeInsets.symmetric(
          horizontal: AppConstants.defaultPadding,
          vertical: AppConstants.smallPadding,
        ),
      ),
    );
  }

  Widget _buildRecentActivity(
    BuildContext context,
    List<Map<String, dynamic>>? activities,
  ) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppConstants.defaultPadding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'النشاط الأخير',
              style: Theme.of(
                context,
              ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: AppConstants.defaultPadding),
            if (activities != null && activities.isNotEmpty) ...[
              ...activities.map(
                (activity) => _buildActivityItem(context, activity),
              ),
            ] else ...[
              const Center(
                child: Padding(
                  padding: EdgeInsets.all(AppConstants.largePadding),
                  child: Text('لا توجد أنشطة حديثة'),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildActivityItem(
    BuildContext context,
    Map<String, dynamic> activity,
  ) {
    final type = activity['type'] as String?;
    final title =
        type == 'inventory'
            ? '${activity['action']} ${activity['item_name']}'
            : 'بيع رقم ${activity['reference']}';
    final subtitle =
        type == 'inventory'
            ? 'الكمية: ${activity['quantity']}'
            : 'المبلغ: ${activity['amount']?.toStringAsFixed(2) ?? '0'} ريال';
    final icon = type == 'inventory' ? Icons.inventory : Icons.point_of_sale;
    final color = type == 'inventory' ? Colors.blue : Colors.green;

    return ListTile(
      leading: CircleAvatar(
        backgroundColor: color.withOpacity(0.1),
        child: Icon(icon, color: color, size: 20),
      ),
      title: Text(title),
      subtitle: Text(subtitle),
      trailing: Text(
        _formatDate(activity['created_at']),
        style: Theme.of(context).textTheme.bodySmall,
      ),
    );
  }

  String _formatDate(String? dateString) {
    if (dateString == null) return '';
    try {
      final date = DateTime.parse(dateString);
      return '${date.day}/${date.month}/${date.year}';
    } catch (e) {
      return '';
    }
  }

  Widget _buildDashboardOverview(
    BuildContext context,
    DashboardSummary? summary,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'نظرة عامة على النظام',
          style: Theme.of(
            context,
          ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: AppConstants.defaultPadding),
        GridView.count(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          crossAxisCount: 2,
          crossAxisSpacing: AppConstants.smallPadding,
          mainAxisSpacing: AppConstants.smallPadding,
          childAspectRatio: 0.9,
          children: [
            _buildOverviewCard(
              context,
              'إجمالي المخزون',
              summary?.totalInventoryItems.toString() ?? '0',
              'عنصر',
              Icons.inventory_2,
              Colors.blue,
              () {
                // TODO: Navigate to inventory
              },
            ),
            _buildOverviewCard(
              context,
              'العناصر منخفضة المخزون',
              summary?.lowStockItems.toStringAsFixed(0) ?? '0',
              'عنصر',
              Icons.warning,
              Colors.orange,
              () {
                // TODO: Navigate to sales
              },
            ),
            _buildOverviewCard(
              context,
              'أوامر الإنتاج',
              summary?.activeProductionOrders.toString() ?? '0',
              'جارية',
              Icons.precision_manufacturing,
              Colors.green,
              () {
                // TODO: Navigate to production
              },
            ),
            _buildOverviewCard(
              context,
              'العمال الحاليين',
              summary?.currentWorkers.toString() ?? '0',
              'موجود',
              Icons.people,
              Colors.orange,
              () {
                // TODO: Navigate to workers
              },
            ),
            _buildOverviewCard(
              context,
              'المبيعات اليومية',
              summary?.dailySales.toStringAsFixed(0) ?? '0',
              'ريال',
              Icons.trending_up,
              Colors.purple,
              () {
                // TODO: Navigate to sales
              },
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildOverviewCard(
    BuildContext context,
    String title,
    String value,
    String unit,
    IconData icon,
    Color color,
    VoidCallback onTap,
  ) {
    return Card(
      elevation: 2,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppConstants.borderRadius),
        child: Padding(
          padding: const EdgeInsets.all(AppConstants.defaultPadding),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 40, color: color),
              const SizedBox(height: AppConstants.smallPadding),
              Text(
                value,
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: color,
                ),
              ),
              Text(
                unit,
                style: Theme.of(
                  context,
                ).textTheme.bodySmall?.copyWith(color: Colors.grey[600]),
              ),
              const SizedBox(height: AppConstants.smallPadding),
              Text(
                title,
                style: Theme.of(
                  context,
                ).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w500),
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
