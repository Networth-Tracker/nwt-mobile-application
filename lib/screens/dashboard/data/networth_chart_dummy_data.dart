import 'dart:math';
import 'package:intl/intl.dart';
import 'package:nwt_app/screens/dashboard/types/dashboard_networth.dart';

class NetworthChartDummyData {
  static const double initialNetWorth = 5000000; // 50L starting amount
  static const double historicalAnnualRate = 0.155; // 15.5%
  static const double futureAnnualRate = 0.19; // 19%
  static const int daysInYear = 365;

  static String _formatDate(DateTime date) {
    return DateFormat('yyyy-MM-dd').format(date);
  }

  static double _calculateCompoundedValue(double principal, double rate, int days) {
    final dailyRate = rate / daysInYear;
    return principal * pow(1 + dailyRate, days).toDouble();
  }

  static DateTime _parseDate(String dateStr) {
    return DateTime.parse(dateStr);
  }

  static Map<String, dynamic> get rawData {
    final now = DateTime.now();
    final startDate = DateTime(2024, 1, 1);
    
    // Generate historical data (past year to now)
    final currentProjection = <Map<String, dynamic>>[];
    DateTime currentDate = startDate;
    double currentValue = initialNetWorth;
    
    while (currentDate.isBefore(now)) {
      // Add some random fluctuation (±2%)
      final fluctuation = 0.98 + (0.04 * (DateTime.now().millisecondsSinceEpoch % 100) / 100);
      final dayValue = currentValue * fluctuation;
      
      currentProjection.add({
        'date': _formatDate(currentDate),
        'value': dayValue,
      });
      
      // Move to next day and compound the value
      currentDate = currentDate.add(const Duration(days: 1));
      currentValue = _calculateCompoundedValue(
        currentValue, 
        historicalAnnualRate,
        1,
      );
    }
    
    // Generate future projections (next 1 year)
    final futureProjection = <Map<String, dynamic>>[];
    final endDate = now.add(const Duration(days: 365));
    
    while (currentDate.isBefore(endDate)) {
      // Add some random fluctuation (±1.5% for future)
      final fluctuation = 0.985 + (0.03 * (DateTime.now().millisecondsSinceEpoch % 100) / 100);
      final dayValue = currentValue * fluctuation;
      
      futureProjection.add({
        'date': _formatDate(currentDate),
        'projectedValue': dayValue,
      });
      
      // Move to next day and compound the value
      currentDate = currentDate.add(const Duration(days: 1));
      currentValue = _calculateCompoundedValue(
        currentValue,
        futureAnnualRate,
        1,
      );
    }
    
    // Get the latest value for totalNetWorth
    final totalNetWorth = currentProjection.isNotEmpty 
        ? currentProjection.last['value'] 
        : initialNetWorth;
    
    return {
      'status': 200,
      'message': 'All Graph data fetched successfully',
      'data': {
        'currentdatetime': DateFormat('MM/dd/yyyy, HH:mm:ss').format(now),
        'totalnetworth': totalNetWorth,
        'currentprojection': currentProjection,
        'futureprojection': futureProjection,
      },
    };
  }

  // Helper method to get total net worth
  static double getTotalNetworth() {
    return (rawData['data']['totalnetworth'] as num).toDouble();
  }
  
  // Helper method to get projected net worth (1 year from now)
  static double getProjectedNetworth() {
    final projections = rawData['data']['futureprojection'] as List;
    if (projections.isEmpty) return getTotalNetworth();
    return (projections.last['projectedValue'] as num).toDouble();
  }
  
  // Helper method to get current projection data
  static List<Currentprojection> getCurrentProjection() {
    final data = rawData['data']['currentprojection'] as List;
    return data.map((e) => Currentprojection(
      date: DateTime.parse(e['date']),
      value: (e['value'] as num).toDouble(),
    )).toList();
  }
  
  // Helper method to get future projection data
  static List<Futureprojection> getFutureProjection() {
    final data = rawData['data']['futureprojection'] as List;
    return data.map((e) => Futureprojection(
      date: DateTime.parse(e['date']),
      projectedValue: (e['projectedValue'] as num).toDouble(),
    )).toList();
  }
}
