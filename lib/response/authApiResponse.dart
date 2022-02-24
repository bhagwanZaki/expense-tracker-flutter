class AuthResponse<T> {
  late Status status;
  late T data;
  late String msg;

  AuthResponse.loading(this.msg) : status = Status.LOADING;
  AuthResponse.completed(this.data) : status = Status.COMPLETED;
  AuthResponse.error(this.msg) : status = Status.ERROR;

  @override
  String toString() {
    return "Status : $status \n Message : $msg \n Data : $data";
  }
}

enum Status { LOADING ,COMPLETED, ERROR }

class LogoutResponse<T>{
  late Status status;
  late String msg;

  LogoutResponse.loading(this.msg) : status = Status.LOADING;
  LogoutResponse.completed(this.msg) : status = Status.COMPLETED;
  LogoutResponse.error(this.msg) : status = Status.ERROR;

  @override
  String toString() {
    return "Status : $status \n Message : $msg";
  }
}
