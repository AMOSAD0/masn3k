import 'package:flutter/material.dart';
import '../../../../core/constants.dart';
import '../../domain/entities/item.dart';

class ItemCard extends StatelessWidget {
  final Item item;
  final VoidCallback onEdit;
  final VoidCallback onDelete;
  final VoidCallback onViewTransactions;
  final VoidCallback onAddTransaction;
  final bool showWarning;

  const ItemCard({
    super.key,
    required this.item,
    required this.onEdit,
    required this.onDelete,
    required this.onViewTransactions,
    required this.onAddTransaction,
    this.showWarning = false,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: AppConstants.smallPadding),
      child: Container(
        decoration: showWarning && item.isLowStock
            ? BoxDecoration(
                border: Border.all(color: Colors.orange, width: 2),
                borderRadius: BorderRadius.circular(AppConstants.borderRadius),
              )
            : null,
        child: Padding(
          padding: const EdgeInsets.all(AppConstants.defaultPadding),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                item.name,
                                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            if (showWarning && item.isLowStock)
                              const Icon(
                                Icons.warning,
                                color: Colors.orange,
                                size: 20,
                              ),
                          ],
                        ),
                        if (item.supplier != null && item.supplier!.isNotEmpty)
                          Text(
                            'المورد: ${item.supplier}',
                            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              color: Colors.grey[600],
                            ),
                          ),
                      ],
                    ),
                  ),
                  PopupMenuButton<String>(
                    onSelected: (value) {
                      switch (value) {
                        case 'edit':
                          onEdit();
                          break;
                        case 'delete':
                          onDelete();
                          break;
                        case 'transactions':
                          onViewTransactions();
                          break;
                        case 'add_transaction':
                          onAddTransaction();
                          break;
                      }
                    },
                    itemBuilder: (context) => [
                      const PopupMenuItem(
                        value: 'edit',
                        child: Row(
                          children: [
                            Icon(Icons.edit),
                            SizedBox(width: AppConstants.smallPadding),
                            Text(AppStrings.edit),
                          ],
                        ),
                      ),
                      const PopupMenuItem(
                        value: 'transactions',
                        child: Row(
                          children: [
                            Icon(Icons.history),
                            SizedBox(width: AppConstants.smallPadding),
                            Text('المعاملات'),
                          ],
                        ),
                      ),
                      const PopupMenuItem(
                        value: 'add_transaction',
                        child: Row(
                          children: [
                            Icon(Icons.add),
                            SizedBox(width: AppConstants.smallPadding),
                            Text('إضافة معاملة'),
                          ],
                        ),
                      ),
                      const PopupMenuItem(
                        value: 'delete',
                        child: Row(
                          children: [
                            Icon(Icons.delete, color: Colors.red),
                            SizedBox(width: AppConstants.smallPadding),
                            Text(AppStrings.delete, style: TextStyle(color: Colors.red)),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: AppConstants.smallPadding),
              Row(
                children: [
                  Expanded(
                    child: _buildInfoItem(
                      'الكمية',
                      '${item.quantity} ${item.unit}',
                      Icons.inventory,
                    ),
                  ),
                  Expanded(
                    child: _buildInfoItem(
                      'السعر',
                      '${item.price.toStringAsFixed(2)} ريال',
                      Icons.attach_money,
                    ),
                  ),
                  Expanded(
                    child: _buildInfoItem(
                      'القيمة',
                      '${(item.quantity * item.price).toStringAsFixed(2)} ريال',
                      Icons.calculate,
                    ),
                  ),
                ],
              ),
              if (item.minQuantity > 0) ...[
                const SizedBox(height: AppConstants.smallPadding),
                Row(
                  children: [
                    Icon(
                      Icons.warning,
                      size: 16,
                      color: item.isLowStock ? Colors.orange : Colors.grey,
                    ),
                    const SizedBox(width: AppConstants.smallPadding),
                    Text(
                      'الحد الأدنى: ${item.minQuantity} ${item.unit}',
                      style: TextStyle(
                        color: item.isLowStock ? Colors.orange : Colors.grey,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ],
              const SizedBox(height: AppConstants.smallPadding),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: onAddTransaction,
                      icon: const Icon(Icons.add),
                      label: const Text('إضافة معاملة'),
                    ),
                  ),
                  const SizedBox(width: AppConstants.smallPadding),
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: onViewTransactions,
                      icon: const Icon(Icons.history),
                      label: const Text('المعاملات'),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoItem(String label, String value, IconData icon) {
    return Column(
      children: [
        Icon(icon, size: 20, color: Colors.blue),
        const SizedBox(height: 4),
        Text(
          value,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 14,
          ),
        ),
        Text(
          label,
          style: const TextStyle(
            fontSize: 12,
            color: Colors.grey,
          ),
        ),
      ],
    );
  }
}
