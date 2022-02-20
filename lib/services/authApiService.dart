import 'dart:convert';
import 'dart:io';

import 'package:expense_tracker_app/constants/constant.dart';
import 'package:expense_tracker_app/model/authModel.dart';
import 'package:expense_tracker_app/model/loginModel.dart';
import 'package:expense_tracker_app/preferences/preference.dart';
import 'package:expense_tracker_app/utils/ApiException.dart';
import 'package:http/http.dart' as http;

class AuthApiService {
  Preference prefs = Preference();

  // check whether user is authenticated or not
  Future<dynamic> isauth() async {
    try {
      String? token = await prefs.getToken();
      http.Response res = await http.get(
          Uri.parse(Constant.baseURL + 'auth/user'),
          headers: <String, String>{
            'Content-Type': 'application/json',
            'Authorization': 'Token $token'
          });

      var responseBody = _returnResponse(res);
      return authModel.fromMap(responseBody);
    } on SocketException {
      throw FetchDataException("No Internet Connect");
    }
  }

  //login
  Future<dynamic> login(String username, String password) async {
    try {
      http.Response res =
          await http.post(Uri.parse(Constant.baseURL + 'auth/login'),
              headers: <String, String>{'Content-Type': 'application/json'},
              body: jsonEncode(<String, String>{
                'username': username,
                'password': password,
              }));

      var responseBody = _returnResponse(res);
      return loginModel.fromMap(responseBody);
    } on SocketException {
      throw FetchDataException("No Internet Connection");
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
      throw BadRequestException(response.body.toString());
    case 403:
      throw UnauthorisedException(response.body.toString());
    case 500:
    default:
      throw FetchDataException(
          'Error occured while Communication with Server with StatusCode : ${response.statusCode}');
  }
}
