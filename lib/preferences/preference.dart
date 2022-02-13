import 'package:shared_preferences/shared_preferences.dart';

class Preference {
  Future<void> setToken(String token) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    pref.setString("token", token);
  }

  Future<void> setUserName(String username) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    pref.setString("username", username);
  }

  Future<String?> getToken() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    return pref.getString('token');
  }

  Future<String?> getUsername() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    return pref.getString('username');
  }
}
