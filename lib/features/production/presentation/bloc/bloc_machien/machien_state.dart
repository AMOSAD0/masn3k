import 'package:equatable/equatable.dart';
import 'package:masn3k/features/production/domain/entity/machien.dart';

abstract class MachienState extends Equatable {
  const MachienState();

  @override
  List<Object?> get props => [];
}

class MachienInitial extends MachienState {}

class MachienLoading extends MachienState {}

class MachienLoaded extends MachienState {
  final String message;
  final List<Machine> machiens;
  const MachienLoaded({required this.message, required this.machiens});

  @override
  List<Object?> get props => [message];
}

class MachienError extends MachienState {
  final String message;

  const MachienError(this.message);

  @override
  List<Object?> get props => [message];
}
