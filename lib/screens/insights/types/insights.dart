class MutualFundInsightRespose {
  int status;
  String message;
  InsightsSummary? data;

  MutualFundInsightRespose({
    required this.status,
    required this.message,
    this.data,
  });

  factory MutualFundInsightRespose.fromJson(
    Map<String, dynamic> json,
  ) => MutualFundInsightRespose(
    status: json["status"],
    message: json["message"],
    data: json["data"] != null ? InsightsSummary.fromJson(json["data"]) : null,
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "message": message,
    "data": data?.toJson(),
  };
}

class InsightsSummary {
  String fundname;
  String fundtype;
  double nav;
  double navdelta;
  Mfreturnandsipreturn mfreturnandsipreturn;
  Funddetail funddetail;
  Assetallocation assetallocation;
  Sipdetail sipdetail;
  Funddistributionequity funddistributionequity;
  Funddistributiondebtcash funddistributiondebtcash;
  Sectorallocation sectorallocation;
  List<Dividendhistory> dividendhistory;
  List<Top20Holding> top20Holding;
  Riskometer riskometer;

  InsightsSummary({
    required this.fundname,
    required this.fundtype,
    required this.nav,
    required this.navdelta,
    required this.mfreturnandsipreturn,
    required this.funddetail,
    required this.assetallocation,
    required this.sipdetail,
    required this.funddistributionequity,
    required this.funddistributiondebtcash,
    required this.sectorallocation,
    required this.dividendhistory,
    required this.top20Holding,
    required this.riskometer,
  });

  factory InsightsSummary.fromJson(Map<String, dynamic> json) =>
      InsightsSummary(
        fundname: json["fundname"],
        fundtype: json["fundtype"],
        nav: json["nav"]?.toDouble() ?? 0.0,
        navdelta: json["navdelta"]?.toDouble() ?? 0.0,
        mfreturnandsipreturn: Mfreturnandsipreturn.fromJson(
          json["mfreturnandsipreturn"],
        ),
        funddetail: Funddetail.fromJson(json["funddetail"]),
        assetallocation: Assetallocation.fromJson(json["assetallocation"]),
        sipdetail: Sipdetail.fromJson(json["sipdetail"]),
        funddistributionequity: Funddistributionequity.fromJson(
          json["funddistributionequity"],
        ),
        funddistributiondebtcash: Funddistributiondebtcash.fromJson(
          json["funddistributiondebtcash"],
        ),
        sectorallocation: Sectorallocation.fromJson(json["sectorallocation"]),
        dividendhistory: List<Dividendhistory>.from(
          json["dividendhistory"].map((x) => Dividendhistory.fromJson(x)),
        ),
        top20Holding: List<Top20Holding>.from(
          json["top20holding"].map((x) => Top20Holding.fromJson(x)),
        ),
        riskometer: Riskometer.fromJson(json["riskometer"]),
      );

  Map<String, dynamic> toJson() => {
    "fundname": fundname,
    "fundtype": fundtype,
    "nav": nav,
    "navdelta": navdelta,
    "mfreturnandsipreturn": mfreturnandsipreturn.toJson(),
    "funddetail": funddetail.toJson(),
    "assetallocation": assetallocation.toJson(),
    "sipdetail": sipdetail.toJson(),
    "funddistributionequity": funddistributionequity.toJson(),
    "funddistributiondebtcash": funddistributiondebtcash.toJson(),
    "sectorallocation": sectorallocation.toJson(),
    "dividendhistory": List<dynamic>.from(
      dividendhistory.map((x) => x.toJson()),
    ),
    "top20holding": List<dynamic>.from(top20Holding.map((x) => x.toJson())),
    "riskometer": riskometer.toJson(),
  };
}

class Assetallocation {
  double equity;
  double debt;
  double hybrid;

  Assetallocation({
    required this.equity,
    required this.debt,
    required this.hybrid,
  });

  factory Assetallocation.fromJson(Map<String, dynamic> json) =>
      Assetallocation(
        equity: json["equity"]?.toDouble() ?? 0.0,
        debt: json["debt"]?.toDouble() ?? 0.0,
        hybrid: json["hybrid"]?.toDouble() ?? 0.0,
      );

