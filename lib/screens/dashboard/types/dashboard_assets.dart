class DashboardAssetsResponse {
    int status;
    String message;
    DashboardAssetData? data;
    bool get success => status == 200 || status == 201;

    DashboardAssetsResponse({
        required this.status,
        required this.message,
        this.data,
    });

    factory DashboardAssetsResponse.fromJson(Map<String, dynamic> json) => DashboardAssetsResponse(
        status: json["status"],
        message: json["message"],
        data: json["data"] == null ? null : DashboardAssetData.fromJson(json["data"]),
    );

    Map<String, dynamic> toJson() => {
        "status": status,
        "message": message,
        "data": data?.toJson(),
    };
}

class DashboardAssetData {
    List<Assetdatum> assetdata;

    DashboardAssetData({
        required this.assetdata,
    });

    factory DashboardAssetData.fromJson(Map<String, dynamic> json) => DashboardAssetData(
        assetdata: List<Assetdatum>.from(json["assetdata"].map((x) => Assetdatum.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "assetdata": List<dynamic>.from(assetdata.map((x) => x.toJson())),
    };
}

class Assetdatum {
    String name;
    double value;
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
        value: json["value"]+0.0,
        type: json["type"],
        deltavalue: json["deltavalue"]+0.0,
        deltapercentage: json["deltapercentage"]+0.0,
    );

    Map<String, dynamic> toJson() => {
        "name": name,
        "value": value,
        "type": type,
        "deltavalue": deltavalue,
        "deltapercentage": deltapercentage,
    };
}
