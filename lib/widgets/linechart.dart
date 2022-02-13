// ignore_for_file: non_constant_identifier_names

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:collection/collection.dart';
import 'dart:math';

class LineChartWidget extends StatelessWidget {
  final List<int> dayList;
  final List<int> income_graph_data;
  final List<int> saving_graph_data;
  final List<int> expense_graph_data;
  const LineChartWidget({
    Key? key,
    required this.dayList,
    required this.income_graph_data,
    required this.saving_graph_data,
    required this.expense_graph_data,
  }) : super(key: key);

  LineTouchData get lineTouchData => LineTouchData(
      handleBuiltInTouches: true,
      touchTooltipData: LineTouchTooltipData(
          tooltipBgColor: Colors.blueGrey.withOpacity(0.8)));

  int largeNumber(int num1, int num2, int num3) {
    var a = [num1, num2, num3];
    a.sort();
    return a.last;
  }

  @override
  Widget build(BuildContext context) {
    int maxX = dayList.last;
    int maxY = 0;

    if (saving_graph_data.sum == 0 &&
        income_graph_data.sum == 0 &&
        expense_graph_data.sum == 0) {
      maxY = 10;
    } else {
      maxY = largeNumber(saving_graph_data.reduce(max),
          income_graph_data.reduce(max), expense_graph_data.reduce(max));
    }
    print("--");
    print(maxX);

    return LineChart(
      LineChartData(
          minX: 0,
          minY: 0,
          maxX: maxX.toDouble(),
          maxY: maxY.toDouble(),
          gridData: FlGridData(show: false),
          titlesData: FlTitlesData(
            rightTitles: SideTitles(showTitles: false),
            topTitles: SideTitles(showTitles: false),
          ),
          borderData: FlBorderData(
              show: true,
              border: const Border(
                bottom: BorderSide(color: Colors.transparent),
                left: BorderSide(color: Colors.transparent),
                right: BorderSide(color: Colors.transparent),
                top: BorderSide(color: Colors.transparent),
              )),
          lineTouchData: lineTouchData,
          lineBarsData: [
            LineChartBarData(
                colors: [const Color(0xffff5252)],
                isCurved: true,
                isStrokeCapRound: true,
                curveSmoothness: 0.5,
                dotData: FlDotData(show: false),
                belowBarData: BarAreaData(show: false),
                spots: List.generate(expense_graph_data.length, (i){
                  return FlSpot(dayList[i].toDouble(),expense_graph_data[i].toDouble());
                })),
            LineChartBarData(
                colors: [const Color(0xff448AFF)],
                isCurved: true,
                isStrokeCapRound: true,
                curveSmoothness: 0.5,
                dotData: FlDotData(show: false),
                belowBarData: BarAreaData(show: false),
                spots: List.generate(saving_graph_data.length, (i){
                  return FlSpot(dayList[i].toDouble(),saving_graph_data[i].toDouble());
                })),
            LineChartBarData(
                colors: [const Color(0xff4caf50)],
                isCurved: true,
                isStrokeCapRound: true,
                curveSmoothness: 0.5,
                dotData: FlDotData(show: false),
                belowBarData: BarAreaData(show: false),
                spots: List.generate(income_graph_data.length, (i){
                  return FlSpot(dayList[i].toDouble(),income_graph_data[i].toDouble());
                })),
          ]),
      swapAnimationDuration: const Duration(milliseconds: 250),
    );
  }
}
