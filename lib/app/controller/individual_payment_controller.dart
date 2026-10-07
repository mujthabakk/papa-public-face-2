import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
import 'package:salon_user/app/backend/api/handler.dart';
import 'package:salon_user/app/backend/models/address_model.dart';
import 'package:salon_user/app/backend/models/coupons_model.dart';
import 'package:salon_user/app/backend/models/individual_info_model.dart';
import 'package:salon_user/app/backend/models/payment_models.dart';
import 'package:salon_user/app/backend/models/pricing_model.dart';
import 'package:salon_user/app/backend/parse/individual_payment_parse.dart';
import 'package:salon_user/app/backend/parse/pricing_parse.dart';
import 'package:salon_user/app/controller/address_list_controller.dart';
import 'package:salon_user/app/controller/coupon_controller.dart';
import 'package:salon_user/app/controller/individual_slot_controller.dart';
import 'package:salon_user/app/controller/service_cart_controller.dart';
import 'package:salon_user/app/controller/tabs_controller.dart';
import 'package:salon_user/app/env.dart';
import 'package:salon_user/app/helper/country_payment.dart';
import 'package:salon_user/app/helper/discount_rules.dart';
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
  bool codEnabled = true;
  bool onlineEnabled = true;

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
  double taxableValue = 0.0;
  bool taxInclusive = true;
  PricingBookingFields? bookingFields;

  bool haveAddress = false;

  late CouponsModel _selectedCoupon = CouponsModel();
  CouponsModel get selectedCoupon => _selectedCoupon;

  bool get hasCoupon {
    final code = (_selectedCoupon.code ?? '').trim();
    final name = offerName.trim();
    return code.isNotEmpty ||
        (_selectedCoupon.id ?? 0) > 0 ||
        (name.isNotEmpty && name != 'null');
  }

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
    getMyWalletAmount();
    debugPrint('*****************${Get.find<ServiceCartController>().salonId}');
    final cartCoupon = Get.find<ServiceCartController>().selectedCoupon;
    if ((cartCoupon.code ?? '').isNotEmpty || (cartCoupon.id ?? 0) > 0) {
      onSaveCoupon(cartCoupon, ask: false);
    }

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

  void _closePaymentDialog() {
    while (Get.isDialogOpen == true) {
      Get.back();
    }
  }

  void _handlePaymentSuccess(PaymentSuccessResponse response) {
    debugPrint('Razorpay Payment Success: ${response.paymentId}');
    _closePaymentDialog();
    if (response.paymentId != null) {
      verifyRazorpayPurchase(response.paymentId!);
    }
  }

  void _handlePaymentError(PaymentFailureResponse response) {
    debugPrint('Razorpay Error: ${response.code} - ${response.message}');
    _closePaymentDialog();
    final cancelled = (response.message ?? '')
        .toLowerCase()
        .contains('cancelled');
    showToast(cancelled
        ? 'Payment cancelled'.tr
        : 'Payment failed. Please try again.'.tr);
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

  Future<void> updateWalletChecked(bool status) async {
    if (status && hasCoupon) {
      final allow = await DiscountRules.confirmOnlyOne(useRewards: true);
      if (!allow) {
        update();
        return;
      }
      _clearCoupon();
    }
    isWalletChecked = status;
    calculateAllCharge();
    update();
  }

  void _clearCoupon() {
    _selectedCoupon = CouponsModel();
    offerId = '';
    offerName = '';
    _discount = 0;
    if (Get.isRegistered<ServiceCartController>()) {
      Get.find<ServiceCartController>().onSaveCoupon(CouponsModel());
    }
  }

  Future<void> onSaveCoupon(CouponsModel offer, {bool ask = true}) async {
    final applying =
        (offer.code ?? '').trim().isNotEmpty || (offer.id ?? 0) > 0;
    if (applying && isWalletChecked) {
      if (ask) {
        final allow = await DiscountRules.confirmOnlyOne(useRewards: false);
        if (!allow) return;
      }
      isWalletChecked = false;
      walletDiscount = 0;
    }
    _selectedCoupon = offer;
    offerId = offer.id.toString();
    offerName = offer.name.toString();
    update();
    calculateAllCharge();
    if (applying && Get.isRegistered<ServiceCartController>()) {
      final priced = DiscountRules.couponOff(
        type: offer.type ?? 1,
        value: offer.discount ?? 0,
        upto: offer.upto ?? 0,
        base: Get.find<ServiceCartController>().totalPrice,
      );
      if (priced.capped) {
        showToast('Maximum discount is 50%.'.tr);
      }
    }
  }

  void calculateAllCharge() {
    _discount = _couponDiscountAmount();
    if (_discount > 0) {
      isWalletChecked = false;
      walletDiscount = 0;
    } else {
      final cart = Get.find<ServiceCartController>();
      walletDiscount = isWalletChecked
          ? DiscountRules.cap(balance, cart.totalPrice)
          : 0;
    }
    refreshPricingFromApi();
  }

  double _couponDiscountAmount() {
    if (!Get.isRegistered<ServiceCartController>()) return 0;
    final cart = Get.find<ServiceCartController>();
    return DiscountRules.couponOff(
      type: _selectedCoupon.type ?? 1,
      value: _selectedCoupon.discount ?? 0,
      upto: _selectedCoupon.upto ?? 0,
      base: cart.totalPrice,
    ).amount;
  }

  Future<void> refreshPricingFromApi() async {
    if (!Get.isRegistered<PricingParser>()) {
      _applyLocalPricingFallback();
      update();
      return;
    }

    final cart = Get.find<ServiceCartController>();
    final useWallet = isWalletChecked && _discount <= 0;
    final result = await Get.find<PricingParser>().calculateAppointment(
      servicesAmount: cart.totalPrice,
      discount: useWallet ? 0 : discount,
      distanceCost: deliveryPrice,
      walletAmount: useWallet ? walletDiscount : 0,
    );

    if (result.success && result.data != null) {
      final data = result.data!;
      taxAmount = data.serviceTax;
      taxableValue = data.taxableValue;
      taxInclusive = data.taxInclusive;
      bookingFields = data.bookingFields;
      _grandTotal = data.grandTotal;
    } else {
      _applyLocalPricingFallback();
    }
    update();
  }

  void _applyLocalPricingFallback() {
    double totalPrice =
        Get.find<ServiceCartController>().totalPrice + deliveryPrice;

    if (!isWalletChecked) {
      totalPrice -= discount;
    } else if (totalPrice <= walletDiscount) {
      walletDiscount = totalPrice;
      totalPrice = 0;
    } else {
      totalPrice -= walletDiscount;
    }

    taxAmount = 0;
    taxableValue = totalPrice;
    bookingFields = null;
    _grandTotal = double.parse(totalPrice.toStringAsFixed(2));
  }

  Future<void> getPaymentMethods() async {
    paymentAPICalled = false;
    update();
    final country = await parser.fetchByCountry();
    paymentAPICalled = true;
    if (country != null && country.methods.isNotEmpty) {
      _applyCountryMethods(country);
      update();
      return;
    }

    Response response = await parser.getPayments();
    if (response.statusCode == 200) {
      Map<String, dynamic> myMap = Map<String, dynamic>.from(response.body);
      final parsed = CountryPaymentData.tryParse(response.body);
      if (parsed != null && parsed.methods.isNotEmpty) {
        _applyCountryMethods(parsed);
      } else {
        var payment = myMap['data'];
        _paymentList = [];
        if (payment is List) {
          for (final pay in payment) {
            if (pay is! Map) continue;
            final pays =
                PaymentModel.fromJson(Map<String, dynamic>.from(pay));
            if ((pays.status ?? 1) == 1) {
              _paymentList.add(pays);
            }
          }
        }
        if (myMap['cod_enabled'] != null) {
          codEnabled = myMap['cod_enabled'] == true ||
              myMap['cod_enabled'].toString() == '1';
        }
        if (myMap['online_enabled'] != null) {
          onlineEnabled = myMap['online_enabled'] == true ||
              myMap['online_enabled'].toString() == '1';
        }
        _paymentList.removeWhere((m) => m.isCod && !codEnabled);
        _paymentList.removeWhere((m) => m.isOnline && !onlineEnabled);
        paymentId = CountryPaymentApi.pickDefault(
          methods: _paymentList,
          preferred: paymentId,
        );
        _syncPayMethodName();
      }
    } else {
      ApiChecker.checkApi(response);
    }
    update();
  }

  void _applyCountryMethods(CountryPaymentData data) {
    codEnabled = data.codEnabled;
    onlineEnabled = data.onlineEnabled;
    _paymentList = List<PaymentModel>.from(data.methods);
    if (!codEnabled) {
      _paymentList.removeWhere((m) => m.isCod);
    }
    if (!onlineEnabled) {
      _paymentList.removeWhere((m) => m.isOnline);
    }
    paymentId = CountryPaymentApi.pickDefault(
      methods: _paymentList,
      preferred: data.defaultPayMethod,
    );
    _syncPayMethodName();
  }

  PaymentModel? get _selectedMethod {
    for (final m in _paymentList) {
      if (m.id == paymentId) return m;
    }
    return null;
  }

  bool get isCodSelected => _selectedMethod?.isCod ?? paymentId == 1;

  void _syncPayMethodName() {
    final method = _selectedMethod;
    if (method == null) {
      payMethodName = '';
      return;
    }
    payMethodName = method.isCod
        ? 'cod'
        : (method.name ?? 'online').toLowerCase().replaceAll(' ', '');
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

  void onCoupon(String offerId, String offerName, String cartValue) async {
    if (isWalletChecked) {
      final allow = await DiscountRules.confirmOnlyOne(useRewards: false);
      if (!allow) return;
      isWalletChecked = false;
      walletDiscount = 0;
      update();
    }
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
    PaymentModel? method;
    for (final m in _paymentList) {
      if (m.id == id) method = m;
    }
    if (method == null) return;
    paymentId = id;
    _syncPayMethodName();
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
    if (isCodSelected) {
      if (!codEnabled) {
        showToast('Cash on delivery is not available.'.tr);
        return;
      }
      createOrder();
      return;
    }
    if (!onlineEnabled) {
      showToast('Online payment is not available.'.tr);
      return;
    }
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

      Future.delayed(const Duration(milliseconds: 400), () {
        _closePaymentDialog();
        try {
          _razorpay.open(options);
        } catch (e) {
          debugPrint('Razorpay open error: $e');
          _closePaymentDialog();
          showToast('Could not open payment screen.');
        }
      });
  }

  Future<void> createOrder({String? transactionId}) async {
    await refreshPricingFromApi();
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

    final cart = Get.find<ServiceCartController>();
    final orderTotal = bookingFields?.total ?? cart.totalPrice;
    final orderTax = bookingFields?.serviceTax ?? taxAmount;
    final orderGrandTotal = bookingFields?.grandTotal ?? grandTotal;

    var param = {
      "uid": parser.getUID(),
      "freelancer_id": cart.salonId,
      "salon_id": 0,
      "specialist_id": 0,
      "appointments_to": 1,
      "address": jsonEncode(addressInfo),
      "items": jsonEncode(cart.savedInCart),
      "coupon_id": selectedCoupon.code != null ? selectedCoupon.id : 0,
      "coupon": selectedCoupon.code != null ? jsonEncode(selectedCoupon) : 'NA',
      "discount": discount,
      "distance_cost": deliveryPrice,
      "total": orderTotal,
      "serviceTax": orderTax,
      "grand_total": orderGrandTotal,
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
    Future.delayed(const Duration(milliseconds: 100), () {
      Get.find<TabsController>().openAppointments();
    });
  }

  Future<void> verifyRazorpayPurchase(String payKey) async {
    // Bypassing server-side verification as requested by user
    createOrder(transactionId: payKey);
  }
}
