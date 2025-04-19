import 'dart:io';

import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:salon_user/app/backend/api/handler.dart';
import 'package:salon_user/app/backend/models/redeem_model.dart';
import 'package:salon_user/app/backend/parse/refer_and_earn_parse.dart';
import 'package:salon_user/app/env.dart';
import 'package:salon_user/app/util/toast.dart';
import 'package:flutter_share/flutter_share.dart';

class ReferAndEarnController extends GetxController implements GetxService {
  final ReferAndEarnParser parser;
  bool apiCalled = false;
  RedeemModel _referralData = RedeemModel();
  RedeemModel get referralData => _referralData;
  String myCode = '';
  String userName = '';
  bool haveReferral = false;
  ReferAndEarnController({required this.parser});

  @override
  void onInit() {
    super.onInit();
    userName = parser.getName();
    getMyCode();
  }

  Future<void> getMyCode() async {
    Response response = await parser.getMyCode();
    apiCalled = true;
    if (response.statusCode == 200) {
      Map<String, dynamic> myMap = Map<String, dynamic>.from(response.body);
      print(response.body.toString());
      if (myMap['data'] != null &&
          myMap['data'] != '' &&
          myMap['referral'] != null &&
          myMap['referral'] != '') {
        haveReferral = true;
        dynamic body = myMap["data"];
        myCode = body['code'];
        RedeemModel referralCode = RedeemModel.fromJson(myMap["referral"]);
        _referralData = referralCode;
      }
      update();
    } else {
      ApiChecker.checkApi(response);
    }
    update();
  }

  Future<void> share() async {
    String title =
        '${'Your friend'.tr} $userName ${'has invited you to'.tr} ${Environments.appName}';

    String message =
        '${'Hey Buddy download'.tr} ${Environments.appName} ${'from the App Store or Play Store and use my code'.tr} '
        '$myCode '
        '${'while signing up! We both will get'.tr} ${referralData.amount} ${'wallet amount'.tr}.\n\n'
        '${'Download here:'.tr}\n';

    // Store Links
    String playStoreLink =
        'https://play.google.com/store/apps/details?id=com.papabear.userapp';
    String appStoreLink = 'https://apps.apple.com/app/idYOUR_APP_ID';

    // Add appropriate store link based on platform
    String linkUrl = '';
    if (Platform.isAndroid) {
      message += '📱 Play Store: ';
      linkUrl = playStoreLink;
    } else if (Platform.isIOS) {
      message += '📱 App Store: ';
      linkUrl = appStoreLink;
    }

    await FlutterShare.share(
      title: title,
      text: message,
      linkUrl: linkUrl, // Dynamically selected link
      chooserTitle: 'Share with buddies'.tr,
    );
  }

  void copyToClipBoard() {
    Clipboard.setData(ClipboardData(text: myCode)).then((_) {
      successToast('Copied to clipboard'.tr);
    });
  }
}
