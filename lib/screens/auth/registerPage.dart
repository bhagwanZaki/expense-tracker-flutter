import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:expense_tracker_app/bloc/authBloc.dart';
import 'package:expense_tracker_app/constants/colors.dart';
import 'package:expense_tracker_app/constants/routes.dart';
import 'package:expense_tracker_app/model/registerModel.dart';
import 'package:expense_tracker_app/preferences/preference.dart';
import 'package:expense_tracker_app/response/authApiResponse.dart';
import 'package:expense_tracker_app/services/authApiService.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({Key? key}) : super(key: key);

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  AuthApiService client = AuthApiService();
  Preference pref = Preference();
  AuthBloc? _bloc;

  bool loading = false;

  final _formKey = GlobalKey<FormState>();
  TextEditingController username = TextEditingController();
  TextEditingController password = TextEditingController();
  TextEditingController password2 = TextEditingController();
  TextEditingController email = TextEditingController();

  Widget makeInput({label, obsureText = false, controller}) {
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
        TextFormField(
          controller: controller,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter $label';
            }
            return null;
          },
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

  Widget emailInput({label, controller}) {
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
        TextFormField(
          controller: controller,
          validator: (value) => EmailValidator.validate(value!)
              ? null
              : "Please enter a valid email",
          decoration: InputDecoration(
              hintStyle: GoogleFonts.poppins(fontSize: 16),
              border:
                  OutlineInputBorder(borderRadius: BorderRadius.circular(15)),
              hintText: label),
        )
      ],
    );
  }

  register(String username, String password, String password2, String email) {
    FocusScope.of(context).requestFocus(FocusNode());
    if (password == password2) {
      if (_formKey.currentState!.validate()) {
        _bloc?.register(username, password, email);
      }
    } else {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text("Password not same")));
    }
  }

  @override
  void initState() {
    _bloc = AuthBloc();
    super.initState();
  }

  Widget registerBtn() {
    return Padding(
      padding: const EdgeInsets.only(
          top: 20.0, bottom: 30.0, left: 20.0, right: 20.0),
      child: MaterialButton(
        color: AppColors.purpleColor,
        minWidth: double.infinity,
        height: 55,
        shape: RoundedRectangleBorder(
            side: BorderSide(color: AppColors.purpleColor),
            borderRadius: BorderRadius.circular(15)),
        onPressed: () =>
            register(username.text, password.text, password2.text, email.text),
        child: Text(
          "Register",
          style: GoogleFonts.poppins(fontSize: 20, color: Colors.white),
        ),
      ),
    );
  }

  Widget loadingBtn() {
    return Padding(
      padding: const EdgeInsets.only(
          top: 20.0, bottom: 30.0, left: 20.0, right: 20.0),
      child: MaterialButton(
        color: AppColors.purpleColor,
        minWidth: double.infinity,
        height: 55,
        shape: RoundedRectangleBorder(
            side: BorderSide(color: AppColors.purpleColor),
            borderRadius: BorderRadius.circular(15)),
        onPressed: () => {},
        child: CircularProgressIndicator(
          color: Colors.white,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: Colors.white,
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        elevation: 0,
        // brightness: Brightness.light,
        // backgroundColor: Colors.white,
        leading: IconButton(
          onPressed: () => {Navigator.pop(context)},
          icon: Icon(
            Icons.arrow_back_ios_new,
            color: Theme.of(context).brightness == Brightness.light
                ? Colors.black
                : Colors.white,
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
                    child: Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          makeInput(label: "Username", controller: username),
                          SizedBox(
                            height: 5,
                          ),
                          emailInput(label: "Email", controller: email),
                          SizedBox(
                            height: 5,
                          ),
                          makeInput(
                              label: "Password",
                              obsureText: true,
                              controller: password),
                          SizedBox(
                            height: 5,
                          ),
                          makeInput(
                              label: "Confirm Password",
                              obsureText: true,
                              controller: password2)
                        ],
                      ),
                    ),
                  ),
                  loading ? loadingBtn() : registerBtn(),
                  StreamBuilder<AuthResponse<registerModel>>(
                      stream: _bloc?.registerStream,
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          switch (snapshot.data?.status) {
                            case Status.LOADING:
                              WidgetsBinding.instance
                                  ?.addPostFrameCallback((_) {
                                if (loading == false) {
                                  setState(() {
                                    loading = true;
                                  });
                                }
                              });
                              break;
                            case Status.COMPLETED:
                              WidgetsBinding.instance
                                  ?.addPostFrameCallback((_) {
                                pref.setToken(snapshot.data!.data.token);
                                pref.setUserName(
                                    snapshot.data!.data.user.username);

                                Navigator.pushReplacementNamed(
                                    context, Routes.profileRoute);
                              });
                              break;
                            case Status.ERROR:
                              WidgetsBinding.instance
                                  ?.addPostFrameCallback((_) {
                                if (loading == false) {
                                  if (snapshot.data!.msg ==
                                      'Invalid Request: {"email":["Enter a valid email address."]}') {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                        SnackBar(
                                            content: Text(
                                                "Enter a valid email address.")));
                                  }
                                } else if (snapshot.data!.msg ==
                                    'Invalid Request: {"username":["A user with that username already exists."]}') {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                          content:
                                              Text("Username already taken.")));
                                }
                              });
                              WidgetsBinding.instance
                                  ?.addPostFrameCallback((_) {
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
                        }
                        return SizedBox(
                          height: 1,
                        );
                      })
                ],
              ),
              InkWell(
                onTap: () => {Navigator.pushNamed(context, Routes.loginRoute)},
                child: Padding(
                  padding: const EdgeInsets.only(top: 8.0, bottom: 8.0),
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
