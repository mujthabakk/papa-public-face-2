import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:salon_user/app/backend/api/handler.dart';
import 'package:salon_user/app/backend/parse/account_parse.dart';
import 'package:salon_user/app/controller/address_controller.dart';
import 'package:salon_user/app/controller/app_pages_controller.dart';
import 'package:salon_user/app/controller/chat_controller.dart';
import 'package:salon_user/app/controller/edit_profile_controller.dart';
import 'package:salon_user/app/controller/login_controller.dart';
import 'package:salon_user/app/controller/product_cart_controller.dart';
import 'package:salon_user/app/controller/product_order_controller.dart';
import 'package:salon_user/app/controller/refer_and_earn_controller.dart';
import 'package:salon_user/app/controller/reset_password_controller.dart';
import 'package:salon_user/app/controller/service_cart_controller.dart';
import 'package:salon_user/app/controller/tabs_controller.dart';
import 'package:salon_user/app/controller/wallet_controller.dart';
import 'package:salon_user/app/helper/router.dart';
import 'package:salon_user/app/util/theme.dart';

class AccountController extends GetxController implements GetxService {
  final AccountParser parser;

  String cover = '';
  String firstName = '';
  String lastName = '';
  String email = '';
  String userId = '';

  AccountController({required this.parser});

  @override
  void onInit() {
    super.onInit();
    changeInfo();
  }

  void changeInfo() {
    firstName = parser.getFirstName();
    lastName = parser.getLastName();
    userId = parser.getUid();
    email = parser.getEmail();
    cover = parser.getCover();
    debugPrint('Update');
    update();
  }

