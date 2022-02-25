import 'package:expense_tracker_app/bloc/authBloc.dart';
import 'package:expense_tracker_app/constants/routes.dart';
import 'package:expense_tracker_app/model/authModel.dart';
import 'package:expense_tracker_app/response/authApiResponse.dart';
import 'package:expense_tracker_app/services/authApiService.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:async';

import 'package:shared_preferences/shared_preferences.dart';

class MainPage extends StatefulWidget {
  const MainPage({Key? key}) : super(key: key);

  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  AuthApiService client = AuthApiService();

  AuthBloc? _bloc;

  @override
  void initState() {
    _bloc = AuthBloc();
    // isAuth();
    super.initState();
  }

  // AuthApiService? _auth;

  isAuth(authModel authData) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    //     () => Navigator.pushReplacementNamed(context, Routes.welcomeRoute));
  }

  Widget build(BuildContext context) {
    return Scaffold(
        body: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        StreamBuilder<AuthResponse<authModel>>(
            stream: _bloc?.authStream,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                switch (snapshot.data?.status) {
                  case Status.LOADING:
                    return Expanded(
                        child: Center(
                      child: Text("Expense Tracker",
                          textAlign: TextAlign.center,
                          style: GoogleFonts.poppins(
                              fontSize: 80, fontWeight: FontWeight.w200)),
                    ));
                  case Status.COMPLETED:
                    WidgetsBinding.instance?.addPostFrameCallback(
                      (_) => Navigator.pushReplacementNamed(
                          context, Routes.baseRoute),
                    );

                    break;
                  case Status.ERROR:
                    if (snapshot.data!.msg ==
                            'Unauthorised: {"detail":"Invalid token."}' ||
                        snapshot.data!.msg ==
                            'Invalid Request: {"detail":"Invalid token."}' || snapshot.data!.msg == 'Invalid Request: {"detail":"Invalid token header. No credentials provided."}') {
                      WidgetsBinding.instance?.addPostFrameCallback(
                        (_) => Navigator.pushReplacementNamed(
                            context, Routes.welcomeRoute),
                      );
                      break;
                    } else {
                      return Expanded(
                          child: Center(
                        child: Icon(
                          CupertinoIcons.wifi_slash,
                          size: 100.0,
                        ),
                      ));
                    }
                  default:
                    return Expanded(
                        child: Center(
                      child: Icon(
                        CupertinoIcons.wifi_slash,
                        size: 100.0,
                      ),
                    ));
                }
              }
              return Expanded(
                  child: Center(
                child: Text("Expense Tracker",
                    textAlign: TextAlign.center,
                    style: GoogleFonts.poppins(
                        fontSize: 80, fontWeight: FontWeight.w200)),
              ));
            }),
        // Expanded(
        //   child: Center(
        //     child: Text("Expense Tracker",
        //         textAlign: TextAlign.center,
        //         style: GoogleFonts.poppins(
        //             fontSize: 80, fontWeight: FontWeight.w200)),
        //   ),
        // ),
        Align(
          alignment: Alignment.bottomCenter,
          child: Padding(
            padding: const EdgeInsets.only(bottom: 30.0),
            child: Column(
              children: [
                Text(
                  "From",
                  style: GoogleFonts.reemKufi(
                      fontSize: 22, fontWeight: FontWeight.w100),
                ),
                Text(
                  "Floran",
                  style: GoogleFonts.reemKufi(
                      fontSize: 22, fontWeight: FontWeight.w100),
                )
              ],
            ),
          ),
        )
      ],
    ));
  }
}
