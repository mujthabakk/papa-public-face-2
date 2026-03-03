import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:salon_user/app/backend/api/handler.dart';
import 'package:salon_user/app/backend/models/product_salon_model.dart';
import 'package:salon_user/app/backend/parse/product_order_detail_parse.dart';
import 'package:salon_user/app/controller/add_review_controller.dart';
import 'package:salon_user/app/controller/chat_controller.dart';
import 'package:salon_user/app/controller/complaints_controller.dart';
import 'package:salon_user/app/controller/product_order_controller.dart';
import 'package:salon_user/app/helper/router.dart';
import 'package:salon_user/app/util/constant.dart';
import 'package:salon_user/app/util/theme.dart';
import 'package:salon_user/app/util/toast.dart';
import 'package:url_launcher/url_launcher.dart';

class ProductOrderDetailController extends GetxController
    implements GetxService {
  final ProductOrderDetailParser parser;

  ProductSalonModel _salonOrderInfo = ProductSalonModel();
  ProductSalonModel get salonOrderInfo => _salonOrderInfo;

  bool apiCalled = false;

  int orderId = 0;

  String fullAddres = '';
  String name = '';
  String slot = '';
  String createdAt = '';
  String discount = '';
  String walletDiscount = '';
  String distanceCost = '';
  String serviceTax = '';
  String total = '';
  String grandTotal = '';

  String firstName = '';
  String lastName = '';

  String invoiceURL = '';

  String currencySide = AppConstants.defaultCurrencySide;
  String currencySymbol = AppConstants.defaultCurrencySymbol;

  String orderStatus = 'Created';

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
  ProductOrderDetailController({required this.parser});

  @override
  void onInit() {
    super.onInit();
    currencySide = parser.getCurrencySide();
    currencySymbol = parser.getCurrencySymbol();
    orderId = int.parse(Get.arguments[0].toString());
    // orderId = 18;
    debugPrint('order id --> $orderId');
    invoiceURL =
        '${parser.apiService.appBaseUrl}${AppConstants.getProductInvoice}$orderId&token=${parser.getToken()}';
    getAppointmentDetails();
  }

  Future<void> getAppointmentDetails() async {
    var response = await parser.getOrderDetails({"id": orderId});
    apiCalled = true;
    if (response.statusCode == 200) {
      Map<String, dynamic> myMap = Map<String, dynamic>.from(response.body);
      var body = myMap['data'];

      _salonOrderInfo = ProductSalonModel();
      ProductSalonModel salonInfo = ProductSalonModel.fromJson(body);
      _salonOrderInfo = salonInfo;
      if (salonOrderInfo.status == 1) {
        orderStatus = 'Accepted'.tr;
      } else if (salonOrderInfo.status == 2) {
        orderStatus = 'Rejected by Freelancer'.tr;
      } else if (salonOrderInfo.status == 3) {
        orderStatus = 'Ongoing'.tr;
      } else if (salonOrderInfo.status == 4) {
        orderStatus = 'Completed'.tr;
      } else if (salonOrderInfo.status == 5) {
        orderStatus = 'Cancelled'.tr;
      } else if (salonOrderInfo.status == 6) {
        orderStatus = 'Refunded'.tr;
      } else if (salonOrderInfo.status == 7) {
        orderStatus = 'Delayed'.tr;
      } else if (salonOrderInfo.status == 8) {
        orderStatus = 'Pending Payment'.tr;
      }
      debugPrint(orderStatus);
      if (salonOrderInfo.type == 'salon') {
        name = _salonOrderInfo.salonInfo!.name as String;
      } else {
        firstName = salonInfo.freelancerInfo!.firstName as String;
        lastName = salonInfo.freelancerInfo!.lastName as String;
      }
      fullAddres =
          '${_salonOrderInfo.address!.house!} ${_salonOrderInfo.address!.landmark!} ${_salonOrderInfo.address!.address!} ${_salonOrderInfo.address!.pincode!}';
      slot = _salonOrderInfo.dateTime as String;
      createdAt = _salonOrderInfo.createdAt as String;
      walletDiscount = _salonOrderInfo.walletPrice.toString();
      discount = _salonOrderInfo.discount.toString();
      distanceCost = _salonOrderInfo.deliveryCharge.toString();
      serviceTax = _salonOrderInfo.tax.toString();
      total = _salonOrderInfo.total.toString();
      grandTotal = _salonOrderInfo.grandTotal.toString();
      debugPrint(salonOrderInfo.ownerInfo!.email);
      update();
    } else {
      ApiChecker.checkApi(response);
    }
    update();
  }

  // Future<void> onUpdateAppointmentStatus(int status) async {
  //   Get.dialog(
  //       SimpleDialog(
  //         children: [
  //           Row(
  //             children: [
  //               const SizedBox(
  //                 width: 30,
  //               ),
  //               const CircularProgressIndicator(
  //                 color: ThemeProvider.appColor,
  //               ),
  //               const SizedBox(
  //                 width: 30,
  //               ),
  //               SizedBox(
  //                   child: Text(
  //                 "Please wait".tr,
  //                 style: const TextStyle(fontFamily: 'bold'),
  //               )),
  //             ],
  //           )
  //         ],
  //       ),
  //       barrierDismissible: false);
  //   var body = {"id": orderId, "status": status};
  //   Response response = await parser.updateProductOrder(body);
  //   Get.back();
  //   if (response.statusCode == 200) {
  //     // successToast('Status Updated'.tr);
  //     // Get.find<ProductOrderController>().getProductById();
  //     //onBack(); // list refresh

  //     showCancellationSuccessDialog();
  //   } else {
  //     ApiChecker.checkApi(response);
  //   }
  //   update();
  // }

  Future<void> onUpdateAppointmentStatus(int status) async {
    // Show confirmation dialog for cancellation
    if (status == 5) {
      // Assuming 5 is the cancel status code
      bool? shouldCancel = await showCancelConfirmationDialog();
      if (shouldCancel != true) {
        return; // User cancelled the action
      }
    }

    // Show loading dialog
    Get.dialog(
        SimpleDialog(
          children: [
            Row(
              children: [
                const SizedBox(width: 30),
                const CircularProgressIndicator(
                  color: ThemeProvider.appColor,
                ),
                const SizedBox(width: 30),
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

    var body = {"id": orderId, "status": status};
    Response response = await parser.updateProductOrder(body);
    Get.back(); // Close loading dialog

    if (response.statusCode == 200) {
      showCancellationSuccessDialog();
    } else {
      ApiChecker.checkApi(response);
    }
    update();
  }

  Future<bool?> showCancelConfirmationDialog() async {
    return await Get.dialog<bool>(
      Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Warning Icon
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.red.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.warning_outlined,
                  size: 64,
                  color: Colors.red,
                ),
              ),
              const SizedBox(height: 24),

              // Title
              Text(
                'Cancel Appointment?'.tr,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: ThemeProvider.blackColor,
                ),
              ),
              const SizedBox(height: 8),

              // Description
              Text(
                'Do you want to cancel this appointment? This action cannot be undone.'
                    .tr,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 14,
                  color: ThemeProvider.greyColor,
                  height: 1.4,
                ),
              ),
              const SizedBox(height: 24),

              // Buttons
              Row(
                children: [
                  // Cancel Button (Keep appointment)
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () {
                        Get.back(result: false); // Don't cancel
                      },
                      style: OutlinedButton.styleFrom(
                        side: BorderSide(color: ThemeProvider.greyColor),
                        minimumSize: const Size.fromHeight(48),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: Text(
                        'Close'.tr,
                        style: TextStyle(
                          color: ThemeProvider.blackColor,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),

                  // Confirm Cancel Button
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        Get.back(result: true); // Confirm cancellation
                      },
                      style: ElevatedButton.styleFrom(
                        foregroundColor: ThemeProvider.whiteColor,
                        backgroundColor: Colors.red,
                        minimumSize: const Size.fromHeight(48),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        elevation: 0,
                      ),
                      child: Text(
                        'Yes, Cancel'.tr,
                        style: const TextStyle(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
      barrierDismissible: false,
    );
  }

// Alternative simpler confirmation dialog
  Future<bool?> showSimpleCancelConfirmationDialog() async {
    return await Get.dialog<bool>(
      AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        title: Text(
          'Cancel Appointment'.tr,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        content: Text(
          'Do you want to cancel this appointment?'.tr,
          style: TextStyle(
            color: ThemeProvider.greyColor,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Get.back(result: false); // Don't cancel
            },
            child: Text(
              'No'.tr,
              style: TextStyle(
                color: ThemeProvider.greyColor,
              ),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              Get.back(result: true); // Confirm cancellation
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
            ),
            child: Text('Yes, Cancel'.tr),
          ),
        ],
      ),
      barrierDismissible: false,
    );
  }

  void showCancellationSuccessDialog() {
    Get.dialog(
      Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Success icon
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: ThemeProvider.greenColor.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.check_circle_outline,
                  size: 64,
                  color: ThemeProvider.greenColor,
                ),
              ),
              const SizedBox(height: 24),

              // Success title
              Text(
                'Order Cancelled'.tr,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: ThemeProvider.blackColor,
                ),
              ),
              const SizedBox(height: 8),

              // Success message
              Text(
                'Your order has been successfully cancelled. You will receive a confirmation email shortly. For any queries regarding refund, please contact us at hello@papabear4u.com'
                    .tr,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 14,
                  color: ThemeProvider.greyColor,
                  height: 1.4,
                ),
              ),
              const SizedBox(height: 24),

              // Action buttons
              Column(
                children: [
                  // Book new appointment button
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: () {
                        Get.find<ProductOrderController>().getProductById();
                        onBack(); // list refresh
                        onBack();
                      },
                      icon: const Icon(Icons.schedule, size: 18),
                      label: Text('Goto Order List'.tr),
                      style: ElevatedButton.styleFrom(
                        foregroundColor: ThemeProvider.whiteColor,
                        backgroundColor: ThemeProvider.appColor,
                        minimumSize: const Size.fromHeight(48),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        elevation: 0,
                      ),
                    ),
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
                  'Rate Your Orders'.tr,
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
                              salonOrderInfo.salonId != 0
                                  ? salonOrderInfo.salonInfo!.name.toString()
                                  : '${salonOrderInfo.ownerInfo!.firstName!} ${salonOrderInfo.ownerInfo!.lastName!}',
                              style: const TextStyle(
                                  fontSize: 14, fontFamily: 'bold')),
                          InkWell(
                              onTap: () {
                                Get.back();
                                Get.delete<AddReviewController>(force: true);
                                Get.toNamed(AppRouter.getAddReviewsRoutes(),
                                    arguments: [
                                      'owner',
                                      salonOrderInfo.salonId != 0
                                          ? salonOrderInfo.salonInfo!.cover
                                              .toString()
                                          : salonOrderInfo.ownerInfo!.cover
                                              .toString(),
                                      salonOrderInfo.salonId != 0
                                          ? salonOrderInfo.salonInfo!.name
                                              .toString()
                                          : '${salonOrderInfo.ownerInfo!.firstName} ${salonOrderInfo.ownerInfo!.lastName}',
                                      salonOrderInfo.salonId != 0
                                          ? salonOrderInfo.salonId.toString()
                                          : salonOrderInfo.freelancerId
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
                        salonOrderInfo.orders!.isNotEmpty
                            ? Text(
                                'Products'.tr,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
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
                              salonOrderInfo.orders!.length,
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
                                          salonOrderInfo
                                              .orders![serviceIndex].name
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
                                                    'products',
                                                    salonOrderInfo
                                                        .orders![serviceIndex]
                                                        .cover
                                                        .toString(),
                                                    salonOrderInfo
                                                        .orders![serviceIndex]
                                                        .name
                                                        .toString(),
                                                    salonOrderInfo
                                                        .orders![serviceIndex]
                                                        .id
                                                        .toString(),
                                                    salonOrderInfo.salonId != 0
                                                        ? salonOrderInfo.salonId
                                                            .toString()
                                                        : salonOrderInfo
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

  void onContactInfo(String name, String phone, String email, String uid) {
    var context = Get.context as BuildContext;
    showCupertinoModalPopup<void>(
      context: context,
      builder: (BuildContext context) => CupertinoActionSheet(
        title: Text('Choose'.tr),
        actions: <CupertinoActionSheetAction>[
          CupertinoActionSheetAction(
            child: Text(
              'Chat'.tr,
              style: const TextStyle(color: ThemeProvider.appColor),
            ),
            onPressed: () {
              Navigator.pop(context);
              Get.delete<ChatController>(force: true);
              Get.toNamed(AppRouter.getChatRoutes(), arguments: [uid, name]);
            },
          ),
          CupertinoActionSheetAction(
            child: Text(
              'Call'.tr,
              style: const TextStyle(color: ThemeProvider.appColor),
            ),
            onPressed: () {
              Navigator.pop(context);
              makePhoneCall(phone);
            },
          ),
          CupertinoActionSheetAction(
            child: Text(
              'Email'.tr,
              style: const TextStyle(color: ThemeProvider.appColor),
            ),
            onPressed: () {
              Navigator.pop(context);
              onMail(email);
            },
          ),
          CupertinoActionSheetAction(
            child: Text(
              'Cancel'.tr,
              style: const TextStyle(fontFamily: 'bold', color: Colors.red),
            ),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ],
      ),
    );
  }

  void openHelpModal() {
    var context = Get.context as BuildContext;
    showCupertinoModalPopup<void>(
      context: context,
      builder: (BuildContext context) => CupertinoActionSheet(
        title: Text('Choose'.tr),
        actions: <CupertinoActionSheetAction>[
          CupertinoActionSheetAction(
            child: Text(
              'Chat'.tr,
              style: const TextStyle(color: ThemeProvider.appColor),
            ),
            onPressed: () {
              Navigator.pop(context);
              Get.delete<ChatController>(force: true);
              Get.toNamed(AppRouter.getChatRoutes(), arguments: [
                parser.getAdminId().toString(),
                parser.getAdminName()
              ]);
            },
          ),
          CupertinoActionSheetAction(
            child: Text(
              'Complaints'.tr,
              style: const TextStyle(color: ThemeProvider.appColor),
            ),
            onPressed: () {
              Navigator.pop(context);
              Get.delete<ComplaintsController>(force: true);
              Get.toNamed(AppRouter.getComplaintsRoutes(),
                  arguments: [orderId, 'products']);
            },
          ),
          CupertinoActionSheetAction(
            child: Text(
              'Cancel'.tr,
              style: const TextStyle(fontFamily: 'bold', color: Colors.red),
            ),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ],
      ),
    );
  }
}
