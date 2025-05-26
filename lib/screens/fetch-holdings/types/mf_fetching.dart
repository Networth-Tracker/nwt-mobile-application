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

class MfCentralVerifyOtpResponse {
  int status;
  String message;
  MFCOTPData? data;
  bool get success => status == 200 || status == 201;

  MfCentralVerifyOtpResponse({
    required this.status,
    required this.message,
    this.data,
  });

  factory MfCentralVerifyOtpResponse.fromJson(Map<String, dynamic> json) =>
      MfCentralVerifyOtpResponse(
        status: json["status"],
        message: json["message"],
        data: json["data"] != null ? MFCOTPData.fromJson(json["data"]) : null,
      );

  Map<String, dynamic> toJson() => {
    "status": status,
    "message": message,
    "data": data?.toJson(),
  };
}

class MFCOTPData {
  bool ismffetched;
  int switchsavings;

  MFCOTPData({required this.ismffetched, required this.switchsavings});

  factory MFCOTPData.fromJson(Map<String, dynamic> json) => MFCOTPData(
    ismffetched: json["ismffetched"],
    switchsavings: json["switchsavings"],
  );

  Map<String, dynamic> toJson() => {
    "ismffetched": ismffetched,
    "switchsavings": switchsavings,
  };
}
