import 'package:expense_tracker_app/bloc/dashboardBloc.dart';
import 'package:expense_tracker_app/bloc/expenseBloc.dart';
import 'package:expense_tracker_app/constants/routes.dart';
import 'package:expense_tracker_app/model/dashboardModel.dart';
import 'package:expense_tracker_app/model/profileModel.dart';
import 'package:expense_tracker_app/response/dashboardApiResponse.dart';
import 'package:expense_tracker_app/response/expenseApiResponse.dart';
import 'package:expense_tracker_app/widgets/appBar.dart';
import 'package:expense_tracker_app/widgets/dashboardCard.dart';
import 'package:expense_tracker_app/widgets/linechart.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({Key? key}) : super(key: key);

  @override
  _DashboardPageState createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage>
    with AutomaticKeepAliveClientMixin<DashboardPage> {
  DashboardBloc? _bloc;
  ExpenseBloc? _expenseBloc;

  @override
  void initState() {
    super.initState();
    _bloc = DashboardBloc();
    _expenseBloc = ExpenseBloc();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: () async {
            _expenseBloc?.profile();
            _bloc?.dashboard();
          },
          // onRefresh: (List<dynamic>)=> [_bloc?.dashboard(),
          //   _expenseBloc?.profile()
          // ],
          child: SingleChildScrollView(
            child: Container(
              padding: EdgeInsets.all(10.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CustomAppBar(),
                  StreamBuilder<ExpenseApiResponse<profileModel>>(
                      stream: _expenseBloc?.profileStream,
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          switch (snapshot.data?.status) {
                            case Status.LOADING:
                              return Center(
                                child: CircularProgressIndicator(),
                              );
                            case Status.COMPLETED:
                              return DashboardCard(
                                label: "Total Amount",
                                backgroudColor: Colors.white,
                                amount: snapshot.data!.data.amount.toString(),
                                textColor: Colors.black,
                              );
                            case Status.ERROR:
                              if (snapshot.data!.msg ==
                                      'Unauthorised: {"detail":"Invalid token."}' ||
                                  snapshot.data!.msg ==
                                      'Invalid Request: {"detail":"Invalid token."}') {
                                WidgetsBinding.instance?.addPostFrameCallback(
                                  (_) => Navigator.pushReplacementNamed(
                                      context, Routes.welcomeRoute),
                                );
                              }
                              break;
                            default:
                              return Text("laoding");
                          }
                        }
                        return Text("laoding");
                      }),
                  StreamBuilder<DashboardApiResponse<DashboardModel>>(
                    stream: _bloc?.dashboardStream,
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        switch (snapshot.data?.status) {
                          case DashboardStatus.LOADING:
                            return Center(
                              child: CircularProgressIndicator(),
                            );
                          case DashboardStatus.COMPLETED:
                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                DashboardCard(
                                  label: "Current Month Expense",
                                  backgroudColor: Colors.redAccent,
                                  amount:
                                      snapshot.data!.data.expenseAmt.toString(),
                                  textColor: Colors.white,
                                ),
                                DashboardCard(
                                  label: "Current Month Income",
                                  backgroudColor: Colors.green,
                                  amount:
                                      snapshot.data!.data.incomeAmt.toString(),
                                  textColor: Colors.white,
                                ),
                                DashboardCard(
                                  label: "Current Month Saving",
                                  backgroudColor: Colors.blueAccent,
                                  amount:
                                      snapshot.data!.data.savingAmt.toString(),
                                  textColor: Colors.white,
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(
                                      top: 8.0, bottom: 8.0),
                                  child: Text(
                                    "Transaction Analytics",
                                    style: GoogleFonts.poppins(fontSize: 30),
                                  ),
                                ),
                                Card(
                                  clipBehavior: Clip.antiAlias,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(15.0),
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.only(
                                        top: 20.0, bottom: 20.0),
                                    child: Container(
                                        padding: const EdgeInsets.all(8.0),
                                        height: 400,
                                        child: LineChartWidget(
                                          dayList: snapshot.data!.data.dayList,
                                          income_graph_data: snapshot
                                              .data!.data.income_graph_data,
                                          saving_graph_data: snapshot
                                              .data!.data.saving_graph_data,
                                          expense_graph_data: snapshot
                                              .data!.data.expense_graph_data,
                                        )),
                                  ),
                                ),
                                SizedBox(
                                  height: 10,
                                )
                              ],
                            );
                          case DashboardStatus.ERROR:
                            if (snapshot.data!.msg ==
                                    'Unauthorised: {"detail":"Invalid token."}' ||
                                snapshot.data!.msg ==
                                    'Invalid Request: {"detail":"Invalid token."}') {
                              WidgetsBinding.instance?.addPostFrameCallback(
                                (_) => Navigator.pushReplacementNamed(
                                    context, Routes.welcomeRoute),
                              );
                            }
                            break;
                          default:
                            return Center(
                              child: Icon(
                                CupertinoIcons.wifi_slash,
                                size: 100.0,
                              ),
                            );
                        }
                      }
                      return Text("loading");
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

  @override
  bool get wantKeepAlive => true;
}
