class DashboardNetworthResponse {
  int status;
  String message;
  DashboardData? data;

  DashboardNetworthResponse({
    required this.status,
    required this.message,
    this.data,
  });

  factory DashboardNetworthResponse.fromJson(Map<String, dynamic> json) =>
      DashboardNetworthResponse(
        status: json["status"],
        message: json["message"],
        data:
            json["data"] != null ? DashboardData.fromJson(json["data"]) : null,
      );

  Map<String, dynamic> toJson() => {
    "status": status,
    "message": message,
    "data": data?.toJson(),
  };
}

class DashboardData {
  String currentdatetime;
  double totalNetWorth;
  List<Currentprojection> currentprojection;
  List<Futureprojection> futureprojection;

  DashboardData({
    required this.currentdatetime,
    required this.totalNetWorth,
    required this.currentprojection,
    required this.futureprojection,
  });

  factory DashboardData.fromJson(Map<String, dynamic> json) => DashboardData(
    currentdatetime: json["currentdatetime"],
    totalNetWorth: json["totalnetworth"]?.toDouble(),
    currentprojection: List<Currentprojection>.from(
      json["currentprojection"].map((x) => Currentprojection.fromJson(x)),
    ),
    futureprojection: List<Futureprojection>.from(
      json["futureprojection"].map((x) => Futureprojection.fromJson(x)),
    ),
  );

  Map<String, dynamic> toJson() => {
    "currentdatetime": currentdatetime,
    "totalNetWorth": totalNetWorth,
    "currentprojection": List<dynamic>.from(
      currentprojection.map((x) => x.toJson()),
    ),
    "futureprojection": List<dynamic>.from(
      futureprojection.map((x) => x.toJson()),
    ),
  };
}

class Currentprojection {
  DateTime date;
  double value;

  Currentprojection({required this.date, required this.value});

  factory Currentprojection.fromJson(Map<String, dynamic> json) =>
      Currentprojection(
        date: DateTime.parse(json["date"]),
        value: json["value"]?.toDouble(),
      );

  Map<String, dynamic> toJson() => {
    "date":
        "${date.year.toString().padLeft(4, '0')}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}",
    "value": value,
  };
}

class Futureprojection {
  DateTime date;
  double projectedValue;

  Futureprojection({required this.date, required this.projectedValue});

  factory Futureprojection.fromJson(Map<String, dynamic> json) =>
      Futureprojection(
        date: DateTime.parse(json["date"]),
        projectedValue: json["projectedValue"]?.toDouble(),
      );

  Map<String, dynamic> toJson() => {
    "date":
        "${date.year.toString().padLeft(4, '0')}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}",
    "projectedValue": projectedValue,
  };
}
