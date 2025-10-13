// lib/features/production/presentation/widgets/inventory_info_card.dart
import 'package:flutter/material.dart';
import '../../../../core/constants.dart';

class InventoryInfoCard extends StatelessWidget {
  const InventoryInfoCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: AppConstants.smallPadding,
      ),
      child: Card(
        child: ListTile(
          leading: const Icon(Icons.info_outline),
          title: const Text('ربط الإنتاج بالمخزون'),
          subtitle: const Text(
            'عند بدء أمر الإنتاج سيتم خصم المواد الخام المطلوبة تلقائياً.',
          ),
        ),
      ),
    );
  }
}
