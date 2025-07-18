import 'package:intl/intl.dart';

class DashboardData {
  final String site;
  final String individual;
  final DateTime date;
  final int hour;
  final double parameterA;
  final double parameterB;

  DashboardData({
    required this.site,
    required this.individual,
    required this.date,
    required this.hour,
    required this.parameterA,
    required this.parameterB,
  });

  factory DashboardData.fromList(List<dynamic> values) {
    final dateFormat = DateFormat('yyyy-MM-dd');
    final dateStr = values[2].toString().trim();
    final date = dateFormat.parse(dateStr);

    final timeStr = values[3].toString().trim();
    final hour = int.tryParse(timeStr.split(':')[0]) ?? 0;

    return DashboardData(
      site: values[0].toString(),
      individual: values[1].toString(),
      date: date,
      hour: hour,
      parameterA: double.tryParse(values[4].toString()) ?? 0.0,
      parameterB: double.tryParse(values[5].toString()) ?? 0.0,
    );
  }
}
