import '../entities/item.dart';
import '../entities/inventory_transaction.dart';

abstract class InventoryRepository {
  // Item operations
  Future<List<Item>> getAllItems();
  Future<Item?> getItemById(int id);
  Future<List<Item>> searchItems(String query);
  Future<List<Item>> getLowStockItems();
  Future<int> addItem(Item item);
  Future<int> updateItem(Item item);
  Future<int> deleteItem(int id);
  Future<int> updateItemQuantity(int itemId, double newQuantity);

  // Transaction operations
  Future<List<InventoryTransaction>> getItemTransactions(int itemId);
  Future<List<InventoryTransaction>> getAllTransactions();
  Future<List<InventoryTransaction>> getTransactionsByType(TransactionType type);
  Future<List<InventoryTransaction>> getTransactionsByDateRange(DateTime start, DateTime end);
  Future<int> addTransaction(InventoryTransaction transaction);
  Future<int> deleteTransaction(int id);

  // Reports
  Future<Map<String, dynamic>> getInventorySummary();
  Future<List<Map<String, dynamic>>> getStockMovementReport(DateTime start, DateTime end);
  Future<List<Map<String, dynamic>>> getLowStockReport();
}
