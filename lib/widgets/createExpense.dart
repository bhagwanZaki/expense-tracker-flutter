import 'package:expense_tracker_app/constants/colors.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CreateExpense extends StatefulWidget {
  const CreateExpense({Key? key}) : super(key: key);

  @override
  _CreateExpenseState createState() => _CreateExpenseState();
}

class _CreateExpenseState extends State<CreateExpense> {
  late String transactionType;
  String? dropdownValue;

  Widget labelTextWidget({label}) {
    return Padding(
      padding: const EdgeInsets.only(top: 4.0, bottom: 8.0),
      child: Text(
        label,
        style: GoogleFonts.poppins(fontSize: 15),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            labelTextWidget(label: "Note"),
            TextField(
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
                style: const TextStyle(color: Colors.black, fontSize: 15.0),
                elevation: 20,
                onChanged: (String? newValue) {
                  setState(() {
                    dropdownValue = newValue!;
                  });
                },
                hint: Text("Select option"),
                items: <String>['Expense', 'Saving', 'Income']
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
            TextField(
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                  hintStyle: GoogleFonts.poppins(fontSize: 16),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15)),
                  hintText: 'Amount'),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 20.0),
              child: MaterialButton(
                color: AppColors.purpleColor,
                minWidth: double.infinity,
                height: 55,
                shape: RoundedRectangleBorder(
                    side: BorderSide(color: AppColors.purpleColor),
                    borderRadius: BorderRadius.circular(15)),
                onPressed: () => {Navigator.of(context).pop()},
                child: Text(
                  "Add",
                  style: GoogleFonts.poppins(fontSize: 20, color: Colors.white),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
