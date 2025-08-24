import '../../../../db/database_helper.dart';
import '../../domain/entities/item.dart';
import '../../domain/entities/inventory_transaction.dart';

class InventoryLocalDataSource {
  final DatabaseHelper _databaseHelper;

  InventoryLocalDataSource(this._databaseHelper);

  // Item operations
  Future<List<Map<String, dynamic>>> getAllItems() async {
    return await _databaseHelper.query(
      'items',
      orderBy: 'name ASC',
    );
  }

  Future<Map<String, dynamic>?> getItemById(int id) async {
    final results = await _databaseHelper.query(
      'items',
      where: 'id = ?',
      whereArgs: [id],
    );
    return results.isNotEmpty ? results.first : null;
  }

  Future<List<Map<String, dynamic>>> searchItems(String query) async {
    return await _databaseHelper.query(
      'items',
      where: 'name LIKE ? OR supplier LIKE ?',
      whereArgs: ['%$query%', '%$query%'],
      orderBy: 'name ASC',
    );
  }

  Future<List<Map<String, dynamic>>> getLowStockItems() async {
    return await _databaseHelper.rawQuery('''
      SELECT * FROM items 
      WHERE quantity <= min_quantity 
      ORDER BY (min_quantity - quantity) DESC
    ''');
  }

  Future<int> addItem(Item item) async {
    return await _databaseHelper.insert('items', item.toMap());
  }

  Future<int> updateItem(Item item) async {
    return await _databaseHelper.update(
      'items',
      item.toMap(),
      where: 'id = ?',
      whereArgs: [item.id],
    );
  }

  Future<int> deleteItem(int id) async {
    return await _databaseHelper.delete(
      'items',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<int> updateItemQuantity(int itemId, double newQuantity) async {
    return await _databaseHelper.update(
      'items',
      {
        'quantity': newQuantity,
        'updated_at': DateTime.now().toIso8601String(),
      },
      where: 'id = ?',
      whereArgs: [itemId],
    );
  }

  // Transaction operations
  Future<List<Map<String, dynamic>>> getItemTransactions(int itemId) async {
    return await _databaseHelper.query(
      'inventory_transactions',
      where: 'item_id = ?',
      whereArgs: [itemId],
      orderBy: 'created_at DESC',
    );
  }

  Future<List<Map<String, dynamic>>> getAllTransactions() async {
    return await _databaseHelper.query(
      'inventory_transactions',
      orderBy: 'created_at DESC',
    );
  }

  Future<List<Map<String, dynamic>>> getTransactionsByType(TransactionType type) async {
    return await _databaseHelper.query(
      'inventory_transactions',
      where: 'type = ?',
      whereArgs: [type.name],
      orderBy: 'created_at DESC',
    );
  }

  Future<List<Map<String, dynamic>>> getTransactionsByDateRange(DateTime start, DateTime end) async {
    return await _databaseHelper.query(
      'inventory_transactions',
      where: 'created_at BETWEEN ? AND ?',
      whereArgs: [start.toIso8601String(), end.toIso8601String()],
      orderBy: 'created_at DESC',
    );
  }

  Future<int> addTransaction(InventoryTransaction transaction) async {
    return await _databaseHelper.insert('inventory_transactions', transaction.toMap());
  }

  Future<int> deleteTransaction(int id) async {
    return await _databaseHelper.delete(
      'inventory_transactions',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  // Reports
  Future<Map<String, dynamic>> getInventorySummary() async {
    final results = await _databaseHelper.rawQuery('''
      SELECT 
        COUNT(*) as total_items,
        SUM(quantity * price) as total_value,
        COUNT(CASE WHEN quantity <= min_quantity THEN 1 END) as low_stock_items
      FROM items
    ''');
    
    return results.isNotEmpty ? results.first : {};
  }

  Future<List<Map<String, dynamic>>> getStockMovementReport(DateTime start, DateTime end) async {
    return await _databaseHelper.rawQuery('''
      SELECT 
        i.name as item_name,
        i.unit,
        SUM(CASE WHEN it.type IN ('purchase', 'return_') THEN it.quantity ELSE 0 END) as incoming,
        SUM(CASE WHEN it.type IN ('sale', 'production', 'waste') THEN it.quantity ELSE 0 END) as outgoing,
        i.quantity as current_stock
      FROM items i
      LEFT JOIN inventory_transactions it ON i.id = it.item_id 
        AND it.created_at BETWEEN ? AND ?
      GROUP BY i.id, i.name, i.unit, i.quantity
      ORDER BY i.name
    ''', [start.toIso8601String(), end.toIso8601String()]);
  }

  Future<List<Map<String, dynamic>>> getLowStockReport() async {
    return await _databaseHelper.rawQuery('''
      SELECT 
        name,
        unit,
        quantity,
        min_quantity,
        (min_quantity - quantity) as shortage,
        price,
        (min_quantity - quantity) * price as shortage_value
      FROM items
      WHERE quantity <= min_quantity
      ORDER BY (min_quantity - quantity) DESC
    ''');
  }
}
