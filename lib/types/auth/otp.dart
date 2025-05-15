class GenerateOtpResponse {
    int status;
    String message;
    GenerateOtpData? data;
    bool get success => status == 200 || status == 201;

    GenerateOtpResponse({
        required this.status,
        required this.message,
        this.data,
    });

    factory GenerateOtpResponse.fromJson(Map<String, dynamic> json) => GenerateOtpResponse(
        status: json["status"],
        message: json["message"],
        data: json["data"]==null?null: GenerateOtpData.fromJson(json["data"]),
    );

    Map<String, dynamic> toJson() => {
        "status": status,
        "message": message,
        "data": data?.toJson(),
    };
}

class GenerateOtpData {
    DateTime expireAt;

    GenerateOtpData({
        required this.expireAt,
    });

    factory GenerateOtpData.fromJson(Map<String, dynamic> json) => GenerateOtpData(
        expireAt: DateTime.parse(json["expireAt"]),
    );

    Map<String, dynamic> toJson() => {
        "expireAt": expireAt.toIso8601String(),
    };
}

class VerifyOtpResponse {
    int status;
    String message;
    VerifyOtpData? data;
    bool get success => status == 200 || status == 201;

    VerifyOtpResponse({
        required this.status,
        required this.message,
        this.data,
    });

    factory VerifyOtpResponse.fromJson(Map<String, dynamic> json) => VerifyOtpResponse(
        status: json["status"],
        message: json["message"],
        data: json["data"]==null?null: VerifyOtpData.fromJson(json["data"]),
    );

    Map<String, dynamic> toJson() => {
        "status": status,
        "message": message,
        "data": data?.toJson(),
    };
}

class VerifyOtpData {
    String token;

    VerifyOtpData({
        required this.token,
    });

    factory VerifyOtpData.fromJson(Map<String, dynamic> json) => VerifyOtpData(
        token: json["token"],
    );

    Map<String, dynamic> toJson() => {
        "token": token,
    };
}

