class DashboardNetworth {
    int status;
    String message;
    TotalNetworth? data;

    DashboardNetworth({
        required this.status,
        required this.message,
        this.data,
    });

    factory DashboardNetworth.fromJson(Map<String, dynamic> json) => DashboardNetworth(
        status: json["status"],
        message: json["message"],
        data: json["data"] != null ? TotalNetworth.fromJson(json["data"]) : null,
    );

    Map<String, dynamic> toJson() => {
        "status": status,
        "message": message,
        "data": data?.toJson(),  
    };
}

class TotalNetworth {
    double totalcurrentmarketvalue;
    DateTime currentdatetime;

    TotalNetworth({
        required this.totalcurrentmarketvalue,
        required this.currentdatetime,
    });

    factory TotalNetworth.fromJson(Map<String, dynamic> json) => TotalNetworth(
        totalcurrentmarketvalue: json["totalcurrentmarketvalue"]+0.0,
        currentdatetime: DateTime.parse(json["currentdatetime"]),
    );

    Map<String, dynamic> toJson() => {
        "totalcurrentmarketvalue": totalcurrentmarketvalue + 0.0,
        "currentdatetime": currentdatetime.toIso8601String(),
    };
}
