class GenerateOtpResponse {
    bool success;
    String message;
    GenerateOtpData? data;

    GenerateOtpResponse({
        required this.success,
        required this.message,
        this.data,
    });

    factory GenerateOtpResponse.fromJson(Map<String, dynamic> json) => GenerateOtpResponse(
        success: json["success"],
        message: json["message"],
        data: json["data"]==null?null: GenerateOtpData.fromJson(json["data"]),
    );

    Map<String, dynamic> toJson() => {
        "success": success,
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
    bool success;
    String message;
    VerifyOtpData? data;

    VerifyOtpResponse({
        required this.success,
        required this.message,
        this.data,
    });

    factory VerifyOtpResponse.fromJson(Map<String, dynamic> json) => VerifyOtpResponse(
        success: json["success"],
        message: json["message"],
        data: json["data"]==null?null: VerifyOtpData.fromJson(json["data"]),
    );

    Map<String, dynamic> toJson() => {
        "success": success,
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

