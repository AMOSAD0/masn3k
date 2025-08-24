import 'package:equatable/equatable.dart';

class DashboardSummary extends Equatable {
  final int totalInventoryItems;
  final double totalInventoryValue;
  final int activeProductionOrders;
  final int currentWorkers;
  final double dailySales;
  final double monthlyProfit;
  final int lowStockItems;
  final int pendingOrders;

  const DashboardSummary({
    required this.totalInventoryItems,
    required this.totalInventoryValue,
    required this.activeProductionOrders,
    required this.currentWorkers,
    required this.dailySales,
    required this.monthlyProfit,
    required this.lowStockItems,
    required this.pendingOrders,
  });

  Map<String, dynamic> toMap() {
    return {
      'totalInventoryItems': totalInventoryItems,
      'totalInventoryValue': totalInventoryValue,
      'activeProductionOrders': activeProductionOrders,
      'currentWorkers': currentWorkers,
      'dailySales': dailySales,
      'monthlyProfit': monthlyProfit,
      'lowStockItems': lowStockItems,
      'pendingOrders': pendingOrders,
    };
  }

  factory DashboardSummary.fromMap(Map<String, dynamic> map) {
    return DashboardSummary(
      totalInventoryItems: map['totalInventoryItems']?.toInt() ?? 0,
      totalInventoryValue: map['totalInventoryValue']?.toDouble() ?? 0.0,
      activeProductionOrders: map['activeProductionOrders']?.toInt() ?? 0,
      currentWorkers: map['currentWorkers']?.toInt() ?? 0,
      dailySales: map['dailySales']?.toDouble() ?? 0.0,
      monthlyProfit: map['monthlyProfit']?.toDouble() ?? 0.0,
      lowStockItems: map['lowStockItems']?.toInt() ?? 0,
      pendingOrders: map['pendingOrders']?.toInt() ?? 0,
    );
  }

  DashboardSummary copyWith({
    int? totalInventoryItems,
    double? totalInventoryValue,
    int? activeProductionOrders,
    int? currentWorkers,
    double? dailySales,
    double? monthlyProfit,
    int? lowStockItems,
    int? pendingOrders,
  }) {
    return DashboardSummary(
      totalInventoryItems: totalInventoryItems ?? this.totalInventoryItems,
      totalInventoryValue: totalInventoryValue ?? this.totalInventoryValue,
      activeProductionOrders:
          activeProductionOrders ?? this.activeProductionOrders,
      currentWorkers: currentWorkers ?? this.currentWorkers,
      dailySales: dailySales ?? this.dailySales,
      monthlyProfit: monthlyProfit ?? this.monthlyProfit,
      lowStockItems: lowStockItems ?? this.lowStockItems,
      pendingOrders: pendingOrders ?? this.pendingOrders,
    );
  }

  @override
  List<Object?> get props => [
    totalInventoryItems,
    totalInventoryValue,
    activeProductionOrders,
    currentWorkers,
    dailySales,
    monthlyProfit,
    lowStockItems,
    pendingOrders,
  ];
}

