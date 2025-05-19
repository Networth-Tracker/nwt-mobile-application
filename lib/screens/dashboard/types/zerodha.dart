class ZerodhaResponse {
    int status;
    String message;
    Data data;

    ZerodhaResponse({
        required this.status,
        required this.message,
        required this.data,
    });

    factory ZerodhaResponse.fromJson(Map<String, dynamic> json) => ZerodhaResponse(
        status: json["status"],
        message: json["message"],
        data: Data.fromJson(json["data"]),
    );

    Map<String, dynamic> toJson() => {
        "status": status,
        "message": message,
        "data": data.toJson(),
    };
}

class Data {
    String loginUrl;

    Data({
        required this.loginUrl,
    });

    factory Data.fromJson(Map<String, dynamic> json) => Data(
        loginUrl: json["loginURL"],
    );

    Map<String, dynamic> toJson() => {
        "loginURL": loginUrl,
    };
}
