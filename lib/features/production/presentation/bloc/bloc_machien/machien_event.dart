import 'package:equatable/equatable.dart';
import 'package:masn3k/features/production/domain/entity/machien.dart';

abstract class MachienEvent extends Equatable {
  const MachienEvent();

  @override
  List<Object?> get props => [];
}

class InsertMachien extends MachienEvent {
  final Machine machine;

  const InsertMachien(this.machine);

  @override
  List<Object?> get props => [machine];
}

class LoadMachiens extends MachienEvent {}

class UpdateMachien extends MachienEvent {
  final Machine machine;

  const UpdateMachien(this.machine);

  @override
  List<Object?> get props => [machine];
}

class DeleteMachien extends MachienEvent {
  final Machine machine;

  const DeleteMachien(this.machine);

  @override
  List<Object?> get props => [machine];
}
