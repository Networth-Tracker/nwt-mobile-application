class MfCentralOtpResponse {
  int status;
  String message;
  MFCentralOTPData data;

  MfCentralOtpResponse({
    required this.status,
    required this.message,
    required this.data,
  });

  factory MfCentralOtpResponse.fromJson(Map<String, dynamic> json) =>
      MfCentralOtpResponse(
        status: json["status"],
        message: json["message"],
        data: MFCentralOTPData.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
    "status": status,
    "message": message,
    "data": data.toJson(),
  };
}

class MFCentralOTPData {
  DecryptedCASDetails decryptedcasdetails;
  String token;

  MFCentralOTPData({required this.decryptedcasdetails, required this.token});

  factory MFCentralOTPData.fromJson(Map<String, dynamic> json) =>
      MFCentralOTPData(
        decryptedcasdetails: DecryptedCASDetails.fromJson(
          json["decryptedcasdetails"],
        ),
        token: json["token"],
      );

  Map<String, dynamic> toJson() => {
    "decryptedcasdetails": decryptedcasdetails.toJson(),
    "token": token,
  };
}

class DecryptedCASDetails {
  int reqId;
  String otpRef;
  String userSubjectReference;
  String clientRefNo;

  DecryptedCASDetails({
    required this.reqId,
    required this.otpRef,
    required this.userSubjectReference,
    required this.clientRefNo,
  });

  factory DecryptedCASDetails.fromJson(Map<String, dynamic> json) =>
      DecryptedCASDetails(
        reqId: json["reqId"],
        otpRef: json["otpRef"],
        userSubjectReference: json["userSubjectReference"],
        clientRefNo: json["clientRefNo"],
      );

  Map<String, dynamic> toJson() => {
    "reqId": reqId,
    "otpRef": otpRef,
    "userSubjectReference": userSubjectReference,
    "clientRefNo": clientRefNo,
  };
}
