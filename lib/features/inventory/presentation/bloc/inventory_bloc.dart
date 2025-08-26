import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:masn3k/features/activities/domin/entities/activity.dart';
import 'package:masn3k/features/activities/domin/repositories/activity_repository.dart';
import '../../domain/entities/item.dart';
import '../../domain/entities/inventory_transaction.dart';
import '../../domain/repositories/inventory_repository.dart';

// Events
abstract class InventoryEvent extends Equatable {
  const InventoryEvent();

  @override
  List<Object?> get props => [];
}

class LoadItems extends InventoryEvent {}

class SearchItems extends InventoryEvent {
  final String query;

  const SearchItems(this.query);

  @override
  List<Object?> get props => [query];
}

class LoadLowStockItems extends InventoryEvent {}

class AddItem extends InventoryEvent {
  final Item item;

  const AddItem(this.item);

  @override
  List<Object?> get props => [item];
}

class UpdateItem extends InventoryEvent {
  final Item item;

  const UpdateItem(this.item);

  @override
  List<Object?> get props => [item];
}

class DeleteItem extends InventoryEvent {
  final int itemId;
  final Item item;

  const DeleteItem(this.itemId, this.item);

  @override
  List<Object?> get props => [itemId, item];
}

class LoadItemTransactions extends InventoryEvent {
  final int itemId;

  const LoadItemTransactions(this.itemId);

  @override
  List<Object?> get props => [itemId];
}

class AddTransaction extends InventoryEvent {
  final InventoryTransaction transaction;

  const AddTransaction(this.transaction);

  @override
  List<Object?> get props => [transaction];
}

class LoadInventorySummary extends InventoryEvent {}

class LoadStockMovementReport extends InventoryEvent {
  final DateTime startDate;
  final DateTime endDate;

  const LoadStockMovementReport(this.startDate, this.endDate);

  @override
  List<Object?> get props => [startDate, endDate];
}

class LoadLowStockReport extends InventoryEvent {}

// States
abstract class InventoryState extends Equatable {
  const InventoryState();

  @override
  List<Object?> get props => [];
}

class InventoryInitial extends InventoryState {}

class InventoryLoading extends InventoryState {}

class ItemsLoaded extends InventoryState {
  final List<Item> items;

  const ItemsLoaded(this.items);

  @override
  List<Object?> get props => [items];
}

class LowStockItemsLoaded extends InventoryState {
  final List<Item> items;

  const LowStockItemsLoaded(this.items);

  @override
  List<Object?> get props => [items];
}

class ItemTransactionsLoaded extends InventoryState {
  final List<InventoryTransaction> transactions;

  const ItemTransactionsLoaded(this.transactions);

  @override
  List<Object?> get props => [transactions];
}

class InventorySummaryLoaded extends InventoryState {
  final Map<String, dynamic> summary;

  const InventorySummaryLoaded(this.summary);

  @override
  List<Object?> get props => [summary];
}

class StockMovementReportLoaded extends InventoryState {
  final List<Map<String, dynamic>> report;

  const StockMovementReportLoaded(this.report);

  @override
  List<Object?> get props => [report];
}

class LowStockReportLoaded extends InventoryState {
  final List<Map<String, dynamic>> report;

  const LowStockReportLoaded(this.report);

  @override
  List<Object?> get props => [report];
}

class InventorySuccess extends InventoryState {
  final String message;

  const InventorySuccess(this.message);

  @override
  List<Object?> get props => [message];
}

class InventoryError extends InventoryState {
  final String message;

  const InventoryError(this.message);

  @override
  List<Object?> get props => [message];
}

// BLoC
class InventoryBloc extends Bloc<InventoryEvent, InventoryState> {
  final InventoryRepository _repository;
  final ActivityRepository _activityRepository;

  InventoryBloc(this._repository, this._activityRepository)
    : super(InventoryInitial()) {
    on<LoadItems>(_onLoadItems);
    on<SearchItems>(_onSearchItems);
    on<LoadLowStockItems>(_onLoadLowStockItems);
    on<AddItem>(_onAddItem);
    on<UpdateItem>(_onUpdateItem);
    on<DeleteItem>(_onDeleteItem);
    on<LoadItemTransactions>(_onLoadItemTransactions);
    on<AddTransaction>(_onAddTransaction);
    on<LoadInventorySummary>(_onLoadInventorySummary);
    on<LoadStockMovementReport>(_onLoadStockMovementReport);
    on<LoadLowStockReport>(_onLoadLowStockReport);
  }

  Future<void> _onLoadItems(
    LoadItems event,
    Emitter<InventoryState> emit,
  ) async {
    emit(InventoryLoading());
    try {
      final items = await _repository.getAllItems();
      emit(ItemsLoaded(items));
    } catch (e) {
      emit(InventoryError(e.toString()));
    }
  }

