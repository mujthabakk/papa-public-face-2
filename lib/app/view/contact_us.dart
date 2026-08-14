import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:salon_user/app/controller/contact_us_controller.dart';
import 'package:salon_user/app/util/theme.dart';
import 'package:salon_user/app/view/widgets/elite_ui.dart';

class ContactUsScreen extends StatefulWidget {
  const ContactUsScreen({Key? key}) : super(key: key);

  @override
  State<ContactUsScreen> createState() => _ContactUsScreenState();
}

class _ContactUsScreenState extends State<ContactUsScreen> {
  InputDecoration _dec(String hint) {
    return InputDecoration(
      hintText: hint,
      hintStyle: ThemeProvider.sans(size: 13, color: ThemeProvider.greyColor),
      filled: true,
      fillColor: ThemeProvider.surface,
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
    return GetBuilder<ContactUsController>(
      builder: (value) {
        return Scaffold(
          backgroundColor: ThemeProvider.backgroundColor,
          appBar: const EliteAppBar(showBack: true, title: 'Contact Us'),
          body: ListView(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
            children: [
              TextField(
                controller: value.nameContact,
                style: ThemeProvider.sans(size: 14),
                decoration: _dec('Full Name'.tr),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: value.emailContanct,
                keyboardType: TextInputType.emailAddress,
                style: ThemeProvider.sans(size: 14),
                decoration: _dec('Email Address'.tr),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: value.messageContanct,
                maxLines: 6,
                style: ThemeProvider.sans(size: 14),
                decoration: _dec('Message'.tr),
              ),
              const SizedBox(height: 24),
              EliteGoldButton(
                label: value.isLogin.value ? 'PLEASE WAIT' : 'SUBMIT',
                onTap: value.saveContacts,
              ),
            ],
          ),
        );
      },
    );
  }
}
