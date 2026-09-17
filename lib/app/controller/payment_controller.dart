import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
import 'package:salon_user/app/backend/api/handler.dart';
import 'package:salon_user/app/backend/api/api_response.dart';
import 'package:salon_user/app/backend/models/address_model.dart';
import 'package:salon_user/app/backend/models/checkout_payment_model.dart';
import 'package:salon_user/app/backend/models/coupons_model.dart';
import 'package:salon_user/app/backend/models/payment_models.dart';
import 'package:salon_user/app/backend/models/salon_details_model.dart';
import 'package:salon_user/app/backend/models/pricing_model.dart';
import 'package:salon_user/app/backend/parse/payment_parse.dart';
import 'package:salon_user/app/backend/parse/pricing_parse.dart';
import 'package:salon_user/app/controller/address_list_controller.dart';
import 'package:salon_user/app/controller/coupon_controller.dart';
import 'package:salon_user/app/controller/service_cart_controller.dart';
import 'package:salon_user/app/controller/slot_controller.dart';
import 'package:salon_user/app/controller/tabs_controller.dart';
import 'package:salon_user/app/helper/router.dart';
import 'package:salon_user/app/util/constant.dart';
import 'package:salon_user/app/util/theme.dart';
import 'package:salon_user/app/util/toast.dart';
import 'package:salon_user/app/view/upgrade_payment.dart';
import 'package:geolocator/geolocator.dart';

class PaymentController extends GetxController implements GetxService {
  final PaymentParser parser;

  bool isChecked = false;
  bool apiCalled = false;
  bool paymentAPICalled = false;
  SalonDetailsModel _salonDetails = SalonDetailsModel();
  SalonDetailsModel get salonDetails => _salonDetails;
  bool checkPremium = false;

  List<PaymentModel> _paymentList = <PaymentModel>[];
  List<PaymentModel> get paymentList => _paymentList;

  String currencySide = AppConstants.defaultCurrencySide;
  String currencySymbol = AppConstants.defaultCurrencySymbol;

  final notesEditor = TextEditingController();

  String offerId = '';
  String offerName = '';

  double _discount = 0.0;
  double get discount => _discount;

  double _grandTotal = 0.0;
  double get grandTotal => _grandTotal;

  bool haveFairDeliveryRadius = false;

  double _deliveryPrice = 0.0;
  double get deliveryPrice => _deliveryPrice;

  int paymentId = 0;
  String payMethodName = '';
  late bool cashOnly;
  bool isWalletChecked = false;
  double balance = 0.0;
  double walletDiscount = 0.0;
  double taxAmount = 0.0;
  double taxableValue = 0.0;
  bool taxInclusive = true;
  bool pricingLoading = false;
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

  int appointmentsTo = 0;

  late Razorpay _razorpay;

  PaymentController({required this.parser});

  @override
  void onInit() {
    super.onInit();
    checkCod();
    getPaymentMethods();
    getMyWalletAmount();

    // Set default values first
    appointmentsTo = 0;
    _deliveryPrice = 0;

    // Load salon details and then do calculations
    getSalonDetails();

    currencySide = parser.getCurrencySide();
    currencySymbol = parser.getCurrencySymbol();

    final cartCoupon = Get.find<ServiceCartController>().selectedCoupon;
    if ((cartCoupon.code ?? '').isNotEmpty || (cartCoupon.id ?? 0) > 0) {
      onSaveCoupon(cartCoupon);
    }

    // Initialize Razorpay SDK
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

  Future<void> getMyWalletAmount() async {
    try {
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
        debugPrint('Wallet balance unavailable: ${response.statusText}');
      }
    } catch (e) {
      debugPrint('Wallet balance failed: $e');
    }
    update();
  }

