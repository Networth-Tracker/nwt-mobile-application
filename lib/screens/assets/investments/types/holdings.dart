class InvestmentHoldingsResponse {
  int status;
  String message;
  HoldingsData data;

  InvestmentHoldingsResponse({
    required this.status,
    required this.message,
    required this.data,
  });

  factory InvestmentHoldingsResponse.fromJson(Map<String, dynamic> json) =>
      InvestmentHoldingsResponse(
        status: json["status"],
        message: json["message"],
        data: HoldingsData.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
    "status": status,
    "message": message,
    "data": data.toJson(),
  };
}

class HoldingsData {
  List<Investment> investments;

  HoldingsData({required this.investments});

  factory HoldingsData.fromJson(Map<String, dynamic> json) => HoldingsData(
    investments: List<Investment>.from(
      json["investments"].map((x) => Investment.fromJson(x)),
    ),
  );

  Map<String, dynamic> toJson() => {
    "investments": List<dynamic>.from(investments.map((x) => x.toJson())),
  };
}

class Investment {
  int id;
  String createdat;
  String userguid;
  bool activestate;
  String? reqid;
  String? amc;
  String? amcname;
  String? taxstatus;
  String? modeofholding;
  String? transactionsource;
  String? schemecode;
  String name;
  bool? idcwchangeallowed;
  String? schemeoption;
  String? assettype;
  String? schemetype;
  double? nav;
  String? navdate;
  double? closingbalance;
  bool? isdemat;
  double currentmktvalue;
  double costvalue;
  double gainloss;
  double? gainlosspercentage;
  bool? lienunitsflag;
  double? decimalunit;
  double? decimalamount;
  double? decimalnav;
  String? brokercode;
  String? brokername;
  bool? purallow;
  bool? redallow;
  bool? swtallow;
  bool? sipallow;
  bool? stpallow;
  bool? swpallow;
  String? planmode;
  String? dpid;
  String? mobilerelationship;
  String? emailrelationship;
  bool? newfolio;
  String? nomineestatus;
  double? lienavailableunits;
  String? investorname;
  String guid;
  double quantity;
  double deltavalue;
  double deltapercentage;
  Type type;
  String? stockaccountguid;
  String? isin;
  String? symbol;
  String? securityname;
  String? status;
  String? buydate;
  String? selldate;
  double? averageprice;
  String? currency;
  String? exchangename;
  String? tradedate;
  String? updatedat;

  Investment({
    required this.id,
    required this.createdat,
    required this.userguid,
    required this.activestate,
    this.reqid,
    this.amc,
    this.amcname,
    this.taxstatus,
    this.modeofholding,
    this.transactionsource,
    this.schemecode,
    required this.name,
    this.idcwchangeallowed,
    this.schemeoption,
    this.assettype,
    this.schemetype,
    this.nav,
    this.navdate,
    this.closingbalance,
    this.isdemat,
    required this.currentmktvalue,
    required this.costvalue,
    required this.gainloss,
    this.gainlosspercentage,
    this.lienunitsflag,
    this.decimalunit,
    this.decimalamount,
    this.decimalnav,
    this.brokercode,
    this.brokername,
    this.purallow,
    this.redallow,
    this.swtallow,
    this.sipallow,
    this.stpallow,
    this.swpallow,
    this.planmode,
    this.dpid,
    this.mobilerelationship,
    this.emailrelationship,
    this.newfolio,
    this.nomineestatus,
    this.lienavailableunits,
    this.investorname,
    required this.guid,
    required this.quantity,
    required this.deltavalue,
    required this.deltapercentage,
    required this.type,
    this.stockaccountguid,
    this.isin,
    this.symbol,
    this.securityname,
    this.status,
    this.buydate,
    this.selldate,
    this.averageprice,
    this.currency,
    this.exchangename,
    this.tradedate,
    this.updatedat,
  });

