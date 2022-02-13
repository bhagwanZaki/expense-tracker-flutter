import 'package:expense_tracker_app/model/dashboardModel.dart';
import 'package:expense_tracker_app/services/dashboardApiService.dart';

class DashboardRepository {
  DashboardApiService _service = DashboardApiService();

  Future<DashboardModel> getDashboard() async {
    final response = await _service.dashboard();
    return response;
  }
}
