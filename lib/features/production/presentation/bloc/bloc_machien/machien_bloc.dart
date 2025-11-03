import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:masn3k/features/production/domain/entity/machien.dart';
import 'package:masn3k/features/production/domain/repository/production_repository.dart';
import 'package:masn3k/features/production/presentation/bloc/bloc_machien/machien_event.dart';
import 'package:masn3k/features/production/presentation/bloc/bloc_machien/machien_state.dart';

class MachienBloc extends Bloc<MachienEvent, MachienState> {
  final ProductionRepository _repository;

  MachienBloc(this._repository) : super(MachienInitial()) {
    on<InsertMachien>(_onInsertMachien);
    on<LoadMachiens>(_onLoadMachiens);
    on<UpdateMachien>(_onUpdateMachien);
    on<DeleteMachien>(_onDeleteMachien);
  }

  Future<void> _onInsertMachien(
    InsertMachien event,
    Emitter<MachienState> emit,
  ) async {
    emit(MachienLoading());
    try {
      await _repository.insertMachien(event.machine);
      final List<Machine> machiens = await _repository.loadMachiens();
      emit(MachienLoaded(machiens: machiens, message: 'تم إضافة الالة بنجاح'));
    } catch (e) {
      emit(MachienError(e.toString()));
    }
  }

  Future<void> _onLoadMachiens(
    LoadMachiens event,
    Emitter<MachienState> emit,
  ) async {
    emit(MachienLoading());
    try {
      final List<Machine> machiens = await _repository.loadMachiens();
      emit(MachienLoaded(machiens: machiens, message: 'تم تحميل الالات بنجاح'));
    } catch (e) {
      emit(MachienError(e.toString()));
    }
  }

  Future<void> _onUpdateMachien(
    UpdateMachien event,
    Emitter<MachienState> emit,
  ) async {
    emit(MachienLoading());
    try {
      await _repository.updateMachien(event.machine);
      final List<Machine> machiens = await _repository.loadMachiens();
      emit(MachienLoaded(machiens: machiens, message: 'تم تعديل الالة بنجاح'));
    } catch (e) {
      emit(MachienError(e.toString()));
    }
  }

  Future<void> _onDeleteMachien(
    DeleteMachien event,
    Emitter<MachienState> emit,
  ) async {
    emit(MachienLoading());
    try {
      await _repository.deleteMachien(event.machine);
      final List<Machine> machiens = await _repository.loadMachiens();
      emit(MachienLoaded(machiens: machiens, message: 'تم حذف الالة بنجاح'));
    } catch (e) {
      emit(MachienError(e.toString()));
    }
  }
}
