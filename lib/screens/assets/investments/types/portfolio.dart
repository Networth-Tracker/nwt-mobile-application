
class InvestmentPortfolioResponse {
    int status;
    String message;
    InvestmentPortfolio? data;

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
    int value;
    int invested;
    int gain;
    DateTime lastdatafetch;
    String lastdatafetchtime;

    InvestmentPortfolio({
        required this.value,
        required this.invested,
        required this.gain,
        required this.lastdatafetch,
        required this.lastdatafetchtime,
    });

    factory InvestmentPortfolio.fromJson(Map<String, dynamic> json) => InvestmentPortfolio(
        value: json["value"],
        invested: json["invested"],
        gain: json["gain"],
        lastdatafetch: DateTime.parse(json["lastdatafetch"]),
        lastdatafetchtime: json["lastdatafetchtime"],
    );

    Map<String, dynamic> toJson() => {
        "value": value,
        "invested": invested,
        "gain": gain,
        "lastdatafetch": lastdatafetch.toIso8601String(),
        "lastdatafetchtime": lastdatafetchtime,
    };
}
