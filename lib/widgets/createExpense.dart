import 'package:expense_tracker_app/bloc/expenseBloc.dart';
import 'package:expense_tracker_app/constants/colors.dart';
import 'package:expense_tracker_app/constants/routes.dart';
import 'package:expense_tracker_app/model/expenseModel.dart';
import 'package:expense_tracker_app/response/expenseApiResponse.dart';
import 'package:expense_tracker_app/services/expenseApiService.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CreateExpense extends StatefulWidget {
  const CreateExpense({Key? key}) : super(key: key);

  @override
  _CreateExpenseState createState() => _CreateExpenseState();
}

class _CreateExpenseState extends State<CreateExpense> {
  expenseApiService client = expenseApiService();
  ExpenseBloc? _bloc;
  bool loading = false;

  @override
  void initState() {
    super.initState();
    _bloc = ExpenseBloc();
  }

  late String transactionType;
  String? dropdownValue;

  final _formKey = GlobalKey<FormState>();
  TextEditingController note = TextEditingController();
  TextEditingController amount = TextEditingController();

  createExpense(BuildContext context, String note, String? incomeOrexpense,
      double amount) {
    FocusScope.of(context).requestFocus(FocusNode());
    if (_formKey.currentState!.validate() && incomeOrexpense != null) {
      print("valid");
      print(note);
      print(incomeOrexpense);
      print(amount);
      print("=========");
      _bloc?.createExpense(note, amount, incomeOrexpense);
    } else {
      print("not calid");
    }
  }

  Widget labelTextWidget({label}) {
    return Padding(
      padding: const EdgeInsets.only(top: 4.0, bottom: 8.0),
      child: Text(
        label,
        style: GoogleFonts.poppins(fontSize: 15),
      ),
    );
  }

  Widget createBtn() {
    return Padding(
      padding: const EdgeInsets.only(top: 20.0),
      child: MaterialButton(
        color: AppColors.purpleColor,
        minWidth: double.infinity,
        height: 55,
        shape: RoundedRectangleBorder(
            side: BorderSide(color: AppColors.purpleColor),
            borderRadius: BorderRadius.circular(15)),
        onPressed: () => createExpense(
            context, note.text, dropdownValue, double.parse(amount.text)),
        child: Text(
          "Add",
          style: GoogleFonts.poppins(fontSize: 20, color: Colors.white),
        ),
      ),
    );
  }

  Widget loadingBtn() {
    return Padding(
      padding: const EdgeInsets.only(top: 20.0),
      child: MaterialButton(
        color: AppColors.purpleColor,
        minWidth: double.infinity,
        height: 55,
        shape: RoundedRectangleBorder(
            side: BorderSide(color: AppColors.purpleColor),
            borderRadius: BorderRadius.circular(15)),
        onPressed: () => {},
        child: CircularProgressIndicator(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      content: SingleChildScrollView(
        child: Column(
          children: [
            Form(
              key: _formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  labelTextWidget(label: "Note"),
                  TextFormField(
                    controller: note,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter note';
                      }
                      return null;
                    },
                    decoration: InputDecoration(
                        hintStyle: GoogleFonts.poppins(fontSize: 16),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15)),
                        hintText: 'Note'),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  labelTextWidget(label: "Type"),
                  Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Color(0xFFBDBDBD), width: 1)),
                    padding: const EdgeInsets.all(5.0),
                    child: DropdownButton<String>(
                      isExpanded: true,
                      value: dropdownValue,
                      // elevation: 16,
                      style:
                          const TextStyle(color: Colors.black, fontSize: 15.0),
                      elevation: 20,
                      onChanged: (String? newValue) {
                        setState(() {
                          dropdownValue = newValue!;
                        });
                      },
                      hint: Text("Select option"),
                      items: <String>['expense', 'saving', 'income']
                          .map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  labelTextWidget(label: "Amount"),
                  TextFormField(
                    controller: amount,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter amount';
                      }
                      return null;
                    },
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                        hintStyle: GoogleFonts.poppins(fontSize: 16),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15)),
                        hintText: 'Amount'),
                  ),
                  loading ? loadingBtn() : createBtn()
                ],
              ),
            ),
            StreamBuilder<ExpenseApiResponse<expenseModel>>(
                stream: _bloc?.expenseCreateStream,
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    print(snapshot.data?.status);
                    switch (snapshot.data?.status) {
                      case Status.LOADING:
                        WidgetsBinding.instance?.addPostFrameCallback((_) {
                          print("loading");

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
                            print("completed");
                            Navigator.of(context).pop();
                          }
                        });
                        break;

                      case Status.ERROR:
                        WidgetsBinding.instance?.addPostFrameCallback((_) {
                          print("Error");
                          if (loading == false) {
                            if (snapshot.data!.msg ==
                                'Invalid Request: ["Expense cannot be greater than total amount"]') {
                              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                  content: Text(
                                      "Expense cannot be greater than total amount")));
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
      ),
    );
  }
}
