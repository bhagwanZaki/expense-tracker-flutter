import 'dart:convert';
import 'dart:io';

import 'package:expense_tracker_app/constants/constant.dart';
import 'package:expense_tracker_app/model/expenseModel.dart';
import 'package:expense_tracker_app/preferences/preference.dart';
import 'package:expense_tracker_app/utils/ApiException.dart';
import 'package:expense_tracker_app/model/profileModel.dart';
import 'package:http/http.dart' as http;

// ignore: camel_case_types
class expenseApiService {
  final endPoint = Constant.baseURL + "expense/";
  Preference prefs = Preference();

  Future<dynamic> getExpense() async {
    try {
      String? token = await prefs.getToken();
      http.Response res = await http.get(Uri.parse(endPoint),
          headers: <String, String>{
            'Content-Type': 'application/json',
            'Authorization': 'Token $token'
          });
      var responseBody = _returnResponse(res);

      List<expenseModel> expenseModels = List.from(responseBody)
          .map<expenseModel>((item) => expenseModel.fromMap(item))
          .toList();
      return expenseModels;
    } on SocketException {
      throw FetchDataException("No Internet connection");
    }
  }

  //profile
  Future<dynamic> profile() async {
    try {
      String? token = await prefs.getToken();
      http.Response res = await http.get(
          Uri.parse(Constant.baseURL + 'auth/profile'),
          headers: <String, String>{
            'Content-Type': 'application/json',
            'Authorization': 'Token $token'
          });

      var responseBody = _returnResponse(res);
      return profileModel.fromMap(responseBody[0]);
    } on SocketException {
      throw FetchDataException("No Internet Connection");
    }
  }

  Future<dynamic> createExpense(
      String title, double amount, String incomeOrexpense) async {
    try {
      String? token = await prefs.getToken();
      http.Response res = await http.post(Uri.parse(endPoint),
          headers: <String, String>{
            'Content-Type': 'application/json',
            'Authorization': 'Token $token'
          },
          body: jsonEncode(<String, dynamic>{
            'title': title,
            'amount': amount,
            'incomeOrexpense': incomeOrexpense
          }));

      var responseBody = _returnResponse(res);
      return expenseModel.fromMap(responseBody);
    } on SocketException {
      throw FetchDataException("No Internet Connection");
    }
  }

  Future<dynamic> deleteExpense(int id) async {
    try {
      String? token = await prefs.getToken();

      http.Response res = await http.delete(Uri.parse(endPoint + "$id/"),
          headers: <String, String>{
            'Content-Type': 'application/json',
            'Authorization': 'Token $token'
          });
      var responseBody = _returnResponse(res);
      return responseBody;
    } on SocketException {
      throw FetchDataException("No Internet Connection");
    }
  }
}

dynamic _returnResponse(http.Response response) {
  switch (response.statusCode) {
    case 200:
      var responseJson = json.decode(response.body.toString());
      return responseJson;
    case 201:
      var responseJson = json.decode(response.body.toString());
      return responseJson;
    case 204:
      return "true";
    case 400:
      throw BadRequestException(response.body.toString());
    case 401:
      throw BadRequestException(response.body.toString());
    case 403:
      throw UnauthorisedException(response.body.toString());
    case 500:
    default:
      throw FetchDataException(
          'Error occured while Communication with Server with StatusCode : ${response.statusCode}');
  }
}
