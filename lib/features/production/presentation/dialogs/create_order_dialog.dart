// lib/features/production/presentation/dialogs/create_order_dialog.dart
import 'package:flutter/material.dart';
import 'package:masn3k/features/production/presentation/model/order_ui_model.dart';
import 'package:masn3k/features/production/presentation/widgets/material_row_widget.dart';

class CreateOrderDialog extends StatefulWidget {
  final OrderUiModel? existing;
  final List<String> machines;
  final Function(OrderUiModel) onSave;

  const CreateOrderDialog({
    super.key,
    this.existing,
    required this.machines,
    required this.onSave,
  });

  @override
  State<CreateOrderDialog> createState() => _CreateOrderDialogState();
}

class _CreateOrderDialogState extends State<CreateOrderDialog> {
  late TextEditingController _productCtrl;
  late TextEditingController _qtyCtrl;
  late String _machine;
  TimeOfDay? _startTime;
  TimeOfDay? _endTime;
  late List<MaterialRowModel> _materials;

  @override
  void initState() {
    super.initState();
    _productCtrl = TextEditingController(text: widget.existing?.product ?? '');
    _qtyCtrl = TextEditingController(
      text: widget.existing?.qty.toString() ?? '',
    );
    _machine = widget.existing?.machine ?? '';
    _materials = List<MaterialRowModel>.from(widget.existing?.materials ?? []);
  }

  @override
  void dispose() {
    _productCtrl.dispose();
    _qtyCtrl.dispose();
    super.dispose();
  }

  bool get _isEdit => widget.existing != null;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(_isEdit ? 'تعديل أمر إنتاج' : 'إنشاء أمر إنتاج'),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildMachineDropdown(),
            const SizedBox(height: 8),
            _buildProductField(),
            const SizedBox(height: 8),
            _buildQtyField(),
            const SizedBox(height: 8),
            _buildMaterialsSection(),
            const SizedBox(height: 8),
            _buildTimeSelectors(),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('إلغاء'),
        ),
        ElevatedButton(
          onPressed: _handleSave,
          child: Text(_isEdit ? 'حفظ' : 'إنشاء'),
        ),
      ],
    );
  }

  Widget _buildMachineDropdown() {
    return DropdownButtonFormField<String>(
      value: _machine.isEmpty ? null : _machine,
      items: widget.machines
          .map((m) => DropdownMenuItem(value: m, child: Text(m)))
          .toList(),
      onChanged: (v) => setState(() => _machine = v ?? ''),
      decoration: const InputDecoration(labelText: 'الآلة'),
    );
  }

  Widget _buildProductField() {
    return TextField(
      controller: _productCtrl,
      decoration: const InputDecoration(labelText: 'المنتج'),
    );
  }

  Widget _buildQtyField() {
    return TextField(
      controller: _qtyCtrl,
      keyboardType: TextInputType.number,
      decoration: const InputDecoration(labelText: 'الكمية'),
    );
  }

  Widget _buildMaterialsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Align(
          alignment: Alignment.centerLeft,
          child: Text(
            'المواد المطلوبة',
            style: Theme.of(context).textTheme.titleMedium,
          ),
        ),
        const SizedBox(height: 8),
        ..._materials.map(
          (row) => MaterialRowWidget(
            item: row.item,
            qty: row.qty,
            onItemChanged: (v) => setState(() => row.item = v),
            onQtyChanged: (v) => setState(() => row.qty = v),
            onRemove: () => setState(() => _materials.remove(row)),
          ),
        ),
        TextButton.icon(
          onPressed: () => setState(
            () => _materials.add(MaterialRowModel(item: '', qty: 0)),
          ),
          icon: const Icon(Icons.add),
          label: const Text('إضافة مادة'),
        ),
      ],
    );
  }

  Widget _buildTimeSelectors() {
    return Row(
      children: [
        Expanded(
          child: OutlinedButton(
            onPressed: () async {
              final t = await showTimePicker(
                context: context,
                initialTime: TimeOfDay.now(),
              );
              if (t != null) setState(() => _startTime = t);
            },
            child: Text(
              'وقت البداية${_startTime == null ? '' : ' • ${_startTime!.format(context)}'}',
            ),
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: OutlinedButton(
            onPressed: () async {
              final t = await showTimePicker(
                context: context,
                initialTime: TimeOfDay.now(),
              );
              if (t != null) setState(() => _endTime = t);
            },
            child: Text(
              'وقت النهاية${_endTime == null ? '' : ' • ${_endTime!.format(context)}'}',
            ),
          ),
        ),
      ],
    );
  }

  void _handleSave() {
    if (_machine.isEmpty ||
        _productCtrl.text.trim().isEmpty ||
        double.tryParse(_qtyCtrl.text.trim()) == null) {
      return;
    }

    final order = OrderUiModel(
      machine: _machine,
      product: _productCtrl.text.trim(),
      qty: double.parse(_qtyCtrl.text.trim()),
      status: widget.existing?.status ?? OrderStatus.pending,
      materials: List.from(_materials),
    );

    widget.onSave(order);
    Navigator.pop(context);
  }
}
