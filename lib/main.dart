import 'package:expense_tracker_app/constants/routes.dart';
import 'package:expense_tracker_app/screens/auth/loginPage.dart';
import 'package:expense_tracker_app/screens/auth/mainPage.dart';
import 'package:expense_tracker_app/screens/auth/profilePage.dart';
import 'package:expense_tracker_app/screens/auth/registerPage.dart';
import 'package:expense_tracker_app/screens/auth/welcomePage.dart';
import 'package:expense_tracker_app/screens/home/basePage.dart';
import 'package:expense_tracker_app/themes/themeData.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      themeMode: ThemeMode.system,
      theme: Themes.lightTheme(context),
      darkTheme: Themes.darkTheme(context),
      routes: {
        Routes.loginRoute: (context) => LoginPage(),
        Routes.welcomeRoute: (context) => WelcomePage(),
        Routes.registerRoute: (context) => RegisterPage(),
        Routes.profileRoute: (context) => ProfilePage(),
        Routes.baseRoute: (context) => BasePage(),
      },
      home: MainPage(),
    );
  }
}