  Map<String, dynamic> toJson() => {
    "equity": equity,
    "debt": debt,
    "hybrid": hybrid,
  };
}

class Dividendhistory {
  DateTime recorddate;
  double dividend;

  Dividendhistory({required this.recorddate, required this.dividend});

  factory Dividendhistory.fromJson(Map<String, dynamic> json) =>
      Dividendhistory(
        recorddate: DateTime.parse(json["recorddate"]),
        dividend: json["dividend"]?.toDouble(),
      );

  Map<String, dynamic> toJson() => {
    "recorddate":
        "${recorddate.year.toString().padLeft(4, '0')}-${recorddate.month.toString().padLeft(2, '0')}-${recorddate.day.toString().padLeft(2, '0')}",
    "dividend": dividend,
  };
}

class Funddetail {
  double expenseratio;
  double churn;
  String investmentstyle;
  String fundmanager;
  double aum;
  String exitload;

  Funddetail({
    required this.expenseratio,
    required this.churn,
    required this.investmentstyle,
    required this.fundmanager,
    required this.aum,
    required this.exitload,
  });

  factory Funddetail.fromJson(Map<String, dynamic> json) => Funddetail(
    expenseratio: json["expenseratio"]?.toDouble() ?? 0.0,
    churn: json["churn"]?.toDouble() ?? 0.0,
    investmentstyle: json["investmentstyle"],
    fundmanager: json["fundmanager"],
    aum: json["aum"]?.toDouble() ?? 0.0,
    exitload: json["exitload"],
  );

  Map<String, dynamic> toJson() => {
    "expenseratio": expenseratio,
    "churn": churn,
    "investmentstyle": investmentstyle,
    "fundmanager": fundmanager,
    "aum": aum,
    "exitload": exitload,
  };
}

class Funddistributiondebtcash {
  double aaa;

  Funddistributiondebtcash({required this.aaa});

  factory Funddistributiondebtcash.fromJson(Map<String, dynamic> json) =>
      Funddistributiondebtcash(aaa: json["aaa"]?.toDouble() ?? 0.0);

  Map<String, dynamic> toJson() => {"aaa": aaa};
}

class Funddistributionequity {
  double midcap;
  double largecap;
  double smallcap;

  Funddistributionequity({
    required this.midcap,
    required this.largecap,
    required this.smallcap,
  });

  factory Funddistributionequity.fromJson(Map<String, dynamic> json) =>
      Funddistributionequity(
        midcap: json["midcap"]?.toDouble() ?? 0.0,
        largecap: json["largecap"]?.toDouble() ?? 0.0,
        smallcap: json["smallcap"]?.toDouble() ?? 0.0,
      );

  Map<String, dynamic> toJson() => {
    "midcap": midcap,
    "largecap": largecap,
    "smallcap": smallcap,
  };
}

class Mfreturnandsipreturn {
  Return mfreturnandsipreturnReturn;
  Return sipreturn;

  Mfreturnandsipreturn({
    required this.mfreturnandsipreturnReturn,
    required this.sipreturn,
  });

  factory Mfreturnandsipreturn.fromJson(Map<String, dynamic> json) =>
      Mfreturnandsipreturn(
        mfreturnandsipreturnReturn: Return.fromJson(json["return"]),
        sipreturn: Return.fromJson(json["sipreturn"]),
      );

  Map<String, dynamic> toJson() => {
    "return": mfreturnandsipreturnReturn.toJson(),
    "sipreturn": sipreturn.toJson(),
  };
}

class Return {
  List<MFPerformanceDataPoint> oneMonth;
  List<MFPerformanceDataPoint> threeMonths;
  List<MFPerformanceDataPoint> sixMonths;
  List<MFPerformanceDataPoint> oneYear;
  List<MFPerformanceDataPoint> fiveYears;
  List<MFPerformanceDataPoint> tenYears;

  Return({
    required this.oneMonth,
    required this.threeMonths,
    required this.sixMonths,
    required this.oneYear,
    required this.fiveYears,
    required this.tenYears,
  });

