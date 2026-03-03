import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:salon_user/app/backend/api/handler.dart';
import 'package:salon_user/app/backend/models/appointment_model.dart';
import 'package:salon_user/app/backend/models/issuewith_model.dart';
import 'package:salon_user/app/backend/models/product_salon_model.dart';
import 'package:salon_user/app/backend/parse/complaints_parse.dart';
import 'package:image_picker/image_picker.dart';
import 'package:salon_user/app/util/theme.dart';
import 'package:salon_user/app/util/toast.dart';

class ComplaintsController extends GetxController implements GetxService {
  final ComplaintsParser parser;
  String orderId = '';
  bool apiCalled = false;
  RxBool isLogin = false.obs;
  List<IssueItemsModel> _issueWithList = <IssueItemsModel>[];
  List<IssueItemsModel> get issueWithList => _issueWithList;

  ProductSalonModel _details = ProductSalonModel();
  ProductSalonModel get details => _details;

  AppointmentModel _appointmentDetail = AppointmentModel();
  AppointmentModel get appointmentDetail => _appointmentDetail;

  XFile? _selectedImage;

  List<String> reasonList = [
    'The Product arrived too late'.tr,
    'The Product did not match the description'.tr,
    'The Purchase was fraudulent'.tr,
    'The Product was damaged or defective'.tr,
    'The Merchant shipped the wrong item'.tr,
    'Wrong Item Size or Wrong Product Shipped'.tr,
    'Driver arrived too late'.tr,
    'Driver behavior'.tr,
    'Employee/Freelacer behavior'.tr,
    'Issue with Payment Amount'.tr,
    'Others'.tr,
  ];

  List<String> freelancerReasonsList = [
    'Employee/Freelancer arrived too late'.tr,
    'Employee/Freelancer did not match the description'.tr,
    'Employee/Freelancer was fraudulent'.tr,
    'Related to service'.tr,
    'Satisfaction of services'.tr,
    'Employee/Freelacer behavior'.tr,
    'Issue with Payment Amount'.tr,
    'Others'.tr,
  ];
  String issueWith = '1';
  String issueWithText = '';

  String freelancerID = '';
  String freelancerName = '';

  String selectedReason = '';

  String productId = '';
  String productName = '';

  String serviceId = '';
  String serviceName = '';

  final title = TextEditingController();
  final comments = TextEditingController();
  int complaintsOn = 0;

  List<String> savedImages = [''];
  ComplaintsController({required this.parser});

  @override
  void onInit() {
    super.onInit();

    orderId = Get.arguments[0].toString();

    debugPrint('OrderID $orderId');
    if (Get.arguments[1] == 'products') {
      complaintsOn = 1;
      issueWithText = 'Order';
      update();
      debugPrint('producs');
      productId = '';
      productName = '';
      getOrderDetails();
    } else {
      debugPrint('appointments');
      complaintsOn = 0;
      issueWith = '6';
      issueWithText = 'Service';
      serviceName = '';
      serviceId = '';

      update();
      getAppointmentById();
    }
  }

  Future<void> getAppointmentById() async {
    var response = await parser.getAppointmentById({"id": orderId});
    apiCalled = true;
    if (response.statusCode == 200) {
      Map<String, dynamic> myMap = Map<String, dynamic>.from(response.body);
      _appointmentDetail = AppointmentModel();
      var body = myMap['data'];
      AppointmentModel data = AppointmentModel.fromJson(body);
      _appointmentDetail = data;
      update();
      if (_appointmentDetail.salonId != 0) {
        freelancerID = _appointmentDetail.salonId.toString();
        freelancerName = _appointmentDetail.salonInfo!.name.toString();
      } else {
        freelancerID = _appointmentDetail.freelancerId.toString();
        freelancerName =
            '${_appointmentDetail.individualInfo!.firstName} ${_appointmentDetail.individualInfo!.lastName}';
      }

      debugPrint('freelancer id$freelancerID');
      debugPrint('freelancer name$freelancerName');

      _issueWithList = [];
      var orderParam = {"id": 6, "name": "Service".tr};
      _issueWithList.add(IssueItemsModel.fromJson(orderParam));

      var freelancerParam = {"id": 2, "name": "Business/Freelancer".tr};
      _issueWithList.add(IssueItemsModel.fromJson(freelancerParam));

      var packageParam = {"id": 9, "name": "Packages".tr};
      _issueWithList.add(IssueItemsModel.fromJson(packageParam));
    } else {
      ApiChecker.checkApi(response);
    }
    update();
  }

