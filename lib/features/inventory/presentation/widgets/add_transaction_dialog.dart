import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/constants.dart';
import '../../domain/entities/item.dart';
import '../../domain/entities/inventory_transaction.dart';
import '../bloc/inventory_bloc.dart';

class AddTransactionDialog extends StatefulWidget {
  final Item item;

  const AddTransactionDialog({super.key, required this.item});

  @override
  State<AddTransactionDialog> createState() => _AddTransactionDialogState();
}

class _AddTransactionDialogState extends State<AddTransactionDialog> {
  final _formKey = GlobalKey<FormState>();
  final _quantityController = TextEditingController();
  final _referenceController = TextEditingController();
  final _notesController = TextEditingController();
  
  TransactionType _selectedType = TransactionType.purchase;

  @override
  void dispose() {
    _quantityController.dispose();
    _referenceController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('إضافة معاملة لـ ${widget.item.name}'),
      content: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Transaction Type
              DropdownButtonFormField<TransactionType>(
                value: _selectedType,
                decoration: const InputDecoration(
                  labelText: 'نوع المعاملة *',
                  border: OutlineInputBorder(),
                ),
                items: TransactionType.values.map((type) {
                  return DropdownMenuItem(
                    value: type,
                    child: Text(_getTransactionTypeName(type)),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedType = value!;
                  });
                },
                validator: (value) {
                  if (value == null) {
                    return AppStrings.fieldRequired;
                  }
                  return null;
                },
              ),
              const SizedBox(height: AppConstants.smallPadding),
              
              // Quantity
              TextFormField(
                controller: _quantityController,
                decoration: InputDecoration(
                  labelText: 'الكمية *',
                  border: const OutlineInputBorder(),
                  suffixText: widget.item.unit,
                ),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return AppStrings.fieldRequired;
                  }
                  if (double.tryParse(value) == null) {
                    return AppStrings.invalidQuantity;
                  }
                  if (double.parse(value) <= 0) {
                    return 'يجب أن تكون الكمية أكبر من صفر';
                  }
                  return null;
                },
              ),
              const SizedBox(height: AppConstants.smallPadding),
              
              // Reference
              TextFormField(
                controller: _referenceController,
                decoration: const InputDecoration(
                  labelText: 'المرجع (اختياري)',
                  border: OutlineInputBorder(),
                  hintText: 'رقم الفاتورة أو المرجع',
                ),
              ),
              const SizedBox(height: AppConstants.smallPadding),
              
              // Notes
              TextFormField(
                controller: _notesController,
                decoration: const InputDecoration(
                  labelText: 'ملاحظات (اختياري)',
                  border: OutlineInputBorder(),
                ),
                maxLines: 3,
              ),
              const SizedBox(height: AppConstants.smallPadding),
              
              // Current Stock Info
              Card(
                color: Colors.grey[100],
                child: Padding(
                  padding: const EdgeInsets.all(AppConstants.smallPadding),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'معلومات المخزون الحالي:',
                        style: Theme.of(context).textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: AppConstants.smallPadding),
                      Text('الكمية الحالية: ${widget.item.quantity} ${widget.item.unit}'),
                      if (widget.item.minQuantity > 0)
                        Text(
                          'الحد الأدنى: ${widget.item.minQuantity} ${widget.item.unit}',
                          style: TextStyle(
                            color: widget.item.isLowStock ? Colors.orange : Colors.grey,
                          ),
                        ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text(AppStrings.cancel),
        ),
        ElevatedButton(
          onPressed: _saveTransaction,
          child: const Text(AppStrings.add),
        ),
      ],
    );
  }

  String _getTransactionTypeName(TransactionType type) {
    switch (type) {
      case TransactionType.purchase:
        return 'شراء';
      case TransactionType.sale:
        return 'بيع';
      case TransactionType.return_:
        return 'إرجاع';
      case TransactionType.adjustment:
        return 'تعديل';
      case TransactionType.production:
        return 'إنتاج';
      case TransactionType.waste:
        return 'هدر';
    }
  }

  void _saveTransaction() {
    if (_formKey.currentState!.validate()) {
      final transaction = InventoryTransaction(
        itemId: widget.item.id!,
        type: _selectedType,
        quantity: double.parse(_quantityController.text),
        reference: _referenceController.text.trim().isEmpty ? null : _referenceController.text.trim(),
        notes: _notesController.text.trim().isEmpty ? null : _notesController.text.trim(),
        createdAt: DateTime.now(),
      );

      context.read<InventoryBloc>().add(AddTransaction(transaction));
      Navigator.of(context).pop();
    }
  }
}
