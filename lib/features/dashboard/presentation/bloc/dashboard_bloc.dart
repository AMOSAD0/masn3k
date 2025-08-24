import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../../domain/entities/dashboard_summary.dart';
import '../../domain/repositories/dashboard_repository.dart';

// Events
abstract class DashboardEvent extends Equatable {
  const DashboardEvent();

  @override
  List<Object?> get props => [];
}

class LoadDashboardSummary extends DashboardEvent {}

class LoadQuickStats extends DashboardEvent {}

class LoadRecentActivity extends DashboardEvent {}

// States
abstract class DashboardState extends Equatable {
  const DashboardState();

  @override
  List<Object?> get props => [];
}

class DashboardInitial extends DashboardState {}

class DashboardLoading extends DashboardState {}

class DashboardSummaryLoaded extends DashboardState {
  final DashboardSummary summary;

  const DashboardSummaryLoaded(this.summary);

  @override
  List<Object?> get props => [summary];
}

class QuickStatsLoaded extends DashboardState {
  final Map<String, dynamic> stats;

  const QuickStatsLoaded(this.stats);

  @override
  List<Object?> get props => [stats];
}

class RecentActivityLoaded extends DashboardState {
  final List<Map<String, dynamic>> activities;

  const RecentActivityLoaded(this.activities);

  @override
  List<Object?> get props => [activities];
}

class DashboardError extends DashboardState {
  final String message;

  const DashboardError(this.message);

  @override
  List<Object?> get props => [message];
}

// BLoC
class DashboardBloc extends Bloc<DashboardEvent, DashboardState> {
  final DashboardRepository _repository;

  DashboardBloc(this._repository) : super(DashboardInitial()) {
    on<LoadDashboardSummary>(_onLoadDashboardSummary);
    on<LoadQuickStats>(_onLoadQuickStats);
    on<LoadRecentActivity>(_onLoadRecentActivity);
  }

  Future<void> _onLoadDashboardSummary(
    LoadDashboardSummary event,
    Emitter<DashboardState> emit,
  ) async {
    emit(DashboardLoading());
    try {
      final summary = await _repository.getDashboardSummary();
      emit(DashboardSummaryLoaded(summary));
    } catch (e) {
      emit(DashboardError(e.toString()));
    }
  }

  Future<void> _onLoadQuickStats(
    LoadQuickStats event,
    Emitter<DashboardState> emit,
  ) async {
    emit(DashboardLoading());
    try {
      final stats = await _repository.getQuickStats();
      emit(QuickStatsLoaded(stats));
    } catch (e) {
      emit(DashboardError(e.toString()));
    }
  }

  Future<void> _onLoadRecentActivity(
    LoadRecentActivity event,
    Emitter<DashboardState> emit,
  ) async {
    emit(DashboardLoading());
    try {
      final activities = await _repository.getRecentActivity();
      emit(RecentActivityLoaded(activities));
    } catch (e) {
      emit(DashboardError(e.toString()));
    }
  }
}

