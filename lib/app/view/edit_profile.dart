// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:country_code_picker/country_code_picker.dart';
// import 'package:salon_user/app/controller/edit_profile_controller.dart';
// import 'package:salon_user/app/util/theme.dart';
// import 'package:salon_user/app/env.dart';

// class EditProfileScreen extends StatefulWidget {
//   const EditProfileScreen({Key? key}) : super(key: key);

//   @override
//   State<EditProfileScreen> createState() => _EditProfileScreenState();
// }

// class _EditProfileScreenState extends State<EditProfileScreen> {
//   @override
//   Widget build(BuildContext context) {
//     return GetBuilder<EditProfileController>(builder: (value) {
//       return Scaffold(
//         backgroundColor: ThemeProvider.whiteColor,
//         appBar: AppBar(
//           backgroundColor: ThemeProvider.appColor,
//           iconTheme: const IconThemeData(color: ThemeProvider.whiteColor),
//           elevation: 0,
//           centerTitle: true,
//           title: Text(
//             'Edit Profile'.tr,
//             style: ThemeProvider.titleStyle,
//           ),
//         ),
//         body: value.apiCalled == false
//             ? const Center(
//                 child: CircularProgressIndicator(color: ThemeProvider.appColor),
//               )
//             : SingleChildScrollView(
//                 padding: const EdgeInsets.all(16),
//                 child: Column(
//                   children: [
//                     GestureDetector(
//                       onTap: () {
//                         showCupertinoModalPopup<void>(
//                           context: context,
//                           builder: (BuildContext context) =>
//                               CupertinoActionSheet(
//                             title: Text('Choose From'.tr),
//                             actions: <CupertinoActionSheetAction>[
//                               CupertinoActionSheetAction(
//                                 isDefaultAction: true,
//                                 onPressed: () {
//                                   Navigator.pop(context);
//                                   value.selectFromGallery('camera');
//                                 },
//                                 child: Text('Camera'.tr),
//                               ),
//                               CupertinoActionSheetAction(
//                                 onPressed: () {
//                                   Navigator.pop(context);
//                                   value.selectFromGallery('gallery');
//                                 },
//                                 child: Text('Gallery'.tr),
//                               ),
//                               CupertinoActionSheetAction(
//                                 isDestructiveAction: true,
//                                 onPressed: () {
//                                   Navigator.pop(context);
//                                 },
//                                 child: Text('Cancel'.tr),
//                               )
//                             ],
//                           ),
//                         );
//                       },
//                       child: Container(
//                         clipBehavior: Clip.antiAlias,
//                         decoration: BoxDecoration(
//                           borderRadius: BorderRadius.circular(50),
//                         ),
//                         width: 100,
//                         height: 100,
//                         child: FadeInImage(
//                           image: NetworkImage(
//                               '${Environments.imageURL}${value.cover.toString()}'),
//                           placeholder: const AssetImage(
//                               "assets/images/placeholder.jpeg"),
//                           imageErrorBuilder: (context, error, stackTrace) {
//                             return Image.asset(
//                               'assets/images/notfound.png',
//                               fit: BoxFit.cover,
//                               height: 100,
//                               width: 100,
//                             );
//                           },
//                           fit: BoxFit.cover,
//                         ),
//                       ),
//                     ),
//                     const SizedBox(height: 10),
//                     Row(
//                       children: [
//                         Expanded(
//                           child: Container(
//                             padding: const EdgeInsets.symmetric(vertical: 8),
//                             child: Container(
//                               padding:
//                                   const EdgeInsets.symmetric(horizontal: 16),
//                               decoration: BoxDecoration(
//                                 color: ThemeProvider.backgroundColor,
//                                 borderRadius: const BorderRadius.all(
//                                   Radius.circular(8.0),
//                                 ),
//                                 boxShadow: [
//                                   BoxShadow(
//                                       color: ThemeProvider.blackColor
//                                           .withOpacity(0.2),
//                                       offset: const Offset(0, 1),
//                                       blurRadius: 3),
//                                 ],
//                               ),
//                               child: TextFormField(
//                                 controller: value.firstNameTextEditor,
//                                 onChanged: (String txt) {},
//                                 cursorColor: ThemeProvider.appColor,
//                                 decoration: InputDecoration(
//                                     labelStyle: const TextStyle(
//                                         fontSize: 14,
//                                         color: ThemeProvider.greyColor),
//                                     border: InputBorder.none,
//                                     labelText: "First Name".tr),
//                               ),
//                             ),
//                           ),
//                         ),
//                         const SizedBox(width: 10),
//                         Expanded(
//                           child: Container(
//                             padding: const EdgeInsets.symmetric(vertical: 8),
//                             child: Container(
//                               padding:
//                                   const EdgeInsets.symmetric(horizontal: 16),
//                               decoration: BoxDecoration(
//                                 color: ThemeProvider.backgroundColor,
//                                 borderRadius: const BorderRadius.all(
//                                   Radius.circular(8.0),
//                                 ),
//                                 boxShadow: [
//                                   BoxShadow(
//                                       color: ThemeProvider.blackColor
//                                           .withOpacity(0.2),
//                                       offset: const Offset(0, 1),
//                                       blurRadius: 3),
//                                 ],
//                               ),
//                               child: TextFormField(
//                                 controller: value.lastNameTextEditor,
//                                 onChanged: (String txt) {},
//                                 cursorColor: ThemeProvider.appColor,
//                                 decoration: InputDecoration(
//                                     labelStyle: const TextStyle(
//                                         fontSize: 14,
//                                         color: ThemeProvider.greyColor),
//                                     border: InputBorder.none,
//                                     labelText: "Last Name".tr),
//                               ),
//                             ),
//                           ),
//                         ),
//                       ],
//                     ),
//                     GestureDetector(
//                       onTap: () {
//                         showCupertinoModalPopup<void>(
//                           context: context,
//                           builder: (BuildContext context) =>
//                               CupertinoActionSheet(
//                             title: Text('Gender'.tr),
//                             actions: <CupertinoActionSheetAction>[
//                               CupertinoActionSheetAction(
//                                 onPressed: () {
//                                   Navigator.pop(context);
//                                   value.updateGender(1);
//                                 },
//                                 child: Text('Male'.tr),
//                               ),
//                               CupertinoActionSheetAction(
//                                 onPressed: () {
//                                   Navigator.pop(context);
//                                   value.updateGender(0);
//                                 },
//                                 child: Text('Female'.tr),
//                               ),
//                               CupertinoActionSheetAction(
//                                 isDestructiveAction: true,
//                                 onPressed: () {
//                                   Navigator.pop(context);
//                                 },
//                                 child: Text('Cancel'.tr),
//                               )
//                             ],
//                           ),
//                         );
//                       },
//                       child: Container(
//                         width: double.infinity,
//                         margin: const EdgeInsets.symmetric(vertical: 8),
//                         padding: const EdgeInsets.symmetric(
//                             vertical: 8, horizontal: 16),
//                         decoration: BoxDecoration(
//                           color: ThemeProvider.backgroundColor,
//                           borderRadius: const BorderRadius.all(
//                             Radius.circular(8.0),
//                           ),
//                           boxShadow: [
//                             BoxShadow(
//                                 color:
//                                     ThemeProvider.blackColor.withOpacity(0.2),
//                                 offset: const Offset(0, 1),
//                                 blurRadius: 3),
//                           ],
//                         ),
//                         child: Column(
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           children: [
//                             Text(
//                               'Gender'.tr,
//                               style: const TextStyle(
//                                   fontSize: 12, color: ThemeProvider.greyColor),
//                             ),
//                             const SizedBox(height: 4),
//                             Row(
//                               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                               children: [
//                                 Text(
//                                   value.selectedGender == 0
//                                       ? 'Female'.tr
//                                       : 'Male'.tr,
//                                   style: const TextStyle(
//                                       fontSize: 14,
//                                       color: ThemeProvider.blackColor),
//                                 ),
//                                 const Icon(Icons.keyboard_arrow_down,
//                                     color: ThemeProvider.greyColor)
//                               ],
//                             ),
//                           ],
//                         ),
//                       ),
//                     ),
//                     Container(
//                       padding: const EdgeInsets.symmetric(vertical: 8),
//                       child: Container(
//                         padding: const EdgeInsets.symmetric(horizontal: 16),
//                         decoration: BoxDecoration(
//                           color: ThemeProvider.backgroundColor,
//                           borderRadius: const BorderRadius.all(
//                             Radius.circular(8.0),
//                           ),
//                           boxShadow: [
//                             BoxShadow(
//                                 color:
//                                     ThemeProvider.blackColor.withOpacity(0.2),
//                                 offset: const Offset(0, 1),
//                                 blurRadius: 3),
//                           ],
//                         ),
//                         child: TextFormField(
//                           readOnly: true,
//                           controller: value.emailTextEditor,
//                           onChanged: (String txt) {},
//                           cursorColor: ThemeProvider.appColor,
//                           decoration: InputDecoration(
//                               labelStyle: const TextStyle(
//                                   fontSize: 14, color: ThemeProvider.greyColor),
//                               border: InputBorder.none,
//                               labelText: "Email".tr),
//                         ),
//                       ),
//                     ),
//                     Row(
//                       children: [
//                         Container(
//                           padding: const EdgeInsets.symmetric(
//                               horizontal: 8, vertical: 6),
//                           decoration: BoxDecoration(
//                             color: ThemeProvider.backgroundColor,
//                             borderRadius: const BorderRadius.all(
//                               Radius.circular(8.0),
//                             ),
//                             boxShadow: [
//                               BoxShadow(
//                                   color:
//                                       ThemeProvider.blackColor.withOpacity(0.2),
//                                   offset: const Offset(0, 1),
//                                   blurRadius: 3),
//                             ],
//                           ),
//                           width: 60,
//                           child: GestureDetector(
//                             onTap: () {
//                               CountryCodePicker(
//                                 onChanged: (e) => value
//                                     .saveCountryCode(e.dialCode.toString()),
//                                 initialSelection: 'IN',
//                                 favorite: const ['+91', 'IN'],
//                                 showCountryOnly: false,
//                                 showOnlyCountryWhenClosed: false,
//                                 alignLeft: false,
//                               );
//                             },
//                             child: Column(
//                               crossAxisAlignment: CrossAxisAlignment.start,
//                               children: [
//                                 Text(
//                                   'Code'.tr,
//                                   style: const TextStyle(
//                                       fontSize: 12,
//                                       color: ThemeProvider.greyColor),
//                                 ),
//                                 const SizedBox(height: 4),
//                                 Text(
//                                   value.countryCodeMobile.toString(),
//                                   style: const TextStyle(
//                                       fontSize: 14,
//                                       color: ThemeProvider.blackColor),
//                                 )
//                               ],
//                             ),
//                           ),
//                         ),
//                         const SizedBox(width: 10),
//                         Expanded(
//                           child: Container(
//                             padding: const EdgeInsets.symmetric(vertical: 8),
//                             child: Container(
//                               padding:
//                                   const EdgeInsets.symmetric(horizontal: 16),
//                               decoration: BoxDecoration(
//                                 color: ThemeProvider.backgroundColor,
//                                 borderRadius: const BorderRadius.all(
//                                   Radius.circular(8.0),
//                                 ),
//                                 boxShadow: [
//                                   BoxShadow(
//                                       color: ThemeProvider.blackColor
//                                           .withOpacity(0.2),
//                                       offset: const Offset(0, 1),
//                                       blurRadius: 3),
//                                 ],
//                               ),
//                               child: TextFormField(
//                                 // readOnly: true,
//                                 controller: value.mobileTextEditor,
//                                 onChanged: (String txt) {},
//                                 cursorColor: ThemeProvider.appColor,
//                                 decoration: InputDecoration(
//                                     labelStyle: const TextStyle(
//                                         fontSize: 14,
//                                         color: ThemeProvider.greyColor),
//                                     border: InputBorder.none,
//                                     labelText: "Phone".tr),
//                               ),
//                             ),
//                           ),
//                         ),
//                       ],
//                     ),
//                     const SizedBox(height: 10),
//                     SizedBox(
//                       height: 45,
//                       width: double.infinity,
//                       child: ElevatedButton(
//                           onPressed: () {
//                             value.onUpdateInfo();
//                           },
//                           style: ElevatedButton.styleFrom(
//                               backgroundColor: ThemeProvider.appColor,
//                               shadowColor: ThemeProvider.blackColor,
//                               foregroundColor: ThemeProvider.whiteColor,
//                               elevation: 3,
//                               shape: (RoundedRectangleBorder(
//                                 borderRadius: BorderRadius.circular(6),
//                               )),
//                               padding: const EdgeInsets.all(0)),
//                           child: Text(
//                             'Submit'.tr,
//                             style: const TextStyle(
//                                 letterSpacing: 1,
//                                 fontSize: 16,
//                                 color: ThemeProvider.whiteColor,
//                                 fontFamily: 'bold'),
//                           )),
//                     )
//                   ],
//                 )),
//       );
//     });
//   }
// }
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:country_code_picker/country_code_picker.dart';
import 'package:salon_user/app/controller/edit_profile_controller.dart';
import 'package:salon_user/app/util/theme.dart';
import 'package:salon_user/app/env.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({Key? key}) : super(key: key);

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  // Modern Color Scheme
  static const Color primary = ThemeProvider.appColor;
  static const Color primaryDark = ThemeProvider.pink;
  static const Color success = Color(0xFF10B981);
  static const Color warning = Color(0xFFF59E0B);
  static const Color error = Color(0xFFEF4444);
  static const Color info = Color(0xFF3B82F6);
  static const Color background = Color(0xFFF8F9FA);
  static const Color cardBackground = Colors.white;
  static const Color textPrimary = Color(0xFF2C3E50);
  static const Color textSecondary = Color(0xFF64748B);
  static const Color textLight = Color(0xFF94A3B8);
  static const Color borderLight = Color(0xFFE2E8F0);
  static const Color shadowLight = Color(0x0F000000);
  static const Color surfaceBackground = Color(0xFFF1F5F9);

  @override
  Widget build(BuildContext context) {
    return GetBuilder<EditProfileController>(builder: (value) {
      return Scaffold(
        backgroundColor: background,
        appBar: _buildAppBar(),
        body: value.apiCalled == false
            ? const Center(
                child: CircularProgressIndicator(
                  color: primary,
                  strokeWidth: 3,
                ),
              )
            : SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Column(
                  children: [
                    _buildProfileSection(value),
                    _buildFormSection(value),
                  ],
                ),
              ),
      );
    });
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      backgroundColor: primary,
      elevation: 0,
      centerTitle: true,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back, color: Colors.white),
        onPressed: () => Get.back(),
      ),
      title: const Text(
        'Edit Profile',
        style: TextStyle(
          color: Colors.white,
          fontSize: 20,
          fontWeight: FontWeight.w600,
        ),
      ),
      flexibleSpace: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              primary,
              primary.withOpacity(0.8),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildProfileSection(EditProfileController value) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            primary,
            primary.withOpacity(0.8),
          ],
        ),
      ),
      child: Column(
        children: [
          // Profile Picture
          Stack(
            children: [
              Container(
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(70),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.2),
                      blurRadius: 20,
                      offset: const Offset(0, 10),
                    ),
                  ],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(66),
                  child: SizedBox(
                    width: 132,
                    height: 132,
                    child: FadeInImage(
                      image: NetworkImage(
                          '${Environments.imageURL}${value.cover.toString()}'),
                      placeholder:
                          const AssetImage("assets/images/placeholder.jpeg"),
                      imageErrorBuilder: (context, error, stackTrace) {
                        return Container(
                          color: surfaceBackground,
                          child: const Icon(
                            Icons.person,
                            size: 66,
                            color: textLight,
                          ),
                        );
                      },
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
              // Edit button
              Positioned(
                bottom: 0,
                right: 0,
                child: GestureDetector(
                  onTap: () => _showImagePicker(value),
                  child: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: success,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: Colors.white, width: 3),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 10,
                          offset: const Offset(0, 5),
                        ),
                      ],
                    ),
                    child: const Icon(
                      Icons.camera_alt,
                      color: Colors.white,
                      size: 20,
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          const Text(
            'Tap to change profile picture',
            style: TextStyle(
              color: Colors.white,
              fontSize: 14,
              fontWeight: FontWeight.w400,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFormSection(EditProfileController value) {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Personal Information',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w600,
              color: textPrimary,
            ),
          ),
          const SizedBox(height: 24),

          // Name fields
          Row(
            children: [
              Expanded(
                child: _buildTextField(
                  controller: value.firstNameTextEditor,
                  label: 'First Name'.tr,
                  icon: Icons.person_outline,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _buildTextField(
                  controller: value.lastNameTextEditor,
                  label: 'Last Name'.tr,
                  icon: Icons.person_outline,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),

          // Gender selector
          _buildGenderSelector(value),
          const SizedBox(height: 20),

          // Email field
          _buildTextField(
            controller: value.emailTextEditor,
            label: 'Email'.tr,
            icon: Icons.email_outlined,
            readOnly: true,
            suffixIcon:
                const Icon(Icons.lock_outline, color: textLight, size: 16),
          ),
          const SizedBox(height: 20),

          // Phone number
          _buildPhoneField(value),
          const SizedBox(height: 40),

          // Submit button
          _buildSubmitButton(value),
          const SizedBox(height: 24),
        ],
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    bool readOnly = false,
    Widget? suffixIcon,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: cardBackground,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: borderLight),
        boxShadow: const [
          BoxShadow(
            color: shadowLight,
            blurRadius: 10,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: TextField(
        controller: controller,
        readOnly: readOnly,
        style: TextStyle(
          fontSize: 16,
          color: readOnly ? textSecondary : textPrimary,
          fontWeight: FontWeight.w500,
        ),
        decoration: InputDecoration(
          labelText: label,
          labelStyle: const TextStyle(
            color: textSecondary,
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
          prefixIcon: Container(
            padding: const EdgeInsets.all(12),
            child: Icon(
              icon,
              color: primary,
              size: 20,
            ),
          ),
          suffixIcon: suffixIcon,
          border: InputBorder.none,
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          floatingLabelBehavior: FloatingLabelBehavior.auto,
        ),
      ),
    );
  }

  Widget _buildGenderSelector(EditProfileController value) {
    return Container(
      decoration: BoxDecoration(
        color: cardBackground,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: borderLight),
        boxShadow: const [
          BoxShadow(
            color: shadowLight,
            blurRadius: 10,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () => _showGenderPicker(value),
          borderRadius: BorderRadius.circular(12),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  child: Icon(
                    value.selectedGender == 0 ? Icons.female : Icons.male,
                    color: primary,
                    size: 20,
                  ),
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Gender'.tr,
                        style: const TextStyle(
                          color: textSecondary,
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        value.selectedGender == 0 ? 'Female'.tr : 'Male'.tr,
                        style: const TextStyle(
                          color: textPrimary,
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
                const Icon(
                  Icons.expand_more,
                  color: textSecondary,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildPhoneField(EditProfileController value) {
    return Row(
      children: [
        // Country code
        Container(
          width: 90,
          decoration: BoxDecoration(
            color: cardBackground,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: borderLight),
            boxShadow: const [
              BoxShadow(
                color: shadowLight,
                blurRadius: 10,
                offset: Offset(0, 2),
              ),
            ],
          ),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: () => _showCountryCodePicker(value),
              borderRadius: BorderRadius.circular(12),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Code'.tr,
                      style: const TextStyle(
                        color: textSecondary,
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      value.countryCodeMobile.toString(),
                      style: const TextStyle(
                        color: textPrimary,
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
        const SizedBox(width: 16),
        // Phone number
        Expanded(
          child: _buildTextField(
            controller: value.mobileTextEditor,
            label: 'Phone Number'.tr,
            icon: Icons.phone_outlined,
          ),
        ),
      ],
    );
  }

  Widget _buildSubmitButton(EditProfileController value) {
    return SizedBox(
      width: double.infinity,
      height: 56,
      child: ElevatedButton(
        onPressed: () => value.onUpdateInfo(),
        style: ElevatedButton.styleFrom(
          backgroundColor: primaryDark,
          foregroundColor: Colors.white,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          shadowColor: primary.withOpacity(0.3),
        ).copyWith(
          elevation: WidgetStateProperty.resolveWith<double>(
            (Set<WidgetState> states) {
              if (states.contains(WidgetState.pressed)) return 0;
              return 8;
            },
          ),
        ),
        child: Container(
          decoration: BoxDecoration(
            // gradient: LinearGradient(
            //   colors: [primaryDark, primaryDark],
            //   begin: Alignment.centerLeft,
            //   end: Alignment.centerRight,
            // ),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Center(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(
                  Icons.save_outlined,
                  color: Colors.white,
                  size: 20,
                ),
                const SizedBox(width: 8),
                Text(
                  'Update Profile'.tr,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                    letterSpacing: 0.5,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _showImagePicker(EditProfileController value) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (BuildContext context) {
        return Container(
          decoration: const BoxDecoration(
            color: cardBackground,
            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 40,
                height: 4,
                margin: const EdgeInsets.symmetric(vertical: 12),
                decoration: BoxDecoration(
                  color: borderLight,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    Text(
                      'Choose Profile Picture'.tr,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: textPrimary,
                      ),
                    ),
                    const SizedBox(height: 20),
                    Row(
                      children: [
                        Expanded(
                          child: _buildImageOption(
                            icon: Icons.camera_alt,
                            title: 'Camera'.tr,
                            onTap: () {
                              Navigator.pop(context);
                              value.selectFromGallery('camera');
                            },
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: _buildImageOption(
                            icon: Icons.photo_library,
                            title: 'Gallery'.tr,
                            onTap: () {
                              Navigator.pop(context);
                              value.selectFromGallery('gallery');
                            },
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: Text(
                        'Cancel'.tr,
                        style: const TextStyle(
                          color: textSecondary,
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildImageOption({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            border: Border.all(color: borderLight),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: primary.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  icon,
                  color: primary,
                  size: 24,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: textPrimary,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showGenderPicker(EditProfileController value) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (BuildContext context) {
        return Container(
          decoration: const BoxDecoration(
            color: cardBackground,
            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 40,
                height: 4,
                margin: const EdgeInsets.symmetric(vertical: 12),
                decoration: BoxDecoration(
                  color: borderLight,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    Text(
                      'Select Gender'.tr,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: textPrimary,
                      ),
                    ),
                    const SizedBox(height: 20),
                    _buildGenderOption(
                      icon: Icons.male,
                      title: 'Male'.tr,
                      isSelected: value.selectedGender == 1,
                      onTap: () {
                        Navigator.pop(context);
                        value.updateGender(1);
                      },
                    ),
                    const SizedBox(height: 12),
                    _buildGenderOption(
                      icon: Icons.female,
                      title: 'Female'.tr,
                      isSelected: value.selectedGender == 0,
                      onTap: () {
                        Navigator.pop(context);
                        value.updateGender(0);
                      },
                    ),
                    const SizedBox(height: 16),
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: Text(
                        'Cancel'.tr,
                        style: const TextStyle(
                          color: textSecondary,
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildGenderOption({
    required IconData icon,
    required String title,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: isSelected ? primary.withOpacity(0.1) : Colors.transparent,
            border: Border.all(
              color: isSelected ? primary : borderLight,
              width: isSelected ? 2 : 1,
            ),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: isSelected ? primary : primary.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  icon,
                  color: isSelected ? Colors.white : primary,
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),
              Text(
                title,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: isSelected ? primary : textPrimary,
                ),
              ),
              const Spacer(),
              if (isSelected)
                Icon(
                  Icons.check_circle,
                  color: primary,
                  size: 20,
                ),
            ],
          ),
        ),
      ),
    );
  }

  void _showCountryCodePicker(EditProfileController value) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (BuildContext context) {
        return Container(
          height: MediaQuery.of(context).size.height * 0.7,
          decoration: const BoxDecoration(
            color: cardBackground,
            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
          ),
          child: Column(
            children: [
              // Handle bar
              Container(
                width: 40,
                height: 4,
                margin: const EdgeInsets.symmetric(vertical: 12),
                decoration: BoxDecoration(
                  color: borderLight,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              // Title
              Padding(
                padding: const EdgeInsets.all(20),
                child: Text(
                  'Select Country Code'.tr,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: textPrimary,
                  ),
                ),
              ),
              // Country picker
              Expanded(
                child: CountryCodePicker(
                  onChanged: (countryCode) {
                    Navigator.pop(context);
                    value.saveCountryCode(countryCode.dialCode.toString());
                  },
                  initialSelection: 'IN',
                  favorite: const ['+91', 'IN'],
                  showCountryOnly: false,
                  showOnlyCountryWhenClosed: false,
                  alignLeft: false,
                  showDropDownButton: false,
                  showFlagMain: true,
                  flagWidth: 25,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  textStyle: const TextStyle(
                    fontSize: 16,
                    color: textPrimary,
                    fontWeight: FontWeight.w500,
                  ),
                  dialogTextStyle: const TextStyle(
                    fontSize: 14,
                    color: textSecondary,
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
