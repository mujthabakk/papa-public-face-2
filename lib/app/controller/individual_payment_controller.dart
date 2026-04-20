import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
import 'package:salon_user/app/backend/api/handler.dart';
import 'package:salon_user/app/backend/models/address_model.dart';
import 'package:salon_user/app/backend/models/coupons_model.dart';
import 'package:salon_user/app/backend/models/individual_info_model.dart';
import 'package:salon_user/app/backend/models/payment_models.dart';
import 'package:salon_user/app/backend/parse/individual_payment_parse.dart';
import 'package:salon_user/app/controller/address_list_controller.dart';
import 'package:salon_user/app/controller/coupon_controller.dart';
import 'package:salon_user/app/controller/individual_slot_controller.dart';
import 'package:salon_user/app/controller/service_cart_controller.dart';
import 'package:salon_user/app/controller/tabs_controller.dart';
import 'package:salon_user/app/env.dart';
import 'package:salon_user/app/helper/router.dart';
import 'package:salon_user/app/util/constant.dart';
import 'package:salon_user/app/util/theme.dart';
import 'package:salon_user/app/util/toast.dart';
import 'package:geolocator/geolocator.dart';

class IndividualPaymentController extends GetxController
    implements GetxService {
  final IndividualPaymentParser parser;

  bool checkPremium = false;

  bool isChecked = false;
  bool apiCalled = false;
  bool paymentAPICalled = false;
  IndividualInfoModel _individualInfo = IndividualInfoModel();
  IndividualInfoModel get individualInfo => _individualInfo;

  List<PaymentModel> _paymentList = <PaymentModel>[];
  List<PaymentModel> get paymentList => _paymentList;

  String currencySide = AppConstants.defaultCurrencySide;
  String currencySymbol = AppConstants.defaultCurrencySymbol;

  final notesEditor = TextEditingController();

  int paymentId = 0;
  String payMethodName = '';

  String offerId = '';
  String offerName = '';

  double _discount = 0.0;
  double get discount => _discount;

  double _grandTotal = 0.0;
  double get grandTotal => _grandTotal;

  bool isWalletChecked = false;
  double balance = 0.0;
  double walletDiscount = 0.0;
  double taxAmount = 0.0;

  bool haveAddress = false;

  late CouponsModel _selectedCoupon = CouponsModel();
  CouponsModel get selectedCoupon => _selectedCoupon;

  List<AddressModel> _addressList = <AddressModel>[];
  List<AddressModel> get addressList => _addressList;

  AddressModel _addressInfo = AddressModel();
  AddressModel get addressInfo => _addressInfo;

  String selectedAddressId = '';

  bool haveFairDeliveryRadius = false;

  double _deliveryPrice = 0.0;
  double get deliveryPrice => _deliveryPrice;

  late Razorpay _razorpay;

  IndividualPaymentController({required this.parser});

  @override
  void onInit() {
    super.onInit();
    currencySide = parser.getCurrencySide();
    currencySymbol = parser.getCurrencySymbol();
    getSalonDetails();
    getPaymentMethods();
    getMyWalletAmount();
    debugPrint('*****************${Get.find<ServiceCartController>().salonId}');

    _razorpay = Razorpay();
    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
    _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);
  }

  @override
  void onClose() {
    _razorpay.clear();
    super.onClose();
  }

  void _handlePaymentSuccess(PaymentSuccessResponse response) {
    debugPrint('Razorpay Payment Success: ${response.paymentId}');
    if (response.paymentId != null) {
      verifyRazorpayPurchase(response.paymentId!);
    }
  }

  void _handlePaymentError(PaymentFailureResponse response) {
    debugPrint('Razorpay Error: ${response.code} - ${response.message}');
    showToast('Payment failed. Please try again.');
  }

  void _handleExternalWallet(ExternalWalletResponse response) {
    debugPrint('External Wallet: ${response.walletName}');
    showToast('External wallet selected: ${response.walletName}');
  }

  Future<void> getMyWalletAmount() async {
    Response response = await parser.getMyWalletBalance();
    if (response.statusCode == 200) {
      Map<String, dynamic> myMap = Map<String, dynamic>.from(response.body);
      dynamic body = myMap["data"];
      if (body != null &&
          body != '' &&
          body['balance'] != null &&
          body['balance'] != '') {
        balance = double.tryParse(body['balance'].toString()) ?? 0.0;
        walletDiscount = double.tryParse(body['balance'].toString()) ?? 0.0;
      }
    } else {
      ApiChecker.checkApi(response);
    }
    update();
  }

  Future<void> checkPremiumStatus(String salonId) async {
    var response = await parser.getPremium({"uid": salonId});

    if (response.statusCode == 200) {
      checkPremium = response.body['is_premium'] ?? false;
      debugPrint('premium $checkPremium');
    } else {
      debugPrint('premium $checkPremium');

      ApiChecker.checkApi(response);
    }
    update();
  }

  Future<void> getSalonDetails() async {
    var response = await parser
        .individualDetails({"id": Get.find<IndividualSlotController>().uid});
    apiCalled = true;
    if (response.statusCode == 200) {
      Map<String, dynamic> myMap = Map<String, dynamic>.from(response.body);
      var body = myMap['data'];

      _individualInfo = IndividualInfoModel();

      IndividualInfoModel services = IndividualInfoModel.fromJson(body);
      _individualInfo = services;
      haveFairDeliveryRadius = true;
      getSavedAddress();
      checkPremiumStatus(Get.find<IndividualSlotController>().uid);
      update();
    } else {
      ApiChecker.checkApi(response);
    }
    update();
  }

  Future<void> getSavedAddress() async {
    var param = {"id": parser.getUID()};

    Response response = await parser.getSavedAddress(param);
    debugPrint(response.bodyString);
    update();
    if (response.statusCode == 200) {
      debugPrint(response.bodyString);
      Map<String, dynamic> myMap = Map<String, dynamic>.from(response.body);
      if (myMap['data'] != null && myMap['data'] != '') {
        var address = myMap['data'];
        _addressList = [];
        _addressInfo = AddressModel();
        address.forEach((add) {
          AddressModel adds = AddressModel.fromJson(add);
          _addressList.add(adds);
        });
        if (_addressList.isNotEmpty) {
          haveAddress = true;
          _addressInfo = _addressList[0];
          selectedAddressId = _addressInfo.id.toString();
          calculateDistance();
        } else {
          haveAddress = false;
        }
        debugPrint(addressList.length.toString());
      }
    } else {
      ApiChecker.checkApi(response);
    }
    update();
  }

  void calculateDistance() {
    debugPrint(_individualInfo.lat.toString());
    debugPrint(_individualInfo.lng.toString());
    debugPrint(addressInfo.lat.toString());
    debugPrint(addressInfo.lng.toString());

    debugPrint(Get.find<ServiceCartController>().shippingMethod.toString());
    if (addressInfo.lat != null &&
        addressInfo.lng != null &&
        _individualInfo.lat != null &&
        _individualInfo.lng != null) {
      double storeDistance = 0.0;
      double totalMeters = 0.0;
      storeDistance = Geolocator.distanceBetween(
        double.tryParse(addressInfo.lat.toString()) ?? 0.0,
        double.tryParse(addressInfo.lng.toString()) ?? 0.0,
        double.tryParse(_individualInfo.lat.toString()) ?? 0.0,
        double.tryParse(_individualInfo.lng.toString()) ?? 0.0,
      );
      totalMeters = totalMeters + storeDistance;
      double distance = double.parse((storeDistance / 1000).toStringAsFixed(2));
      debugPrint('distance$distance');
      debugPrint(
          'distance price${Get.find<ServiceCartController>().shippingPrice}');
      if (distance >
          Get.find<ServiceCartController>().parser.getAllowedDeliveryRadius()) {
        haveFairDeliveryRadius = false;
        showToast(
            '${'Sorry we deliver the order near to'.tr} ${Get.find<ServiceCartController>().parser.getAllowedDeliveryRadius()} KM');
      } else {
        if (Get.find<ServiceCartController>().shippingMethod == 0) {
          double distancePricer =
              distance * Get.find<ServiceCartController>().shippingPrice;

          double deliveryGst = distancePricer *
              (Get.find<ServiceCartController>().orderTax / 100);

          double finalAmt = distancePricer + deliveryGst;

          _deliveryPrice = double.parse((finalAmt).toStringAsFixed(2));
        } else {
          double deliveryGst = Get.find<ServiceCartController>().shippingPrice *
              (Get.find<ServiceCartController>().orderTax / 100);

          double finalAmt =
              Get.find<ServiceCartController>().shippingPrice + deliveryGst;

          _deliveryPrice = double.parse((finalAmt).toStringAsFixed(2));
        }
        haveFairDeliveryRadius = true;
      }
      calculateAllCharge();
      update();
    }
  }

  void updateWalletChecked(bool status) {
    isWalletChecked = status;
    calculateAllCharge();
    update();
  }

  void onSaveCoupon(CouponsModel offer) {
    _selectedCoupon = offer;
    offerId = offer.id.toString();
    offerName = offer.name.toString();
    update();
    calculateAllCharge();
  }

  void calculateAllCharge() {
    taxAmount = Get.find<ServiceCartController>().totalPrice *
        (Get.find<ServiceCartController>().orderTax / 100);

    double totalPrice = Get.find<ServiceCartController>().totalPrice +
        taxAmount +
        //  Get.find<ServiceCartController>().orderTax +
        deliveryPrice;
    if (_selectedCoupon.discount != null && _selectedCoupon.discount != 0) {
      double percentage(numFirst, per) {
        return (numFirst / 100) * per;
      }

      _discount = percentage(Get.find<ServiceCartController>().totalPrice,
          _selectedCoupon.discount); // null

      if (_discount > _selectedCoupon.upto!) {
        _discount = _selectedCoupon.upto!;
      }
    }
    walletDiscount = balance;
    if (isWalletChecked == true) {
      if (totalPrice <= walletDiscount) {
        walletDiscount = totalPrice;
        totalPrice = totalPrice - walletDiscount;
      } else {
        totalPrice = totalPrice - walletDiscount;
      }
    } else {
      if (totalPrice <= discount) {
        _discount = totalPrice;
        totalPrice = totalPrice - discount;
      } else {
        totalPrice = totalPrice - discount;
      }
    }
    debugPrint('grand total $totalPrice');
    _grandTotal = double.parse((totalPrice).toStringAsFixed(2));
    update();
  }

  Future<void> getPaymentMethods() async {
    Response response = await parser.getPayments();
    paymentAPICalled = true;

    if (response.statusCode == 200) {
      Map<String, dynamic> myMap = Map<String, dynamic>.from(response.body);
      var payment = myMap['data'];
      _paymentList = [];
      payment.forEach((pay) {
        PaymentModel pays = PaymentModel.fromJson(pay);
        if (pays.id == 1 || pays.id == 5) {
          _paymentList.add(pays);
        }
      });
    } else {
      ApiChecker.checkApi(response);
    }
    update();
  }

  // void onCoupon(String offerId, String offerName) {
  //   Get.delete<CouponController>(force: true);
  //   Get.toNamed(AppRouter.getCouponRoutes(), arguments: [
  //     'individual-service',
  //     offerId,
  //     offerName,
  //     Get.find<ServiceCartController>().salonId.toString()
  //   ]);
  // }

  void onCoupon(String offerId, String offerName, String cartValue) {
    Get.delete<CouponController>(force: true);
    Get.toNamed(AppRouter.getCouponRoutes(), arguments: [
      'individual-service',
      offerId,
      offerName,
      Get.find<ServiceCartController>().salonId.toString(),
      cartValue
    ]);
  }

  void updateStatus() {
    update();
  }

  void onBack() {
    var context = Get.context as BuildContext;
    Navigator.of(context).pop(true);
  }

  void selectPaymentMethod(int id) {
    paymentId = id;
    if (paymentId == 1) {
      payMethodName = 'cod';
    } else if (paymentId == 5) {
      payMethodName = 'razorpay';
    }
    update();
  }

  void onSelectAddress() {
    Get.delete<AddressListController>(force: true);
    Get.toNamed(AppRouter.getAddressList(),
        arguments: ['individual', selectedAddressId]);
  }

  void onSaveAddress(String id) {
    selectedAddressId = id;
    var address =
        _addressList.firstWhere((element) => element.id.toString() == id);
    _addressInfo = address;
    calculateDistance();

    update();
  }

  void onPayment() {
    if (paymentId == 0) {
      showToast('Please select payment method'.tr);
      return;
    }

    Get.defaultDialog(
      title: '',
      contentPadding: const EdgeInsets.all(20),
      content: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(
            'assets/images/question-mark.png',
            fit: BoxFit.cover,
            height: 80,
            width: 80,
          ),
          const SizedBox(
            height: 20,
          ),
          Text(
            'Are you sure'.tr,
            style: const TextStyle(fontSize: 24, fontFamily: 'semi-bold'),
          ),
          const SizedBox(
            height: 10,
          ),
          Text(
              'You are going to make an appointment/order, Do you want to continue?'
                  .tr),
          const SizedBox(
            height: 20,
          ),
          Row(
            children: [
              Expanded(
                child: ElevatedButton(
                  onPressed: () {
                    var context = Get.context as BuildContext;
                    Navigator.pop(context);
                  },
                  style: ElevatedButton.styleFrom(
                    foregroundColor: ThemeProvider.whiteColor,
                    backgroundColor: ThemeProvider.greyColor,
                    minimumSize: const Size.fromHeight(35),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5),
                    ),
                  ),
                  child: Text(
                    'Cancel'.tr,
                    style: const TextStyle(
                      color: ThemeProvider.whiteColor,
                      fontSize: 14,
                    ),
                  ),
                ),
              ),
              const SizedBox(
                width: 10,
              ),
              Expanded(
                child: ElevatedButton(
                  onPressed: () {
                    var context = Get.context as BuildContext;
                    Navigator.pop(context);
                    onCheckout();
                  },
                  style: ElevatedButton.styleFrom(
                    foregroundColor: ThemeProvider.whiteColor,
                    backgroundColor: ThemeProvider.appColor,
                    minimumSize: const Size.fromHeight(35),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5),
                    ),
                  ),
                  child: Text(
                    'Book'.tr,
                    style: const TextStyle(
                      color: ThemeProvider.whiteColor,
                      fontSize: 14,
                    ),
                  ),
                ),
              ),
            ],
          )
        ],
      ),
    );
  }

  void onCheckout() {
    if (paymentId == 1) {
      createOrder();
      // cod
      //  Order API call
    } else if (paymentId == 5) {
      // razorpay - native SDK
      final int amountInPaise =
          double.parse((grandTotal * 100).toStringAsFixed(0)).toInt();
      final options = {
        'key': Environments.razorpayKey,
        'amount': amountInPaise,
        'name': 'PapaBear',
        'description': 'Appointment Booking',
        'image':
            'https://papa-bear.blr1.cdn.digitaloceanspaces.com/papalogo.png',
        'prefill': {
          'contact': parser.getPhone(),
          'email': parser.getEmail(),
          'name': parser.getName(),
        },
        'theme': {'color': '#000000'},
        'retry': {'enabled': false},
        'send_sms_hash': true,
        'remember_customer': false,
      };

      Get.dialog(
          SimpleDialog(
            children: [
              Row(
                children: [
                  const SizedBox(width: 30),
                  const CircularProgressIndicator(
                      color: ThemeProvider.appColor),
                  const SizedBox(width: 30),
                  SizedBox(
                      child: Text('Opening Payment...'.tr,
                          style: const TextStyle(fontFamily: 'bold'))),
                ],
              )
            ],
          ),
          barrierDismissible: false);

      Future.delayed(const Duration(milliseconds: 500), () {
        // Get.back(closeOverlays: true);
        try {
          _razorpay.open(options);
        } catch (e) {
          debugPrint('Razorpay open error: $e');
          showToast('Could not open payment screen.');
        }
      });
    }
  }

  Future<void> createOrder({String? transactionId}) async {
    Get.dialog(
        SimpleDialog(
          children: [
            Row(
              children: [
                const SizedBox(
                  width: 30,
                ),
                const CircularProgressIndicator(
                  color: ThemeProvider.appColor,
                ),
                const SizedBox(
                  width: 30,
                ),
                SizedBox(
                    child: Text(
                  "Please wait".tr,
                  style: const TextStyle(fontFamily: 'bold'),
                )),
              ],
            )
          ],
        ),
        barrierDismissible: false);

    var param = {
      "uid": parser.getUID(),
      "freelancer_id": Get.find<ServiceCartController>().salonId,
      "salon_id": 0,
      "specialist_id": 0,
      "appointments_to": 1,
      "address": jsonEncode(addressInfo),
      "items": jsonEncode(Get.find<ServiceCartController>().savedInCart),
      "coupon_id": selectedCoupon.code != null ? selectedCoupon.id : 0,
      "coupon": selectedCoupon.code != null ? jsonEncode(selectedCoupon) : 'NA',
      "discount": discount,
      "distance_cost": deliveryPrice,
      "total": Get.find<ServiceCartController>().totalPrice,
      "serviceTax": Get.find<ServiceCartController>().taxAmount,
      "grand_total": grandTotal,
      "pay_method": paymentId,
      "paid": transactionId ?? "COD",
      "save_date": Get.find<IndividualSlotController>().savedDate,
      "slot": Get.find<IndividualSlotController>().selectedSlotIndex,
      'wallet_used': isWalletChecked == true && walletDiscount > 0 ? 1 : 0,
      'wallet_price':
          isWalletChecked == true && walletDiscount > 0 ? walletDiscount : 0,
      "notes": notesEditor.text.isNotEmpty ? notesEditor.text : 'NA',
      "status": 0
    };
    debugPrint('Create Order Params: $param');
    var response = await parser.createAppoinments(param);
    Get.back();

    if (response.statusCode == 200) {
      debugPrint('Order Create Success: ${response.bodyString}');
      Get.defaultDialog(
        title: '',
        contentPadding: const EdgeInsets.all(20),
        content: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(100),
                  child: Image.asset(
                    'assets/images/sure.gif',
                    height: 60,
                    width: 60,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              const SizedBox(
                height: 30,
              ),
              Text(
                'Thank You!'.tr,
                style: const TextStyle(fontFamily: 'bold', fontSize: 18),
              ),
              const SizedBox(
                height: 10,
              ),
              Text(
                'For Your Appoinment'.tr,
                style: const TextStyle(fontFamily: 'semi-bold', fontSize: 16),
              ),
              const SizedBox(
                height: 20,
              ),
              Text(
                'We look forward to serving you!\nPlease check your email for the appointment details'
                    .tr,
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 14),
              ),
              const SizedBox(
                height: 50,
              ),
              ElevatedButton(
                onPressed: () {
                  backOrders();
                },
                style: ElevatedButton.styleFrom(
                  foregroundColor: ThemeProvider.whiteColor,
                  backgroundColor: ThemeProvider.pink,
                  minimumSize: const Size.fromHeight(45),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
                child: Text(
                  'TRACK MY APPOINTMENT'.tr,
                  style: const TextStyle(
                    color: ThemeProvider.whiteColor,
                    fontSize: 14,
                  ),
                ),
              ),
              TextButton(
                onPressed: () {
                  backHome();
                },
                child: Text(
                  'BACK TO HOME'.tr,
                  style: const TextStyle(color: ThemeProvider.appColor),
                ),
              ),
            ],
          ),
        ),
      );
    } else {
      debugPrint(
          'Order Create Error: Status ${response.statusCode}, Body: ${response.bodyString}');
      ApiChecker.checkApi(response);
      showToast('Order creation failed. Please try again.');
    }
    update();
  }

  // void backHome() {
  //   Get.find<ServiceCartController>().clearCart();
  //   Get.find<TabsController>().updateTabId(0);
  //   Get.offAllNamed(AppRouter.getTabsBarRoute());
  // }

  // void backOrders() {
  //   Get.find<ServiceCartController>().clearCart();
  //   Get.find<TabsController>().updateTabId(4);
  //   Get.offAllNamed(AppRouter.getTabsBarRoute());
  // }

  void backHome() {
    Get.find<ServiceCartController>().clearCart();
    Get.find<TabsController>().updateTabId(0);
    Get.offAllNamed(AppRouter.getTabsBarRoute());
  }

  void backOrders() {
    Get.find<ServiceCartController>().clearCart();
    Get.offAllNamed(AppRouter.getTabsBarRoute());
    Future.delayed(Duration(milliseconds: 100), () {
      Get.find<TabsController>().updateTabId(4);
    });
  }

  Future<void> verifyRazorpayPurchase(String payKey) async {
    // Bypassing server-side verification as requested by user
    createOrder(transactionId: payKey);
  }
}