  Future<void> getSalonDetails() async {
    var response =
        await parser.salonDetails({"id": Get.find<SlotController>().uid});

    if (response.statusCode == 200) {
      Map<String, dynamic> myMap = Map<String, dynamic>.from(response.body);
      var body = myMap['data'];

      _salonDetails = SalonDetailsModel();

      SalonDetailsModel services = SalonDetailsModel.fromJson(body);
      _salonDetails = services;

      // Set appointmentsTo to 0 (Business) by default
      appointmentsTo = 0;
      haveFairDeliveryRadius = true;

      // Only load address if service at home is available
      if (salonDetails.serviceAtHome == 1) {
        getSavedAddress();
      }

      checkPremiumStatus(Get.find<SlotController>().uid);

      // Calculate charges with business location (appointmentsTo = 0)
      calculateAllCharge();
    } else {
      ApiChecker.checkApi(response);
    }

    apiCalled = true;
    update();
  }

  Future<void> checkCod() async {
    var response = await parser.checkCod();

    if (response.statusCode == 200) {
      Map<String, dynamic> myMap = Map<String, dynamic>.from(response.body);
      cashOnly = myMap['cash_only'];
      var success = myMap['success'];

      if (success) {
        _salonDetails = SalonDetailsModel();

        if (cashOnly) {
          print('Cash payment only available.');
        }
      } else {
        print('Request was not successful.');
      }
    } else {
      ApiChecker.checkApi(response);
    }

    update();
  }

  void updateServiceAt(int type) {
    appointmentsTo = type;
    if (appointmentsTo == 0) {
      _deliveryPrice = 0; // This part exists but might be executed too late
      haveFairDeliveryRadius = true;
    } else {
      haveFairDeliveryRadius = false;
      getSavedAddress();
    }
    calculateAllCharge();
    update();
  }

