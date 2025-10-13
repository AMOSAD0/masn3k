// lib/features/production/presentation/dialogs/log_breakdown_dialog.dart
import 'package:flutter/material.dart';

class LogBreakdownDialog extends StatefulWidget {
  final List<String> machines;
  final VoidCallback onSave;

  const LogBreakdownDialog({
    super.key,
    required this.machines,
    required this.onSave,
  });

  @override
  State<LogBreakdownDialog> createState() => _LogBreakdownDialogState();
}

class _LogBreakdownDialogState extends State<LogBreakdownDialog> {
  late TextEditingController _descCtrl;
  String? _machine;
  DateTime _date = DateTime.now();

  @override
  void initState() {
    super.initState();
    _descCtrl = TextEditingController();
    _machine = widget.machines.isNotEmpty ? widget.machines.first : null;
  }

  @override
  void dispose() {
    _descCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('تسجيل عطل'),
      content: Column(
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
          TextField(
            controller: _descCtrl,
            decoration: const InputDecoration(labelText: 'الوصف'),
            maxLines: 3,
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