  Future<void> getOrderDetails() async {
    Response response = await parser.getOrderDetails(orderId);
    apiCalled = true;
    if (response.statusCode == 200) {
      Map<String, dynamic> myMap = Map<String, dynamic>.from(response.body);
      dynamic orderInfo = myMap["data"];
      ProductSalonModel orderData = ProductSalonModel.fromJson(orderInfo);
      _details = orderData;
      if (_details.type == 'salon') {
        freelancerID = _details.salonId.toString();
        freelancerName = _details.salonInfo!.name.toString();
      } else {
        freelancerID = _details.freelancerId.toString();
        freelancerName =
            '${_details.freelancerInfo!.firstName} ${_details.freelancerInfo!.lastName}';
      }
      debugPrint('freelancer id$freelancerID');
      debugPrint('freelancer name$freelancerName');
      _issueWithList = [];
      var orderParam = {"id": 1, "name": "Order".tr};
      _issueWithList.add(IssueItemsModel.fromJson(orderParam));

      var freelancerParam = {"id": 2, "name": "Business/Freelancer".tr};
      _issueWithList.add(IssueItemsModel.fromJson(freelancerParam));

      var productParam = {"id": 4, "name": "Product".tr};
      _issueWithList.add(IssueItemsModel.fromJson(productParam));
      update();
    } else {
      ApiChecker.checkApi(response);
      update();
    }
  }

