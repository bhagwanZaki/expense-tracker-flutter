// ignore_for_file: non_constant_identifier_names

import 'dart:convert';

import 'package:flutter/foundation.dart';

class DashboardModel {
  double total_amount;
  double incomeAmt;
  double savingAmt;
  double expenseAmt;
  List<int> dayList;
  List<int> income_graph_data;
  List<int> saving_graph_data;
  List<int> expense_graph_data;
  int total_income_count;
  int total_saving_count;
  int total_expense_count;
  DashboardModel({
    required this.total_amount,
    required this.incomeAmt,
    required this.savingAmt,
    required this.expenseAmt,
    required this.dayList,
    required this.income_graph_data,
    required this.saving_graph_data,
    required this.expense_graph_data,
    required this.total_income_count,
    required this.total_saving_count,
    required this.total_expense_count,
  });


  DashboardModel copyWith({
    double? total_amount,
    double? incomeAmt,
    double? savingAmt,
    double? expenseAmt,
    List<int>? dayList,
    List<int>? income_graph_data,
    List<int>? saving_graph_data,
    List<int>? expense_graph_data,
    int? total_income_count,
    int? total_saving_count,
    int? total_expense_count,
  }) {
    return DashboardModel(
      total_amount: total_amount ?? this.total_amount,
      incomeAmt: incomeAmt ?? this.incomeAmt,
      savingAmt: savingAmt ?? this.savingAmt,
      expenseAmt: expenseAmt ?? this.expenseAmt,
      dayList: dayList ?? this.dayList,
      income_graph_data: income_graph_data ?? this.income_graph_data,
      saving_graph_data: saving_graph_data ?? this.saving_graph_data,
      expense_graph_data: expense_graph_data ?? this.expense_graph_data,
      total_income_count: total_income_count ?? this.total_income_count,
      total_saving_count: total_saving_count ?? this.total_saving_count,
      total_expense_count: total_expense_count ?? this.total_expense_count,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'total_amount': total_amount,
      'incomeAmt': incomeAmt,
      'savingAmt': savingAmt,
      'expenseAmt': expenseAmt,
      'dayList': dayList,
      'income_graph_data': income_graph_data,
      'saving_graph_data': saving_graph_data,
      'expense_graph_data': expense_graph_data,
      'total_income_count': total_income_count,
      'total_saving_count': total_saving_count,
      'total_expense_count': total_expense_count,
    };
  }

  factory DashboardModel.fromMap(Map<String, dynamic> map) {
    return DashboardModel(
      total_amount: map['total_amount']?.toDouble() ?? 0.0,
      incomeAmt: map['incomeAmt']?.toDouble() ?? 0.0,
      savingAmt: map['savingAmt']?.toDouble() ?? 0.0,
      expenseAmt: map['expenseAmt']?.toDouble() ?? 0.0,
      dayList: List<int>.from(map['dayList']),
      income_graph_data: List<int>.from(map['income_graph_data']),
      saving_graph_data: List<int>.from(map['saving_graph_data']),
      expense_graph_data: List<int>.from(map['expense_graph_data']),
      total_income_count: map['total_income_count']?.toInt() ?? 0,
      total_saving_count: map['total_saving_count']?.toInt() ?? 0,
      total_expense_count: map['total_expense_count']?.toInt() ?? 0,
    );
  }

  String toJson() => json.encode(toMap());

  factory DashboardModel.fromJson(String source) => DashboardModel.fromMap(json.decode(source));

  @override
  String toString() {
    return 'DashboardModel(total_amount: $total_amount, incomeAmt: $incomeAmt, savingAmt: $savingAmt, expenseAmt: $expenseAmt, dayList: $dayList, income_graph_data: $income_graph_data, saving_graph_data: $saving_graph_data, expense_graph_data: $expense_graph_data, total_income_count: $total_income_count, total_saving_count: $total_saving_count, total_expense_count: $total_expense_count)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
  
    return other is DashboardModel &&
      other.total_amount == total_amount &&
      other.incomeAmt == incomeAmt &&
      other.savingAmt == savingAmt &&
      other.expenseAmt == expenseAmt &&
      listEquals(other.dayList, dayList) &&
      listEquals(other.income_graph_data, income_graph_data) &&
      listEquals(other.saving_graph_data, saving_graph_data) &&
      listEquals(other.expense_graph_data, expense_graph_data) &&
      other.total_income_count == total_income_count &&
      other.total_saving_count == total_saving_count &&
      other.total_expense_count == total_expense_count;
  }

  @override
  int get hashCode {
    return total_amount.hashCode ^
      incomeAmt.hashCode ^
      savingAmt.hashCode ^
      expenseAmt.hashCode ^
      dayList.hashCode ^
      income_graph_data.hashCode ^
      saving_graph_data.hashCode ^
      expense_graph_data.hashCode ^
      total_income_count.hashCode ^
      total_saving_count.hashCode ^
      total_expense_count.hashCode;
  }
}