  factory Return.fromJson(Map<String, dynamic> json) => Return(
    oneMonth: List<MFPerformanceDataPoint>.from(
      json["1m"].map((x) => MFPerformanceDataPoint.fromJson(x)),
    ),
    threeMonths: List<MFPerformanceDataPoint>.from(
      json["3m"].map((x) => MFPerformanceDataPoint.fromJson(x)),
    ),
    sixMonths: List<MFPerformanceDataPoint>.from(
      json["6m"].map((x) => MFPerformanceDataPoint.fromJson(x)),
    ),
    oneYear: List<MFPerformanceDataPoint>.from(
      json["1y"].map((x) => MFPerformanceDataPoint.fromJson(x)),
    ),
    fiveYears: List<MFPerformanceDataPoint>.from(
      json["5y"].map((x) => MFPerformanceDataPoint.fromJson(x)),
    ),
    tenYears: List<MFPerformanceDataPoint>.from(
      json["10y"].map((x) => MFPerformanceDataPoint.fromJson(x)),
    ),
  );

  Map<String, dynamic> toJson() => {
    "1m": List<dynamic>.from(oneMonth.map((x) => x.toJson())),
    "3m": List<dynamic>.from(threeMonths.map((x) => x.toJson())),
    "6m": List<dynamic>.from(sixMonths.map((x) => x.toJson())),
    "1y": List<dynamic>.from(oneYear.map((x) => x.toJson())),
    "5y": List<dynamic>.from(fiveYears.map((x) => x.toJson())),
    "10y": List<dynamic>.from(tenYears.map((x) => x.toJson())),
  };
}

class MFPerformanceDataPoint {
  String date;
  double value;

  MFPerformanceDataPoint({required this.date, required this.value});

  factory MFPerformanceDataPoint.fromJson(Map<String, dynamic> json) =>
      MFPerformanceDataPoint(
        date: json["date"],
        value: json["value"]?.toDouble(),
      );

  Map<String, dynamic> toJson() => {"date": date, "value": value};
}

class Riskometer {
  String name;

  Riskometer({required this.name});

  factory Riskometer.fromJson(Map<String, dynamic> json) =>
      Riskometer(name: json["name"]);

  Map<String, dynamic> toJson() => {"name": name};
}

class Sectorallocation {
  double financialservices;
  double tech;
  double industrial;
  double realestate;
  double health;
  double utilities;

  Sectorallocation({
    required this.financialservices,
    required this.tech,
    required this.industrial,
    required this.realestate,
    required this.health,
    required this.utilities,
  });

  factory Sectorallocation.fromJson(Map<String, dynamic> json) =>
      Sectorallocation(
        financialservices: json["financialservices"]?.toDouble() ?? 0.0,
        tech: json["tech"]?.toDouble() ?? 0.0,
        industrial: json["industrial"]?.toDouble() ?? 0.0,
        realestate: json["realestate"]?.toDouble() ?? 0.0,
        health: json["health"]?.toDouble() ?? 0.0,
        utilities: json["utilities"]?.toDouble() ?? 0.0,
      );

  Map<String, dynamic> toJson() => {
    "financialservices": financialservices,
    "tech": tech,
    "industrial": industrial,
    "realestate": realestate,
    "health": health,
    "utilities": utilities,
  };
}

class Sipdetail {
  double minimumsip;
  double maximumsip;
  String frequency;
  String lockinperiod;

  Sipdetail({
    required this.minimumsip,
    required this.maximumsip,
    required this.frequency,
    required this.lockinperiod,
  });

  factory Sipdetail.fromJson(Map<String, dynamic> json) => Sipdetail(
    minimumsip: json["minimumsip"]?.toDouble() ?? 0.0,
    maximumsip: json["maximumsip"]?.toDouble() ?? 0.0,
    frequency: json["frequency"],
    lockinperiod: json["lockinperiod"],
  );

  Map<String, dynamic> toJson() => {
    "minimumsip": minimumsip,
    "maximumsip": maximumsip,
    "frequency": frequency,
    "lockinperiod": lockinperiod,
  };
}

class Top20Holding {
  String name;
  double value;

  Top20Holding({required this.name, required this.value});

  factory Top20Holding.fromJson(Map<String, dynamic> json) =>
      Top20Holding(name: json["name"], value: json["value"]?.toDouble());

  Map<String, dynamic> toJson() => {"name": name, "value": value};
}
