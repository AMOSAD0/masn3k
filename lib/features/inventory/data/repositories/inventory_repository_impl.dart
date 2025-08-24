import '../../domain/entities/item.dart';
import '../../domain/entities/inventory_transaction.dart';
import '../../domain/repositories/inventory_repository.dart';
import '../datasources/inventory_local_data_source.dart';

class InventoryRepositoryImpl implements InventoryRepository {
  final InventoryLocalDataSource _localDataSource;

  InventoryRepositoryImpl(this._localDataSource);

  @override
  Future<List<Item>> getAllItems() async {
    try {
      final itemsData = await _localDataSource.getAllItems();
      return itemsData.map((data) => Item.fromMap(data)).toList();
    } catch (e) {
      throw Exception('Failed to load items: $e');
    }
  }

  @override
  Future<Item?> getItemById(int id) async {
    try {
      final itemData = await _localDataSource.getItemById(id);
      return itemData != null ? Item.fromMap(itemData) : null;
    } catch (e) {
      throw Exception('Failed to load item: $e');
    }
  }

  @override
  Future<List<Item>> searchItems(String query) async {
    try {
      final itemsData = await _localDataSource.searchItems(query);
      return itemsData.map((data) => Item.fromMap(data)).toList();
    } catch (e) {
      throw Exception('Failed to search items: $e');
    }
  }

  @override
  Future<List<Item>> getLowStockItems() async {
    try {
      final itemsData = await _localDataSource.getLowStockItems();
      return itemsData.map((data) => Item.fromMap(data)).toList();
    } catch (e) {
      throw Exception('Failed to load low stock items: $e');
    }
  }

  @override
  Future<int> addItem(Item item) async {
    try {
      return await _localDataSource.addItem(item);
    } catch (e) {
      throw Exception('Failed to add item: $e');
    }
  }

  @override
  Future<int> updateItem(Item item) async {
    try {
      return await _localDataSource.updateItem(item);
    } catch (e) {
      throw Exception('Failed to update item: $e');
    }
  }

  @override
  Future<int> deleteItem(int id) async {
    try {
      return await _localDataSource.deleteItem(id);
    } catch (e) {
      throw Exception('Failed to delete item: $e');
    }
  }

  @override
  Future<int> updateItemQuantity(int itemId, double newQuantity) async {
    try {
      return await _localDataSource.updateItemQuantity(itemId, newQuantity);
    } catch (e) {
      throw Exception('Failed to update item quantity: $e');
    }
  }

  @override
  Future<List<InventoryTransaction>> getItemTransactions(int itemId) async {
    try {
      final transactionsData = await _localDataSource.getItemTransactions(itemId);
      return transactionsData.map((data) => InventoryTransaction.fromMap(data)).toList();
    } catch (e) {
      throw Exception('Failed to load item transactions: $e');
    }
  }

  @override
  Future<List<InventoryTransaction>> getAllTransactions() async {
    try {
      final transactionsData = await _localDataSource.getAllTransactions();
      return transactionsData.map((data) => InventoryTransaction.fromMap(data)).toList();
    } catch (e) {
      throw Exception('Failed to load all transactions: $e');
    }
  }

  @override
  Future<List<InventoryTransaction>> getTransactionsByType(TransactionType type) async {
    try {
      final transactionsData = await _localDataSource.getTransactionsByType(type);
      return transactionsData.map((data) => InventoryTransaction.fromMap(data)).toList();
    } catch (e) {
      throw Exception('Failed to load transactions by type: $e');
    }
  }

  @override
  Future<List<InventoryTransaction>> getTransactionsByDateRange(DateTime start, DateTime end) async {
    try {
      final transactionsData = await _localDataSource.getTransactionsByDateRange(start, end);
      return transactionsData.map((data) => InventoryTransaction.fromMap(data)).toList();
    } catch (e) {
      throw Exception('Failed to load transactions by date range: $e');
    }
  }

  @override
  Future<int> addTransaction(InventoryTransaction transaction) async {
    try {
      // Update item quantity based on transaction type
      final item = await getItemById(transaction.itemId);
      if (item != null) {
        double newQuantity = item.quantity;
        if (transaction.isIncoming) {
          newQuantity += transaction.quantity;
        } else if (transaction.isOutgoing) {
          newQuantity -= transaction.quantity;
        }
        
        await updateItemQuantity(transaction.itemId, newQuantity);
      }
      
      return await _localDataSource.addTransaction(transaction);
    } catch (e) {
      throw Exception('Failed to add transaction: $e');
    }
  }

  @override
  Future<int> deleteTransaction(int id) async {
    try {
      return await _localDataSource.deleteTransaction(id);
    } catch (e) {
      throw Exception('Failed to delete transaction: $e');
    }
  }

  @override
  Future<Map<String, dynamic>> getInventorySummary() async {
    try {
      return await _localDataSource.getInventorySummary();
    } catch (e) {
      throw Exception('Failed to get inventory summary: $e');
    }
  }

  @override
  Future<List<Map<String, dynamic>>> getStockMovementReport(DateTime start, DateTime end) async {
    try {
      return await _localDataSource.getStockMovementReport(start, end);
    } catch (e) {
      throw Exception('Failed to get stock movement report: $e');
    }
  }

  @override
  Future<List<Map<String, dynamic>>> getLowStockReport() async {
    try {
      return await _localDataSource.getLowStockReport();
    } catch (e) {
      throw Exception('Failed to get low stock report: $e');
    }
  }
}
