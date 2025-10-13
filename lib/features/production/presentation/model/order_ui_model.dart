// lib/features/production/presentation/models/order_ui_model.dart
enum OrderStatus { pending, inProgress, completed }

class OrderUiModel {
  String machine;
  String product;
  double qty;
  OrderStatus status;
  List<MaterialRowModel> materials;

  OrderUiModel({
    required this.machine,
    required this.product,
    required this.qty,
    required this.status,
    this.materials = const [],
  });

  String get statusText {
    switch (status) {
      case OrderStatus.pending:
        return 'معلق';
      case OrderStatus.inProgress:
        return 'قيد التنفيذ';
      case OrderStatus.completed:
        return 'مكتمل';
    }
  }
}

class MaterialRowModel {
  String item;
  double qty;

  MaterialRowModel({required this.item, required this.qty});
}
