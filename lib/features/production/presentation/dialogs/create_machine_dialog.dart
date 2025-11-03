// lib/features/production/presentation/dialogs/create_machine_dialog.dart
import 'package:flutter/material.dart';
import 'package:masn3k/features/production/domain/entity/machien.dart';
import 'package:masn3k/features/production/presentation/model/machien_ui_model.dart';

class CreateMachineDialog extends StatefulWidget {
  final Machine? existing;
  final Function(Machine) onSave;

  const CreateMachineDialog({super.key, this.existing, required this.onSave});

  @override
  State<CreateMachineDialog> createState() => _CreateMachineDialogState();
}

class _CreateMachineDialogState extends State<CreateMachineDialog> {
  late TextEditingController _nameCtrl;
  late TextEditingController _locationCtrl;
  late String _status;

  @override
  void initState() {
    super.initState();
    _nameCtrl = TextEditingController(text: widget.existing?.name ?? '');
    _locationCtrl = TextEditingController(
      text: widget.existing?.description ?? '',
    );
    _status = widget.existing?.status ?? 'active';
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    _locationCtrl.dispose();
    super.dispose();
  }

  bool get _isEdit => widget.existing != null;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(_isEdit ? 'تعديل آلة' : 'إضافة آلة'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: _nameCtrl,
            decoration: const InputDecoration(labelText: 'الاسم'),
          ),
          const SizedBox(height: 8),
          TextField(
            controller: _locationCtrl,
            decoration: const InputDecoration(labelText: 'الموقع'),
          ),
          const SizedBox(height: 8),
          DropdownButtonFormField<String>(
            value: _status,
            items: const [
              DropdownMenuItem(value: 'active', child: Text('نشط')),
              DropdownMenuItem(value: 'inactive', child: Text('غير نشط')),
              DropdownMenuItem(value: 'maintenance', child: Text('صيانة')),
              DropdownMenuItem(value: 'down', child: Text('متوقف')),
            ],
            onChanged: (v) => setState(() => _status = v ?? 'active'),
            decoration: const InputDecoration(labelText: 'الحالة'),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('إلغاء'),
        ),
        ElevatedButton(onPressed: _handleSave, child: const Text('حفظ')),
      ],
    );
  }

  void _handleSave() {
    if (_nameCtrl.text.trim().isEmpty) return;

    final machine = Machine(
      id: _isEdit ? widget.existing!.id : null,
      name: _nameCtrl.text.trim(),
      description: _locationCtrl.text.trim(),
      status: _status,
      updatedAt: DateTime.now().toIso8601String(),
      createdAt: _isEdit
          ? widget.existing!.createdAt
          : DateTime.now().toIso8601String(),
    );

    widget.onSave(machine);
    Navigator.pop(context);
  }
}
