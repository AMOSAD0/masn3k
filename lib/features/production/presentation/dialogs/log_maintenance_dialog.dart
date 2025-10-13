// lib/features/production/presentation/dialogs/log_maintenance_dialog.dart
import 'package:flutter/material.dart';

class LogMaintenanceDialog extends StatefulWidget {
  final List<String> machines;
  final VoidCallback onSave;

  const LogMaintenanceDialog({
    super.key,
    required this.machines,
    required this.onSave,
  });

  @override
  State<LogMaintenanceDialog> createState() => _LogMaintenanceDialogState();
}

class _LogMaintenanceDialogState extends State<LogMaintenanceDialog> {
  late TextEditingController _descCtrl;
  late TextEditingController _costCtrl;
  String? _machine;
  String _maintType = 'scheduled';
  DateTime _date = DateTime.now();

  @override
  void initState() {
    super.initState();
    _descCtrl = TextEditingController();
    _costCtrl = TextEditingController();
    _machine = widget.machines.isNotEmpty ? widget.machines.first : null;
  }

  @override
  void dispose() {
    _descCtrl.dispose();
    _costCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('تسجيل صيانة'),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            DropdownButtonFormField<String>(
              value: _machine,
              items: widget.machines
                  .map((m) => DropdownMenuItem(value: m, child: Text(m)))
                  .toList(),
              onChanged: (v) => setState(() => _machine = v),
              decoration: const InputDecoration(labelText: 'الآلة'),
            ),
            const SizedBox(height: 8),
            DropdownButtonFormField<String>(
              value: _maintType,
              items: const [
                DropdownMenuItem(value: 'scheduled', child: Text('مجدولة')),
                DropdownMenuItem(value: 'unscheduled', child: Text('طارئة')),
              ],
              onChanged: (v) => setState(() => _maintType = v ?? 'scheduled'),
              decoration: const InputDecoration(labelText: 'النوع'),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: _descCtrl,
              decoration: const InputDecoration(labelText: 'الوصف'),
              maxLines: 3,
            ),
            const SizedBox(height: 8),
            TextField(
              controller: _costCtrl,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'التكلفة',
                suffixText: 'جنيه',
              ),
            ),
            const SizedBox(height: 8),
            OutlinedButton(
              onPressed: () async {
                final picked = await showDatePicker(
                  context: context,
                  firstDate: DateTime(2020),
                  lastDate: DateTime(2100),
                  initialDate: _date,
                );
                if (picked != null) setState(() => _date = picked);
              },
              child: Text('التاريخ • ${_date.toString().substring(0, 10)}'),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('إلغاء'),
        ),
        ElevatedButton(
          onPressed: () {
            if (_machine == null || _descCtrl.text.trim().isEmpty) return;
            widget.onSave();
            Navigator.pop(context);
          },
          child: const Text('حفظ'),
        ),
      ],
    );
  }
}
