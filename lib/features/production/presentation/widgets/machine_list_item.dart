// lib/features/production/presentation/widgets/machine_list_item.dart
import 'package:flutter/material.dart';
import 'package:masn3k/features/production/presentation/model/machien_ui_model.dart';

class MachineListItem extends StatelessWidget {
  final MachineUiModel machine;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const MachineListItem({
    super.key,
    required this.machine,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: const Icon(Icons.precision_manufacturing),
      title: Text(machine.name),
      subtitle: Text('الموقع: ${machine.location} • الحالة: ${machine.status}'),
      trailing: PopupMenuButton<String>(
        onSelected: (v) {
          switch (v) {
            case 'edit':
              onEdit();
              break;
            case 'delete':
              onDelete();
              break;
          }
        },
        itemBuilder: (_) => const [
          PopupMenuItem(value: 'edit', child: Text('تعديل')),
          PopupMenuItem(value: 'delete', child: Text('حذف')),
        ],
      ),
    );
  }
}