  Future<void> onIssueModal() async {
    var context = Get.context as BuildContext;

    serviceName = '';
    serviceId = '';
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            scrollable: true,
            title: Text(
              'Choose Issue With'.tr,
              style: const TextStyle(fontSize: 14, fontFamily: 'bold'),
              textAlign: TextAlign.center,
            ),
            content: Column(
              children: [
                SizedBox(
                  height: 200.0, // Change as per your requirement
                  width: 300.0, // Change as per your requirement
                  child: Scrollbar(
                    child: ListView.builder(
                      shrinkWrap: true,
                      itemCount: issueWithList.length,
                      itemBuilder: (BuildContext context, int index) {
                        Color getColor(Set<MaterialState> states) {
                          return ThemeProvider.appColor;
                        }

                        return ListTile(
                          textColor: ThemeProvider.appColor,
                          iconColor: ThemeProvider.appColor,
                          title: Text(issueWithList[index].name.toString()),
                          leading: Radio(
                              fillColor:
                                  MaterialStateProperty.resolveWith(getColor),
                              value: issueWithList[index].id.toString(),
                              groupValue: issueWith,
                              onChanged: (e) {
                                issueWith = e.toString();
                                var selected = issueWithList
                                    .firstWhere((element) =>
                                        element.id.toString() == issueWith)
                                    .name;
                                issueWithText = selected!;
                                update();
                                Navigator.pop(context);
                              }),
                        );
                      },
                    ),
                  ),
                ),
              ],
            ),
          );
        });
  }

  Future<void> onReasonModal() async {
    var context = Get.context as BuildContext;

    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            scrollable: true,
            title: Text(
              'Choose Reason'.tr,
              style: const TextStyle(fontSize: 14, fontFamily: 'bold'),
              textAlign: TextAlign.center,
            ),
            content: Column(
              children: [
                SizedBox(
                  height: 200.0, // Change as per your requirement
                  width: 300.0, // Change as per your requirement
                  child: Scrollbar(
                    child: complaintsOn == 1
                        ? ListView.builder(
                            shrinkWrap: true,
                            itemCount: reasonList.length,
                            itemBuilder: (BuildContext context, int index) {
                              Color getColor(Set<MaterialState> states) {
                                return ThemeProvider.appColor;
                              }

                              return ListTile(
                                textColor: ThemeProvider.appColor,
                                iconColor: ThemeProvider.appColor,
                                title: Text(reasonList[index].toString()),
                                leading: Radio(
                                    fillColor:
                                        MaterialStateProperty.resolveWith(
                                            getColor),
                                    value: reasonList[index].toString(),
                                    groupValue: selectedReason,
                                    onChanged: (e) {
                                      selectedReason = e.toString();
                                      update();
                                      Navigator.pop(context);
                                    }),
                              );
                            },
                          )
                        : ListView.builder(
                            shrinkWrap: true,
                            itemCount: freelancerReasonsList.length,
                            itemBuilder: (BuildContext context, int index) {
                              Color getColor(Set<MaterialState> states) {
                                return ThemeProvider.appColor;
                              }

                              return ListTile(
                                textColor: ThemeProvider.appColor,
                                iconColor: ThemeProvider.appColor,
                                title: Text(
                                    freelancerReasonsList[index].toString()),
                                leading: Radio(
                                    fillColor:
                                        MaterialStateProperty.resolveWith(
                                            getColor),
                                    value:
                                        freelancerReasonsList[index].toString(),
                                    groupValue: selectedReason,
                                    onChanged: (e) {
                                      selectedReason = e.toString();
                                      update();
                                      Navigator.pop(context);
                                    }),
                              );
                            },
                          ),
                  ),
                ),
              ],
            ),
          );
        });
  }

  Future<void> onServiceModal() async {
    var context = Get.context as BuildContext;

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
              borderRadius:
                  BorderRadius.circular(15)), // Modern rounded corners
          scrollable: true,
          title: Text(
            'Choose Service'.tr,
            style: const TextStyle(
              fontSize: 18, // Slightly larger for prominence
              fontFamily: 'bold',
              color: ThemeProvider.blackColor,
            ),
            textAlign: TextAlign.center,
          ),
          content: SizedBox(
            width: 300.0, // Consistent width
            child: appointmentDetail.items!.services!.isEmpty
                ? // Check if services list is empty
                Padding(
                    padding: const EdgeInsets.symmetric(vertical: 20),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.info_outline,
                          size: 40,
                          color: ThemeProvider.greyColor,
                        ),
                        const SizedBox(height: 10),
                        Text(
                          'No services available in this order'.tr,
                          style: const TextStyle(
                            fontSize: 14,
                            color: ThemeProvider.greyColor,
                            fontWeight: FontWeight.w500,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  )
                : // Services list is not empty
                SizedBox(
                    height: 200.0, // Fixed height for scrollable content
                    child: Scrollbar(
                      thumbVisibility:
                          true, // Always show scrollbar for clarity
                      child: ListView.builder(
                        shrinkWrap: true,
                        itemCount: appointmentDetail.items!.services!.length,
                        itemBuilder: (BuildContext context, int index) {
                          final service =
                              appointmentDetail.items!.services![index];
                          Color getColor(Set<MaterialState> states) {
                            return ThemeProvider.appColor;
                          }

                          return ListTile(
                            contentPadding: const EdgeInsets.symmetric(
                                horizontal: 10, vertical: 2), // Compact padding
                            title: Text(
                              service.name.toString(),
                              style: const TextStyle(
                                fontSize: 14,
                                color: ThemeProvider.blackColor,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            leading: Radio<String>(
                              fillColor:
                                  MaterialStateProperty.resolveWith(getColor),
                              value: service.id.toString(),
                              groupValue: serviceId,
                              onChanged: (e) {
                                serviceId = e.toString();
                                serviceName = appointmentDetail.items!.services!
                                    .firstWhere((element) =>
                                        element.id.toString() == serviceId)
                                    .name
                                    .toString();
                                update(); // Assuming this updates the controller state
                                Navigator.pop(context);
                              },
                            ),
                            tileColor: serviceId == service.id.toString()
                                ? ThemeProvider.appColor
                                    .withOpacity(0.1) // Highlight selected item
                                : null,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(
                                  8), // Rounded list items
                            ),
                          );
                        },
                      ),
                    ),
                  ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              style: TextButton.styleFrom(
                foregroundColor: ThemeProvider.appColor,
                textStyle: const TextStyle(fontFamily: 'bold', fontSize: 14),
              ),
              child: Text('Close'.tr),
            ),
          ],
        );
      },
    );
  }

  Future<void> onPackageModal() async {
    var context = Get.context as BuildContext;

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
              borderRadius:
                  BorderRadius.circular(15)), // Rounded corners for modern look
          scrollable: true,
          title: Text(
            'Choose Package'.tr,
            style: const TextStyle(
              fontSize: 18, // Slightly larger for emphasis
              fontFamily: 'bold',
              color: ThemeProvider.blackColor,
            ),
            textAlign: TextAlign.center,
          ),
          content: SizedBox(
            width: 300.0, // Consistent width
            child: appointmentDetail.items!.packages!.isEmpty
                ? // Check if packages list is empty
                Padding(
                    padding: const EdgeInsets.symmetric(vertical: 20),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.info_outline,
                          size: 40,
                          color: ThemeProvider.greyColor,
                        ),
                        const SizedBox(height: 10),
                        Text(
                          'No packages available in this order'.tr,
                          style: const TextStyle(
                            fontSize: 14,
                            color: ThemeProvider.greyColor,
                            fontWeight: FontWeight.w500,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  )
                : // Packages list is not empty
                SizedBox(
                    height: 200.0, // Fixed height for scrollable content
                    child: Scrollbar(
                      thumbVisibility: true, // Always show scrollbar
                      child: ListView.builder(
                        shrinkWrap: true,
                        itemCount: appointmentDetail.items!.packages!.length,
                        itemBuilder: (BuildContext context, int index) {
                          final package =
                              appointmentDetail.items!.packages![index];
                          Color getColor(Set<MaterialState> states) {
                            return ThemeProvider.appColor;
                          }

                          return ListTile(
                            contentPadding: const EdgeInsets.symmetric(
                                horizontal: 10, vertical: 2), // Compact padding
                            title: Text(
                              package.name.toString(),
                              style: const TextStyle(
                                fontSize: 14,
                                color: ThemeProvider.blackColor,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            leading: Radio<String>(
                              fillColor:
                                  MaterialStateProperty.resolveWith(getColor),
                              value: package.id.toString(),
                              groupValue: serviceId,
                              onChanged: (e) {
                                serviceId = e.toString();
                                serviceName = appointmentDetail.items!.packages!
                                    .firstWhere((element) =>
                                        element.id.toString() == serviceId)
                                    .name
                                    .toString();
                                update(); // Assuming this updates the controller state
                                Navigator.pop(context);
                              },
                            ),
                            tileColor: serviceId == package.id.toString()
                                ? ThemeProvider.appColor
                                    .withOpacity(0.1) // Highlight selected item
                                : null,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(
                                  8), // Rounded list items
                            ),
                          );
                        },
                      ),
                    ),
                  ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              style: TextButton.styleFrom(
                foregroundColor: ThemeProvider.appColor,
                textStyle: const TextStyle(fontFamily: 'bold', fontSize: 14),
              ),
              child: Text('Close'.tr),
            ),
          ],
        );
      },
    );
  }

  Future<void> onProductModal() async {
    var context = Get.context as BuildContext;

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
              borderRadius:
                  BorderRadius.circular(15)), // Modern rounded corners
          scrollable: true,
          title: Text(
            'Choose Product'.tr,
            style: const TextStyle(
              fontSize: 18, // Slightly larger for emphasis
              fontFamily: 'bold',
              color: ThemeProvider.blackColor,
            ),
            textAlign: TextAlign.center,
          ),
          content: SizedBox(
            width: 300.0, // Consistent width
            child: details.orders!.isEmpty
                ? // Check if orders list is empty
                Padding(
                    padding: const EdgeInsets.symmetric(vertical: 20),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.info_outline,
                          size: 40,
                          color: ThemeProvider.greyColor,
                        ),
                        const SizedBox(height: 10),
                        Text(
                          'No products available in this order'.tr,
                          style: const TextStyle(
                            fontSize: 14,
                            color: ThemeProvider.greyColor,
                            fontWeight: FontWeight.w500,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  )
                : // Orders list is not empty
                SizedBox(
                    height: 200.0, // Fixed height for scrollable content
                    child: Scrollbar(
                      thumbVisibility: true, // Always show scrollbar
                      child: ListView.builder(
                        shrinkWrap: true,
                        itemCount: details.orders!.length,
                        itemBuilder: (BuildContext context, int index) {
                          final product = details.orders![index];
                          Color getColor(Set<MaterialState> states) {
                            return ThemeProvider.appColor;
                          }

                          return ListTile(
                            contentPadding: const EdgeInsets.symmetric(
                                horizontal: 10, vertical: 2), // Compact padding
                            title: Text(
                              product.name.toString(),
                              style: const TextStyle(
                                fontSize: 14,
                                color: ThemeProvider.blackColor,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            leading: Radio<String>(
                              fillColor:
                                  MaterialStateProperty.resolveWith(getColor),
                              value: product.id.toString(),
                              groupValue: productId,
                              onChanged: (e) {
                                productId = e.toString();
                                productName = details.orders!
                                    .firstWhere((element) =>
                                        element.id.toString() == productId)
                                    .name
                                    .toString();
                                update(); // Assuming this updates the controller state
                                Navigator.pop(context);
                              },
                            ),
                            tileColor: productId == product.id.toString()
                                ? ThemeProvider.appColor
                                    .withOpacity(0.1) // Highlight selected item
                                : null,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(
                                  8), // Rounded list items
                            ),
                          );
                        },
                      ),
                    ),
                  ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              style: TextButton.styleFrom(
                foregroundColor: ThemeProvider.appColor,
                textStyle: const TextStyle(fontFamily: 'bold', fontSize: 14),
              ),
              child: Text('Close'.tr),
            ),
          ],
        );
      },
    );
  }

  Future<void> onImageModal() async {
    var context = Get.context as BuildContext;
    showCupertinoModalPopup<void>(
      context: context,
      builder: (BuildContext context) => CupertinoActionSheet(
        title: Text('Choose From'.tr),
        actions: <CupertinoActionSheetAction>[
          CupertinoActionSheetAction(
            child: Text('Gallery'.tr),
            onPressed: () {
              Navigator.pop(context);
              selectFromGallery('gallery'.tr);
            },
          ),
          CupertinoActionSheetAction(
            child: Text('Camera'.tr),
            onPressed: () {
              Navigator.pop(context);
              selectFromGallery('Camera'.tr);
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

  void selectFromGallery(String kind) async {
    _selectedImage = await ImagePicker().pickImage(
        source: kind == 'gallery' ? ImageSource.gallery : ImageSource.camera,
        imageQuality: 25);
    update();
    if (_selectedImage != null) {
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
      Response response = await parser.uploadImage(_selectedImage as XFile);
      Get.back();
      if (response.statusCode == 200) {
        _selectedImage = null;
        if (response.body['data'] != null && response.body['data'] != '') {
          dynamic body = response.body["data"];
          if (body['image_name'] != null && body['image_name'] != '') {
            savedImages.add(body['image_name']);
            update();
          }
        }
      } else {
        ApiChecker.checkApi(response);
      }
    }
  }

  Future<void> onSubmit() async {
    if (issueWith != '' &&
        selectedReason != '' &&
        title.text != '' &&
        comments.text != '') {
      if (issueWith == '1' && freelancerID != '') {
        callAPI();
      } else if (issueWith == '2' && freelancerID != '') {
        callAPI();
      } else if (issueWith == '4' && productId != '') {
        callAPI();
      }
    } else {
      showToast('All fields are required'.tr);
    }
  }

  Future<void> onSave() async {
    debugPrint('on save');
    if (issueWith != '' &&
        selectedReason != '' &&
        title.text != '' &&
        comments.text != '') {
      if (issueWith == '6' && serviceId != '') {
        saveComplaints();
      } else if (issueWith == '2' && freelancerID != '') {
        saveComplaints();
      } else if (issueWith == '9' && serviceId != '') {
        saveComplaints();
      }
    } else {
      showToast('All fields are required'.tr);
    }
  }

  Future<void> saveComplaints() async {
    var reasonIndex = freelancerReasonsList.indexOf(selectedReason);
    var param = {
      'uid': parser.getUID(),
      'order_id': 0,
      'appointment_id': orderId,
      'complaints_on': complaintsOn,
      'issue_with': issueWith,
      'freelancer_id': freelancerID,
      'product_id': serviceId != '' ? serviceId : 0,
      'reason_id': reasonIndex,
      'title': title.text,
      'short_message': comments.text,
      'status': 0,
      'images': jsonEncode(savedImages)
    };
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
    Response response = await parser.registerComplaints(param);
    isLogin.value = !isLogin.value;
    update();
    Get.back();
    if (response.statusCode == 200) {
      successToast('Complaints registered'.tr);
      onBack();
    } else {
      isLogin.value = !isLogin.value;
      ApiChecker.checkApi(response);
      update();
    }
  }

  Future<void> callAPI() async {
    var reasonIndex = reasonList.indexOf(selectedReason);
    var param = {
      'uid': parser.getUID(),
      'order_id': orderId,
      'appointment_id': 0,
      'complaints_on': complaintsOn,
      'issue_with': issueWith,
      'freelancer_id': freelancerID,
      'product_id': productId != '' ? productId : 0,
      'reason_id': reasonIndex,
      'title': title.text,
      'short_message': comments.text,
      'status': 0,
      'images': jsonEncode(savedImages)
    };
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
    Response response = await parser.registerComplaints(param);
    isLogin.value = !isLogin.value;
    update();
    Get.back();
    if (response.statusCode == 200) {
      successToast('Complaints registered'.tr);
      onBack();
    } else {
      isLogin.value = !isLogin.value;
      ApiChecker.checkApi(response);
      update();
    }
  }

  void onBack() {
    var context = Get.context as BuildContext;
    Navigator.of(context).pop(true);
  }
}
