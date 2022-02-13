import 'package:expense_tracker_app/constants/colors.dart';
import 'package:expense_tracker_app/constants/routes.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class SignoutPage extends StatefulWidget {
  const SignoutPage({Key? key}) : super(key: key);

  @override
  _SignoutPageState createState() => _SignoutPageState();
}

class _SignoutPageState extends State<SignoutPage>
    with AutomaticKeepAliveClientMixin<SignoutPage> {
  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text("Are Sure You Want to Sign Out",
                  textAlign: TextAlign.center,
                  style: GoogleFonts.poppins(fontSize: 25)),
              SizedBox(
                height: 20,
              ),
              MaterialButton(
                color: AppColors.redColor,
                height: 55,
                shape: RoundedRectangleBorder(
                    side: BorderSide(color: AppColors.redColor),
                    borderRadius: BorderRadius.circular(15)),
                onPressed: () => {
                  Navigator.pushNamedAndRemoveUntil(
                      context, Routes.welcomeRoute, (route) => false)
                },
                child: Text(
                  "Sign Out",
                  style: GoogleFonts.poppins(fontSize: 20, color: Colors.white),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
