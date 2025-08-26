import 'package:masn3k/features/activities/domin/entities/activity.dart';

abstract class ActivityRepository {
  Future<void> logActivity(Activity activity);
  Future<List<Activity>> getRecentActivities();
}