  Future<void> _onSearchItems(
    SearchItems event,
    Emitter<InventoryState> emit,
  ) async {
    emit(InventoryLoading());
    try {
      final items = await _repository.searchItems(event.query);
      emit(ItemsLoaded(items));
    } catch (e) {
      emit(InventoryError(e.toString()));
    }
  }

  Future<void> _onLoadLowStockItems(
    LoadLowStockItems event,
    Emitter<InventoryState> emit,
  ) async {
    emit(InventoryLoading());
    try {
      final items = await _repository.getLowStockItems();
      emit(LowStockItemsLoaded(items));
    } catch (e) {
      emit(InventoryError(e.toString()));
    }
  }

  Future<void> _onAddItem(AddItem event, Emitter<InventoryState> emit) async {
    emit(InventoryLoading());
    try {
      await _repository.addItem(event.item);
      await _activityRepository.logActivity(
        Activity(
          category: "inventory",
          action: "add",
          description: "اضافة عنصر : ${event.item.name}",
          quantity: event.item.quantity,
          amount: event.item.price,
          related_item: event.item.name,
          createdAt: DateTime.now(),
        ),
      );
      emit(const InventorySuccess('تم إضافة العنصر بنجاح'));
      add(LoadItems());
    } catch (e) {
      emit(InventoryError(e.toString()));
    }
  }

  Future<void> _onUpdateItem(
    UpdateItem event,
    Emitter<InventoryState> emit,
  ) async {
    emit(InventoryLoading());
    try {
      await _repository.updateItem(event.item);
      await _activityRepository.logActivity(
        Activity(
          category: "inventory",
          action: "update",
          description: "تعديل عنصر : ${event.item.name}",
          quantity: event.item.quantity,
          amount: event.item.price,
          related_item: event.item.name,
          createdAt: DateTime.now(),
        ),
      );
      emit(const InventorySuccess('تم تحديث العنصر بنجاح'));
      add(LoadItems());
    } catch (e) {
      emit(InventoryError(e.toString()));
    }
  }

  Future<void> _onDeleteItem(
    DeleteItem event,
    Emitter<InventoryState> emit,
  ) async {
    emit(InventoryLoading());
    try {
      await _repository.deleteItem(event.itemId);
      await _activityRepository.logActivity(
        Activity(
          category: "inventory",
          action: "delete",
          description: "حذف عنصر : ${event.item.name}",
          quantity: event.item.quantity,
          amount: event.item.price,
          related_item: event.item.name,
          createdAt: DateTime.now(),
        ),
      );
      emit(const InventorySuccess('تم حذف العنصر بنجاح'));
      add(LoadItems());
    } catch (e) {
      emit(InventoryError(e.toString()));
    }
  }

  Future<void> _onLoadItemTransactions(
    LoadItemTransactions event,
    Emitter<InventoryState> emit,
  ) async {
    emit(InventoryLoading());
    try {
      final transactions = await _repository.getItemTransactions(event.itemId);
      emit(ItemTransactionsLoaded(transactions));
    } catch (e) {
      emit(InventoryError(e.toString()));
    }
  }

  Future<void> _onAddTransaction(
    AddTransaction event,
    Emitter<InventoryState> emit,
  ) async {
    emit(InventoryLoading());
    try {
      await _repository.addTransaction(event.transaction);

      await _activityRepository.logActivity(
        Activity(
          category: "inventory",
          action: event.transaction.type.name,
          description:
              "اضافة معاملة ${event.transaction.type.name} للعنصر: ${event.transaction.itemName ?? ''}",
          quantity: event.transaction.quantity,
          related_item: event.transaction.itemName,
          createdAt: DateTime.now(),
        ),
      );
      emit(const InventorySuccess('تم إضافة المعاملة بنجاح'));
      add(LoadItems());
    } catch (e) {
      emit(InventoryError(e.toString()));
    }
  }

  Future<void> _onLoadInventorySummary(
    LoadInventorySummary event,
    Emitter<InventoryState> emit,
  ) async {
    emit(InventoryLoading());
    try {
      final summary = await _repository.getInventorySummary();
      emit(InventorySummaryLoaded(summary));
    } catch (e) {
      emit(InventoryError(e.toString()));
    }
  }

  Future<void> _onLoadStockMovementReport(
    LoadStockMovementReport event,
    Emitter<InventoryState> emit,
  ) async {
    emit(InventoryLoading());
    try {
      final report = await _repository.getStockMovementReport(
        event.startDate,
        event.endDate,
      );
      emit(StockMovementReportLoaded(report));
    } catch (e) {
      emit(InventoryError(e.toString()));
    }
  }

  Future<void> _onLoadLowStockReport(
    LoadLowStockReport event,
    Emitter<InventoryState> emit,
  ) async {
    emit(InventoryLoading());
    try {
      final report = await _repository.getLowStockReport();
      emit(LowStockReportLoaded(report));
    } catch (e) {
      emit(InventoryError(e.toString()));
    }
  }
}
