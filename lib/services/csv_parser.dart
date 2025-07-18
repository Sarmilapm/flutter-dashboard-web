
import 'package:flutter/services.dart';
import '../models/dashboard_data.dart';

class CSVParser {
  static Future<List<DashboardData>> loadDashboardData() async {
    final raw = await rootBundle.loadString('assets/csvfiles/dashboard_data.csv');
    final lines = raw.split('\n');

    print("Raw line count : ${lines.length}");

    final rows = lines
        .skip(1)
        .where((line) => line.trim().isNotEmpty)
        .map((line) => line.split(','))
        .toList();

    print("Parsed rows: ${rows.length}");
    print("First parsed row: ${rows.isNotEmpty ? rows.first : 'None'}");

    return rows.map((values) => DashboardData.fromList(values)).toList();
  }
}
