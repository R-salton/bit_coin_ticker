import 'dart:convert';

import 'package:bitcoin_ticker/coin_data.dart';
import 'package:bitcoin_ticker/exchange.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'dart:io' show Platform;

class PriceScreen extends StatefulWidget {
  const PriceScreen({super.key});

  @override
  _PriceScreenState createState() => _PriceScreenState();
}

class _PriceScreenState extends State<PriceScreen> {
  String? selectedCurrency = "USD";
  List<dynamic> exchangeRateData = [];

  Map btc = {};
  Map eth = {};
  Map ltc = {};
  exchangeRate getExchangeRate = exchangeRate();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getExhange("USD");
    print(exchangeRateData);
  }

  Future<dynamic> getExhange(String currency) async {
    var data = await getExchangeRate.getExhange(currency);
    print(data);

    exchangeRateData = data;
    btc = exchangeRateData[0];
    eth = exchangeRateData[1];
    ltc = exchangeRateData[2];
  }

// ANDROID DROPDOWN
  DropdownButton<String> androidDropdown() {
    List<DropdownMenuItem<String>> dropdownItems = [];
    for (String currency in currenciesList) {
      var newItem = DropdownMenuItem(
        value: currency,
        child: Text(currency),
      );
      dropdownItems.add(newItem);
    }

    return DropdownButton<String>(
      items: dropdownItems,
      onChanged: (value) {
        setState(() {
          selectedCurrency = value;
        });
      },
      value: selectedCurrency,
    );
  }

  // iOS DROPDOWN
  CupertinoPicker iosPicker() {
    List<Text> pickerItems = [];
    for (String currency in currenciesList) {
      pickerItems.add(
        Text(currency),
      );
    }

    return CupertinoPicker(
      itemExtent: 34.0,
      backgroundColor: Colors.lightBlue,
      onSelectedItemChanged: (value) {
        // print(value);
      },
      children: pickerItems,
    );
  }

  Widget getPicker() {
    if (Platform.isAndroid) {
      return androidDropdown();
    } else if (Platform.isIOS) {
      return iosPicker();
    } else {
      return androidDropdown();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('🤑 Coin Ticker'),
        centerTitle: true,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.fromLTRB(18.0, 18.0, 18.0, 0),
            child: CardCoin(
              coin: btc["asset_id_base"],
              currency: btc["asset_id_quote"],
              exachangeRate: btc["rate"],
            ),
          ),
          Container(
            height: 150.0,
            alignment: Alignment.center,
            padding: const EdgeInsets.only(bottom: 30.0),
            color: Colors.lightBlue,
            child: Platform.isIOS ? iosPicker() : androidDropdown(),
          ),
        ],
      ),
    );
  }
}

class CardCoin extends StatelessWidget {
  CardCoin({super.key, this.currency, this.coin, this.exachangeRate});

  String? currency;
  String? coin;
  double? exachangeRate;
  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.lightBlueAccent,
      elevation: 5.0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 15.0, horizontal: 28.0),
        child: Text(
          '1 $coin = $exachangeRate $currency',
          textAlign: TextAlign.center,
          style: const TextStyle(
            fontSize: 20.0,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}
