import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'dart:math';
import '../models/dashboard_data.dart';

class ChartWidget extends StatelessWidget {
  final String title;
  final List<DashboardData> data;
  final bool isA;

  const ChartWidget({
    super.key,
    required this.title,
    required this.data,
    required this.isA,
  });

  @override
  Widget build(BuildContext context) {
    final Map<int, double> grouped = {};

    for (var d in data) {
      grouped[d.hour] =
          (grouped[d.hour] ?? 0) + (isA ? d.parameterA : d.parameterB);
    }

    final sorted = grouped.entries.toList()
      ..sort((a, b) => a.key.compareTo(b.key));
    final maxY = sorted.isEmpty ? 100.0 : grouped.values.reduce(max) * 1.2;

    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 500),
      child: Card(
        key: ValueKey(title + data.length.toString()),
        elevation: 6,
        color: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                title,
                style: TextStyle(
                  fontSize: 20,
                  color: const Color(0xFF011638),
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              SizedBox(
                height: 320,
                child: BarChart(
                  BarChartData(
                    maxY: maxY,
                    borderData: FlBorderData(show: false),
                    gridData: FlGridData(show: false),
                    titlesData: FlTitlesData(
                      leftTitles: AxisTitles(
                        sideTitles: SideTitles(
                          showTitles: true,
                          reservedSize: 40,
                          getTitlesWidget: (value, _) => Padding(
                            padding: const EdgeInsets.only(right: 4),
                            child: Text(
                              value.toStringAsFixed(0),
                              style: const TextStyle(
                                fontSize: 10,
                                color: Color(0xFF011638),
                              ),
                            ),
                          ),
                        ),
                      ),
                      bottomTitles: AxisTitles(
                        sideTitles: SideTitles(
                          showTitles: true,
                          getTitlesWidget: (value, _) => Padding(
                            padding: const EdgeInsets.only(top: 4),
                            child: Text(
                              '${value.toInt()}h',
                              style: const TextStyle(
                                fontSize: 10,
                                color: Color(0xFF011638),
                              ),
                            ),
                          ),
                        ),
                      ),
                      topTitles: AxisTitles(
                          sideTitles: SideTitles(showTitles: false)),
                      rightTitles: AxisTitles(
                          sideTitles: SideTitles(showTitles: false)),
                    ),
                    barGroups: sorted
                        .map((e) => BarChartGroupData(
                      x: e.key,
                      barRods: [
                        BarChartRodData(
                          toY: e.value,
                          width: 18,
                          color: isA
                              ? const Color(0xFF3EB1C8)
                              : const Color(0xFFEFCC6C),
                          borderRadius: const BorderRadius.only(
                            topLeft: Radius.circular(10),
                            topRight: Radius.circular(10),
                          ),
                        )
                      ],
                    ))
                        .toList(),
                  ),
                  swapAnimationDuration: const Duration(milliseconds: 400),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