  Future<void> getSavedAddress() async {
    var param = {"id": parser.getUID()};

    Response response = await parser.getSavedAddress(param);
    debugPrint(response.bodyString);
    apiCalled = true;
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

  void calculateDistance() {
    debugPrint(salonDetails.lat.toString());
    debugPrint(salonDetails.lng.toString());
    debugPrint(addressInfo.lat.toString());
    debugPrint(addressInfo.lng.toString());

    debugPrint(Get.find<ServiceCartController>().shippingMethod.toString());
    if (addressInfo.lat != null &&
        addressInfo.lng != null &&
        salonDetails.lat != null &&
        salonDetails.lng != null) {
      double storeDistance = 0.0;
      double totalMeters = 0.0;
      storeDistance = Geolocator.distanceBetween(
        double.tryParse(addressInfo.lat.toString()) ?? 0.0,
        double.tryParse(addressInfo.lng.toString()) ?? 0.0,
        double.tryParse(salonDetails.lat.toString()) ?? 0.0,
        double.tryParse(salonDetails.lng.toString()) ?? 0.0,
      );
      totalMeters = totalMeters + storeDistance;
      double distance = double.parse((storeDistance / 1000).toStringAsFixed(2));
      debugPrint('distance $distance');
      debugPrint(
          'distance price${Get.find<ServiceCartController>().shippingPrice}');
      if (distance >
          Get.find<ServiceCartController>().parser.getAllowedDeliveryRadius()) {
        if (appointmentsTo == 1) {
          haveFairDeliveryRadius = false;
          showToast(
              '${'Sorry we deliver the order near to'.tr} ${Get.find<ServiceCartController>().parser.getAllowedDeliveryRadius()} KM');
        }
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

  void onCoupon(String offerId, String offerName, String cartValue) {
    if (isWalletChecked) {
      showToast('Use either a coupon or wallet, not both.'.tr);
      return;
    }
    Get.delete<CouponController>(force: true);
    Get.toNamed(AppRouter.getCouponRoutes(), arguments: [
      'service',
      offerId,
      offerName,
      Get.find<ServiceCartController>().salonId.toString(),
      cartValue
    ]);
  }

  void updateWalletChecked(bool status) {
    if (status && hasCoupon) {
      _clearCoupon();
      showToast('Coupon removed. Use either a coupon or wallet.'.tr);
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

  void onSaveCoupon(CouponsModel offer) {
    final applying =
        (offer.code ?? '').trim().isNotEmpty || (offer.id ?? 0) > 0;
    if (applying && isWalletChecked) {
      isWalletChecked = false;
      walletDiscount = 0;
      showToast('Wallet removed. Use either a coupon or wallet.'.tr);
    }
    _selectedCoupon = offer;

    offerId = offer.id.toString();
    offerName = offer.name.toString();
    update();
    calculateAllCharge();
  }

  void calculateAllCharge() {
    if (appointmentsTo == 0) {
      _deliveryPrice = 0;
    }

    _discount = _couponDiscountAmount();
    if (_discount > 0) {
      isWalletChecked = false;
      walletDiscount = 0;
    } else {
      walletDiscount = isWalletChecked ? balance : 0;
    }
    refreshPricingFromApi();
  }

  double _couponDiscountAmount() {
    if (!Get.isRegistered<ServiceCartController>()) return 0;
    final cart = Get.find<ServiceCartController>();
    final value = _selectedCoupon.discount ?? 0;
    if (value <= 0) return 0;
    double amount;
    if ((_selectedCoupon.type ?? 1) == 1) {
      amount = cart.totalPrice * (value / 100);
      final upto = _selectedCoupon.upto ?? 0;
      if (upto > 0 && amount > upto) amount = upto;
    } else {
      amount = value;
    }
    if (amount > cart.totalPrice) amount = cart.totalPrice;
    return amount;
  }

  Future<void> refreshPricingFromApi() async {
    if (!Get.isRegistered<PricingParser>()) {
      _applyLocalPricingFallback();
      update();
      return;
    }

    pricingLoading = true;
    update();

    final cart = Get.find<ServiceCartController>();
    final servicesAmount = cart.totalPrice + cart.serviceChargeAmount;
    final useWallet = isWalletChecked && _discount <= 0;
    final result = await Get.find<PricingParser>().calculateAppointment(
      servicesAmount: servicesAmount,
      discount: useWallet ? 0 : discount,
      distanceCost: deliveryPrice,
      walletAmount: useWallet ? walletDiscount : 0,
    );

    pricingLoading = false;

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
    final cart = Get.find<ServiceCartController>();
    double totalPrice = cart.totalPrice +
        cart.serviceChargeAmount +
        _deliveryPrice;

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
      if (cashOnly) {
        showToast('3 Free Cancellations Exceeded, COD Not Available');
        return;
      }
      payMethodName = 'cod';
    } else if (paymentId == 5) {
      payMethodName = 'razorpay';
    }
    update();
  }

  void onSelectAddress() {
    Get.delete<AddressListController>(force: true);
    Get.toNamed(AppRouter.getAddressList(),
        arguments: ['salon', selectedAddressId]);
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
      _startCheckoutPayment();
    }
  }

  Future<void> _startCheckoutPayment() async {
    try {
      await refreshPricingFromApi();

      _showProgressDialog('Please wait'.tr);

      final appointmentId = await _createPendingAppointment();
      _closePaymentDialog();
      if (appointmentId == null) return;

      _showProgressDialog('Opening Payment...'.tr);

      final result = await parser.generateCheckoutPaymentUrl(
        appointmentId: appointmentId,
      );
      _closePaymentDialog();

      if (!result.success || result.data == null) {
        showToast(result.message.isNotEmpty
            ? result.message
            : 'Unable to start payment.');
        return;
      }

      final paymentData = result.data!;
      if (paymentData.paymentUrl.isEmpty) {
        showToast('Payment URL not available.');
        return;
      }

      final verifyResult = await openUpgradePaymentWebView(
        paymentUrl: paymentData.paymentUrl,
        appointmentId: paymentData.appointmentId,
        paymentLinkId: paymentData.paymentLinkId,
      );

      if (verifyResult is! CheckoutVerifyData || !verifyResult.isPaid) {
        showToast('Payment not completed.');
        return;
      }

      _showOrderSuccessDialog();
    } catch (e) {
      debugPrint('Checkout payment error: $e');
      _closePaymentDialog();
      showToast('Payment not completed.');
    }
  }

  Future<int?> _createPendingAppointment() async {
    final param = _buildOrderParams(status: 8, paid: 'PENDING');
    debugPrint('Create Pending Appointment Params: $param');
    final response = await parser.createAppoinments(param);

    if (response.statusCode != 200) {
      debugPrint(
          'Pending Appointment Error: Status ${response.statusCode}, Body: ${response.bodyString}');
      ApiChecker.checkApi(response);
      showToast('Unable to create booking. Please try again.');
      return null;
    }

    final map = ApiBody.asMap(response.body);
    if (map == null || map['success'] != true) {
      showToast(ApiBody.message(response) ?? 'Unable to create booking.');
      return null;
    }

    final data = ApiBody.asObject(map['data']);
    final appointmentId = ApiBody.asInt(
      data?['appointment_id'] ?? data?['id'],
    );
    if (appointmentId <= 0) {
      showToast('Appointment id missing from server.');
      return null;
    }
    return appointmentId;
  }

  Map<String, dynamic> _buildOrderParams({
    required int status,
    String? paid,
  }) {
    final cart = Get.find<ServiceCartController>();
    final orderTotal = bookingFields?.total ?? cart.totalPrice;
    final orderTax = bookingFields?.serviceTax ?? taxAmount;
    final orderGrandTotal = bookingFields?.grandTotal ?? grandTotal;

    return {
      "uid": parser.getUID(),
      "freelancer_id": 0,
      "salon_id": cart.salonId.toString(),
      "specialist_id": Get.find<SlotController>().selectedSpecialist,
      "appointments_to": appointmentsTo,
      "address": appointmentsTo == 1 ? jsonEncode(addressInfo) : 'NA',
      "items": jsonEncode(cart.savedInCart),
      "coupon_id": selectedCoupon.code != null ? selectedCoupon.id : 0,
      "coupon": selectedCoupon.code != null ? jsonEncode(selectedCoupon) : 'NA',
      "discount": discount,
      "distance_cost": deliveryPrice,
      "total": orderTotal,
      "serviceTax": orderTax,
      "grand_total": orderGrandTotal,
      "pay_method": paymentId,
      "paid": paid ?? "COD",
      "save_date": Get.find<SlotController>().savedDate,
      "slot": Get.find<SlotController>().selectedSlotIndex,
      'wallet_used': isWalletChecked == true && walletDiscount > 0 ? 1 : 0,
      'wallet_price':
          isWalletChecked == true && walletDiscount > 0 ? walletDiscount : 0,
      "notes": notesEditor.text.isNotEmpty ? notesEditor.text : 'NA',
      "status": status,
    };
  }

  void _showProgressDialog(String message) {
    Get.dialog(
      SimpleDialog(
        children: [
          Row(
            children: [
              const SizedBox(width: 30),
              const CircularProgressIndicator(color: ThemeProvider.appColor),
              const SizedBox(width: 30),
              SizedBox(
                child: Text(
                  message,
                  style: const TextStyle(fontFamily: 'bold'),
                ),
              ),
            ],
          )
        ],
      ),
      barrierDismissible: false,
    );
  }

  void _showOrderSuccessDialog() {
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
                  fit: BoxFit.cover,
                  height: 60,
                  width: 60,
                ),
              ),
            ),
            const SizedBox(height: 30),
            Text(
              'Thank You!'.tr,
              style: const TextStyle(fontFamily: 'bold', fontSize: 18),
            ),
            const SizedBox(height: 10),
            Text(
              'For Your Appoinment'.tr,
              style: const TextStyle(fontFamily: 'semi-bold', fontSize: 16),
            ),
            const SizedBox(height: 20),
            Text(
              'We look forward to serving you!\nPlease check your email for the appointment details'
                  .tr,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 14),
            ),
            const SizedBox(height: 50),
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
  }

  Future<void> createOrder({String? transactionId}) async {
    await refreshPricingFromApi();
    _showProgressDialog('Please wait'.tr);

    var param = _buildOrderParams(status: 0, paid: transactionId ?? 'COD');
    debugPrint('Create Order Params: $param');
    var response = await parser.createAppoinments(param);
    Get.back();

    if (response.statusCode == 200) {
      debugPrint('Order Create Success: ${response.bodyString}');
      _showOrderSuccessDialog();
    } else {
      debugPrint(
          'Order Create Error: Status ${response.statusCode}, Body: ${response.bodyString}');
      ApiChecker.checkApi(response);
      showToast('Order creation failed. Please try again.');
    }
    update();
  }

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