  void onDeleteAccount() {
    // First confirmation dialog - Warning about consequences
    Get.dialog(
      AlertDialog(
        //
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        title: Row(
          children: [
            Icon(
              Icons.warning_amber_rounded,
              color: Colors.red[700],
              size: 28,
            ),
            const SizedBox(width: 10),
            Text(
              'Delete Account?'.tr,
              style: const TextStyle(
                fontFamily: 'bold',
                fontSize: 20,
                color: Colors.red,
              ),
            ),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'This action cannot be undone. Deleting your account will:'.tr,
              style: const TextStyle(
                fontFamily: 'semibold',
                fontSize: 15,
              ),
            ),
            const SizedBox(height: 16),
            _buildWarningItem(
                'Permanently delete your profile and all data (Your account will be deleted within 30 days)'
                    .tr),
            _buildWarningItem('Remove all your services and appointments'.tr),
            _buildWarningItem('Delete all your reviews and ratings'.tr),
            _buildWarningItem('Cancel any active bookings'.tr),
            _buildWarningItem('Remove access to your account immediately'.tr),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.red[50],
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.red[200]!),
              ),
              child: Row(
                children: [
                  Icon(Icons.info_outline, color: Colors.red[700], size: 20),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'This action is permanent and cannot be reversed'.tr,
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.red[700],
                        fontFamily: 'medium',
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: Text(
              'Cancel'.tr,
              style: const TextStyle(
                fontFamily: 'medium',
                fontSize: 16,
              ),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              Get.back();
              _showFinalConfirmation();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: Text(
              'Continue'.tr,
              style: const TextStyle(
                fontFamily: 'semibold',
                fontSize: 16,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
      barrierDismissible: false,
    );
  }

  Widget _buildWarningItem(String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(
            Icons.close,
            color: Colors.red,
            size: 18,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(
                fontSize: 14,
                height: 1.4,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showFinalConfirmation() {
    final TextEditingController confirmController = TextEditingController();

    Get.dialog(
      AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        title: Text(
          'Final Confirmation'.tr,
          style: const TextStyle(
            fontFamily: 'bold',
            fontSize: 20,
            color: Colors.red,
          ),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'To confirm account deletion, please type DELETE below:'.tr,
              style: const TextStyle(
                fontSize: 14,
                fontFamily: 'medium',
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: confirmController,
              decoration: InputDecoration(
                hintText: 'Type DELETE'.tr,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: const BorderSide(color: Colors.red),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: const BorderSide(color: Colors.red, width: 2),
                ),
              ),
              textCapitalization: TextCapitalization.characters,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: Text(
              'Cancel'.tr,
              style: const TextStyle(
                fontFamily: 'medium',
                fontSize: 16,
              ),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              if (confirmController.text.toUpperCase() == 'DELETE') {
                Get.back();
                _performAccountDeletion();
              } else {
                Get.snackbar(
                  'Error'.tr,
                  'Please type DELETE to confirm'.tr,
                  snackPosition: SnackPosition.BOTTOM,
                  backgroundColor: Colors.red,
                  colorText: Colors.white,
                );
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red[700],
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: Text(
              'Delete Account'.tr,
              style: const TextStyle(
                fontFamily: 'semibold',
                fontSize: 16,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
      barrierDismissible: false,
    );
  }

  Future<void> _performAccountDeletion() async {
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
                  "Deleting account...".tr,
                  style: const TextStyle(fontFamily: 'bold'),
                )),
              ],
            )
          ],
        ),
        barrierDismissible: false);

    Response response = await parser.onDelete();
    Get.back();

    if (response.statusCode == 200) {
      parser.clearAccount();
      Get.dialog(
        AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: Row(
            children: [
              Icon(
                Icons.check_circle,
                color: Colors.green[600],
                size: 28,
              ),
              const SizedBox(width: 10),
              Text(
                'Account Deleted'.tr,
                style: TextStyle(
                  fontFamily: 'bold',
                  fontSize: 20,
                  color: Colors.green[700],
                ),
              ),
            ],
          ),
          content: Text(
            'Your account has been permanently deleted within 30 days. We\'re sorry to see you go.'
                .tr,
            style: const TextStyle(fontSize: 15),
          ),
          actions: [
            ElevatedButton(
              onPressed: () {
                parser.clearAccount();
                Get.back();
                Get.toNamed(AppRouter.getInitialRoute());
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: ThemeProvider.appColor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: Text(
                'OK'.tr,
                style: const TextStyle(
                  fontFamily: 'semibold',
                  fontSize: 16,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
        barrierDismissible: false,
      );
    } else {
      ApiChecker.checkApi(response);
    }
    update();
  }

  Future<void> logout() async {
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
    Response response = await parser.logout();
    // Get.back();
    if (response.statusCode == 200) {
      parser.clearAccount();
      Get.find<ServiceCartController>().clearCart();
      Get.find<ProductCartController>().clearCart();
      Get.find<TabsController>().updateCartValue();
      Get.offAllNamed(AppRouter.getSplashRoute());

      update();
    } else {
      ApiChecker.checkApi(response);
    }
    update();
  }

  void cleanData() {
    parser.clearAccount();
  }

  void onProductOrder() {
    Get.delete<ProductOrderController>(force: true);
    Get.toNamed(AppRouter.getProductOrder());
  }

  void onAddress() {
    Get.delete<AddressController>(force: true);
    Get.toNamed(AppRouter.getAddressRoutes());
  }

  void onWallet() {
    Get.delete<WalletController>(force: true);
    Get.toNamed(AppRouter.getWalletRoutes());
  }

  void onReferAndEarn() {
    Get.delete<ReferAndEarnController>(force: true);
    Get.toNamed(AppRouter.getReferAndEarnRoutes());
  }

  void onChangePassword() {
    Get.delete<ResetPasswordController>(force: true);
    Get.toNamed(AppRouter.getResetPasswordRoute());
  }

  void onLanguages() {
    Get.toNamed(AppRouter.getLanguagesRoutes());
  }

  void onAccountChat() {
    Get.delete<ChatController>(force: true);
    Get.toNamed(AppRouter.getAccountChatRoutes());
  }

  void onContactUs() {
    Get.toNamed(AppRouter.getContactUsRoutes());
  }

  void onAppPages(String name, String id) {
    debugPrint('$name = $id');
    Get.delete<AppPagesController>(force: true);
    Get.toNamed(AppRouter.getAppPagesRoutes(),
        arguments: [name, id], preventDuplicates: false);
  }

  void onLogin() {
    Get.delete<LoginController>(force: true);
    Get.toNamed(AppRouter.getLoginRoute());
  }

  void onEdit() {
    Get.delete<EditProfileController>(force: true);
    Get.toNamed(AppRouter.getEditProfileRoutes());
  }
}
