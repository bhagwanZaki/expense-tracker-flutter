import 'dart:convert';
import 'dart:io';

import 'package:expense_tracker_app/constants/constant.dart';
import 'package:expense_tracker_app/model/authModel.dart';
import 'package:expense_tracker_app/model/loginModel.dart';
import 'package:expense_tracker_app/model/profileModel.dart';
import 'package:expense_tracker_app/model/registerModel.dart';
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
      print(responseBody);
      return loginModel.fromMap(responseBody);
    } on SocketException {
      throw FetchDataException("No Internet Connection");
    }
  }

  //register
  Future<dynamic> register(
      String username, String password, String email) async {
    try {
      http.Response res = await http.post(
          Uri.parse(Constant.baseURL + 'auth/register'),
          headers: <String, String>{'Content-Type': 'application/json'},
          body: jsonEncode(<String, String>{
            'username': username,
            'password': password,
            'email': email
          }));

      var responseBody = _returnResponse(res);
      return registerModel.fromMap(responseBody);
    } on SocketException {
      throw FetchDataException("No Internet Connection");
    }
  }

  Future<dynamic> createProfile(double amount) async {
    try {
      String? token = await prefs.getToken();

      http.Response res = await http.post(
          Uri.parse(Constant.baseURL + 'auth/profile/'),
          headers: <String, String>{
            'Content-Type': 'application/json',
            'Authorization': 'Token $token'
          },
          body: jsonEncode(<String, double>{'amount': amount}));

      var responseBody = _returnResponse(res);
      print(responseBody[0]);
      return createProfileModel.fromMap(responseBody);
    } on SocketException {
      throw FetchDataException("No Internet Connection");
    }
  }

  //logout

  Future<dynamic> logout() async {
    try {
      String? token = await prefs.getToken();

      http.Response res = await http.post(
          Uri.parse(Constant.baseURL + 'auth/logout'),
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
