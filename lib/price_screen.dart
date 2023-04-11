import 'package:bitcoin_ticker/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart' as cupertino;
import 'package:bitcoin_ticker/coin_data.dart';

class PriceScreen extends StatefulWidget {
  const PriceScreen({super.key});

  @override
  State<PriceScreen> createState() => _PriceScreenState();
}

class _PriceScreenState extends State<PriceScreen> {
  //Exchange rate variables
  List<Widget> _result = [];

  //Choosing currency widget
  Widget? _choosingCurrencyWidget;
  String? _targetCoin;
  final List<DropdownMenuItem<String>> _dropdownMenuItems = [];

  //Cupertino specific attributes
  final List<Text> _cupertinoPickerMenuItems = [];

  //Methods
  Future<String?> _getTargetExchangeRate({
    required String baseCoin,
    required String targetCoin,
  }) async {
    double? result = await CoinData.getCoinExchangeRate(
        baseCoin: baseCoin, targetCoin: targetCoin);
    if (result != null) {
      return result.toStringAsFixed(0);
    }
    return null;
  }

  void _initChoosingCurrencyWidgetLists() {
    if (kUsesCupertino) {
      for (String currency in kCurrenciesList) {
        _cupertinoPickerMenuItems.add(Text(currency));
      }
    } else {
      for (String currency in kCurrenciesList) {
        _dropdownMenuItems.add(DropdownMenuItem(
          value: currency,
          child: Text(currency),
        ));
      }
    }
  }

  Widget _initChoosingCurrencyWidget() {
    if (kUsesCupertino) {
      _targetCoin = _cupertinoPickerMenuItems[0].data;
      return cupertino.CupertinoPicker(
        itemExtent: 30,
        onSelectedItemChanged: (selectedIndex) {
          _targetCoin = _cupertinoPickerMenuItems[selectedIndex].data;
          _updateResult();
        },
        children: _cupertinoPickerMenuItems,
      );
    } else {
      _targetCoin = kCurrenciesList[0];
      return _getDropDownButton(value: kCurrenciesList[0]);
    }
  }

  DropdownButton<String> _getDropDownButton({String? value}) {
    return DropdownButton<String>(
        value: value,
        items: _dropdownMenuItems,
        onChanged: (newValue) {
          if (newValue != null) {
            _targetCoin = newValue;
            setState(() {
              _choosingCurrencyWidget = _getDropDownButton(value: _targetCoin);
            });
            _updateResult();
          }
        });
  }

  Card _getResultCard(
      {required String baseCoin, required String targetCoinExchangeRate}) {
    return Card(
      color: Colors.lightBlueAccent,
      elevation: 5.0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 15.0, horizontal: 28.0),
        child: Text(
          '1 $baseCoin = $targetCoinExchangeRate $_targetCoin',
          textAlign: TextAlign.center,
          style: const TextStyle(
            fontSize: 20.0,
            color: Colors.white,
          ),
        ),
      ),
    );
  }

  void _updateResult() async {
    List<Widget> tmp = [];
    for (String baseCoin in kCryptoList) {
      tmp.add(
        _getResultCard(baseCoin: baseCoin, targetCoinExchangeRate: '?'),
      );
      //Waiting
      setState(() {
        _result = tmp;
      });
    }

    String? targetCoinExchangeRate;
    tmp = [];
    for (String baseCoin in kCryptoList) {
      targetCoinExchangeRate = await _getTargetExchangeRate(
          baseCoin: baseCoin, targetCoin: _targetCoin!);
      tmp.add(
        _getResultCard(
            baseCoin: baseCoin,
            targetCoinExchangeRate: targetCoinExchangeRate ?? '???'),
      );
      //Final Result
      setState(() {
        _result = tmp;
      });
    }
  }

  @override
  void initState() {
    _initChoosingCurrencyWidgetLists();
    _choosingCurrencyWidget = _initChoosingCurrencyWidget();
    _updateResult();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('🤑 Coin Ticker'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.fromLTRB(18.0, 18.0, 18.0, 0),
            child: Column(
              children: _result,
            ),
          ),
          Container(
            height: 150.0,
            alignment: Alignment.center,
            padding: const EdgeInsets.only(bottom: 30.0),
            color: Colors.lightBlue,
            child: _choosingCurrencyWidget,
          ),
        ],
      ),
    );
  }
}
