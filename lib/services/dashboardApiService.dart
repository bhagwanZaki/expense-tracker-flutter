import 'dart:convert';
import 'dart:io';

import 'package:expense_tracker_app/constants/constant.dart';
import 'package:expense_tracker_app/model/dashboardModel.dart';
import 'package:expense_tracker_app/preferences/preference.dart';
import 'package:expense_tracker_app/utils/ApiException.dart';
import 'package:http/http.dart' as http;

class DashboardApiService {
  final endPoint = Constant.baseURL + "dashboard/";
  Preference prefs = Preference();
  Future<dynamic> dashboard() async {
    try {
      String? token = await prefs.getToken();
      http.Response res = await http.get(Uri.parse(endPoint),
          headers: <String, String>{
            'Content-Type': 'application/json',
            'Authorization': 'Token $token'
          });

      var responseBody = _returnResponse(res);

      return DashboardModel.fromMap(responseBody);
    } on SocketException {
      throw FetchDataException("No Internet connection");
    }
  }
}

dynamic _returnResponse(http.Response response) {
  switch (response.statusCode) {
    case 200:
      var responseJson = json.decode(response.body.toString());
      print(responseJson);
      return responseJson;
    case 400:
      throw BadRequestException(response.body.toString());
    case 401:
    case 403:
      throw UnauthorisedException(response.body.toString());
    case 500:
    default:
      throw FetchDataException(
          'Error occured while Communication with Server with StatusCode : ${response.statusCode}');
  }
}
