import 'package:masn3k/features/production/domain/entity/machien.dart';

abstract class ProductionRepository {
  Future<void> insertMachien(Machine machien);

  Future<List<Machine>> loadMachiens();

  Future<void> updateMachien(Machine machien);
  Future<void> deleteMachien(Machine machien);
}
