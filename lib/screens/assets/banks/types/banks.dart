class BankSummaryResponse {
    int status;
    String message;
    Data data;

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
    dynamic currency;
    dynamic balancedatetime;
    dynamic accounttype;
    String accountsubtype;
    dynamic branch;
    dynamic facility;
    dynamic ifsc;
    dynamic micrcode;
    dynamic openingdate;
    dynamic currentodlimit;
    dynamic drawinglimit;
    dynamic status;
    DateTime createdat;
    DateTime updatedat;
    dynamic sourceprovider;
    dynamic delta;
    String userguid;
    bool activestate;
    int id;
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
        required this.currency,
        required this.balancedatetime,
        required this.accounttype,
        required this.accountsubtype,
        required this.branch,
        required this.facility,
        required this.ifsc,
        required this.micrcode,
        required this.openingdate,
        required this.currentodlimit,
        required this.drawinglimit,
        required this.status,
        required this.createdat,
        required this.updatedat,
        required this.sourceprovider,
        required this.delta,
        required this.userguid,
        required this.activestate,
        required this.id,
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
        currency: json["currency"],
        balancedatetime: json["balancedatetime"],
        accounttype: json["accounttype"],
        accountsubtype: json["accountsubtype"],
        branch: json["branch"],
        facility: json["facility"],
        ifsc: json["ifsc"],
        micrcode: json["micrcode"],
        openingdate: json["openingdate"],
        currentodlimit: json["currentodlimit"],
        drawinglimit: json["drawinglimit"],
        status: json["status"],
        createdat: DateTime.parse(json["createdat"]),
        updatedat: DateTime.parse(json["updatedat"]),
        sourceprovider: json["sourceprovider"],
        delta: json["delta"],
        userguid: json["userguid"],
        activestate: json["activestate"],
        id: json["id"],
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
        "currency": currency,
        "balancedatetime": balancedatetime,
        "accounttype": accounttype,
        "accountsubtype": accountsubtype,
        "branch": branch,
        "facility": facility,
        "ifsc": ifsc,
        "micrcode": micrcode,
        "openingdate": openingdate,
        "currentodlimit": currentodlimit,
        "drawinglimit": drawinglimit,
        "status": status,
        "createdat": createdat.toIso8601String(),
        "updatedat": updatedat.toIso8601String(),
        "sourceprovider": sourceprovider,
        "delta": delta,
        "userguid": userguid,
        "activestate": activestate,
        "id": id,
        "currentpercentage": currentpercentage,
        "currentamount": currentamount,
        "deltavalue": deltavalue,
        "deltapercentage": deltapercentage,
    };
}
