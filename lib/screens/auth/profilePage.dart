import 'package:expense_tracker_app/bloc/authBloc.dart';
import 'package:expense_tracker_app/constants/colors.dart';
import 'package:expense_tracker_app/constants/routes.dart';
import 'package:expense_tracker_app/model/profileModel.dart';
import 'package:expense_tracker_app/preferences/preference.dart';
import 'package:expense_tracker_app/response/authApiResponse.dart';
import 'package:expense_tracker_app/services/authApiService.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  AuthApiService client = AuthApiService();
  Preference pref = Preference();
  AuthBloc? _bloc;

  bool loading = false;

  final _formKey = GlobalKey<FormState>();
  TextEditingController amount = TextEditingController();

  createProfile(double amount) {
    FocusScope.of(context).requestFocus(FocusNode());
    if (_formKey.currentState!.validate()) {
      _bloc?.createProfile(amount);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Enter amount detail correctly")));
    }
  }

  @override
  void initState() {
    _bloc = AuthBloc();
    super.initState();
  }

  Widget profileBtn() {
    return Padding(
      padding: const EdgeInsets.only(top: 20.0),
      child: MaterialButton(
        minWidth: double.infinity,
        height: 60,
        shape: RoundedRectangleBorder(
            side: BorderSide(color: AppColors.purpleColor, width: 2),
            borderRadius: BorderRadius.circular(15)),
        onPressed: () => createProfile(double.parse(amount.text)),
        child: Text(
          "Continue",
          style:
              GoogleFonts.poppins(fontSize: 24, color: AppColors.purpleColor),
        ),
      ),
    );
  }

  Widget loadingBtn() {
    return Padding(
      padding: const EdgeInsets.only(top: 20.0),
      child: MaterialButton(
        minWidth: double.infinity,
        height: 60,
        shape: RoundedRectangleBorder(
            side: BorderSide(color: AppColors.purpleColor, width: 2),
            borderRadius: BorderRadius.circular(15)),
        onPressed: () => {},
        child: CircularProgressIndicator(
          color: AppColors.purpleColor,
        ),
      ),
    );
  }

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
              Form(
                key: _formKey,
                child: TextFormField(
                  controller: amount,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Enter Amount";
                    }
                    return null;
                  },
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                      hintStyle: GoogleFonts.roboto(fontSize: 16),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15)),
                      hintText: "Enter the amount"),
                ),
              ),
              loading ? loadingBtn() : profileBtn(),
              StreamBuilder<AuthResponse<createProfileModel>>(
                  stream: _bloc?.profileStream,
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
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
                            Navigator.pushNamedAndRemoveUntil(
                                context, Routes.baseRoute, (route) => false);
                          });
                          break;

                        case Status.ERROR:
                          WidgetsBinding.instance?.addPostFrameCallback((_) {
                            if (loading) {
                              setState(() {
                                loading = false;
                              });
                            }
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
                          break;
                        default:
                          break;
                      }
                    }
                    return SizedBox(
                      height: 0,
                    );
                  })
            ],
          ),
        ),
      ),
    );
  }
}
