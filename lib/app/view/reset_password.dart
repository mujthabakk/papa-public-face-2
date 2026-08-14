import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:salon_user/app/controller/reset_password_controller.dart';
import 'package:salon_user/app/util/theme.dart';
import 'package:salon_user/app/view/widgets/elite_ui.dart';

class ResetPasswordScreen extends StatefulWidget {
  const ResetPasswordScreen({Key? key}) : super(key: key);

  @override
  State<ResetPasswordScreen> createState() => _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends State<ResetPasswordScreen> {
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
    return GetBuilder<ResetPasswordController>(builder: (value) {
      return Scaffold(
        backgroundColor: ThemeProvider.backgroundColor,
        appBar: const EliteAppBar(showBack: true, title: 'Reset Password'),
        body: AbsorbPointer(
          absorbing: value.isLogin.value,
          child: ListView(
            padding: const EdgeInsets.fromLTRB(20, 12, 20, 32),
            children: [
              if (value.divNumber == 1) ...[
                Text(
                  'Enter your email address and we will send a verification code to generate a new password'
                      .tr,
                  style: ThemeProvider.sans(
                      size: 13, color: ThemeProvider.greyColor),
                ),
                const SizedBox(height: 20),
                TextField(
                  controller: value.emailReset,
                  keyboardType: TextInputType.emailAddress,
                  style: ThemeProvider.sans(size: 14),
                  decoration: _dec('Email Address'.tr),
                ),
                const SizedBox(height: 24),
                EliteGoldButton(label: 'SEND CODE', onTap: value.sendMail),
              ] else ...[
                Text(
                  'Generate New Password'.tr,
                  style: ThemeProvider.serif(size: 20, color: ThemeProvider.gold),
                ),
                const SizedBox(height: 20),
                TextField(
                  controller: value.passwordReset,
                  obscureText: !value.passwordVisible.value,
                  style: ThemeProvider.sans(size: 14),
                  decoration: _dec(
                    'New Password'.tr,
                    suffix: IconButton(
                      onPressed: value.togglePassword,
                      icon: Icon(
                        value.passwordVisible.value
                            ? Icons.visibility_off
                            : Icons.visibility,
                        color: ThemeProvider.gold,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: value.confirmPasswordReset,
                  obscureText: !value.passwordVisible.value,
                  style: ThemeProvider.sans(size: 14),
                  decoration: _dec('Confirm Password'.tr),
                ),
                const SizedBox(height: 24),
                EliteGoldButton(
                    label: 'UPDATE PASSWORD', onTap: value.updatePassword),
              ],
            ],
          ),
        ),
      );
    });
  }
}
