// lib/features/production/presentation/widgets/status_filter_chips.dart
import 'package:flutter/material.dart';
import 'package:masn3k/features/production/presentation/model/order_ui_model.dart';
import 'package:masn3k/features/production/presentation/widgets/status_chip.dart';
import '../../../../core/constants.dart';

class StatusFilterChips extends StatelessWidget {
  final OrderStatus? currentFilter;
  final ValueChanged<OrderStatus?> onFilterChanged;

  const StatusFilterChips({
    super.key,
    required this.currentFilter,
    required this.onFilterChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(AppConstants.smallPadding),
      child: Wrap(
        spacing: 8,
        children: [
          StatusChip(
            label: 'الكل',
            selected: currentFilter == null,
            onSelected: () => onFilterChanged(null),
          ),
          StatusChip(
            label: 'معلق',
            selected: currentFilter == OrderStatus.pending,
            onSelected: () => onFilterChanged(OrderStatus.pending),
          ),
          StatusChip(
            label: 'قيد التنفيذ',
            selected: currentFilter == OrderStatus.inProgress,
            onSelected: () => onFilterChanged(OrderStatus.inProgress),
          ),
          StatusChip(
            label: 'مكتمل',
            selected: currentFilter == OrderStatus.completed,
            onSelected: () => onFilterChanged(OrderStatus.completed),
          ),
        ],
      ),
    );
  }
}
