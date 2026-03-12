import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

class ExpenseChart extends StatelessWidget {
  const ExpenseChart({super.key});

  @override
  Widget build(BuildContext context) {

    return SizedBox(
      height: 200,
      child: PieChart(

        PieChartData(

          sections: [

            PieChartSectionData(
              value: 40,
              color: Colors.red,
              title: "Expense",
            ),

            PieChartSectionData(
              value: 60,
              color: Colors.green,
              title: "Income",
            ),

          ],

        ),

      ),
    );
  }
}