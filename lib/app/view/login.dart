import 'package:country_code_picker/country_code_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:salon_user/app/controller/login_controller.dart';
import 'package:salon_user/app/helper/router.dart';
import 'package:salon_user/app/util/theme.dart';
import 'package:salon_user/app/view/widgets/elite_ui.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  InputDecoration _dec(String label, {Widget? suffix}) {
    return InputDecoration(
      labelText: label,
      labelStyle: ThemeProvider.sans(size: 13, color: ThemeProvider.greyColor),
      filled: true,
      fillColor: ThemeProvider.surface,
      suffixIcon: suffix,
      floatingLabelBehavior: FloatingLabelBehavior.never,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Color(0xFF2C2C2C)),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: ThemeProvider.gold),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<LoginController>(builder: (value) {
      return Scaffold(
        backgroundColor: ThemeProvider.backgroundColor,
        body: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Column(
              children: [
                const SizedBox(height: 40),
                Text(
                  'PAPA BEAR',
                  style: ThemeProvider.serif(
                    size: 32,
                    color: ThemeProvider.gold,
                    letterSpacing: 3,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Sign in to your elite account',
                  style: ThemeProvider.sans(
                      size: 13, color: ThemeProvider.greyColor),
                ),
                const SizedBox(height: 36),
                if (value.loginVersion == 0) ...[
                  TextField(
                    controller: value.emailTextEditor,
                    keyboardType: TextInputType.emailAddress,
                    style: ThemeProvider.sans(size: 14),
                    decoration: _dec('Email Address'.tr),
                  ),
                  const SizedBox(height: 14),
                  TextField(
                    controller: value.passwordTextEditor,
                    obscureText: !value.passwordVisible,
                    style: ThemeProvider.sans(size: 14),
                    decoration: _dec(
                      'Password'.tr,
                      suffix: IconButton(
                        onPressed: () {
                          value.passwordVisible = !value.passwordVisible;
                          value.update();
                        },
                        icon: Icon(
                          value.passwordVisible
                              ? Icons.visibility_off
                              : Icons.visibility,
                          color: ThemeProvider.gold,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  EliteGoldButton(label: 'LOG IN', onTap: value.onLogin),
                ] else if (value.loginVersion == 1) ...[
                  _phoneRow(value),
                  const SizedBox(height: 14),
                  TextField(
                    controller: value.passwordTextEditor,
                    obscureText: !value.passwordVisible,
                    style: ThemeProvider.sans(size: 14),
                    decoration: _dec(
                      'Password'.tr,
                      suffix: IconButton(
                        onPressed: () {
                          value.passwordVisible = !value.passwordVisible;
                          value.update();
                        },
                        icon: Icon(
                          value.passwordVisible
                              ? Icons.visibility_off
                              : Icons.visibility,
                          color: ThemeProvider.gold,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  EliteGoldButton(
                      label: 'LOG IN', onTap: value.loginWithPhonePassword),
                ] else ...[
                  _phoneRow(value),
                  const SizedBox(height: 24),
                  EliteGoldButton(
                      label: 'SEND OTP', onTap: value.loginWithPhoneOTP),
                ],
                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton(
                    onPressed: () =>
                        Get.toNamed(AppRouter.getResetPasswordRoute()),
                    child: Text(
                      'Forgot Password ?'.tr,
                      style: ThemeProvider.sans(
                          size: 12, color: ThemeProvider.gold),
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                TextButton(
                  onPressed: () => Get.toNamed(AppRouter.getRegisterRoute()),
                  child: Text.rich(
                    TextSpan(
                      text: 'New here? '.tr,
                      style: ThemeProvider.sans(
                          size: 13, color: ThemeProvider.greyColor),
                      children: [
                        TextSpan(
                          text: 'Create Account'.tr,
                          style: ThemeProvider.sans(
                            size: 13,
                            weight: FontWeight.w700,
                            color: ThemeProvider.gold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    });
  }

  Widget _phoneRow(LoginController value) {
    return Container(
      decoration: BoxDecoration(
        color: ThemeProvider.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFF2C2C2C)),
      ),
      child: Row(
        children: [
          CountryCodePicker(
            onChanged: (e) =>
                value.updateCountryCode(e.dialCode.toString()),
            initialSelection: 'IN',
            favorite: const ['+91', 'IN'],
            showFlag: false,
            padding: EdgeInsets.zero,
            textStyle: ThemeProvider.sans(size: 14),
            dialogBackgroundColor: ThemeProvider.surface,
          ),
          Expanded(
            child: TextField(
              controller: value.mobileNo,
              keyboardType: TextInputType.phone,
              style: ThemeProvider.sans(size: 14),
              decoration: InputDecoration(
                border: InputBorder.none,
                hintText: 'Phone Number'.tr,
                hintStyle: ThemeProvider.sans(
                    size: 14, color: ThemeProvider.greyColor),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
