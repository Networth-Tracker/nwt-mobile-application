class DashboardAssetsResponse {
    int status;
    String message;
    Data? data;
    bool get success => status == 200 || status == 201;

    DashboardAssetsResponse({
        required this.status,
        required this.message,
        this.data,
    });

    factory DashboardAssetsResponse.fromJson(Map<String, dynamic> json) => DashboardAssetsResponse(
        status: json["status"],
        message: json["message"],
        data: json["data"] == null ? null : Data.fromJson(json["data"]),
    );

    Map<String, dynamic> toJson() => {
        "status": status,
        "message": message,
        "data": data?.toJson(),
    };
}

class Data {
    List<Assetdatum> assetdata;

    Data({
        required this.assetdata,
    });

    factory Data.fromJson(Map<String, dynamic> json) => Data(
        assetdata: List<Assetdatum>.from(json["assetdata"].map((x) => Assetdatum.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "assetdata": List<dynamic>.from(assetdata.map((x) => x.toJson())),
    };
}

class Assetdatum {
    String name;
    int value;
    String type;
    double deltavalue;
    double deltapercentage;

    Assetdatum({
        required this.name,
        required this.value,
        required this.type,
        required this.deltavalue,
        required this.deltapercentage,
    });

    factory Assetdatum.fromJson(Map<String, dynamic> json) => Assetdatum(
        name: json["name"],
        value: json["value"],
        type: json["type"],
        deltavalue: json["deltavalue"]?.toDouble(),
        deltapercentage: json["deltapercentage"]?.toDouble(),
    );

    Map<String, dynamic> toJson() => {
        "name": name,
        "value": value,
        "type": type,
        "deltavalue": deltavalue,
        "deltapercentage": deltapercentage,
    };
}
