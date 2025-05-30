class MutualFundTopPerformersRespose {
  int status;
  String message;
  List<MFPerformers>? data;

  MutualFundTopPerformersRespose({
    required this.status,
    required this.message,
    this.data,
  });

  factory MutualFundTopPerformersRespose.fromJson(Map<String, dynamic> json) =>
      MutualFundTopPerformersRespose(
        status: json["status"],
        message: json["message"],
        data:
            json["data"] != null
                ? List<MFPerformers>.from(
                  json["data"].map((x) => MFPerformers.fromJson(x)),
                )
                : null,
      );

  Map<String, dynamic> toJson() => {
    "status": status,
    "message": message,
    "data":
        data != null ? List<dynamic>.from(data!.map((x) => x.toJson())) : null,
  };
}

class MFPerformers {
  int id;
  int rank;
  String guid;
  String fundname;
  DateTime createdat;
  DateTime updatedat;
  String? isincode;

  MFPerformers({
    required this.id,
    required this.rank,
    required this.guid,
    required this.fundname,
    required this.createdat,
    required this.updatedat,
    this.isincode,
  });

  factory MFPerformers.fromJson(Map<String, dynamic> json) => MFPerformers(
    id: json["id"],
    rank: json["rank"],
    guid: json["guid"],
    fundname: json["fundname"],
    createdat: DateTime.parse(json["createdat"]),
    updatedat: DateTime.parse(json["updatedat"]),
    isincode: json["isincode"] ?? "N/A",
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "rank": rank,
    "guid": guid,
    "fundname": fundname,
    "createdat": createdat.toIso8601String(),
    "updatedat": updatedat.toIso8601String(),
    "isincode": isincode ?? "N/A",
  };
}
