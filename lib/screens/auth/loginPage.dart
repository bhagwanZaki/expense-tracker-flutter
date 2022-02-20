import 'package:expense_tracker_app/bloc/authBloc.dart';
import 'package:expense_tracker_app/constants/colors.dart';
import 'package:expense_tracker_app/constants/routes.dart';
import 'package:expense_tracker_app/model/loginModel.dart';
import 'package:expense_tracker_app/preferences/preference.dart';
import 'package:expense_tracker_app/response/authApiResponse.dart';
import 'package:expense_tracker_app/services/authApiService.dart';
import 'package:expense_tracker_app/widgets/loadingDialog.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  AuthApiService client = AuthApiService();
  Preference pref = Preference();
  AuthBloc? _bloc;

  bool loading = false;

  final _formKey = GlobalKey<FormState>();
  TextEditingController username = TextEditingController();
  TextEditingController password = TextEditingController();

  login(BuildContext context, String username, String password) {
    FocusScope.of(context).requestFocus(FocusNode());
    if (_formKey.currentState!.validate()) {
      print("login");
      _bloc?.login(username, password);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Username or password is not valid")));
    }
  }

  Widget loginBtn() {
    return Padding(
      padding: const EdgeInsets.only(top: 40.0, left: 20.0, right: 20.0),
      child: MaterialButton(
        color: AppColors.purpleColor,
        minWidth: double.infinity,
        height: 55,
        shape: RoundedRectangleBorder(
            side: BorderSide(color: AppColors.purpleColor),
            borderRadius: BorderRadius.circular(15)),
        // onPressed: () => {
        //   Navigator.pushNamedAndRemoveUntil(
        //       context, Routes.baseRoute, (route) => false)
        // },
        onPressed: () => login(context, username.text, password.text),
        child: Text(
          "Login",
          style: GoogleFonts.poppins(fontSize: 20, color: Colors.white),
        ),
      ),
    );
  }

  Widget loadingBtn() {
    return Padding(
      padding: const EdgeInsets.only(top: 40.0, left: 20.0, right: 20.0),
      child: MaterialButton(
        color: AppColors.purpleColor,
        minWidth: double.infinity,
        height: 55,
        shape: RoundedRectangleBorder(
            side: BorderSide(color: AppColors.purpleColor),
            borderRadius: BorderRadius.circular(15)),
        // onPressed: () => {
        //   Navigator.pushNamedAndRemoveUntil(
        //       context, Routes.baseRoute, (route) => false)
        // },
        onPressed: () => {},
        child: Text(
          "Loading",
          style: GoogleFonts.poppins(fontSize: 20, color: Colors.white),
        ),
      ),
    );
  }

  @override
  void initState() {
    _bloc = AuthBloc();
    // isAuth();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
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
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Center(
                    child: Padding(
                      padding: const EdgeInsets.only(top: 20.0),
                      child: Text(
                        "Login Page",
                        style: GoogleFonts.poppins(fontSize: 50),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Username",
                            style: GoogleFonts.poppins(fontSize: 20),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          TextFormField(
                            controller: username,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter username';
                              }
                              return null;
                            },
                            decoration: InputDecoration(
                                hintStyle: GoogleFonts.poppins(fontSize: 16),
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(15)),
                                hintText: 'Username'),
                          ),
                          SizedBox(
                            height: 5,
                          ),
                          Text(
                            "Password",
                            style: GoogleFonts.poppins(fontSize: 20),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          TextFormField(
                            controller: password,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter password';
                              }
                              return null;
                            },
                            obscureText: true,
                            decoration: InputDecoration(
                                hintStyle: GoogleFonts.poppins(fontSize: 16),
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(15)),
                                hintText: 'Password'),
                          ),
                        ],
                      ),
                    ),
                  ),
                  loading ? loadingBtn() : loginBtn(),
                  InkWell(
                    onTap: () => {},
                    child: Padding(
                      padding: const EdgeInsets.only(top: 15.0, bottom: 10.0),
                      child: Center(
                          child: Text(
                        "Forget Password",
                        style: GoogleFonts.poppins(fontSize: 15.0),
                      )),
                    ),
                  ),
                ],
              ),
              StreamBuilder<AuthResponse<loginModel>>(
                stream: _bloc?.loginStream,
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    print(snapshot.data?.status);
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
                          pref.setToken(snapshot.data!.data.token);
                          pref.setUserName(snapshot.data!.data.user.username);

                          Navigator.pushNamedAndRemoveUntil(
                              context, Routes.baseRoute, (route) => false);
                        });
                        break;

                      case Status.ERROR:
                        WidgetsBinding.instance?.addPostFrameCallback((_) {
                          if (loading == false) {
                            if (snapshot.data!.msg ==
                                'Invalid Request: {"non_field_errors":["Incorrect Credentials"]}') {
                              ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                      content: Text(
                                          "Username or password is not valid")));
                            }
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
                    }
                  }
                  return SizedBox(
                    height: 1,
                  );
                },
              ),
              Align(
                alignment: Alignment.bottomCenter,
                child: InkWell(
                  onTap: () =>
                      {Navigator.pushNamed(context, Routes.registerRoute)},
                  child: Padding(
                    padding: const EdgeInsets.only(top: 50.0),
                    child: Text("Don't Have An Account",
                        style: GoogleFonts.poppins(
                          fontSize: 15.0,
                        )),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
