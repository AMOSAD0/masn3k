import 'package:equatable/equatable.dart';

class Item extends Equatable {
  final int? id;
  final String name;
  final String? supplier;
  final double price;
  final String unit;
  final double quantity;
  final double minQuantity;
  final DateTime createdAt;
  final DateTime updatedAt;

  const Item({
    this.id,
    required this.name,
    this.supplier,
    required this.price,
    required this.unit,
    required this.quantity,
    this.minQuantity = 0,
    required this.createdAt,
    required this.updatedAt,
  });

  bool get isLowStock => quantity <= minQuantity;

  Item copyWith({
    int? id,
    String? name,
    String? supplier,
    double? price,
    String? unit,
    double? quantity,
    double? minQuantity,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Item(
      id: id ?? this.id,
      name: name ?? this.name,
      supplier: supplier ?? this.supplier,
      price: price ?? this.price,
      unit: unit ?? this.unit,
      quantity: quantity ?? this.quantity,
      minQuantity: minQuantity ?? this.minQuantity,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'supplier': supplier,
      'price': price,
      'unit': unit,
      'quantity': quantity,
      'min_quantity': minQuantity,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }

  factory Item.fromMap(Map<String, dynamic> map) {
    return Item(
      id: map['id']?.toInt(),
      name: map['name'] ?? '',
      supplier: map['supplier'],
      price: map['price']?.toDouble() ?? 0.0,
      unit: map['unit'] ?? '',
      quantity: map['quantity']?.toDouble() ?? 0.0,
      minQuantity: map['min_quantity']?.toDouble() ?? 0.0,
      createdAt: DateTime.parse(map['created_at']),
      updatedAt: DateTime.parse(map['updated_at']),
    );
  }

  @override
  List<Object?> get props => [
        id,
        name,
        supplier,
        price,
        unit,
        quantity,
        minQuantity,
        createdAt,
        updatedAt,
      ];
}
