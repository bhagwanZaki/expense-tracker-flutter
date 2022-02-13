import 'dart:async';

import 'package:expense_tracker_app/model/expenseModel.dart';
import 'package:expense_tracker_app/model/profileModel.dart';
import 'package:expense_tracker_app/repository/expenseRepository.dart';
import 'package:expense_tracker_app/response/expenseApiResponse.dart';

class ExpenseBloc {
  late ExpenseRepository _expenseRepository;
  late StreamController<ExpenseApiResponse<List<expenseModel>>>
      _expenseListController;
  late StreamController<ExpenseApiResponse<profileModel>> _profileController;

  StreamSink<ExpenseApiResponse<List<expenseModel>>> get expenseListSink =>
      _expenseListController.sink;
  StreamSink<ExpenseApiResponse<profileModel>> get profileSink =>
      _profileController.sink;

  Stream<ExpenseApiResponse<List<expenseModel>>> get expenseListStream =>
      _expenseListController.stream;
  Stream<ExpenseApiResponse<profileModel>> get profileStream =>
      _profileController.stream;

  ExpenseBloc() {
    _expenseListController =
        StreamController<ExpenseApiResponse<List<expenseModel>>>();
    _profileController = StreamController<ExpenseApiResponse<profileModel>>();
    _expenseRepository = ExpenseRepository();
    fetchExpenseList();
    profile();
  }

  fetchExpenseList() async {
    expenseListSink.add(ExpenseApiResponse.loading("Fetching data"));
    try {
      List<expenseModel> expenseDatas = await _expenseRepository.fetchData();
      expenseListSink.add(ExpenseApiResponse.completed(expenseDatas));
    } catch (e) {
      expenseListSink.add(ExpenseApiResponse.error(e.toString()));
      print(e);
    }
  }

  profile() async {
    profileSink.add(ExpenseApiResponse.loading("getting Data"));
    try {
      profileModel profileData = await _expenseRepository.getProfile();
      profileSink.add(ExpenseApiResponse.completed(profileData));
    } catch (e) {
      print(e);
      profileSink.add(ExpenseApiResponse.error(e.toString()));
    }
  }

  dispose() {
    _expenseListController.close();
    _profileController.close();
  }
}
