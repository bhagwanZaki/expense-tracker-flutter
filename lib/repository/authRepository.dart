import 'package:expense_tracker_app/model/authModel.dart';
import 'package:expense_tracker_app/model/loginModel.dart';
import 'package:expense_tracker_app/model/profileModel.dart';
import 'package:expense_tracker_app/services/authApiService.dart';

class AuthRepository {
  AuthApiService _service = AuthApiService();

  Future<authModel> isAuth() async {
    final response = await _service.isauth();
    return response;
  }

  Future<loginModel> login(String username, String password) async {
    final response = await _service.login(username, password);
    return response;
  }

  
}
