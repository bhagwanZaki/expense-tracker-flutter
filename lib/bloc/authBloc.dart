import 'dart:async';

import 'package:expense_tracker_app/model/authModel.dart';
import 'package:expense_tracker_app/model/loginModel.dart';
import 'package:expense_tracker_app/repository/authRepository.dart';
import 'package:expense_tracker_app/response/authApiResponse.dart';

class AuthBloc {
  late AuthRepository _authRepository;
  late StreamController<AuthResponse<authModel>> _authController;
  late StreamController<AuthResponse<loginModel>> _loginController;

  StreamSink<AuthResponse<authModel>> get authSink => _authController.sink;
  StreamSink<AuthResponse<loginModel>> get loginSink => _loginController.sink;
 

  Stream<AuthResponse<authModel>> get authStream => _authController.stream;
  Stream<AuthResponse<loginModel>> get loginStream => _loginController.stream;
  

  AuthBloc() {
    _authController = StreamController<AuthResponse<authModel>>();
    _loginController = StreamController<AuthResponse<loginModel>>();
   

    _authRepository = AuthRepository();
    fetchIsAuth();
  }

  fetchIsAuth() async {
    authSink.add(AuthResponse.loading("Fetching Data"));
    try {
      authModel authData = await _authRepository.isAuth();
      authSink.add(AuthResponse.completed(authData));
    } catch (e) {
      print(e);
      authSink.add(AuthResponse.error(e.toString()));
    }
  }

  login(String username, String password) async {
    loginSink.add(AuthResponse.loading("Posting Data"));
    try {
      loginModel loginData = await _authRepository.login(username, password);
      loginSink.add(AuthResponse.completed(loginData));
    } catch (e) {
      print(e);
      loginSink.add(AuthResponse.error(e.toString()));
    }
  }

 

  dispose() {
    _authController.close();
    _loginController.close();
  }
}
