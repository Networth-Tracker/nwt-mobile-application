class UserDataResponse {
  int status;
  String message;
  DataResponse? data;
  bool get success => status == 200 || status == 201;

  UserDataResponse({required this.status, required this.message, this.data});

  factory UserDataResponse.fromJson(Map<String, dynamic> json) =>
      UserDataResponse(
        status: json["status"],
        message: json["message"],
        data: json["data"] != null ? DataResponse.fromJson(json["data"]) : null,
      );

  Map<String, dynamic> toJson() => {
    "status": status,
    "message": message,
    "data": data?.toJson(),
  };
}

class DataResponse {
  User user;

  DataResponse({required this.user});

  factory DataResponse.fromJson(Map<String, dynamic> json) =>
      DataResponse(user: User.fromJson(json["user"]));

  Map<String, dynamic> toJson() => {"user": user.toJson()};
}

class User {
  int id;
  String phonenumber;
  String? guid;
  String? firstname;
  String? lastname;
  String? email;
  dynamic createdat;
  bool isverified;
  DateTime? dob;
  bool isonboardingcompleted;
  bool ispanverified;
  String? gender;
  bool ismfverified; // This is mapped from 'ismffetched' in the API response

  User({
    required this.id,
    required this.phonenumber,
    this.guid,
    this.firstname,
    this.lastname,
    this.email,
    required this.createdat,
    required this.isverified,
    this.dob,
    required this.isonboardingcompleted,
    required this.ispanverified,
    this.gender,
    required this.ismfverified,
  });

  factory User.fromJson(Map<String, dynamic> json) => User(
    id: json["id"],
    phonenumber: json["phonenumber"],
    guid: json["guid"],
    firstname: json["firstname"],
    lastname: json["lastname"],
    email: json["email"],
    createdat: json["createdat"],
    isverified: json["isverified"],
    dob: json["dob"] != null ? DateTime.parse(json["dob"]) : null,
    isonboardingcompleted: json["isonboardingcompleted"],
    ispanverified: json["ispanverified"],
    gender: json["gender"],
    ismfverified: json["ismffetched"] ?? false,
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "phonenumber": phonenumber,
    "guid": guid,
    "firstname": firstname,
    "lastname": lastname,
    "email": email,
    "createdat": createdat,
    "isverified": isverified,
    "dob":
        dob != null
            ? "${dob!.year.toString().padLeft(4, '0')}-${dob!.month.toString().padLeft(2, '0')}-${dob!.day.toString().padLeft(2, '0')}"
            : null,
    "isonboardingcompleted": isonboardingcompleted,
    "ispanverified": ispanverified,
    "gender": gender,
    "ismfverified": ismfverified,
  };
}
