import 'package:expense_tracker_app/bloc/expenseBloc.dart';
import 'package:expense_tracker_app/constants/colors.dart';
import 'package:expense_tracker_app/constants/routes.dart';
import 'package:expense_tracker_app/model/expenseModel.dart';
import 'package:expense_tracker_app/model/profileModel.dart';
import 'package:expense_tracker_app/preferences/preference.dart';
import 'package:expense_tracker_app/response/expenseApiResponse.dart';
import 'package:expense_tracker_app/services/expenseApiService.dart';
import 'package:expense_tracker_app/widgets/appBar.dart';
import 'package:expense_tracker_app/widgets/createExpense.dart';
import 'package:expense_tracker_app/widgets/expenseRecordItem.dart';
import 'package:expense_tracker_app/widgets/incomeRecordItem.dart';
import 'package:expense_tracker_app/widgets/savingRecordItem.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class WalletPage extends StatefulWidget {
  const WalletPage({Key? key}) : super(key: key);

  @override
  _WalletPageState createState() => _WalletPageState();
}

class _WalletPageState extends State<WalletPage>
    with AutomaticKeepAliveClientMixin<WalletPage> {
  expenseApiService client = expenseApiService();

  ExpenseBloc? _bloc;
  Preference prefs = Preference();
  String? username = "";
  List<expenseModel>? expenses = [];
  @override
  void initState() {
    super.initState();
    _bloc = ExpenseBloc();
    getUsername();
  }

  getUsername() async {
    username = await prefs.getUsername();
  }

  removeCardFromList(index) {
    print(index);
    print(expenses!.length);
    _bloc?.fetchExpenseList();
    _bloc?.profile();
    print('00');
    print(expenses!.length);
  }

  Widget containerType(expenseModel data, int index) {
    if (data.incomeOrexpense == "expense") {
      return ExpenseRecordItem(
        data: data,
        index: index,
        removeCardFromList: removeCardFromList,
      );
    } else if (data.incomeOrexpense == "income") {
      return IncomeRecordItem(
        data: data,
        index: index,
        removeCardFromList: removeCardFromList,
      );
    } else {
      return SavingRecordItem(
        data: data,
        index: index,
        removeCardFromList: removeCardFromList,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      extendBody: true,
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: () => _bloc?.fetchExpenseList(),
          child: SingleChildScrollView(
            child: Container(
              padding: const EdgeInsets.all(10.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CustomAppBar(),
                  StreamBuilder<ExpenseApiResponse<profileModel>>(
                      stream: _bloc?.profileStream,
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          switch (snapshot.data?.status) {
                            case Status.LOADING:
                              return Container(
                                width: double.infinity,
                                child: Card(
                                  clipBehavior: Clip.antiAlias,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(15.0),
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.all(16.0),
                                    child: Center(
                                        child: CircularProgressIndicator()),
                                  ),
                                ),
                              );

                            case Status.COMPLETED:
                              return Container(
                                width: double.infinity,
                                child: Card(
                                  clipBehavior: Clip.antiAlias,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(15.0),
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.all(16.0),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text('Hey ' + username!,
                                            style: GoogleFonts.poppins(
                                                fontSize: 22,
                                                fontWeight: FontWeight.w500)),
                                        Text(
                                            'Wallet Cash 💵: ' +
                                                snapshot.data!.data.amount
                                                    .toString(),
                                            style: GoogleFonts.poppins(
                                                fontSize: 28,
                                                fontWeight: FontWeight.w500)),
                                      ],
                                    ),
                                  ),
                                ),
                              );
                            default:
                          }
                        }
                        return Text("opo");
                      }),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("Expense Record",
                          style: GoogleFonts.poppins(
                              fontSize: 22, fontWeight: FontWeight.w500)),
                      Padding(
                        padding: const EdgeInsets.only(
                            top: 10.0, bottom: 10.0, left: 20.0, right: 20.0),
                        child: MaterialButton(
                          color: AppColors.purpleColor,
                          height: 55,
                          shape: RoundedRectangleBorder(
                              side: BorderSide(color: AppColors.purpleColor),
                              borderRadius: BorderRadius.circular(15)),
                          onPressed: () => {
                            showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return CreateExpense();
                                }).then((value) {
                              _bloc?.profile();
                              _bloc?.fetchExpenseList();
                            })
                          },
                          child: Text(
                            "Add New",
                            style: GoogleFonts.poppins(
                                fontSize: 18, color: Colors.white),
                          ),
                        ),
                      )
                    ],
                  ),
                  StreamBuilder<ExpenseApiResponse<List<expenseModel>>>(
                    stream: _bloc?.expenseListStream,
                    builder: (context, snapshot) {
                      print(snapshot.hasData);
                      if (snapshot.hasData) {
                        switch (snapshot.data?.status) {
                          case Status.LOADING:
                            return Center(child: CircularProgressIndicator());
                          case Status.COMPLETED:
                            expenses = snapshot.data?.data.reversed.toList();
                            if (expenses!.length != 0) {
                              return Column(children: [
                                ListView.builder(
                                    physics: NeverScrollableScrollPhysics(),
                                    // scrollDirection: Axis.vertical,
                                    shrinkWrap: true,
                                    itemCount: expenses?.length,
                                    itemBuilder: (context, index) =>
                                        containerType(expenses![index], index)),
                              ]);
                            } else {
                              return Padding(
                                padding: const EdgeInsets.only(top: 20.0),
                                child: Center(
                                    child: Text("No Records Added",
                                        style: GoogleFonts.poppins(
                                            fontSize: 22,
                                            fontWeight: FontWeight.w300))),
                              );
                            }
                          case Status.ERROR:
                            if (snapshot.data!.msg ==
                                    'Unauthorised: {"detail":"Invalid token."}' ||
                                snapshot.data!.msg ==
                                    'Invalid Request: {"detail":"Invalid token."}') {
                              WidgetsBinding.instance?.addPostFrameCallback(
                                (_) => Navigator.pushReplacementNamed(
                                    context, Routes.welcomeRoute),
                              );
                              break;
                            } else {
                              return retryBtn();
                            }
                          default:
                            return retryBtn();
                        }
                      }
                      return retryBtn();
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget retryBtn() {
    return Column(
      children: [
        Center(
          child: Icon(
            CupertinoIcons.wifi_slash,
            size: 100.0,
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(
              top: 10.0, bottom: 10.0, left: 20.0, right: 20.0),
          child: MaterialButton(
            color: AppColors.redColor,
            height: 55,
            shape: RoundedRectangleBorder(
                side: BorderSide(color: AppColors.redColor),
                borderRadius: BorderRadius.circular(15)),
            onPressed: () => _bloc?.fetchExpenseList(),
            child: Text(
              "Retry",
              style: GoogleFonts.poppins(fontSize: 18, color: Colors.white),
            ),
          ),
        )
      ],
    );
  }

  @override
  bool get wantKeepAlive => true;
}
