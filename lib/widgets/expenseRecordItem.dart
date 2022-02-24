import 'package:expense_tracker_app/bloc/expenseBloc.dart';
import 'package:expense_tracker_app/constants/colors.dart';
import 'package:expense_tracker_app/response/expenseApiResponse.dart';
import 'package:expense_tracker_app/services/expenseApiService.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:expense_tracker_app/model/expenseModel.dart';

class ExpenseRecordItem extends StatefulWidget {
  final expenseModel data;
  final int index;
  final Function removeCardFromList;
  const ExpenseRecordItem({
    Key? key,
    required this.data,
    required this.index,
    required this.removeCardFromList,
  }) : super(key: key);

  @override
  State<ExpenseRecordItem> createState() => _ExpenseRecordItemState();
}

class _ExpenseRecordItemState extends State<ExpenseRecordItem> {
  expenseApiService client = expenseApiService();
  ExpenseBloc? _bloc;
  bool loading = false;

  @override
  void initState() {
    _bloc = ExpenseBloc();
    super.initState();
  }

  Widget bottomRowItem({label, labelData}) {
    return Padding(
      padding: const EdgeInsets.only(top: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: GoogleFonts.poppins(
                color: Colors.white, fontSize: 20, fontWeight: FontWeight.w500),
          ),
          Text(
            labelData,
            style: GoogleFonts.poppins(
                color: Colors.white, fontSize: 20, fontWeight: FontWeight.w400),
          )
        ],
      ),
    );
  }

  Widget loadingBtn() {
    return MaterialButton(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(100)),
      onPressed: () => {},
      child: CircularProgressIndicator(
        color: AppColors.greyColor,
      ),
    );
  }

  deleteRecord(int id) {
    _bloc?.deleteExpense(id);
  }

  Widget removeBtn(int id) {
    return IconButton(
      onPressed: () => deleteRecord(id),
      icon: Icon(
        CupertinoIcons.delete_solid,
        color: AppColors.greyColor,
        size: 29.0,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      child: Card(
        clipBehavior: Clip.antiAlias,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15.0),
        ),
        color: Colors.redAccent,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Note :',
                      style: GoogleFonts.poppins(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.w500)),
                  loading ? loadingBtn() : removeBtn(widget.data.id),
                ],
              ),
              StreamBuilder<ExpenseDeleteApiResponse<dynamic>>(
                  stream: _bloc?.expenseDeleteStream,
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
                          // Navigator.pushNamedAndRemoveUntil(
                          //     context, Routes.baseRoute, (route) => false);
                          if (loading) {
                            setState(() {
                              loading = false;
                            });
                          }
                          if (loading == false) {
                            widget.removeCardFromList(widget.index);
                          }
                        });
                        break;

                      case Status.ERROR:
                        WidgetsBinding.instance?.addPostFrameCallback((_) {
                          if (loading == false) {
                            ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text(snapshot.data!.msg)));
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
                  }),
              Text(widget.data.title,
                  style: GoogleFonts.poppins(
                      color: Colors.white,
                      fontSize: 27,
                      fontWeight: FontWeight.w400)),
              Row(
                children: [
                  Text("Amount : ",
                      style: GoogleFonts.poppins(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.w500)),
                  Text(widget.data.amount.toString(),
                      style: GoogleFonts.poppins(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.w400)),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  bottomRowItem(label: "Type", labelData: "Expense"),
                  bottomRowItem(
                      label: "Date", labelData: widget.data.amount_date),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
