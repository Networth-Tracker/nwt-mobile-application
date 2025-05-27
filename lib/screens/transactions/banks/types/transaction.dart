class BankTransactionResponse {
  int status;
  String message;
  TransactionData? data;
  bool get success => status == 200 || status == 201;
  

  BankTransactionResponse({
    required this.status,
    required this.message,
    this.data,
  });

  factory BankTransactionResponse.fromJson(
    Map<String, dynamic> json,
  ) => BankTransactionResponse(
    status: json["status"],
    message: json["message"],
    data: json["data"] != null ? TransactionData.fromJson(json["data"]) : null,
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "message": message,
    "data": data?.toJson(),
  };
}

class TransactionData {
  List<Banktransation> banktransations;

  TransactionData({required this.banktransations});

  factory TransactionData.fromJson(Map<String, dynamic> json) =>
      TransactionData(
        banktransations: List<Banktransation>.from(
          json["banktransations"].map((x) => Banktransation.fromJson(x)),
        ),
      );

  Map<String, dynamic> toJson() => {
    "banktransations": List<dynamic>.from(
      banktransations.map((x) => x.toJson()),
    ),
  };
}

class Banktransation {
  int id;
  String guid;
  String txnid;
  Bankaccountguid bankaccountguid;
  Userguid userguid;
  Type type;
  String mode;
  int amount;
  int transactionalbalance;
  DateTime transactiontimestamp;
  DateTime valuedate;
  String narration;
  String reference;
  bool finishedprocess;
  bool activestate;
  DateTime createdat;
  dynamic updatedat;

  Banktransation({
    required this.id,
    required this.guid,
    required this.txnid,
    required this.bankaccountguid,
    required this.userguid,
    required this.type,
    required this.mode,
    required this.amount,
    required this.transactionalbalance,
    required this.transactiontimestamp,
    required this.valuedate,
    required this.narration,
    required this.reference,
    required this.finishedprocess,
    required this.activestate,
    required this.createdat,
    required this.updatedat,
  });

  factory Banktransation.fromJson(Map<String, dynamic> json) => Banktransation(
    id: json["id"],
    guid: json["guid"],
    txnid: json["txnid"],
    bankaccountguid: bankaccountguidValues.map[json["bankaccountguid"]]!,
    userguid: userguidValues.map[json["userguid"]]!,
    type: typeValues.map[json["type"]]!,
    mode: json["mode"],
    amount: json["amount"],
    transactionalbalance: json["transactionalbalance"],
    transactiontimestamp: DateTime.parse(json["transactiontimestamp"]),
    valuedate: DateTime.parse(json["valuedate"]),
    narration: json["narration"],
    reference: json["reference"],
    finishedprocess: json["finishedprocess"],
    activestate: json["activestate"],
    createdat: DateTime.parse(json["createdat"]),
    updatedat: json["updatedat"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "guid": guid,
    "txnid": txnid,
    "bankaccountguid": bankaccountguidValues.reverse[bankaccountguid],
    "userguid": userguidValues.reverse[userguid],
    "type": typeValues.reverse[type],
    "mode": mode,
    "amount": amount,
    "transactionalbalance": transactionalbalance,
    "transactiontimestamp": transactiontimestamp.toIso8601String(),
    "valuedate": valuedate.toIso8601String(),
    "narration": narration,
    "reference": reference,
    "finishedprocess": finishedprocess,
    "activestate": activestate,
    "createdat": createdat.toIso8601String(),
    "updatedat": updatedat,
  };
}

enum Bankaccountguid { B_1747388324308 }

final bankaccountguidValues = EnumValues({
  "B_1747388324308": Bankaccountguid.B_1747388324308,
});

enum Type { CREDIT, DEBIT }

final typeValues = EnumValues({"CREDIT": Type.CREDIT, "DEBIT": Type.DEBIT});

enum Userguid { U_1747255155127 }

final userguidValues = EnumValues({
  "U_1747255155127": Userguid.U_1747255155127,
});

class EnumValues<T> {
  Map<String, T> map;
  late Map<T, String> reverseMap;

  EnumValues(this.map);

  Map<T, String> get reverse {
    reverseMap = map.map((k, v) => MapEntry(v, k));
    return reverseMap;
  }
}
