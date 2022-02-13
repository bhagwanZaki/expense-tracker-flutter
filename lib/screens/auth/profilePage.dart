import 'package:expense_tracker_app/constants/colors.dart';
import 'package:expense_tracker_app/constants/routes.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Padding(
          padding: const EdgeInsets.only(left: 10.0, right: 10.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Center(
                child: Image.asset(
                  'assets/images/profile.png',
                  width: 226,
                  height: 170,
                ),
              ),
              Center(
                child: Text(
                  "Enter the initial amount for yor wallet",
                  textAlign: TextAlign.center,
                  style: GoogleFonts.poppins(fontSize: 30),
                ),
              ),
              SizedBox(
                height: 10,
              ),
              TextField(
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                    hintStyle: GoogleFonts.roboto(fontSize: 16),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15)),
                    hintText: "Enter the amount"),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 20.0),
                child: MaterialButton(
                  minWidth: double.infinity,
                  height: 60,
                  shape: RoundedRectangleBorder(
                      side: BorderSide(color: AppColors.purpleColor, width: 2),
                      borderRadius: BorderRadius.circular(15)),
                  onPressed: () => {
                    Navigator.pushNamedAndRemoveUntil(
                        context, Routes.baseRoute, (route) => false)
                  },
                  child: Text(
                    "Continue",
                    style: GoogleFonts.poppins(
                        fontSize: 24, color: AppColors.purpleColor),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
