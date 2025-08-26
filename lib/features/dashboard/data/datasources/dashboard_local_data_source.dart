import 'package:flutter/material.dart';

import '../../../../db/database_helper.dart';
import '../../domain/entities/dashboard_summary.dart';

class DashboardLocalDataSource {
  final DatabaseHelper _databaseHelper;

  DashboardLocalDataSource(this._databaseHelper);

  Future<DashboardSummary> getDashboardSummary() async {
    try {
      // Get inventory stats
      final inventoryResult = await _databaseHelper.rawQuery('''
        SELECT 
          COUNT(*) as total_items,
          SUM(price * quantity) as total_value,
          COUNT(CASE WHEN quantity <= min_quantity THEN 1 END) as low_stock_items
        FROM items
      ''');

      // Get production orders
      final productionResult = await _databaseHelper.rawQuery('''
        SELECT COUNT(*) as active_orders
        FROM production_orders
        WHERE status = 'active'
      ''');

      // Get workers
      final workersResult = await _databaseHelper.rawQuery('''
        SELECT COUNT(*) as current_workers
        FROM workers
        WHERE status = 'active'
      ''');

      // Get sales stats
      final salesResult = await _databaseHelper.rawQuery('''
        SELECT 
          SUM(total_amount) as daily_sales,
          SUM(total_amount - paid_amount) as pending_amount
        FROM sales
        WHERE date(sale_date) = date('now')
      ''');

      // Get monthly profit (simplified calculation)
      final profitResult = await _databaseHelper.rawQuery('''
        SELECT SUM(total_amount) as monthly_sales
        FROM sales
        WHERE strftime('%Y-%m', sale_date) = strftime('%Y-%m', 'now')
      ''');

      final inventory = inventoryResult.first;
      final production = productionResult.first;
      final workers = workersResult.first;
      final sales = salesResult.first;
      final profit = profitResult.first;

      return DashboardSummary(
        totalInventoryItems: inventory['total_items']?.toInt() ?? 0,
        totalInventoryValue: inventory['total_value']?.toDouble() ?? 0.0,
        activeProductionOrders: production['active_orders']?.toInt() ?? 0,
        currentWorkers: workers['current_workers']?.toInt() ?? 0,
        dailySales: sales['daily_sales']?.toDouble() ?? 0.0,
        monthlyProfit:
            (profit['monthly_sales']?.toDouble() ?? 0.0) *
            0.3, // Assuming 30% profit margin
        lowStockItems: inventory['low_stock_items']?.toInt() ?? 0,
        pendingOrders: sales['pending_amount']?.toDouble() ?? 0.0 > 0 ? 1 : 0,
      );
    } catch (e) {
      // Return default values if database is not ready
      return const DashboardSummary(
        totalInventoryItems: 0,
        totalInventoryValue: 0.0,
        activeProductionOrders: 0,
        currentWorkers: 0,
        dailySales: 0.0,
        monthlyProfit: 0.0,
        lowStockItems: 0,
        pendingOrders: 0,
      );
    }
  }

  Future<Map<String, dynamic>> getQuickStats() async {
    try {
      final result = await _databaseHelper.rawQuery('''
        SELECT 
          COUNT(*) as total_items,
          SUM(price * quantity) as total_value,
          COUNT(CASE WHEN quantity <= min_quantity THEN 1 END) as low_stock_items
        FROM items
      ''');

      return result.first;
    } catch (e) {
      return {'total_items': 0, 'total_value': 0.0, 'low_stock_items': 0};
    }
  }

  Future<List<Map<String, dynamic>>> getRecentActivity() async {
  try {
    final result = await _databaseHelper.rawQuery('''
      SELECT 
        id,
        category,          -- نوع العملية (inventory, production...)
        action,        -- الإجراء (إضافة، بيع...)
        description,     -- فاتورة أو مرجع
       related_item,     -- اسم العنصر لو ينطبق
        quantity,      -- كمية لو ينطبق
        amount,        -- مبلغ لو ينطبق
        created_at
      FROM activities
      ORDER BY datetime(created_at) DESC
      LIMIT 10
    ''');

    return result;
  } catch (e) {
    // ممكن تطبع أو تسجل الخطأ للديباجينج
    debugPrint('Error in getRecentActivity: $e');
    return [];
  }
}

}