  factory Investment.fromJson(Map<String, dynamic> json) => Investment(
    id: json["id"],
    createdat: json["createdat"],
    userguid: json["userguid"],
    activestate: json["activestate"],
    reqid: json["reqid"],
    amc: json["amc"],
    amcname: json["amcname"],
    taxstatus: json["taxstatus"],
    modeofholding: json["modeofholding"],
    transactionsource: json["transactionsource"],
    schemecode: json["schemecode"],
    name: json["type"] == "mf" ? json["name"] : json["securityname"],
    idcwchangeallowed: json["idcwchangeallowed"],
    schemeoption: json["schemeoption"],
    assettype: json["assettype"],
    schemetype: json["schemetype"],
    nav: (json["nav"] as num?)?.toDouble(),
    navdate: json["navdate"],
    closingbalance: (json["closingbalance"] as num?)?.toDouble(),
    isdemat: json["isdimat"],
    currentmktvalue: (json["currentmktvalue"] as num).toDouble(),
    costvalue: (json["costvalue"] as num).toDouble(),
    gainloss: (json["gainloss"] as num).toDouble(),
    gainlosspercentage: (json["gainlosspercentage"] as num?)?.toDouble(),
    lienunitsflag: json["lienunitsflag"],
    decimalunit: (json["decimalunit"] as num?)?.toDouble(),
    decimalamount: (json["decimalamount"] as num?)?.toDouble(),
    decimalnav: (json["decimalnav"] as num?)?.toDouble(),
    brokercode: json["brokercode"],
    brokername: json["brokername"],
    purallow: json["purallow"],
    redallow: json["redallow"],
    swtallow: json["swtallow"],
    sipallow: json["sipallow"],
    stpallow: json["stpallow"],
    swpallow: json["swpallow"],
    planmode: json["planmode"],
    dpid: json["dpid"],
    mobilerelationship: json["mobilerelationship"],
    emailrelationship: json["emailrelationship"],
    newfolio: json["newfolio"],
    nomineestatus: json["nomineestatus"],
    lienavailableunits: (json["lienavailableunits"] as num?)?.toDouble(),
    investorname: json["investorname"],
    guid: json["guid"],
    quantity: (json["quantity"] as num).toDouble(),
    deltavalue: (json["deltavalue"] as num).toDouble(),
    deltapercentage: (json["deltapercentage"] as num).toDouble(),
    type: typeValues.map[json["type"]]!,
    stockaccountguid: json["stockaccountguid"],
    isin: json["isin"],
    symbol: json["symbol"],
    securityname: json["securityname"],
    status: json["status"],
    buydate: json["buydate"],
    selldate: json["selldate"],
    averageprice: (json["averageprice"] as num?)?.toDouble(),
    currency: json["currency"],
    exchangename: json["exchangename"],
    tradedate: json["tradedate"],
    updatedat: json["updatedat"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "createdat": createdat,
    "userguid": userguid,
    "activestate": activestate,
    "reqid": reqid,
    "amc": amc,
    "amcname": amcname,
    "taxstatus": taxstatus,
    "modeofholding": modeofholding,
    "transactionsource": transactionsource,
    "schemecode": schemecode,
    "name": name,
    "idcwchangeallowed": idcwchangeallowed,
    "schemeoption": schemeoption,
    "assettype": assettype,
    "schemetype": schemetype,
    "nav": nav,
    "navdate": navdate,
    "closingbalance": closingbalance,
    "isdemat": isdemat,
    "currentmktvalue": currentmktvalue,
    "costvalue": costvalue,
    "gainloss": gainloss,
    "gainlosspercentage": gainlosspercentage,
    "lienunitsflag": lienunitsflag,
    "decimalunit": decimalunit,
    "decimalamount": decimalamount,
    "decimalnav": decimalnav,
    "brokercode": brokercode,
    "brokername": brokername,
    "purallow": purallow,
    "redallow": redallow,
    "swtallow": swtallow,
    "sipallow": sipallow,
    "stpallow": stpallow,
    "swpallow": swpallow,
    "planmode": planmode,
    "dpid": dpid,
    "mobilerelationship": mobilerelationship,
    "emailrelationship": emailrelationship,
    "newfolio": newfolio,
    "nomineestatus": nomineestatus,
    "lienavailableunits": lienavailableunits,
    "investorname": investorname,
    "guid": guid,
    "quantity": quantity,
    "deltavalue": deltavalue,
    "deltapercentage": deltapercentage,
    "type": typeValues.reverse[type],
    "stockaccountguid": stockaccountguid,
    "isin": isin,
    "symbol": symbol,
    "securityname": securityname,
    "status": status,
    "buydate": buydate,
    "selldate": selldate,
    "averageprice": averageprice,
    "currency": currency,
    "exchangename": exchangename,
    "tradedate": tradedate,
    "updatedat": updatedat,
  };
}

enum Type { MF, STOCKS }

final typeValues = EnumValues({"mf": Type.MF, "stocks": Type.STOCKS});

class EnumValues<T> {
  Map<String, T> map;
  late Map<T, String> reverseMap;

  EnumValues(this.map);

  Map<T, String> get reverse {
    reverseMap = map.map((k, v) => MapEntry(v, k));
    return reverseMap;
  }
}
