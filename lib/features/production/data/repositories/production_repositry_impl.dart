import 'package:masn3k/features/production/data/production_local_data_source.dart';
import 'package:masn3k/features/production/domain/entity/machien.dart';
import 'package:masn3k/features/production/domain/repository/production_repository.dart';

class ProductionRepositryImpl extends ProductionRepository {
  final ProductionLocalDataSource _localDataSource;

  ProductionRepositryImpl(this._localDataSource);

  @override
  Future<void> insertMachien(Machine machien) async {
    try {
      await _localDataSource.insertMachien(machien);
    } catch (e) {
      throw Exception('Failed to insert machien: $e');
    }
  }

  @override
  Future<List<Machine>> loadMachiens() async {
    try {
      return await _localDataSource.loadMachiens();
    } catch (e) {
      throw Exception('Failed to load machiens: $e');
    }
  }

  @override
  Future<void> deleteMachien(Machine machien) async {
    try {
      await _localDataSource.deleteMachien(machien);
    } catch (e) {
      throw Exception('Failed to delete machien: $e');
    }
  }

  @override
  Future<void> updateMachien(Machine machien) async {
    try {
      await _localDataSource.updateMachien(machien);
    } catch (e) {
      throw Exception('Failed to update machien: $e');
    }
  }
}
