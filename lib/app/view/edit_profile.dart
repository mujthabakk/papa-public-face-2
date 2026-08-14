import 'package:country_code_picker/country_code_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:salon_user/app/controller/edit_profile_controller.dart';
import 'package:salon_user/app/env.dart';
import 'package:salon_user/app/util/theme.dart';
import 'package:salon_user/app/view/widgets/elite_ui.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({Key? key}) : super(key: key);

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  @override
  Widget build(BuildContext context) {
    return GetBuilder<EditProfileController>(builder: (value) {
      final fullName =
          '${value.firstNameTextEditor.text} ${value.lastNameTextEditor.text}'
              .trim();
      return Scaffold(
        backgroundColor: ThemeProvider.backgroundColor,
        appBar: EliteAppBar(
          showBack: true,
          title: 'Personal Information',
          onMore: () {},
        ),
        body: value.apiCalled == false
            ? const Center(
                child: CircularProgressIndicator(color: ThemeProvider.gold),
              )
            : ListView(
                padding: const EdgeInsets.fromLTRB(16, 8, 16, 32),
                children: [
                  Center(
                    child: Stack(
                      children: [
                        Container(
                          width: 110,
                          height: 110,
                          padding: const EdgeInsets.all(3),
                          decoration: BoxDecoration(
                            border: Border.all(
                                color: ThemeProvider.gold, width: 2),
                            borderRadius: BorderRadius.circular(18),
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(14),
                            child: EliteNetworkImage(
                              url:
                                  '${Environments.imageURL}${value.cover}',
                            ),
                          ),
                        ),
                        Positioned(
                          right: 0,
                          bottom: 0,
                          child: GestureDetector(
                            onTap: () => _showImagePicker(value),
                            child: Container(
                              width: 32,
                              height: 32,
                              decoration: BoxDecoration(
                                color: ThemeProvider.gold,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: const Icon(Icons.camera_alt,
                                  size: 16, color: Colors.black),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 14),
                  Text(
                    fullName.isEmpty ? 'Member'.tr : fullName,
                    textAlign: TextAlign.center,
                    style: ThemeProvider.serif(size: 26),
                  ),
                  const SizedBox(height: 24),
                  _field(
                    'FULL NAME',
                    Icons.person_outline,
                    TextField(
                      controller: value.firstNameTextEditor,
                      style: ThemeProvider.sans(size: 14),
                      decoration: _input('First name'),
                      onChanged: (_) => setState(() {}),
                    ),
                    extra: Padding(
                      padding: const EdgeInsets.only(top: 8),
                      child: TextField(
                        controller: value.lastNameTextEditor,
                        style: ThemeProvider.sans(size: 14),
                        decoration: _input('Last name'),
                        onChanged: (_) => setState(() {}),
                      ),
                    ),
                  ),
                  _field(
                    'EMAIL ADDRESS',
                    Icons.mail_outline,
                    TextField(
                      controller: value.emailTextEditor,
                      readOnly: true,
                      style: ThemeProvider.sans(size: 14),
                      decoration: _input('Email'),
                    ),
                  ),
                  _field(
                    'PHONE NUMBER',
                    Icons.phone_outlined,
                    Row(
                      children: [
                        CountryCodePicker(
                          onChanged: (code) {
                            value.saveCountryCode(
                                (code.dialCode ?? '+91').replaceAll('+', ''));
                          },
                          initialSelection: value.countryCodeMobile,
                          favorite: const ['+91', 'IN'],
                          showFlag: false,
                          showDropDownButton: false,
                          padding: EdgeInsets.zero,
                          textStyle: ThemeProvider.sans(size: 14),
                          dialogBackgroundColor: ThemeProvider.surface,
                          barrierColor: Colors.black54,
                        ),
                        Expanded(
                          child: TextField(
                            controller: value.mobileTextEditor,
                            keyboardType: TextInputType.phone,
                            style: ThemeProvider.sans(size: 14),
                            decoration: _input('Mobile'),
                          ),
                        ),
                      ],
                    ),
                  ),
                  _field(
                    'GENDER',
                    Icons.wc_outlined,
                    InkWell(
                      onTap: () => _showGenderPicker(value),
                      child: Row(
                        children: [
                          Expanded(
                            child: Text(
                              value.selectedGender == 0
                                  ? 'Female'
                                  : 'Male',
                              style: ThemeProvider.sans(size: 14),
                            ),
                          ),
                          const Icon(Icons.keyboard_arrow_down,
                              color: ThemeProvider.gold),
                        ],
                      ),
                    ),
                  ),
                  EliteCard(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Text('Account Verification',
                                style: ThemeProvider.serif(size: 16)),
                            const Spacer(),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 8, vertical: 4),
                              decoration: BoxDecoration(
                                color: const Color(0xFF2E7D32),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Row(
                                children: [
                                  const Icon(Icons.check,
                                      size: 12, color: Colors.white),
                                  const SizedBox(width: 4),
                                  Text(
                                    'VERIFIED',
                                    style: ThemeProvider.sans(
                                      size: 10,
                                      weight: FontWeight.w700,
                                      color: Colors.white,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Your personal information is encrypted using enterprise-grade security.',
                          style: ThemeProvider.sans(
                              size: 12, color: ThemeProvider.greyColor),
                        ),
                      ],
                    ),
                  ),
                  EliteGoldButton(
                    label: 'SAVE CHANGES',
                    icon: Icons.save_outlined,
                    onTap: value.onUpdateInfo,
                  ),
                  const SizedBox(height: 10),
                  EliteGoldButton(
                    label: 'RESET TO DEFAULT',
                    outlined: true,
                    onTap: value.getUserByID,
                  ),
                  const SizedBox(height: 24),
                  const SizedBox(height: 8),
                ],
              ),
      );
    });
  }

  InputDecoration _input(String hint) {
    return InputDecoration(
      hintText: hint,
      hintStyle: ThemeProvider.sans(size: 13, color: ThemeProvider.greyColor),
      border: InputBorder.none,
      isDense: true,
    );
  }

  Widget _field(String label, IconData icon, Widget child, {Widget? extra}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: ThemeProvider.sans(
              size: 11,
              weight: FontWeight.w700,
              color: ThemeProvider.gold,
              letterSpacing: 1.2,
            ),
          ),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            decoration: BoxDecoration(
              color: ThemeProvider.surface,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: const Color(0xFF2C2C2C)),
            ),
            child: Row(
              children: [
                Icon(icon, color: ThemeProvider.gold, size: 18),
                const SizedBox(width: 10),
                Expanded(child: child),
              ],
            ),
          ),
          if (extra != null) extra,
        ],
      ),
    );
  }

  void _showImagePicker(EditProfileController value) {
    Get.bottomSheet(
      Container(
        padding: const EdgeInsets.all(20),
        decoration: const BoxDecoration(
          color: ThemeProvider.surface,
          borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('Choose Profile Picture'.tr,
                style: ThemeProvider.serif(size: 18)),
            const SizedBox(height: 16),
            EliteGoldButton(
              label: 'CAMERA',
              icon: Icons.camera_alt,
              onTap: () {
                Get.back();
                value.selectFromGallery('camera');
              },
            ),
            const SizedBox(height: 10),
            EliteGoldButton(
              label: 'GALLERY',
              outlined: true,
              onTap: () {
                Get.back();
                value.selectFromGallery('gallery');
              },
            ),
          ],
        ),
      ),
    );
  }

  void _showGenderPicker(EditProfileController value) {
    Get.bottomSheet(
      Container(
        padding: const EdgeInsets.all(20),
        decoration: const BoxDecoration(
          color: ThemeProvider.surface,
          borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('Select Gender'.tr, style: ThemeProvider.serif(size: 18)),
            const SizedBox(height: 12),
            ListTile(
              leading: const Icon(Icons.male, color: ThemeProvider.gold),
              title: Text('Male'.tr, style: ThemeProvider.sans()),
              onTap: () {
                value.updateGender(1);
                Get.back();
              },
            ),
            ListTile(
              leading: const Icon(Icons.female, color: ThemeProvider.gold),
              title: Text('Female'.tr, style: ThemeProvider.sans()),
              onTap: () {
                value.updateGender(0);
                Get.back();
              },
            ),
          ],
        ),
      ),
    );
  }
}
