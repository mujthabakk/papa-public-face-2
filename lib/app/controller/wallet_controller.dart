import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jiffy/jiffy.dart';
import 'package:salon_user/app/backend/api/api_response.dart';
import 'package:salon_user/app/backend/api/handler.dart';
import 'package:salon_user/app/backend/models/wallet_model.dart';
import 'package:salon_user/app/backend/parse/wallet_parse.dart';
import 'package:salon_user/app/util/constant.dart';

class WalletController extends GetxController implements GetxService {
  final WalletParser parser;
  bool apiCalled = false;

  List<WalletModel> _walletList = <WalletModel>[];
  List<WalletModel> get walletList => _walletList;

  String currencySide = AppConstants.defaultCurrencySide;
  String currencySymbol = AppConstants.defaultCurrencySymbol;

  double amount = 0.0;
  WalletController({required this.parser});

  @override
  void onInit() {
    super.onInit();
    currencySide = parser.getCurrencySide();
    currencySymbol = parser.getCurrencySymbol();
    getWallet();
  }

  Future<void> getWallet() async {
    Response response = await parser.getWallet();
    apiCalled = true;
    if (response.statusCode == 200) {
      Map<String, dynamic> myMap = Map<String, dynamic>.from(response.body);
      var transactions = myMap['transactions'];
      dynamic user = myMap['data'];
      if (user is Map && user['balance'] != null) {
        amount = double.tryParse(user['balance'].toString()) ?? amount;
      }
      _walletList = [];
      if (transactions is List) {
        for (final element in transactions) {
          if (element is! Map) continue;
          WalletModel ele =
              WalletModel.fromJson(Map<String, dynamic>.from(element));
          ele.createdAt =
              Jiffy.parse(ele.createdAt ?? '').format(pattern: 'yMMMMd');
          _walletList.add(ele);
        }
      }
    } else {
      ApiChecker.checkApi(response);
    }
    await refreshBalance();
    update();
  }

  Future<void> refreshBalance() async {
    try {
      final response = await parser.getMyWalletBalance();
      if (response.statusCode != 200) return;
      final map = ApiBody.asMap(response.body);
      final data = map?['data'];
      if (data is Map && data['balance'] != null) {
        amount = double.tryParse(data['balance'].toString()) ?? amount;
      }
    } catch (e) {
      debugPrint('refreshBalance: $e');
    }
    update();
  }
}
