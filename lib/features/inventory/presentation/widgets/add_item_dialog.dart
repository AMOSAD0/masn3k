import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/constants.dart';
import '../../domain/entities/item.dart';
import '../bloc/inventory_bloc.dart';

class AddItemDialog extends StatefulWidget {
  final Item? item;

  const AddItemDialog({super.key, this.item});

  @override
  State<AddItemDialog> createState() => _AddItemDialogState();
}

class _AddItemDialogState extends State<AddItemDialog> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _supplierController = TextEditingController();
  final _priceController = TextEditingController();
  final _unitController = TextEditingController();
  final _quantityController = TextEditingController();
  final _minQuantityController = TextEditingController();

  bool get isEditing => widget.item != null;

  @override
  void initState() {
    super.initState();
    if (isEditing) {
      _nameController.text = widget.item!.name;
      _supplierController.text = widget.item!.supplier ?? '';
      _priceController.text = widget.item!.price.toString();
      _unitController.text = widget.item!.unit;
      _quantityController.text = widget.item!.quantity.toString();
      _minQuantityController.text = widget.item!.minQuantity.toString();
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _supplierController.dispose();
    _priceController.dispose();
    _unitController.dispose();
    _quantityController.dispose();
    _minQuantityController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(isEditing ? 'تعديل العنصر' : 'إضافة عنصر جديد'),
      content: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(
                  labelText: 'اسم العنصر *',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return AppStrings.fieldRequired;
                  }
                  return null;
                },
              ),
              const SizedBox(height: AppConstants.smallPadding),
              TextFormField(
                controller: _supplierController,
                decoration: const InputDecoration(
                  labelText: 'المورد',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: AppConstants.smallPadding),
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: _priceController,
                      decoration: const InputDecoration(
                        labelText: 'السعر *',
                        border: OutlineInputBorder(),
                      ),
                      keyboardType: TextInputType.number,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return AppStrings.fieldRequired;
                        }
                        if (double.tryParse(value) == null) {
                          return AppStrings.invalidPrice;
                        }
                        return null;
                      },
                    ),
                  ),
                  const SizedBox(width: AppConstants.smallPadding),
                  Expanded(
                    child: TextFormField(
                      controller: _unitController,
                      decoration: const InputDecoration(
                        labelText: 'الوحدة *',
                        border: OutlineInputBorder(),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return AppStrings.fieldRequired;
                        }
                        return null;
                      },
                    ),
                  ),
                ],
              ),
              const SizedBox(height: AppConstants.smallPadding),
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: _quantityController,
                      decoration: const InputDecoration(
                        labelText: 'الكمية *',
                        border: OutlineInputBorder(),
                      ),
                      keyboardType: TextInputType.number,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return AppStrings.fieldRequired;
                        }
                        if (double.tryParse(value) == null) {
                          return AppStrings.invalidQuantity;
                        }
                        return null;
                      },
                    ),
                  ),
                  const SizedBox(width: AppConstants.smallPadding),
                  Expanded(
                    child: TextFormField(
                      controller: _minQuantityController,
                      decoration: const InputDecoration(
                        labelText: 'الحد الأدنى',
                        border: OutlineInputBorder(),
                      ),
                      keyboardType: TextInputType.number,
                      validator: (value) {
                        if (value != null && value.isNotEmpty) {
                          if (double.tryParse(value) == null) {
                            return AppStrings.invalidQuantity;
                          }
                        }
                        return null;
                      },
                    ),
                  ),
                ],
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
          onPressed: _saveItem,
          child: Text(isEditing ? AppStrings.save : AppStrings.add),
        ),
      ],
    );
  }

  void _saveItem() {
    if (_formKey.currentState!.validate()) {
      final now = DateTime.now();
      final item = Item(
        id: widget.item?.id,
        name: _nameController.text.trim(),
        supplier: _supplierController.text.trim().isEmpty ? null : _supplierController.text.trim(),
        price: double.parse(_priceController.text),
        unit: _unitController.text.trim(),
        quantity: double.parse(_quantityController.text),
        minQuantity: _minQuantityController.text.isEmpty ? 0 : double.parse(_minQuantityController.text),
        createdAt: widget.item?.createdAt ?? now,
        updatedAt: now,
      );

      if (isEditing) {
        context.read<InventoryBloc>().add(UpdateItem(item));
      } else {
        context.read<InventoryBloc>().add(AddItem(item));
      }

      Navigator.of(context).pop();
    }
  }
}
