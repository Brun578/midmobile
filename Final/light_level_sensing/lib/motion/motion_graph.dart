import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

class MotionGraph extends StatelessWidget {
  final List<FlSpot> spots;

  MotionGraph({required this.spots});

  @override
  Widget build(BuildContext context) {
    return Container(

      padding: EdgeInsets.all(6),
      child: LineChart(
        LineChartData(
          lineBarsData: [
            LineChartBarData(
              spots: spots,
              isCurved: true,
              color: Colors.orange,
              dotData: FlDotData(show: false), // Show dots on the graph
              belowBarData: BarAreaData(show: false),
              aboveBarData: BarAreaData(show: false),
              barWidth: 4,
            ),
          ],
          borderData: FlBorderData(
            show: true,
            border: Border.all(
              color: const Color(0xff37434d),
              width: 3,
            ),
          ),
          gridData: FlGridData(show: true),
          lineTouchData: LineTouchData(
            touchTooltipData: LineTouchTooltipData(
              // tooltipBgColor: Colors.blueAccent,
            ),
          ),
          minX: spots.isEmpty ? 0 : spots.first.x,
          maxX: spots.isEmpty ? 0 : spots.last.x,
          minY: -10, // Set boundaries based on your data
          maxY: 10,  // Set boundaries based on your data
        ),
      ),
    );
  }
}
