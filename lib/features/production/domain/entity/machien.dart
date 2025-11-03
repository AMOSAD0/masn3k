import 'package:equatable/equatable.dart';

class Machine extends Equatable {
  final int? id;
  final String name;
  final String? description;
  final String status;
  final String createdAt;
  final String updatedAt;

  Machine({
    this.id,
    required this.name,
    this.description,
    this.status = 'active',
    required this.createdAt,
    required this.updatedAt,
  });

  /// تحويل من Map (من قاعدة البيانات) إلى Object
  factory Machine.fromMap(Map<String, dynamic> map) {
    return Machine(
      id: map['id'] as int?,
      name: map['name'] as String,
      description: map['description'] as String?,
      status: map['status'] as String,
      createdAt: map['created_at'] as String,
      updatedAt: map['updated_at'] as String,
    );
  }

  /// تحويل من Object إلى Map (للتخزين في قاعدة البيانات)
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'status': status,
      'created_at': createdAt,
      'updated_at': updatedAt,
    };
  }

  /// نسخة جديدة من الكائن مع تغييرات
  Machine copyWith({
    int? id,
    String? name,
    String? description,
    String? status,
    String? createdAt,
    String? updatedAt,
  }) {
    return Machine(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      status: status ?? this.status,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  List<Object?> get props => [
    id,
    name,
    description,
    status,
    createdAt,
    updatedAt,
  ];
}
