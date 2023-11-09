import 'dart:convert';
import 'dart:developer';
import 'package:get/get_connect/connect.dart';
import 'package:get_storage/get_storage.dart';

class API extends GetConnect {
  final url = 'https://api.rydeum.info';
  String authToken = '';
  @override
  void onInit() {
    super.onInit();
    //httpClient.baseUrl = 'https://api.rydeum.info';
    httpClient.defaultContentType = 'application/json';
    httpClient.timeout = const Duration(seconds: 8);
  }

  // factory API() => _instance;
  // API._internal();
  // void setToken(){
  //   httpClient.
  // }
  Map<String, String> header(int tokenType, String token) {
    Map<String, String> headers = {};

    if (tokenType == 0) {
      headers = {'Content-Type': 'application/json', 'lan': 'en'};
    } else if (tokenType == 1) {
      // final box = GetStorage();
      // final token = box.read('TOKEN');
      headers = {
        // 'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
        'lan': 'en',
        'Content-Type': 'application/json',
      };
    } else if (tokenType == 2) {
      const token =
          'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJlbWFpbCI6IjIxbWFoZXNoZEBnbWFpbC5jb20iLCJzdWIiOiI2MjBhNTFkN2UxNzg1NjFkYWI1ZjM2ZTUiLCJpZCI6IjYyMGE1MWQ3ZTE3ODU2MWRhYjVmMzZlNSIsImdyYW50VHlwZSI6ImFjY2VzcyIsImlhdCI6MTY0NTIwMzc4NSwiZXhwIjoxNjQ2MDQzNzg1fQ.xYLSg6wJypAybSHhmqoAygV5xJJGR0UngJlv7F7Ooog';
      headers = {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      };
    }

    return headers;
  }

  Future<Map<String, dynamic>> users(String numbers) async {
    final response = await get('https://lookup.binlist.net/$numbers');
    print('Flutter Module -Response is ${response.bodyString!}');

    if (response.status.hasError) {
      return Future.error(response.statusText!);
      // return Future.error(response.statusText!);
    } else {
      return response.body;
    }
  }

  Future<Map<String, dynamic>> dopayment(Map paymentModel, String token) async {
    // final box1 = GetStorage();
    // final token = box1.read('TOKEN');
    print('Flutter Module -Flutter Module -TOKEEENNENNE dopayment: $token');
    print('Flutter Module -Login {$url/master/liquidcashpayment} TOKEN: $token');
    // AppLogger.d('Login {$url/customer/signIn}');
    print('Flutter Module -Data - ${json.encode(paymentModel)}');
    final response = await post(
      '$url/master/liquidcashpayment',
      jsonEncode(json.encode(paymentModel)),
      headers: header(1, token),
    );
    print('Flutter Module -Response is rama ${response.status.code}\n');
    print('Flutter Module -Response is ${response.bodyString!}');
    if (response.status.hasError) {
      if (response.body != null) {
        if (response.body['message'].toString() != 'null') {
          return Future.error("${response.body['message']}");
        } else {
          return Future.error(response.bodyString!);
        }
      } else {
        return Future.error('Somthing went wrong. Please try Again!');
      }
    } else {
      return response.body;
    }
  }

  //post request
  Future<Map<String, dynamic>> generateToken(
      String name, String cardToken) async {
    print("Flutter Module -generateToken $name $cardToken $authToken");
    final response = await post(
      '$url/master/card/customer',
      jsonEncode({
        "name": name,
        "cardToken": cardToken,
      }),
      headers: header(1, authToken),
    );

    if (response.status.hasError) {
      print("Flutter Module -"+response.body);
      if (response.status.code == 401 ||
          response.status.code == 404 ||
          response.status.code == 500) {
        return Future.error("${response.body['message']}");
      } else if (response.body != null) {
        if (response.body['message'].toString() != 'null') {
          return Future.error("${response.body['message']}");
        } else {
          return Future.error(response.bodyString!);
        }
      } else {
        return Future.error('Somthing went wrong. Please try Again!');
      }
    } else {
      print('Flutter Module -Response is rama ${response.status.code}\n');
      print('Flutter Module -Response is ${response.bodyString!}');
      return jsonDecode(response.bodyString!);
    }
  }

  //write a post request with name charge card convinience fees
  Future<Map<String, dynamic>> chargeCardConvinienceFees(
    double amount,
  ) async {
    final response = await post(
        'https://payment.rydeum.info/partner/charge_card_convinience_fee',
        jsonEncode({
          "amount": amount,
        }),
        headers: {
          'Authorization': authToken,
          'Content-Type': 'application/json',
        });

    if (response.status.hasError) {
      print('Flutter Module -Error is ${response.bodyString!}');
      if (response.body != null) {
        if (response.body['message'].toString() != 'null') {
          return Future.error("${response.body['message']}");
        } else {
          return Future.error(response.bodyString!);
        }
      } else {
        return Future.error('Somthing went wrong. Please try Again!');
      }
    } else {
      print('Flutter Module -Response is rama ${response.status.code}\n');
      print('Flutter Module -Response is ${response.bodyString!}');
      return jsonDecode(response.bodyString!);
    }
  }

  //Write a post request to charge card
  Future<Map<String, dynamic>> chargeCard(double amount, String cardId,
      String stripeCustomerId, double tipAmount) async {
    print(
      "Flutter Module -chargeCard $amount $cardId $stripeCustomerId $tipAmount $authToken",
    );
    print(jsonEncode({
      "amount": amount,
      "cardId": cardId,
      "customer": {"stripeCustomerId": stripeCustomerId},
      "tipAmount": tipAmount
    }));

    final response = await post(
        'https://payment.rydeum.info/partner/charge_card',
        jsonEncode({
          "amount": amount,
          "cardId": cardId,
          "customer": {"stripeCustomerId": stripeCustomerId},
          "tipAmount": tipAmount
        }),
        headers: {
          'Authorization': authToken,
          'Content-Type': 'application/json',
        });
    print("Flutter Module -${response.bodyString!}");
    if (response.status.hasError) {
      print("Flutter Module -chargeCard ${response.bodyString!}");
      if (response.body != null) {
        if (response.body['message'].toString() != 'null') {
          return Future.error("${response.body['message']}");
        } else {
          return Future.error(response.bodyString!);
        }
      } else {
        return Future.error('Somthing went wrong. Please try Again!');
      }
    } else {
      print('Flutter Module -Response is rama ${response.status.code}\n');
      print('Flutter Module -Response is ${response.bodyString!}');
      return jsonDecode(response.bodyString!);
    }
  }
}

final api = API();
