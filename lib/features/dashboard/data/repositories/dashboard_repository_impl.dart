import '../../domain/entities/dashboard_summary.dart';
import '../../domain/repositories/dashboard_repository.dart';
import '../datasources/dashboard_local_data_source.dart';

class DashboardRepositoryImpl implements DashboardRepository {
  final DashboardLocalDataSource _localDataSource;

  DashboardRepositoryImpl(this._localDataSource);

  @override
  Future<DashboardSummary> getDashboardSummary() async {
    try {
      return await _localDataSource.getDashboardSummary();
    } catch (e) {
      throw Exception('فشل في تحميل بيانات لوحة التحكم: $e');
    }
  }

  @override
  Future<Map<String, dynamic>> getQuickStats() async {
    try {
      return await _localDataSource.getQuickStats();
    } catch (e) {
      throw Exception('فشل في تحميل الإحصائيات السريعة: $e');
    }
  }

  @override
  Future<List<Map<String, dynamic>>> getRecentActivity() async {
    try {
      return await _localDataSource.getRecentActivity();
    } catch (e) {
      throw Exception('فشل في تحميل النشاط الأخير: $e');
    }
  }
}

