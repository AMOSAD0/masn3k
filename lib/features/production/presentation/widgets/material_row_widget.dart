import 'package:flutter/material.dart';

class MaterialRowWidget extends StatelessWidget {
  final String item;
  final double qty;
  final ValueChanged<String> onItemChanged;
  final ValueChanged<double> onQtyChanged;
  final VoidCallback onRemove;

  const MaterialRowWidget({
    super.key,
    required this.item,
    required this.qty,
    required this.onItemChanged,
    required this.onQtyChanged,
    required this.onRemove,
  });

  @override
  Widget build(BuildContext context) {
    final itemCtrl = TextEditingController(text: item);
    final qtyCtrl = TextEditingController(text: qty == 0 ? '' : qty.toString());
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: TextField(
              controller: itemCtrl,
              onChanged: onItemChanged,
              decoration: const InputDecoration(labelText: 'المادة'),
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: TextField(
              controller: qtyCtrl,
              keyboardType: TextInputType.number,
              onChanged: (v) => onQtyChanged(double.tryParse(v) ?? 0),
              decoration: const InputDecoration(labelText: 'كمية'),
            ),
          ),
          IconButton(
            onPressed: onRemove,
            icon: const Icon(Icons.delete, color: Colors.red),
          ),
        ],
      ),
    );
  }
}
