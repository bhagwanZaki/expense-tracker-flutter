import 'package:expense_tracker_app/constants/colors.dart';
import 'package:expense_tracker_app/constants/routes.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class WelcomePage extends StatelessWidget {
  const WelcomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            child: Center(
              child: Column(
                children: [
                  SizedBox(height: 40),
                  Text("Welcome",
                      style: GoogleFonts.poppins(
                          fontSize: 50, color: Colors.black)),
                  Padding(
                    padding: const EdgeInsets.only(
                        top: 20.0, right: 10.0, left: 10.0),
                    child: Image.asset(
                      'assets/images/welcome.jpg',
                      width: 397,
                      height: 316,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 30.0, bottom: 30.0),
                    child: Text("Track your budget easily",
                        style: GoogleFonts.poppins(
                            fontSize: 20, color: Colors.black87)),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 20.0, right: 20.0),
                    child: MaterialButton(
                      minWidth: double.infinity,
                      height: 60,
                      shape: RoundedRectangleBorder(
                          side: BorderSide(color: AppColors.purpleColor),
                          borderRadius: BorderRadius.circular(15)),
                      onPressed: () =>
                          {Navigator.pushNamed(context, Routes.loginRoute)},
                      child: Text(
                        "Login",
                        style: GoogleFonts.poppins(
                            fontSize: 24, color: AppColors.purpleColor),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 20.0, right: 20.0),
                    child: MaterialButton(
                      color: AppColors.purpleColor,
                      minWidth: double.infinity,
                      height: 60,
                      shape: RoundedRectangleBorder(
                          side: BorderSide(color: AppColors.purpleColor),
                          borderRadius: BorderRadius.circular(15)),
                      onPressed: () =>
                          {Navigator.pushNamed(context, Routes.registerRoute)},
                      child: Text(
                        "Register",
                        style: GoogleFonts.poppins(
                            fontSize: 24, color: Colors.white),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
