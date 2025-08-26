import 'package:masn3k/features/activities/data/datasources/activity_local_data_source.dart';
import 'package:masn3k/features/activities/domin/entities/activity.dart';
import 'package:masn3k/features/activities/domin/repositories/activity_repository.dart';

class ActivityRepositoryImpl implements ActivityRepository {
  final ActivityLocalDataSource _localDataSource;

  ActivityRepositoryImpl(this._localDataSource);

  @override
  Future<void> logActivity(Activity activity) async {
    try {
      await _localDataSource.insertActivity(activity);
    } catch (e) {
      throw Exception('Failed to log activity: $e');
    }
  }

  @override
  Future<List<Activity>> getRecentActivities() async {
    try{
    final result = await _localDataSource.getActivities();
    return result.map((data) => Activity.fromMap(data)).toList();
    }catch(e){
      throw Exception('Failed to fetch activities: $e');
    }
  }
}
