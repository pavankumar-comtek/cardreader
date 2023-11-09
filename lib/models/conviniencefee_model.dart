// To parse this JSON data, do
//
//     final convinienceResponse = convinienceResponseFromJson(jsonString);

import 'dart:convert';

ConvinienceResponse convinienceResponseFromJson(String str) => ConvinienceResponse.fromJson(json.decode(str));

String convinienceResponseToJson(ConvinienceResponse data) => json.encode(data.toJson());

class ConvinienceResponse {
    int partnerCommission;
    int chargeAmount;
    int convienceFee;
    int appCommission;
    int operatorCommission;

    ConvinienceResponse({
        required this.partnerCommission,
        required this.chargeAmount,
        required this.convienceFee,
        required this.appCommission,
        required this.operatorCommission,
    });

    factory ConvinienceResponse.fromJson(Map<String, dynamic> json) => ConvinienceResponse(
        partnerCommission: json["partnerCommission"],
        chargeAmount: json["chargeAmount"],
        convienceFee: json["convienceFee"],
        appCommission: json["appCommission"],
        operatorCommission: json["operatorCommission"],
    );

    Map<String, dynamic> toJson() => {
        "partnerCommission": partnerCommission,
        "chargeAmount": chargeAmount,
        "convienceFee": convienceFee,
        "appCommission": appCommission,
        "operatorCommission": operatorCommission,
    };
}
