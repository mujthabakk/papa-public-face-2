import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:salon_user/app/backend/api/handler.dart';
import 'package:salon_user/app/backend/models/appointment_model.dart';
import 'package:salon_user/app/backend/models/checkout_payment_model.dart';
import 'package:salon_user/app/backend/models/payment_options_model.dart';
import 'package:salon_user/app/backend/parse/appointment_detail_parse.dart';
import 'package:salon_user/app/backend/parse/payment_parse.dart';
import 'package:salon_user/app/controller/add_review_controller.dart';
import 'package:salon_user/app/controller/booking_controller.dart';
import 'package:salon_user/app/controller/chat_controller.dart';
import 'package:salon_user/app/controller/complaints_controller.dart';
import 'package:salon_user/app/controller/payment_socket_controller.dart';
import 'package:salon_user/app/controller/reschedule_slot_controller.dart';
import 'package:salon_user/app/helper/router.dart';
import 'package:salon_user/app/util/constant.dart';
import 'package:salon_user/app/util/theme.dart';
import 'package:salon_user/app/util/toast.dart';
import 'package:salon_user/app/view/upgrade_payment.dart';
import 'package:salon_user/app/view/widgets/elite_ui.dart';
import 'package:url_launcher/url_launcher.dart';

class AppointmentDetailController extends GetxController
    implements GetxService {
  final AppointmentDetailParser parser;

  bool apiCalled = false;

  int appointmentId = 0;

  int uid = 0;
  String type = '';

  String name = '';
  String address = '';
  String slot = '';
  String savedDate = '';
  String discount = '';
  String walletDiscount = '';
  String distanceCost = '';
  String serviceTax = '';
  String total = '';
  String grandTotal = '';

  String firstName = '';
  String lastName = '';
  String individualAddress = '';

  AppointmentModel _appointmentInfo = AppointmentModel();
  AppointmentModel get appointmentInfo => _appointmentInfo;

  String currencySide = AppConstants.defaultCurrencySide;
  String currencySymbol = AppConstants.defaultCurrencySymbol;
  String invoiceURL = '';
  String orderStatus = '';

  List<String> paymentName = [
    'NA',
    'COD'.tr,
    'Stripe'.tr,
    'PayPal'.tr,
    'Paytm'.tr,
    'Razorpay'.tr,
    'Instamojo'.tr,
    'Paystack'.tr,
    'Flutterwave'.tr
  ];

  PaymentOptionsModel? paymentOptions;
  bool paymentLoading = false;
  bool payingNow = false;

  bool get isPaid => paymentOptions?.isPaid == true;
  bool get isCodBooking {
    final method =
        appointmentInfo.payMethod ?? paymentOptions?.payMethod ?? 0;
    final label =
        (paymentOptions?.payMethodLabel ?? appointmentInfo.paid ?? '')
            .toLowerCase();
    if (method == 1 || label.contains('cod') || label.contains('cash')) {
      return true;
    }
    return paymentOptions?.showCod == true && method < 2;
  }

  bool get showPayNow {
    final status = appointmentInfo.status ?? 0;
    if (status == 2 || status == 5 || status == 6) return false;
    return paymentOptions != null &&
        paymentOptions!.showPayNow &&
        !paymentOptions!.isPaid &&
        isCodBooking;
  }
  bool get showCodHint =>
      paymentOptions != null &&
      paymentOptions!.showCod &&
      !paymentOptions!.isPaid;

  AppointmentDetailController({required this.parser});

  PaymentParser get _paymentParser => Get.find<PaymentParser>();

  @override
  void onInit() {
    super.onInit();
    currencySide = parser.getCurrencySide();
    currencySymbol = parser.getCurrencySymbol();
    appointmentId = Get.arguments[0] as int;
    debugPrint('appointment id --> $appointmentId');
    invoiceURL =
        '${parser.apiService.appBaseUrl}${AppConstants.getAppointmentsReceipt}$appointmentId&token=${parser.getToken()}';
    getAppointmentDetails();
  }

  Future<void> getAppointmentDetails() async {
    var response = await parser.getAppointmentDetails({"id": appointmentId});
    apiCalled = true;
    if (response.statusCode == 200) {
      Map<String, dynamic> myMap = Map<String, dynamic>.from(response.body);
      var body = myMap['data'];

      _appointmentInfo = AppointmentModel();
      AppointmentModel info = AppointmentModel.fromJson(body);
      _appointmentInfo = info;
      if (appointmentInfo.status == 1) {
        orderStatus = 'Accepted'.tr;
      } else if (appointmentInfo.status == 2) {
        orderStatus = 'Rejected by Freelancer'.tr;
      } else if (appointmentInfo.status == 3) {
        orderStatus = 'Ongoing'.tr;
      } else if (appointmentInfo.status == 4) {
        orderStatus = 'Completed'.tr;
      } else if (appointmentInfo.status == 5) {
        orderStatus = 'Cancelled'.tr;
      } else if (appointmentInfo.status == 6) {
        orderStatus = 'Refunded'.tr;
      } else if (appointmentInfo.status == 7) {
        orderStatus = 'Delayed'.tr;
      } else if (appointmentInfo.status == 8) {
        orderStatus = 'Panding Payment'.tr;
      }
      debugPrint(orderStatus);
      if (appointmentInfo.salonId != 0) {
        name = _appointmentInfo.salonInfo!.name as String;
        address = _appointmentInfo.salonInfo!.address as String;
      } else {
        firstName = _appointmentInfo.individualInfo!.firstName as String;
        lastName = _appointmentInfo.individualInfo!.lastName as String;
        individualAddress = _appointmentInfo.individualInfo!.address as String;
      }

      debugPrint(appointmentInfo.ownerInfo!.email);

      if (_appointmentInfo.salonInfo != null) {
        uid = _appointmentInfo.salonId!;

        type = 'salon';
        debugPrint('type is salon');
      } else if (_appointmentInfo.individualInfo != null) {
        uid = _appointmentInfo.freelancerId!;

        type = 'individual';
        debugPrint('type is individual');
      }

      slot = _appointmentInfo.slot as String;
      savedDate = _appointmentInfo.saveDate as String;
      walletDiscount = _appointmentInfo.walletPrice.toString();
      discount = _appointmentInfo.discount.toString();
      distanceCost = _appointmentInfo.distanceCost.toString();
      serviceTax = _appointmentInfo.serviceTax.toString();
      total = _appointmentInfo.total.toString();
      grandTotal = _appointmentInfo.grandTotal.toString();
      update();
      await loadPaymentOptions();
      await _listenPaymentSocket();
      if (Get.isRegistered<PaymentSocketController>()) {
        Get.find<PaymentSocketController>().watchBookId(appointmentId);
      }
    } else {
      ApiChecker.checkApi(response);
    }

    update();
  }

  Future<void> loadPaymentOptions() async {
    if (!Get.isRegistered<PaymentParser>()) return;
    paymentLoading = true;
    update();
    final result =
        await _paymentParser.getPaymentOptions(bookId: appointmentId);
    paymentLoading = false;
    if (result.success && result.data != null) {
      paymentOptions = result.data;
      if (paymentOptions!.amount > 0) {
        grandTotal = paymentOptions!.amount.toString();
      }
    }
    update();
  }

  /// Called from dashboard PaymentSocketController.
  void applyPaymentCompletedFromSocket(Map<String, dynamic> payload) {
    try {
      final parsed = PaymentOptionsModel.fromJson(payload);
      paymentOptions = (paymentOptions ?? parsed).copyWith(
        isPaid: true,
        canPayNow: false,
        showPayNow: false,
        showCod: false,
        paymentStatus: parsed.paymentStatus.isNotEmpty
            ? parsed.paymentStatus
            : 'paid',
        message: parsed.message.isNotEmpty
            ? parsed.message
            : paymentOptions?.message,
      );
    } catch (_) {
      paymentOptions = (paymentOptions ?? PaymentOptionsModel()).copyWith(
        isPaid: true,
        canPayNow: false,
        showPayNow: false,
        showCod: false,
        paymentStatus: 'paid',
      );
    }
    update();
  }

  Future<void> _listenPaymentSocket() async {
    // Dashboard owns the global payment socket + popup.
    if (!Get.isRegistered<PaymentSocketController>()) return;
    await Get.find<PaymentSocketController>().startListening();
  }

  /// Public COD Pay Now flow: getPaymentOptions → payNow → WebView → verify/socket.
  Future<void> onPayNow() async {
    if (payingNow || !showPayNow) return;
    payingNow = true;
    update();

    try {
      await loadPaymentOptions();
      if (paymentOptions == null || !paymentOptions!.showPayNow) {
        showToast(paymentOptions?.message.isNotEmpty == true
            ? paymentOptions!.message
            : 'Pay Now is not available.'.tr);
        return;
      }

      Get.dialog(
        const Center(child: CircularProgressIndicator(color: ThemeProvider.gold)),
        barrierDismissible: false,
      );

      final result = await _paymentParser.generateCheckoutPaymentUrl(
        appointmentId: appointmentId,
      );

      if (Get.isDialogOpen ?? false) Get.back();

      if (!result.success || result.data == null) {
        showToast(result.message.isNotEmpty
            ? result.message
            : 'Unable to start payment.'.tr);
        return;
      }

      final paymentData = result.data!;
      if (paymentData.paymentUrl.isEmpty) {
        showToast('Payment URL not available.'.tr);
        return;
      }

      final verifyResult = await openUpgradePaymentWebView(
        paymentUrl: paymentData.paymentUrl,
        appointmentId: paymentData.appointmentId > 0
            ? paymentData.appointmentId
            : appointmentId,
        paymentLinkId: paymentData.paymentLinkId,
        onPaid: () {
          paymentOptions = (paymentOptions ?? PaymentOptionsModel()).copyWith(
            isPaid: true,
            canPayNow: false,
            showPayNow: false,
            showCod: false,
          );
          update();
        },
      );

      // Re-attach socket after WebView (may have paused connection).
      await _listenPaymentSocket();

      if (verifyResult is CheckoutVerifyData && verifyResult.isPaid) {
        paymentOptions = (paymentOptions ?? PaymentOptionsModel()).copyWith(
          isPaid: true,
          canPayNow: false,
          showPayNow: false,
          showCod: false,
        );
        showToast('Payment successful'.tr);
        update();
      } else {
        // Refresh options once via getPaymentOptions — never poll getStatus here.
        await loadPaymentOptions();
      }
    } finally {
      payingNow = false;
      update();
    }
  }

  Future<void> onUpdateAppointmentStatus(int status) async {
    Get.dialog(
      Dialog(
        backgroundColor: ThemeProvider.surface,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: BorderSide(
            color: ThemeProvider.gold.withValues(alpha: 0.35),
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: ThemeProvider.gold.withValues(alpha: 0.12),
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: ThemeProvider.gold.withValues(alpha: 0.4),
                  ),
                ),
                child: const Icon(
                  Icons.help_outline,
                  size: 40,
                  color: ThemeProvider.gold,
                ),
              ),
              const SizedBox(height: 20),
              Text(
                'Manage Appointment'.tr,
                textAlign: TextAlign.center,
                style: ThemeProvider.serif(
                  size: 20,
                  color: ThemeProvider.gold,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'What would you like to do with your appointment?'.tr,
                textAlign: TextAlign.center,
                style: ThemeProvider.sans(
                  size: 13,
                  color: ThemeProvider.greyColor,
                ),
              ),
              const SizedBox(height: 28),
              EliteGoldButton(
                label: 'Reschedule'.tr,
                icon: Icons.schedule,
                onTap: () {
                  Get.back();
                  Get.delete<RescheduleSlotController>(force: true);
                  Get.toNamed(AppRouter.getRescheduleSlotRoutes(),
                      arguments: [appointmentId, uid, type]);
                },
              ),
              const SizedBox(height: 10),
              EliteGoldButton(
                outlined: true,
                label: 'Cancel Appointment'.tr,
                icon: Icons.cancel_outlined,
                onTap: () async {
                  Get.back();
                  Get.dialog(
                    Dialog(
                      backgroundColor: ThemeProvider.surface,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                        side: BorderSide(
                          color: ThemeProvider.gold.withValues(alpha: 0.35),
                        ),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(24),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const CircularProgressIndicator(
                              color: ThemeProvider.gold,
                            ),
                            const SizedBox(height: 16),
                            Text(
                              'Cancelling appointment...'.tr,
                              style: ThemeProvider.sans(
                                size: 14,
                                color: ThemeProvider.whiteColor,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    barrierDismissible: false,
                    barrierColor: const Color(0xB8000000),
                  );

                  var body = {"id": appointmentId, "status": status};
                  Response response =
                      await parser.onUpdateAppointmentStatus(body);
                  Get.back();

                  if (response.statusCode == 200) {
                    showCancellationSuccessDialog();
                  } else {
                    ApiChecker.checkApi(response);
                  }
                  update();
                },
              ),
              const SizedBox(height: 10),
              TextButton(
                onPressed: () => Get.back(),
                style: TextButton.styleFrom(
                  foregroundColor: ThemeProvider.greyColor,
                  minimumSize: const Size.fromHeight(44),
                ),
                child: Text(
                  'Close'.tr,
                  style: ThemeProvider.sans(
                    size: 12,
                    weight: FontWeight.w600,
                    color: ThemeProvider.greyColor,
                    letterSpacing: 0.8,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      barrierColor: const Color(0xB8000000),
    );

    update();
  }

// Method for showing cancellation success dialog
  void showCancellationSuccessDialog() {
    Get.dialog(
      Dialog(
        backgroundColor: ThemeProvider.surface,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: BorderSide(
            color: ThemeProvider.gold.withValues(alpha: 0.35),
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: ThemeProvider.gold.withValues(alpha: 0.12),
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: ThemeProvider.gold.withValues(alpha: 0.4),
                  ),
                ),
                child: const Icon(
                  Icons.check_circle_outline,
                  size: 56,
                  color: ThemeProvider.gold,
                ),
              ),
              const SizedBox(height: 24),
              Text(
                'Appointment Cancelled'.tr,
                textAlign: TextAlign.center,
                style: ThemeProvider.serif(
                  size: 20,
                  color: ThemeProvider.gold,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Your appointment has been successfully cancelled. You will receive a confirmation email shortly. For any queries regarding refund, please contact us at hello@papabear4u.com'
                    .tr,
                textAlign: TextAlign.center,
                style: ThemeProvider.sans(
                  size: 13,
                  color: ThemeProvider.greyColor,
                ),
              ),
              const SizedBox(height: 24),
              Column(
                children: [
                  EliteGoldButton(
                    label: 'Goto Appointments'.tr,
                    icon: Icons.schedule,
                    onTap: () {
                      if (Get.isRegistered<BookingController>()) {
                        Get.find<BookingController>().getAppointmentById();
                      }
                      if (Get.isDialogOpen == true) {
                        Get.back();
                      }
                      Get.offNamedUntil(
                        AppRouter.getBookingRoutes(),
                        (route) =>
                            route.settings.name == AppRouter.tabsBarRoutes ||
                            route.isFirst,
                      );
                    },
                  ),
                  const SizedBox(height: 12),

                  // // Done button
                  // SizedBox(
                  //   width: double.infinity,
                  //   child: TextButton(
                  //     onPressed: () {
                  //       Navigator.pop(Get.context!);
                  //     },
                  //     style: TextButton.styleFrom(
                  //       foregroundColor: ThemeProvider.greyColor,
                  //       minimumSize: const Size.fromHeight(48),
                  //       shape: RoundedRectangleBorder(
                  //         borderRadius: BorderRadius.circular(8),
                  //       ),
                  //     ),
                  //     child: Text(
                  //       'Done'.tr,
                  //       style: const TextStyle(
                  //         fontSize: 16,
                  //         fontWeight: FontWeight.w500,
                  //       ),
                  //     ),
                  //   ),
                  // ),
                ],
              ),
            ],
          ),
        ),
      ),
      barrierDismissible: false,
      barrierColor: const Color(0xB8000000),
    );
  }

  void onBack() {
    var context = Get.context as BuildContext;
    Navigator.of(context).pop(true);
  }

  void onAddReview(int id) {
    debugPrint(id.toString());
    var context = Get.context as BuildContext;
    showDialog(
        context: context,
        barrierColor: ThemeProvider.appColor,
        builder: (context) {
          return AlertDialog(
            insetPadding: const EdgeInsets.all(0.0),
            title: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Rate Your Appointment'.tr,
                  style: const TextStyle(fontSize: 14, fontFamily: 'bold'),
                ),
                IconButton(
                    onPressed: () {
                      Get.back();
                    },
                    icon: const Icon(
                      Icons.close,
                      size: 14,
                    ))
              ],
            ),
            content: SizedBox(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(
                      'Owner'.tr,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                          color: ThemeProvider.appColor,
                          fontFamily: 'bold',
                          fontSize: 15),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Text(
                              appointmentInfo.salonId != 0
                                  ? appointmentInfo.salonInfo!.name.toString()
                                  : '${appointmentInfo.ownerInfo!.firstName!} ${appointmentInfo.ownerInfo!.lastName!}',
                              style: const TextStyle(
                                  fontSize: 14, fontFamily: 'bold')),
                          InkWell(
                              onTap: () {
                                Get.back();
                                Get.delete<AddReviewController>(force: true);
                                Get.toNamed(AppRouter.getAddReviewsRoutes(),
                                    arguments: [
                                      'owner',
                                      appointmentInfo.salonId != 0
                                          ? appointmentInfo.salonInfo!.cover
                                              .toString()
                                              .toString()
                                          : appointmentInfo.ownerInfo!.cover
                                              .toString(),
                                      appointmentInfo.salonId != 0
                                          ? appointmentInfo.salonInfo!.name
                                              .toString()
                                          : '${appointmentInfo.ownerInfo!.firstName} ${appointmentInfo.ownerInfo!.lastName}',
                                      appointmentInfo.salonId != 0
                                          ? appointmentInfo.salonId.toString()
                                          : appointmentInfo.freelancerId
                                              .toString()
                                    ]);
                              },
                              child: const Icon(Icons.star_outline,
                                  color: ThemeProvider.orangeColor))
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        appointmentInfo.items!.services!.isNotEmpty
                            ? const Text(
                                'Services',
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                    color: ThemeProvider.appColor,
                                    fontFamily: 'bold',
                                    fontSize: 15),
                              )
                            : const SizedBox(),
                        const SizedBox(
                          height: 10,
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: List.generate(
                              appointmentInfo.items!.services!.length,
                              (serviceIndex) => Padding(
                                    padding:
                                        const EdgeInsets.symmetric(vertical: 5),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        Text(
                                          appointmentInfo.items!
                                              .services![serviceIndex].name
                                              .toString(),
                                          overflow: TextOverflow.ellipsis,
                                          style: const TextStyle(
                                              fontFamily: 'regular',
                                              fontSize: 10,
                                              color: ThemeProvider.blackColor),
                                        ),
                                        InkWell(
                                            onTap: () {
                                              Get.back();
                                              Get.delete<AddReviewController>(
                                                  force: true);
                                              Get.toNamed(
                                                  AppRouter
                                                      .getAddReviewsRoutes(),
                                                  arguments: [
                                                    'service',
                                                    appointmentInfo
                                                        .items!
                                                        .services![serviceIndex]
                                                        .cover
                                                        .toString(),
                                                    appointmentInfo
                                                        .items!
                                                        .services![serviceIndex]
                                                        .name
                                                        .toString(),
                                                    appointmentInfo
                                                        .items!
                                                        .services![serviceIndex]
                                                        .id
                                                        .toString(),
                                                    appointmentInfo.salonId != 0
                                                        ? appointmentInfo
                                                            .salonId
                                                            .toString()
                                                        : appointmentInfo
                                                            .freelancerId
                                                            .toString()
                                                  ]);
                                            },
                                            child: const Icon(
                                                Icons.star_outline,
                                                color:
                                                    ThemeProvider.orangeColor))
                                      ],
                                    ),
                                  )),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        appointmentInfo.items!.packages!.isNotEmpty
                            ? const Text(
                                'Packages',
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                    color: ThemeProvider.appColor,
                                    fontFamily: 'bold',
                                    fontSize: 15),
                              )
                            : const SizedBox(),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: List.generate(
                              appointmentInfo.items!.packages!.length,
                              (packageIndex) => Padding(
                                    padding:
                                        const EdgeInsets.symmetric(vertical: 5),
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: [
                                            Text(
                                              appointmentInfo.items!
                                                  .packages![packageIndex].name
                                                  .toString(),
                                              overflow: TextOverflow.ellipsis,
                                              style: const TextStyle(
                                                  fontFamily: 'regular',
                                                  fontSize: 10,
                                                  color:
                                                      ThemeProvider.blackColor),
                                            ),
                                            InkWell(
                                                onTap: () {
                                                  Get.back();
                                                  Get.delete<
                                                          AddReviewController>(
                                                      force: true);
                                                  Get.toNamed(
                                                      AppRouter
                                                          .getAddReviewsRoutes(),
                                                      arguments: [
                                                        'package',
                                                        appointmentInfo
                                                            .items!
                                                            .packages![
                                                                packageIndex]
                                                            .cover
                                                            .toString(),
                                                        appointmentInfo
                                                            .items!
                                                            .packages![
                                                                packageIndex]
                                                            .name
                                                            .toString(),
                                                        appointmentInfo
                                                            .items!
                                                            .packages![
                                                                packageIndex]
                                                            .id
                                                            .toString(),
                                                        appointmentInfo
                                                                    .salonId !=
                                                                0
                                                            ? appointmentInfo
                                                                .salonId
                                                                .toString()
                                                            : appointmentInfo
                                                                .freelancerId
                                                                .toString()
                                                      ]);
                                                },
                                                child: const Icon(
                                                    Icons.star_outline,
                                                    color: ThemeProvider
                                                        .orangeColor))
                                          ],
                                        ),
                                      ],
                                    ),
                                  )),
                        )
                      ],
                    ),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ),
          );
        });
  }

  bottomBorder() {
    return BoxDecoration(
        border: Border(
            bottom:
                BorderSide(width: 1, color: ThemeProvider.greyColor)));
  }

  Future<void> launchInBrowser() async {
    var url = Uri.parse(invoiceURL);
    if (!await launchUrl(
      url,
      mode: LaunchMode.externalApplication,
    )) {
      throw '${'Could not launch'.tr} $url';
    }
  }

  Future<void> makePhoneCall(String phone) async {
    debugPrint(phone);
    final Uri launchUri = Uri(
      scheme: 'tel',
      path: phone,
    );
    await launchUrl(launchUri);
  }

  Future<void> onMail(String email) async {
    debugPrint(email);
    final Uri launchUri = Uri(
      scheme: 'mailto',
      path: email,
    );
    await launchUrl(launchUri);
  }

  void openHelpModal() {
    final context = Get.context as BuildContext;
    showEliteBottomSheet(
      context,
      title: 'Choose'.tr,
      actions: [
        EliteSheetAction(
          icon: Icons.chat_bubble_outline,
          label: 'Chat'.tr,
          onTap: () {
            Navigator.pop(context);
            Get.delete<ChatController>(force: true);
            Get.toNamed(AppRouter.getChatRoutes(), arguments: [
              parser.getAdminId().toString(),
              parser.getAdminName(),
            ]);
          },
        ),
        EliteSheetAction(
          icon: Icons.report_problem_outlined,
          label: 'Complaints'.tr,
          onTap: () {
            Navigator.pop(context);
            Get.delete<ComplaintsController>(force: true);
            Get.toNamed(
              AppRouter.getComplaintsRoutes(),
              arguments: [appointmentId, 'appointments'],
            );
          },
        ),
        EliteSheetAction(
          icon: Icons.close,
          label: 'Close'.tr,
          destructive: true,
          onTap: () => Navigator.pop(context),
        ),
      ],
    );
  }

  void onContactInfo(String name, String phone, String email, String uid) {
    final context = Get.context as BuildContext;
    showEliteBottomSheet(
      context,
      title: 'Contact'.tr,
      actions: [
        EliteSheetAction(
          icon: Icons.chat_bubble_outline,
          label: 'Chat'.tr,
          onTap: () {
            Navigator.pop(context);
            Get.delete<ChatController>(force: true);
            Get.toNamed(AppRouter.getChatRoutes(), arguments: [uid, name]);
          },
        ),
        EliteSheetAction(
          icon: Icons.phone_outlined,
          label: 'Call'.tr,
          onTap: () {
            Navigator.pop(context);
            makePhoneCall(phone);
          },
        ),
        EliteSheetAction(
          icon: Icons.email_outlined,
          label: 'Email'.tr,
          onTap: () {
            Navigator.pop(context);
            onMail(email);
          },
        ),
        EliteSheetAction(
          icon: Icons.close,
          label: 'Close'.tr,
          destructive: true,
          onTap: () => Navigator.pop(context),
        ),
      ],
    );
  }
}
