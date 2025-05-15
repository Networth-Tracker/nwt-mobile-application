class UserDataResponse {
  int status;
  String message;
  UserData data;
  bool get success => status == 200 || status == 201;

  UserDataResponse({
    required this.status,
    required this.message,
    required this.data,
  });

  factory UserDataResponse.fromJson(Map<String, dynamic> json) {
    return UserDataResponse(
        status: json["status"],
        message: json["message"],
        data: UserData.fromJson(json["data"]),
      );
  }

  Map<String, dynamic> toJson() => {
    "status": status,
    "message": message,
    "data": data.toJson(),
  };
}

class UserData {
  String firstName;
  String lastName;
  DateTime dob;
  String phoneNumber;
  String? pan;
  String panName;
  Status status;

  UserData({
    required this.firstName,
    required this.lastName,
    required this.dob,
    required this.phoneNumber,
    this.pan,
    required this.panName,
    required this.status,
  });

  factory UserData.fromJson(Map<String, dynamic> json) {
    print(json);
    return UserData(
      firstName: json["firstName"],
      lastName: json["lastName"],
      dob: DateTime.parse(json["dob"]),
      phoneNumber: json["phoneNumber"],
      pan: json["pan"],
      panName: json["panName"],
      status: Status.fromJson(json["status"]),
    );
  }

  Map<String, dynamic> toJson() => {
    "firstName": firstName,
    "lastName": lastName,
    "dob":
        "${dob.year.toString().padLeft(4, '0')}-${dob.month.toString().padLeft(2, '0')}-${dob.day.toString().padLeft(2, '0')}",
    "phoneNumber": phoneNumber,
    "pan": pan,
    "panName": panName,
    "status": status.toJson(),
  };
}

class Status {
  bool isVerified;
  bool isKycVerfied;
  bool isProfileCompleted;

  Status({
    required this.isVerified,
    required this.isKycVerfied,
    required this.isProfileCompleted,
  });

  factory Status.fromJson(Map<String, dynamic> json) => Status(
    isVerified: json["isVerified"],
    isKycVerfied: json["isKYCVerfied"],
    isProfileCompleted: json["isProfileCompleted"],
  );

  Map<String, dynamic> toJson() => {
    "isVerified": isVerified,
    "isKYCVerfied": isKycVerfied,
    "isProfileCompleted": isProfileCompleted,
  };
}

class UserProfileUpdatedResponse {
  int status;
  String message;
  UserProfileUpdatedData data;
  bool get success => status == 200 || status == 201;

  UserProfileUpdatedResponse({
    required this.status,
    required this.message,
    required this.data,
  });

  factory UserProfileUpdatedResponse.fromJson(Map<String, dynamic> json) =>
      UserProfileUpdatedResponse(
        status: json["status"],
        message: json["message"],
        data: UserProfileUpdatedData.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
    "status": status,
    "message": message,
    "data": data.toJson(),
  };
}

class UserProfileUpdatedData {
  bool isProfileCompleted;

  UserProfileUpdatedData({required this.isProfileCompleted});

  factory UserProfileUpdatedData.fromJson(Map<String, dynamic> json) =>
      UserProfileUpdatedData(isProfileCompleted: json["isProfileCompleted"]);

  Map<String, dynamic> toJson() => {"isProfileCompleted": isProfileCompleted};
}
