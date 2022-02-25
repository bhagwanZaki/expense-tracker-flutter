import 'dart:async';

import 'package:expense_tracker_app/model/authModel.dart';
import 'package:expense_tracker_app/model/loginModel.dart';
import 'package:expense_tracker_app/model/profileModel.dart';
import 'package:expense_tracker_app/model/registerModel.dart';
import 'package:expense_tracker_app/repository/authRepository.dart';
import 'package:expense_tracker_app/response/authApiResponse.dart';

class AuthBloc {
  late AuthRepository _authRepository;
  late StreamController<AuthResponse<authModel>> _authController;
  late StreamController<AuthResponse<loginModel>> _loginController;
  late StreamController<LogoutResponse<dynamic>> _logoutController;
  late StreamController<AuthResponse<registerModel>> _registerController;
  late StreamController<AuthResponse<createProfileModel>> _profileController;

  StreamSink<AuthResponse<authModel>> get authSink => _authController.sink;
  StreamSink<AuthResponse<loginModel>> get loginSink => _loginController.sink;
  StreamSink<LogoutResponse<dynamic>> get logoutSink => _logoutController.sink;
  StreamSink<AuthResponse<registerModel>> get registerSink =>
      _registerController.sink;

  StreamSink<AuthResponse<createProfileModel>> get profileSink =>
      _profileController.sink;

  Stream<AuthResponse<authModel>> get authStream => _authController.stream;
  Stream<AuthResponse<loginModel>> get loginStream => _loginController.stream;
  Stream<LogoutResponse<dynamic>> get logoutStream => _logoutController.stream;
  Stream<AuthResponse<registerModel>> get registerStream =>
      _registerController.stream;
  Stream<AuthResponse<createProfileModel>> get profileStream =>
      _profileController.stream;

  AuthBloc() {
    _authController = StreamController<AuthResponse<authModel>>();
    _loginController = StreamController<AuthResponse<loginModel>>();
    _logoutController = StreamController<LogoutResponse<dynamic>>();
    _registerController = StreamController<AuthResponse<registerModel>>();
    _profileController = StreamController<AuthResponse<createProfileModel>>();

    _authRepository = AuthRepository();
    fetchIsAuth();
  }

  fetchIsAuth() async {
    authSink.add(AuthResponse.loading("Fetching Data"));
    try {
      authModel authData = await _authRepository.isAuth();
      authSink.add(AuthResponse.completed(authData));
    } catch (e) {
      authSink.add(AuthResponse.error(e.toString()));
    }
  }

  login(String username, String password) async {
    loginSink.add(AuthResponse.loading("Posting Data"));
    try {
      loginModel loginData = await _authRepository.login(username, password);
      loginSink.add(AuthResponse.completed(loginData));
    } catch (e) {
      loginSink.add(AuthResponse.error(e.toString()));
    }
  }

  register(String username, String password, String email) async {
    registerSink.add(AuthResponse.loading("registering.."));
    try {
      registerModel registerData =
          await _authRepository.register(username, password, email);
      registerSink.add(AuthResponse.completed(registerData));
    } catch (e) {
      registerSink.add(AuthResponse.error(e.toString()));
    }
  }

  logout() async {
    logoutSink.add(LogoutResponse.loading("logging out"));
    try {
      dynamic logoutData = await _authRepository.logout();
      logoutSink.add(LogoutResponse.completed(logoutData));
    } catch (e) {
      logoutSink.add(LogoutResponse.error(e.toString()));
    }
  }

  createProfile(double amount) async {
    profileSink.add(AuthResponse.loading("creating profile"));
    try {
      createProfileModel profileData = await _authRepository.createProfile(amount);
      profileSink.add(AuthResponse.completed(profileData));
    } catch (e) {
      profileSink.add(AuthResponse.error(e.toString()));
    }
  }

  dispose() {
    _authController.close();
    _loginController.close();
    _registerController.close();
    _logoutController.close();
    _profileController.close();
  }
}
