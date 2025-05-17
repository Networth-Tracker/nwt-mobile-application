class PanVerificationResponse {
  int status;
  String message;
  Null data;
  bool get success => status == 200 || status == 201;

  PanVerificationResponse({
    required this.status,
    required this.message,
    this.data,
  });

  factory PanVerificationResponse.fromJson(Map<String, dynamic> json) =>
      PanVerificationResponse(
        status: json["status"],
        message: json["message"],
        data: null,
      );

  Map<String, dynamic> toJson() => {
    "status": status,
    "message": message,
    "data": data,
  };
}
