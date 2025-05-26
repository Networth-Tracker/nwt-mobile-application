import 'package:nwt_app/screens/dashboard/types/dashboard_networth.dart';

class NetworthChartDummyData {
  static final Map<String, dynamic> rawData = {
    "status": 200,
    "message": "All Graph data fetched successfully",
    "data": {
      "currentdatetime": "05/26/2025, 10:29:13",
      "totalnetworth": 6741939486.400001,
      "currentprojection": [
        {"date": "2024-01-08", "value": 20000},
        {"date": "2024-01-10", "value": 50000},
        {"date": "2024-01-12", "value": 50000},
        {"date": "2024-01-15", "value": 10000},
        {"date": "2024-01-20", "value": 25000},
        {"date": "2024-01-25", "value": 100000},
        {"date": "2024-02-01", "value": 20000},
        {"date": "2024-02-08", "value": 153000},
        {"date": "2024-02-15", "value": 30000},
        {"date": "2024-02-20", "value": 75000},
        {"date": "2024-03-01", "value": 80000},
        {"date": "2024-03-08", "value": 3000},
        {"date": "2024-03-10", "value": 790000},
        {"date": "2024-03-15", "value": 10000},
        {"date": "2024-03-20", "value": 5000},
        {"date": "2024-03-25", "value": 15000},
        {"date": "2024-04-01", "value": 10000},
        {"date": "2024-04-05", "value": 25000},
        {"date": "2024-04-08", "value": 3000},
        {"date": "2024-04-10", "value": 30000},
        {"date": "2024-04-15", "value": 10000},
        {"date": "2024-04-20", "value": 40000},
        {"date": "2024-04-25", "value": 2500},
        {"date": "2024-04-28", "value": 8000},
        {"date": "2024-05-01", "value": 10000},
        {"date": "2024-05-05", "value": 3000},
        {"date": "2024-05-08", "value": 3000},
        {"date": "2024-05-12", "value": 5634.48},
        {"date": "2024-05-15", "value": 10000},
        {"date": "2024-05-18", "value": 55000},
        {"date": "2024-05-20", "value": 8037},
        {"date": "2025-01-05", "value": 25000},
        {"date": "2025-01-15", "value": 30000},
        {"date": "2025-01-25", "value": 15000},
        {"date": "2025-02-03", "value": 20000},
        {"date": "2025-02-12", "value": 40000},
        {"date": "2025-02-20", "value": 10000},
        {"date": "2025-03-05", "value": 35000},
        {"date": "2025-03-15", "value": 28000},
        {"date": "2025-03-22", "value": 22000},
        {"date": "2025-04-02", "value": 18000},
        {"date": "2025-04-10", "value": 45000},
        {"date": "2025-04-18", "value": 8000},
        {"date": "2025-04-25", "value": 32000},
        {"date": "2025-05-05", "value": 26000},
        {"date": "2025-05-12", "value": 38000},
        {"date": "2025-05-20", "value": 19000},
        {"date": "2025-05-26", "value": 6741939486.400001},
      ],
      "futureprojection": [
        {"date": "2025-06-26", "projectedValue": 58120404128.72},
        {"date": "2025-07-26", "projectedValue": 501040002346.47},
        {"date": "2025-08-26", "projectedValue": 4319327914433.86},
        {"date": "2025-09-26", "projectedValue": 37235736757614.01},
        {"date": "2025-10-26", "projectedValue": 320999034884356.06},
        {"date": "2025-11-26", "projectedValue": 276724430223345},
        {"date": "2025-12-26", "projectedValue": 23855651258234326},
        {"date": "2026-01-26", "projectedValue": 2056530014347},
        {"date": "2026-02-26", "projectedValue": 1772877349068},
        {"date": "2026-03-26", "projectedValue": 15283242343219},
        {"date": "2026-04-26", "projectedValue": 131754242433447},
        {"date": "2026-05-26", "projectedValue": 11352348346216},
      ],
    },
  };

  // Helper method to convert raw data to typed objects
  static List<Currentprojection> getCurrentProjection() {
    List<dynamic> currentProjectionRaw = rawData['data']['currentprojection'];
    return currentProjectionRaw
        .map(
          (item) => Currentprojection(
            date: DateTime.parse(item['date']),
            value: item['value'].toDouble(),
          ),
        )
        .toList();
  }

  static List<Futureprojection> getFutureProjection() {
    List<dynamic> futureProjectionRaw = rawData['data']['futureprojection'];
    return futureProjectionRaw
        .map(
          (item) => Futureprojection(
            date: DateTime.parse(item['date']),
            projectedValue: item['projectedValue'].toDouble(),
          ),
        )
        .toList();
  }

  static double getTotalNetworth() {
    return rawData['data']['totalnetworth'];
  }

  // Helper method to get a sample projected networth (last future projection value)
  static double getProjectedNetworth() {
    List<dynamic> futureProjectionRaw = rawData['data']['futureprojection'];
    if (futureProjectionRaw.isNotEmpty) {
      return futureProjectionRaw.last['projectedValue'].toDouble();
    }
    return 0.0;
  }
}
