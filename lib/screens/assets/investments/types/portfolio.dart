
class InvestmentPortfolioResponse {
    int status;
    String message;
    InvestmentPortfolio? data;
    bool get success => status == 200 || status == 201;

    InvestmentPortfolioResponse({
        required this.status,
        required this.message,
         this.data,
    });

    factory InvestmentPortfolioResponse.fromJson(Map<String, dynamic> json) => InvestmentPortfolioResponse(
        status: json["status"],
        message: json["message"],
        data: json["data"] != null ? InvestmentPortfolio.fromJson(json["data"]) : null,
    );

    Map<String, dynamic> toJson() => {
        "status": status,
        "message": message,
        "data": data?.toJson(),
    };
}

class InvestmentPortfolio {
    double value;
    double invested;
    double gain;
    DateTime lastdatafetch;
    String lastdatafetchtime;
    double deltavalue;
    double deltapercentage;
    Coverage coverage;

    InvestmentPortfolio({
        required this.value,
        required this.invested,
        required this.gain,
        required this.lastdatafetch,
        required this.lastdatafetchtime,
        required this.deltavalue,
        required this.deltapercentage,
        required this.coverage,
    });

    factory InvestmentPortfolio.fromJson(Map<String, dynamic> json) => InvestmentPortfolio(
        value: json["value"] + 0.0,
        invested: json["invested"] + 0.0,
        gain: json["gain"] + 0.0,
        lastdatafetch: DateTime.parse(json["lastdatafetch"]),
        lastdatafetchtime: json["lastdatafetchtime"],
        deltavalue: json["deltavalue"] + 0.0,
        deltapercentage: json["deltapercentage"] + 0.0,
        coverage: Coverage.fromJson(json["coverage"]),
    );

    Map<String, dynamic> toJson() => {
        "value": value,
        "invested": invested,
        "gain": gain,
        "lastdatafetch": lastdatafetch.toIso8601String(),
        "lastdatafetchtime": lastdatafetchtime,
        "deltavalue": deltavalue,
        "deltapercentage": deltapercentage,
        "coverage": coverage.toJson(),
    };
}

class Coverage {
    double stocks;
    double mutualfunds;
    double commodities;
    double fo;

    Coverage({
        required this.stocks,
        required this.mutualfunds,
        required this.commodities,
        required this.fo,
    });

    factory Coverage.fromJson(Map<String, dynamic> json) => Coverage(
        stocks: json["stocks"] + 0.0,
        mutualfunds: json["mutualfunds"] + 0.0,
        commodities: json["commodities"] + 0.0,
        fo: json["fo"] + 0.0,
    );

    Map<String, dynamic> toJson() => {
        "stocks": stocks,
        "mutualfunds": mutualfunds,
        "commodities": commodities,
        "fo": fo,
    };
}
