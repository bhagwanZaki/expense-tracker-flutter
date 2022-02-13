import 'package:expense_tracker_app/constants/colors.dart';
import 'package:expense_tracker_app/constants/routes.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class RegisterPage extends StatelessWidget {
  const RegisterPage({Key? key}) : super(key: key);

  Widget makeInput({label, obsureText = false}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: GoogleFonts.poppins(fontSize: 20),
        ),
        SizedBox(
          height: 10,
        ),
        TextField(
          obscureText: obsureText,
          decoration: InputDecoration(
              hintStyle: GoogleFonts.poppins(fontSize: 16),
              border:
                  OutlineInputBorder(borderRadius: BorderRadius.circular(15)),
              hintText: label),
        )
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        elevation: 0,
        brightness: Brightness.light,
        backgroundColor: Colors.white,
        leading: IconButton(
          onPressed: () => {Navigator.pop(context)},
          icon: Icon(
            Icons.arrow_back_ios_new,
            color: Colors.black,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Container(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Register Page",
                    style: GoogleFonts.poppins(fontSize: 50),
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(right: 20.0, left: 20.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        makeInput(label: "Username"),
                        SizedBox(
                          height: 5,
                        ),
                        makeInput(label: "Email"),
                        SizedBox(
                          height: 5,
                        ),
                        makeInput(label: "Password", obsureText: true),
                        SizedBox(
                          height: 5,
                        ),
                        makeInput(label: "Confirm Password", obsureText: true)
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                        top: 20.0, bottom: 30.0, left: 20.0, right: 20.0),
                    child: MaterialButton(
                      color: AppColors.purpleColor,
                      minWidth: double.infinity,
                      height: 55,
                      shape: RoundedRectangleBorder(
                          side: BorderSide(color: AppColors.purpleColor),
                          borderRadius: BorderRadius.circular(15)),
                      onPressed: () => {
                        Navigator.pushReplacementNamed(context, Routes.profileRoute)
                      },
                      child: Text(
                        "Register",
                        style: GoogleFonts.poppins(
                            fontSize: 20, color: Colors.white),
                      ),
                    ),
                  )
                ],
              ),
              InkWell(
                onTap: () => {Navigator.pushNamed(context, Routes.loginRoute)},
                child: Padding(
                  padding: const EdgeInsets.only(top: 10.0, bottom: 10.0),
                  child: Text("Already Have An Account",
                      style: GoogleFonts.poppins(
                        fontSize: 15.0,
                      )),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
