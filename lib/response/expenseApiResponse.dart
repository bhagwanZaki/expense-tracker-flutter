class ExpenseApiResponse<T> {
  late Status status;
  late T data;
  late String msg;

  ExpenseApiResponse.loading(this.msg) : status = Status.LOADING;
  ExpenseApiResponse.completed(this.data) : status = Status.COMPLETED;
  ExpenseApiResponse.error(this.msg) : status = Status.ERROR;

  @override
  String toString() {
    return "Status : $status \n Message : $msg \n Data : $data";
  }
}

class ExpenseDeleteApiResponse<T> {
  late Status status;
  late String msg;

  ExpenseDeleteApiResponse.loading(this.msg) : status = Status.LOADING;
  ExpenseDeleteApiResponse.completed(this.msg) : status = Status.COMPLETED;
  ExpenseDeleteApiResponse.error(this.msg) : status = Status.ERROR;

  @override
  String toString() {
    return "Status : $status \n Message : $msg";
  }
}

enum Status { LOADING, COMPLETED, ERROR }

