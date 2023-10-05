import 'dart:convert';
import 'package:get/get_connect/connect.dart';
import 'package:get_storage/get_storage.dart';

class API extends GetConnect {
  final url = 'https://api.rydeum.info';
  @override
  void onInit() {
    super.onInit();
    httpClient.baseUrl = 'https://api.rydeum.info';
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
    print('Response is ${response.bodyString!}');

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
    print('TOKEEENNENNE dopayment: $token');
    print('Login {$url/master/liquidcashpayment} TOKEN: $token');
    // AppLogger.d('Login {$url/customer/signIn}');
    print('Data - ${json.encode(paymentModel)}');
    final response = await post(
      '$url/master/liquidcashpayment',
      jsonEncode(json.encode(paymentModel)),
      headers: header(1, token),
    );
    print('Response is rama ${response.status.code}\n');
    print('Response is ${response.bodyString!}');
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
}
