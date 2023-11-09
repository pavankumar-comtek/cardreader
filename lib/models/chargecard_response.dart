// To parse this JSON data, do
//
//     final chargeCardResponse = chargeCardResponseFromJson(jsonString);

import 'dart:convert';

ChargeCardResponse chargeCardResponseFromJson(String str) => ChargeCardResponse.fromJson(json.decode(str));

String chargeCardResponseToJson(ChargeCardResponse data) => json.encode(data.toJson());

class ChargeCardResponse {
    String message;
    ChargeCardData data;

    ChargeCardResponse({
        required this.message,
        required this.data,
    });

    factory ChargeCardResponse.fromJson(Map<String, dynamic> json) => ChargeCardResponse(
        message: json["message"],
        data: ChargeCardData.fromJson(json["data"]),
    );

    Map<String, dynamic> toJson() => {
        "message": message,
        "data": data.toJson(),
    };
}

class ChargeCardData {
    String currencySymbol;
    String currencyAbbr;
    double walletBalance;
    int walletSoftLimit;
    int walletHardLimit;

    ChargeCardData({
        required this.currencySymbol,
        required this.currencyAbbr,
        required this.walletBalance,
        required this.walletSoftLimit,
        required this.walletHardLimit,
    });

    factory ChargeCardData.fromJson(Map<String, dynamic> json) => ChargeCardData(
        currencySymbol: json["currencySymbol"],
        currencyAbbr: json["currencyAbbr"],
        walletBalance: json["walletBalance"]?.toDouble(),
        walletSoftLimit: json["walletSoftLimit"],
        walletHardLimit: json["walletHardLimit"],
    );

    Map<String, dynamic> toJson() => {
        "currencySymbol": currencySymbol,
        "currencyAbbr": currencyAbbr,
        "walletBalance": walletBalance,
        "walletSoftLimit": walletSoftLimit,
        "walletHardLimit": walletHardLimit,
    };
}
