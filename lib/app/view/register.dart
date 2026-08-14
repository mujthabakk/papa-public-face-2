import 'package:country_code_picker/country_code_picker.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:salon_user/app/controller/register_controller.dart';
import 'package:salon_user/app/util/theme.dart';
import 'package:salon_user/app/view/widgets/elite_ui.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({Key? key}) : super(key: key);

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  bool passwordVisible = false;

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
    return GetBuilder<RegisterController>(builder: (value) {
      return Scaffold(
        backgroundColor: ThemeProvider.backgroundColor,
        appBar: const EliteAppBar(showBack: true, title: 'Create Account'),
        body: ListView(
          padding: const EdgeInsets.fromLTRB(20, 8, 20, 32),
          children: [
            TextField(
              controller: value.firstNameTextEditor,
              style: ThemeProvider.sans(size: 14),
              decoration: _dec('First Name'.tr),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: value.lastNameTextEditor,
              style: ThemeProvider.sans(size: 14),
              decoration: _dec('Last Name'.tr),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: value.emailTextEditor,
              keyboardType: TextInputType.emailAddress,
              style: ThemeProvider.sans(size: 14),
              decoration: _dec('Email Address'.tr),
            ),
            const SizedBox(height: 12),
            Container(
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
                      controller: value.mobileTextEditor,
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
            ),
            const SizedBox(height: 12),
            TextField(
              controller: value.passwordTextEditor,
              obscureText: !passwordVisible,
              style: ThemeProvider.sans(size: 14),
              decoration: _dec(
                'Password'.tr,
                suffix: IconButton(
                  onPressed: () =>
                      setState(() => passwordVisible = !passwordVisible),
                  icon: Icon(
                    passwordVisible ? Icons.visibility_off : Icons.visibility,
                    color: ThemeProvider.gold,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: value.referralCodeTextEditor,
              style: ThemeProvider.sans(size: 14),
              decoration: _dec('Referral Code'.tr),
            ),
            const SizedBox(height: 16),
            Text.rich(
              TextSpan(
                text: 'By continuing, you agree to our '.tr,
                style: ThemeProvider.sans(
                    size: 11, color: ThemeProvider.greyColor),
                children: [
                  TextSpan(
                    text: 'Terms of Service'.tr,
                    style: ThemeProvider.sans(
                        size: 11, color: ThemeProvider.gold),
                    recognizer: TapGestureRecognizer()
                      ..onTap = () =>
                          value.onAppPages('Terms & Conditions'.tr, '3'),
                  ),
                  TextSpan(text: ' and '.tr),
                  TextSpan(
                    text: 'Privacy Policy'.tr,
                    style: ThemeProvider.sans(
                        size: 11, color: ThemeProvider.gold),
                    recognizer: TapGestureRecognizer()
                      ..onTap = () =>
                          value.onAppPages('Privacy Policy'.tr, '2'),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            EliteGoldButton(label: 'CREATE ACCOUNT', onTap: value.onRegister),
          ],
        ),
      );
    });
  }
}
