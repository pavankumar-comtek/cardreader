// To parse this JSON data, do
//
//     final cardTokenResponse = cardTokenResponseFromJson(jsonString);

import 'dart:convert';

CardTokenResponse cardTokenResponseFromJson(String str) =>
    CardTokenResponse.fromJson(json.decode(str));

String cardTokenResponseToJson(CardTokenResponse data) =>
    json.encode(data.toJson());

class CardTokenResponse {
  String message;
  Data data;

  CardTokenResponse({
    required this.message,
    required this.data,
  });

  factory CardTokenResponse.fromJson(Map<String, dynamic> json) =>
      CardTokenResponse(
        message: json["message"],
        data: Data.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
        "message": message,
        "data": data.toJson(),
      };
}

class Data {
  List<Card> cards;

  Data({
    required this.cards,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        cards: List<Card>.from(json["cards"].map((x) => Card.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "cards": List<dynamic>.from(cards.map((x) => x.toJson())),
      };
}

class Card {
  String name;
  String last4;
  int expYear;
  int expMonth;
  String id;
  String brand;
  String funding;
  bool isDefault;
  String customer;

  Card({
    required this.name,
    required this.last4,
    required this.expYear,
    required this.expMonth,
    required this.id,
    required this.brand,
    required this.funding,
    required this.isDefault,
    required this.customer,
  });

  factory Card.fromJson(Map<String, dynamic> json) => Card(
        name: json["name"],
        last4: json["last4"],
        expYear: json["expYear"],
        expMonth: json["expMonth"],
        id: json["id"],
        brand: json["brand"],
        funding: json["funding"],
        isDefault: json["isDefault"],
        customer: json["customer"],
      );

  Map<String, dynamic> toJson() => {
        "name": name,
        "last4": last4,
        "expYear": expYear,
        "expMonth": expMonth,
        "id": id,
        "brand": brand,
        "funding": funding,
        "isDefault": isDefault,
        "customer": customer,
      };
}
