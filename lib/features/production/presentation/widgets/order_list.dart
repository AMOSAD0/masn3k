// lib/features/production/presentation/widgets/order_list_item.dart
import 'package:flutter/material.dart';
import 'package:masn3k/features/production/presentation/model/order_ui_model.dart';

class OrderListItem extends StatelessWidget {
  final OrderUiModel order;
  final VoidCallback onStart;
  final VoidCallback onComplete;
  final VoidCallback onEdit;
  final VoidCallback onCancel;

  const OrderListItem({
    super.key,
    required this.order,
    required this.onStart,
    required this.onComplete,
    required this.onEdit,
    required this.onCancel,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: const Icon(Icons.assignment),
      title: Text('${order.product} — ${order.qty}'),
      subtitle: Text('آلة: ${order.machine} • الحالة: ${order.statusText}'),
      trailing: PopupMenuButton<String>(
        onSelected: (value) {
          switch (value) {
            case 'start':
              onStart();
              break;
            case 'complete':
              onComplete();
              break;
            case 'edit':
              onEdit();
              break;
            case 'cancel':
              onCancel();
              break;
          }
        },
        itemBuilder: (_) => const [
          PopupMenuItem(value: 'edit', child: Text('تعديل')),
          PopupMenuItem(value: 'start', child: Text('بدء')),
          PopupMenuItem(value: 'complete', child: Text('اكتمال')),
          PopupMenuItem(value: 'cancel', child: Text('إلغاء')),
        ],
      ),
    );
  }
}
