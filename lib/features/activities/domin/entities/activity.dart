import 'package:equatable/equatable.dart';

class Activity extends Equatable {
  final int? id;
  final String category; // inventory, sales, production...
  final String action;
  final String? description;
  final String? related_item;
  final double? quantity;
  final double? amount;
  final DateTime createdAt;

  const Activity({
    this.id,
    required this.category,
    required this.action,
    this.description,
    this.related_item,
    this.quantity,
    this.amount,
    required this.createdAt,
  });

  Activity copyWith({
    int? id,
    String? category,
    String? action,
    String? description,
    String? related_item,
    double? quantity,
    double? amount,
    DateTime? createdAt,
  }) {
    return Activity(
      id: id ?? this.id,
      category: category ?? this.category,
      action: action ?? this.action,
      description: description ?? this.description,
      related_item: related_item ?? this.related_item,
      quantity: quantity ?? this.quantity,
      amount: amount ?? this.amount,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'category': category,
      'action': action,
      'description': description,
      'related_item': related_item,
      'quantity': quantity,
      'amount': amount,
      'created_at': createdAt.toIso8601String(),
    };
  }

  factory Activity.fromMap(Map<String, dynamic> map) {
    return Activity(
      id: map['id']?.toInt(),
      category: map['category'],
      action: map['action'],
      description: map['description'],
      related_item: map['related_item'],
      quantity: map['quantity']?.toDouble(),
      amount: map['amount']?.toDouble(),
      createdAt: DateTime.parse(map['created_at']),
    );
  }

  @override
  List<Object?> get props => [
    id,
    category,
    action,
    description,
    related_item,
    quantity,
    amount,
    createdAt,
  ];
}
