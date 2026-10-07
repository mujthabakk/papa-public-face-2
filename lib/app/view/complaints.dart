import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:salon_user/app/controller/complaints_controller.dart';
import 'package:salon_user/app/env.dart';
import 'package:salon_user/app/util/theme.dart';
import 'package:salon_user/app/view/widgets/elite_ui.dart';

class ComplaintScreen extends StatefulWidget {
  const ComplaintScreen({Key? key}) : super(key: key);

  @override
  State<ComplaintScreen> createState() => _ComplaintScreenState();
}

class _ComplaintScreenState extends State<ComplaintScreen> {
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

  Widget _picker({
    required String label,
    required String value,
    required VoidCallback onTap,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          decoration: BoxDecoration(
            color: ThemeProvider.surface,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: const Color(0xFF2C2C2C)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: ThemeProvider.sans(
                  size: 10,
                  color: ThemeProvider.gold,
                  letterSpacing: 0.8,
                ),
              ),
              const SizedBox(height: 6),
              Row(
                children: [
                  Expanded(
                    child: Text(
                      value,
                      style: ThemeProvider.sans(size: 14),
                    ),
                  ),
                  const Icon(Icons.expand_more, color: ThemeProvider.gold),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ComplaintsController>(
      builder: (value) {
        return Scaffold(
          backgroundColor: ThemeProvider.backgroundColor,
          appBar: EliteAppBar(showBack: true, title: 'Complaints'.tr),
          body: value.apiCalled == false
              ? const Center(
                  child: CircularProgressIndicator(color: ThemeProvider.gold),
                )
              : AbsorbPointer(
                  absorbing: value.isLogin.value,
                  child: ListView(
                    padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
                    children: [
                      _picker(
                        label: 'Issue With'.tr,
                        value: value.issueWithText,
                        onTap: value.onIssueModal,
                      ),
                      if (value.issueWith == '1' ||
                          value.issueWith == '2' ||
                          value.issueWith == '6')
                        _picker(
                          label: 'Business/Freelancer'.tr,
                          value: value.freelancerName.isNotEmpty
                              ? value.freelancerName
                              : 'Select Freelancer'.tr,
                          onTap: () {},
                        ),
                      if (value.issueWith == '4')
                        _picker(
                          label: 'Select product'.tr,
                          value: value.productName.isNotEmpty
                              ? value.productName
                              : 'Select product'.tr,
                          onTap: value.onProductModal,
                        ),
                      if (value.issueWith == '6')
                        _picker(
                          label: 'Select service'.tr,
                          value: value.serviceName.isNotEmpty
                              ? value.serviceName
                              : 'Select service'.tr,
                          onTap: value.onServiceModal,
                        ),
                      if (value.issueWith == '9')
                        _picker(
                          label: 'Select package'.tr,
                          value: value.serviceName.isNotEmpty
                              ? value.serviceName
                              : 'Select package'.tr,
                          onTap: value.onPackageModal,
                        ),
                      _picker(
                        label: 'Select Reason'.tr,
                        value: value.selectedReason.isNotEmpty
                            ? value.selectedReason
                            : 'Select Reason'.tr,
                        onTap: value.onReasonModal,
                      ),
                      TextField(
                        controller: value.title,
                        style: ThemeProvider.sans(size: 14),
                        textInputAction: TextInputAction.next,
                        decoration: _dec('Title / Brief of your issue'.tr),
                      ),
                      const SizedBox(height: 12),
                      TextField(
                        controller: value.comments,
                        style: ThemeProvider.sans(size: 14),
                        maxLines: 5,
                        decoration: _dec('Comments'.tr),
                      ),
                      const SizedBox(height: 16),
                      GridView.count(
                        crossAxisCount: 3,
                        crossAxisSpacing: 10,
                        mainAxisSpacing: 10,
                        padding: EdgeInsets.zero,
                        shrinkWrap: true,
                        childAspectRatio: 1,
                        physics: const NeverScrollableScrollPhysics(),
                        children: List.generate(value.savedImages.length,
                            (index) {
                          final empty = value.savedImages[index] == '' &&
                              index == 0;
                          if (empty) {
                            return InkWell(
                              onTap: value.onImageModal,
                              borderRadius: BorderRadius.circular(12),
                              child: Container(
                                decoration: BoxDecoration(
                                  color: ThemeProvider.surface,
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border.all(
                                      color: const Color(0xFF2C2C2C)),
                                ),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    const Icon(Icons.cloud_upload_outlined,
                                        color: ThemeProvider.gold, size: 28),
                                    const SizedBox(height: 8),
                                    Text(
                                      'Upload Image'.tr,
                                      textAlign: TextAlign.center,
                                      style: ThemeProvider.sans(
                                        size: 11,
                                        color: ThemeProvider.greyColor,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          }
                          return ClipRRect(
                            borderRadius: BorderRadius.circular(12),
                            child: EliteNetworkImage(
                              url:
                                  '${Environments.imageURL}${value.savedImages[index]}',
                              width: double.infinity,
                              height: double.infinity,
                            ),
                          );
                        }),
                      ),
                      const SizedBox(height: 24),
                      EliteGoldButton(
                        label: value.isLogin.value
                            ? 'PLEASE WAIT'.tr
                            : 'Submit'.tr,
                        onTap: () {
                          if (value.complaintsOn == 1) {
                            value.onSubmit();
                          } else {
                            value.onSave();
                          }
                        },
                      ),
                    ],
                  ),
                ),
        );
      },
    );
  }
}
