import 'package:equatable/equatable.dart';

enum TransactionType { purchase, sale, return_, adjustment, production, waste }

class InventoryTransaction extends Equatable {
  final int? id;
  final int itemId;
  // Optional, for logging/UI convenience. Not persisted.
  final String? itemName;
  final TransactionType type;
  final double quantity;
  final String? reference;
  final String? notes;
  final DateTime createdAt;

  const InventoryTransaction({
    this.id,
    required this.itemId,
    this.itemName,
    required this.type,
    required this.quantity,
    this.reference,
    this.notes,
    required this.createdAt,
  });

  bool get isIncoming =>
      type == TransactionType.purchase || type == TransactionType.return_;
  bool get isOutgoing =>
      type == TransactionType.sale ||
      type == TransactionType.production ||
      type == TransactionType.waste;

  InventoryTransaction copyWith({
    int? id,
    int? itemId,
    String? itemName,
    TransactionType? type,
    double? quantity,
    String? reference,
    String? notes,
    DateTime? createdAt,
  }) {
    return InventoryTransaction(
      id: id ?? this.id,
      itemId: itemId ?? this.itemId,
      itemName: itemName ?? this.itemName,
      type: type ?? this.type,
      quantity: quantity ?? this.quantity,
      reference: reference ?? this.reference,
      notes: notes ?? this.notes,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'item_id': itemId,
      'type': type.name,
      'quantity': quantity,
      'reference': reference,
      'notes': notes,
      'created_at': createdAt.toIso8601String(),
    };
  }

  factory InventoryTransaction.fromMap(Map<String, dynamic> map) {
    return InventoryTransaction(
      id: map['id']?.toInt(),
      itemId: map['item_id']?.toInt() ?? 0,
      // itemName is not stored in DB
      type: TransactionType.values.firstWhere(
        (e) => e.name == map['type'],
        orElse: () => TransactionType.adjustment,
      ),
      quantity: map['quantity']?.toDouble() ?? 0.0,
      reference: map['reference'],
      notes: map['notes'],
      createdAt: DateTime.parse(map['created_at']),
    );
  }

  @override
  List<Object?> get props => [
    id,
    itemId,
    itemName,
    type,
    quantity,
    reference,
    notes,
    createdAt,
  ];
}
