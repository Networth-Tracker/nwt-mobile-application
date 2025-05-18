class BankSummaryResponse {
    int status;
    String message;
    BankSummaryData? data;

    BankSummaryResponse({
        required this.status,
        required this.message,
        this.data,
    });

    factory BankSummaryResponse.fromJson(Map<String, dynamic> json) => BankSummaryResponse(
        status: json["status"],
        message: json["message"],
        data: json["data"] != null ? BankSummaryData.fromJson(json["data"]) : null,
    );

    Map<String, dynamic> toJson() => {
        "status": status,
        "message": message,
        "data": data?.toJson(),
    };
}

class BankSummaryData {
    List<Bank> banks;
    double totalbalance;
    double totalpercentage;
    double deltavalue;
    double deltapercentage;
    DateTime lastdatafetch;
    String lastdatafetchtime;

    BankSummaryData({
        required this.banks,
        required this.totalbalance,
        required this.totalpercentage,
        required this.deltavalue,
        required this.deltapercentage,
        required this.lastdatafetch,
        required this.lastdatafetchtime,
    });

    factory BankSummaryData.fromJson(Map<String, dynamic> json) => BankSummaryData(
        banks: List<Bank>.from(json["banks"].map((x) => Bank.fromJson(x))),
        totalbalance: (json["totalbalance"] as num).toDouble(),
        totalpercentage: (json["totalpercentage"] as num).toDouble(),
        deltavalue: (json["deltavalue"] as num).toDouble(),
        deltapercentage: (json["deltapercentage"] as num).toDouble(),
        lastdatafetch: DateTime.parse(json["lastdatafetch"]),
        lastdatafetchtime: json["lastdatafetchtime"],
    );

    Map<String, dynamic> toJson() => {
        "banks": List<dynamic>.from(banks.map((x) => x.toJson())),
        "totalbalance": totalbalance,
        "totalpercentage": totalpercentage,
        "deltavalue": deltavalue,
        "deltapercentage": deltapercentage,
        "lastdatafetch": lastdatafetch.toIso8601String(),
        "lastdatafetchtime": lastdatafetchtime,
    };
}

class Bank {
    String guid;
    String fitype;
    String fipid;
    String finame;
    String linkrefnumber;
    String maskedaccnumber;
    double currentbalance;
    String accountsubtype;
    dynamic status;
    DateTime createdat;
    DateTime updatedat;
    String userguid;
    bool activestate;
    int id;
    bool isprimary;
    double currentpercentage;
    double deltavalue;
    double deltapercentage;

    Bank({
        required this.guid,
        required this.fitype,
        required this.fipid,
        required this.finame,
        required this.linkrefnumber,
        required this.maskedaccnumber,
        required this.currentbalance,
        required this.accountsubtype,
        required this.status,
        required this.createdat,
        required this.updatedat,
        required this.userguid,
        required this.activestate,
        required this.id,
        required this.isprimary,
        required this.currentpercentage,
        required this.deltavalue,
        required this.deltapercentage,
    });

    factory Bank.fromJson(Map<String, dynamic> json) => Bank(
        guid: json["guid"],
        fitype: json["fitype"],
        fipid: json["fipid"],
        finame: json["finame"],
        linkrefnumber: json["linkrefnumber"],
        maskedaccnumber: json["maskedaccnumber"],
        currentbalance: (json["currentbalance"] as num).toDouble(),
        accountsubtype: json["accountsubtype"],
        status: json["status"],
        createdat: DateTime.parse(json["createdat"]),
        updatedat: DateTime.parse(json["updatedat"]),
        userguid: json["userguid"],
        activestate: json["activestate"],
        id: json["id"],
        isprimary: json["isprimary"],
        currentpercentage: (json["currentpercentage"] as num).toDouble(),
        deltavalue: (json["deltavalue"] as num).toDouble(),
        deltapercentage: (json["deltapercentage"] as num).toDouble(),
    );

    Map<String, dynamic> toJson() => {
        "guid": guid,
        "fitype": fitype,
        "fipid": fipid,
        "finame": finame,
        "linkrefnumber": linkrefnumber,
        "maskedaccnumber": maskedaccnumber,
        "currentbalance": currentbalance,
        "accountsubtype": accountsubtype,
        "status": status,
        "createdat": createdat.toIso8601String(),
        "updatedat": updatedat.toIso8601String(),
        "userguid": userguid,
        "activestate": activestate,
        "id": id,
        "isprimary": isprimary,
        "currentpercentage": currentpercentage,
        "deltavalue": deltavalue,
        "deltapercentage": deltapercentage,
    };
}
