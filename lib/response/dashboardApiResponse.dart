class DashboardApiResponse<T> {
  late DashboardStatus status;
  late T data;
  late String msg;

  DashboardApiResponse.loading(this.msg) : status = DashboardStatus.LOADING;
  DashboardApiResponse.completed(this.data) : status = DashboardStatus.COMPLETED;
  DashboardApiResponse.error(this.msg) : status = DashboardStatus.ERROR;

  @override
  String toString() {
    return "Status : $status \n Message : $msg \n Data : $data";
  }
}

enum DashboardStatus { LOADING, COMPLETED, ERROR }
