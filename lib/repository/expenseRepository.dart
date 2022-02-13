import 'package:expense_tracker_app/model/expenseModel.dart';
import 'package:expense_tracker_app/model/profileModel.dart';
import 'package:expense_tracker_app/services/expenseApiService.dart';

class ExpenseRepository {
  expenseApiService _service = expenseApiService();

  Future<List<expenseModel>> fetchData() async {
    final response = await _service.getExpense();
    return response;
  }
  
  Future<profileModel> getProfile() async {
    final response = await _service.profile();
    return response;
  }
}
