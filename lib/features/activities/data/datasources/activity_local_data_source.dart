
import 'package:masn3k/db/database_helper.dart';
import 'package:masn3k/features/activities/domin/entities/activity.dart';

class ActivityLocalDataSource {
  final DatabaseHelper _databaseHelper;

  ActivityLocalDataSource(this._databaseHelper);

  Future<void> insertActivity(Activity activity) async {
    await _databaseHelper.insert('activities', activity.toMap());
  }

  Future<List<Map<String, dynamic>>> getActivities() async {
    final result = await _databaseHelper.query('activities', orderBy: 'created_at DESC');
    return result;
  }
}
