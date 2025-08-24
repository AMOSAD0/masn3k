import '../entities/dashboard_summary.dart';

abstract class DashboardRepository {
  Future<DashboardSummary> getDashboardSummary();
  Future<Map<String, dynamic>> getQuickStats();
  Future<List<Map<String, dynamic>>> getRecentActivity();
}

