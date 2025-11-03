import 'package:masn3k/db/database_helper.dart';
import 'package:masn3k/features/production/domain/entity/machien.dart';

class ProductionLocalDataSource {
  final DatabaseHelper _databaseHelper;

  ProductionLocalDataSource(this._databaseHelper);

  Future<void> insertMachien(Machine machien) async {
    await _databaseHelper.insert('machines', machien.toMap());
  }

  Future<List<Machine>> loadMachiens() async {
    final data = await _databaseHelper.query('machines', orderBy: 'name ASC');

    return data.map((e) => Machine.fromMap(e)).toList();
  }

  Future<void> updateMachien(Machine machien) async {
    await _databaseHelper.update(
      'machines',
      machien.toMap(),
      where: 'id = ?',
      whereArgs: [machien.id],
    );
  }

  Future<void> deleteMachien(Machine machien) async {
    await _databaseHelper.delete(
      'machines',
      where: 'id = ?',
      whereArgs: [machien.id],
    );
  }
}
