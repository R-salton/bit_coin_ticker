import 'dart:convert';

import 'package:http/http.dart' as http;

const apiKey = "330EA15F-EA66-4658-9BF5-2B7281ECA17D";
const coinBaseUrl = "https://rest.coinapi.io/v1/exchangerate/BTC/USD?apikey=";

class exchangeRate{



  Future<dynamic> getExhange(String currency) async {
    // var url = Uri.http("www.rest.coinapi.io/v1/exchangerate/BTC/$currency?apikey=$apiKey");
    http.Response response = await http.get(Uri.parse(
        "https://rest.coinapi.io/v1/exchangerate/BTC/$currency?apikey=$apiKey"));
    var data = jsonDecode(response.body);
    print(data);

    return data;
  }
}