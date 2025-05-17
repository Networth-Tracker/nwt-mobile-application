class BankSummaryResponse {
    int status;
    String message;
    Data data;
    bool get success => status == 200 || status == 201;

    BankSummaryResponse({
        required this.status,
        required this.message,
        required this.data,
    });

    factory BankSummaryResponse.fromJson(Map<String, dynamic> json) => BankSummaryResponse(
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
    List<Bank> banks;
    String totalbalance;
    String totalpercentage;
    double deltavalue;
    double deltapercentage;
    DateTime lastdatafetch;
    String lastdatafetchtime;

    Data({
        required this.banks,
        required this.totalbalance,
        required this.totalpercentage,
        required this.deltavalue,
        required this.deltapercentage,
        required this.lastdatafetch,
        required this.lastdatafetchtime,
    });

    factory Data.fromJson(Map<String, dynamic> json) => Data(
        banks: List<Bank>.from(json["banks"].map((x) => Bank.fromJson(x))),
        totalbalance: json["totalbalance"],
        totalpercentage: json["totalpercentage"],
        deltavalue: json["deltavalue"]?.toDouble(),
        deltapercentage: json["deltapercentage"]?.toDouble(),
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
    String currentbalance;
    dynamic accounttype;
    String accountsubtype;
    dynamic status;
    DateTime createdat;
    DateTime updatedat;
    String userguid;
    bool activestate;
    int id;
    bool isprimary;
    String currentpercentage;
    String currentamount;
    int deltavalue;
    int deltapercentage;

    Bank({
        required this.guid,
        required this.fitype,
        required this.fipid,
        required this.finame,
        required this.linkrefnumber,
        required this.maskedaccnumber,
        required this.currentbalance,
        required this.accounttype,
        required this.accountsubtype,
        required this.status,
        required this.createdat,
        required this.updatedat,
        required this.userguid,
        required this.activestate,
        required this.id,
        required this.isprimary,
        required this.currentpercentage,
        required this.currentamount,
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
        currentbalance: json["currentbalance"],
        accounttype: json["accounttype"],
        accountsubtype: json["accountsubtype"],
        status: json["status"],
        createdat: DateTime.parse(json["createdat"]),
        updatedat: DateTime.parse(json["updatedat"]),
        userguid: json["userguid"],
        activestate: json["activestate"],
        id: json["id"],
        isprimary: json["isprimary"],
        currentpercentage: json["currentpercentage"],
        currentamount: json["currentamount"],
        deltavalue: json["deltavalue"],
        deltapercentage: json["deltapercentage"],
    );

    Map<String, dynamic> toJson() => {
        "guid": guid,
        "fitype": fitype,
        "fipid": fipid,
        "finame": finame,
        "linkrefnumber": linkrefnumber,
        "maskedaccnumber": maskedaccnumber,
        "currentbalance": currentbalance,
        "accounttype": accounttype,
        "accountsubtype": accountsubtype,
        "status": status,
        "createdat": createdat.toIso8601String(),
        "updatedat": updatedat.toIso8601String(),
        "userguid": userguid,
        "activestate": activestate,
        "id": id,
        "isprimary": isprimary,
        "currentpercentage": currentpercentage,
        "currentamount": currentamount,
        "deltavalue": deltavalue,
        "deltapercentage": deltapercentage,
    };
}
