import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class DashboardCard extends StatelessWidget {
  final String label;
  final Color backgroudColor;
  final Color textColor;
  final String amount;
  const DashboardCard({
    Key? key,
    required this.label,
    required this.backgroudColor,
    required this.amount, 
    required this.textColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      child: Card(
        clipBehavior: Clip.antiAlias,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15.0),
        ),
        color: backgroudColor,
        child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  flex: 7,
                  child: Text(label,
                      style: GoogleFonts.poppins(
                          fontSize: 30, color:textColor)),
                ),
                Expanded(
                    flex: 3,
                    child: Text(
                      amount,
                      textAlign: TextAlign.end,
                      style: GoogleFonts.poppins(
                          fontSize: 25, color:textColor),
                    ))
              ],
            )),
      ),
    );
  }
}
