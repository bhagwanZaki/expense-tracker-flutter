import 'package:expense_tracker_app/bloc/authBloc.dart';
import 'package:expense_tracker_app/constants/colors.dart';
import 'package:expense_tracker_app/constants/routes.dart';
import 'package:expense_tracker_app/preferences/preference.dart';
import 'package:expense_tracker_app/response/authApiResponse.dart';
import 'package:expense_tracker_app/services/authApiService.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class SignoutPage extends StatefulWidget {
  const SignoutPage({Key? key}) : super(key: key);

  @override
  _SignoutPageState createState() => _SignoutPageState();
}

class _SignoutPageState extends State<SignoutPage>
    with AutomaticKeepAliveClientMixin<SignoutPage> {
  AuthApiService client = AuthApiService();
  Preference pref = Preference();
  AuthBloc? _bloc;
  bool loading = false;

  @override
  void initState() {
    _bloc = AuthBloc();
    // isAuth();
    super.initState();
  }

  logout() {
    _bloc?.logout();
  }

  Widget logoutBtn() {
    return MaterialButton(
      color: AppColors.redColor,
      height: 55,
      shape: RoundedRectangleBorder(
          side: BorderSide(color: AppColors.redColor),
          borderRadius: BorderRadius.circular(15)),
      onPressed: () => logout(),
      child: Text(
        "Sign Out",
        style: GoogleFonts.poppins(fontSize: 20, color: Colors.white),
      ),
    );
  }

  Widget loadingBtn() {
    return MaterialButton(
      color: AppColors.redColor,
      height: 55,
      shape: RoundedRectangleBorder(
          side: BorderSide(color: AppColors.redColor),
          borderRadius: BorderRadius.circular(15)),
      onPressed: () => {},
      child: CircularProgressIndicator(
        color: Colors.white,
      ),
    );
  }

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
              loading ? loadingBtn() : logoutBtn(),
              StreamBuilder<LogoutResponse<dynamic>>(
                  stream: _bloc?.logoutStream,
                  builder: (context, snapshot) {
                    switch (snapshot.data?.status) {
                      case Status.LOADING:
                        WidgetsBinding.instance?.addPostFrameCallback((_) {
                          if (loading == false) {
                            setState(() {
                              loading = true;
                            });
                          }
                        });
                        break;
                      case Status.COMPLETED:
                        WidgetsBinding.instance?.addPostFrameCallback((_) {
                          pref.setToken("");
                          pref.setUserName("");

                          Navigator.pushNamedAndRemoveUntil(
                              context, Routes.welcomeRoute, (route) => false);
                        });
                        break;
                      case Status.ERROR:
                        WidgetsBinding.instance?.addPostFrameCallback((_) {
                          if (loading == false) {
                            ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text("Sign out failed")));
                          }
                        });
                        WidgetsBinding.instance?.addPostFrameCallback((_) {
                          if (loading) {
                            setState(() {
                              loading = false;
                            });
                          }
                        });
                        break;
                      default:
                        break;
                    }
                    return SizedBox(
                      height: 1,
                    );
                  })
            ],
          ),
        ),
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
