import 'dart:async';

import 'package:expense_tracker_app/model/dashboardModel.dart';
import 'package:expense_tracker_app/repository/dashboardRepository.dart';
import 'package:expense_tracker_app/response/dashboardApiResponse.dart';

class DashboardBloc {
  late DashboardRepository _dashboardRepository;
  late StreamController<DashboardApiResponse<DashboardModel>>
      _dashboardController;

  StreamSink<DashboardApiResponse<DashboardModel>> get dashboardSink =>
      _dashboardController.sink;

  Stream<DashboardApiResponse<DashboardModel>> get dashboardStream =>
      _dashboardController.stream;

  DashboardBloc() {
    _dashboardController =
        StreamController<DashboardApiResponse<DashboardModel>>();

    _dashboardRepository = DashboardRepository();
    dashboard();
  }

  dashboard() async {
    dashboardSink.add(DashboardApiResponse.loading("Fetching Data"));
    try {
      DashboardModel dashboardData = await _dashboardRepository.getDashboard();
      dashboardSink.add(DashboardApiResponse.completed(dashboardData));
    } catch (e) {
      dashboardSink.add(DashboardApiResponse.error(e.toString()));
    }
  }

  dispose() {
    _dashboardController.close();
  }
}
