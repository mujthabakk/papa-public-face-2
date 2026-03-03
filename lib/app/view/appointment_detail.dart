import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:salon_user/app/controller/appointment_detail_controller.dart';
import 'package:salon_user/app/env.dart';
import 'package:salon_user/app/util/theme.dart';

class AppointmentDetailScreen extends StatefulWidget {
  const AppointmentDetailScreen({Key? key}) : super(key: key);

  @override
  State<AppointmentDetailScreen> createState() =>
      _AppointmentDetailScreenState();
}

class _AppointmentDetailScreenState extends State<AppointmentDetailScreen> {
  @override
  Widget build(BuildContext context) {
    return GetBuilder<AppointmentDetailController>(
      builder: (value) {
        return Scaffold(
          backgroundColor: ThemeProvider.whiteColor,
          appBar: AppBar(
            backgroundColor: ThemeProvider.appColor,
            elevation: 0,
            centerTitle: true,
            iconTheme: const IconThemeData(color: ThemeProvider.whiteColor),
            title: Text(
              'Appointment Detail'.tr,
              style: ThemeProvider.titleStyle,
            ),
            actions: <Widget>[
              IconButton(
                onPressed: () => value.launchInBrowser(),
                icon: const Icon(Icons.print_outlined),
              ),
              IconButton(
                onPressed: () => value.openHelpModal(),
                icon: const Icon(Icons.question_mark_outlined),
              ),
            ],
          ),
          body: value.apiCalled != true
              ? const Center(
                  child: CircularProgressIndicator(
                    color: ThemeProvider.appColor,
                  ),
                )
              : _buildAppointmentDetails(value),
          bottomNavigationBar: value.apiCalled == false
              ? const SizedBox()
              : _buildBottomBar(value),
        );
      },
    );
  }

  Widget _buildAppointmentDetails(AppointmentDetailController value) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            _buildInfoCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildProviderInfo(value),
                  const Divider(height: 24, thickness: 1),
                  _buildSectionHeader('Booking Date & Time'.tr),
                  const SizedBox(height: 8),
                  _buildInfoRow('Booking Date'.tr, value.savedDate),
                  const SizedBox(height: 4),
                  _buildInfoRow('Booking Time'.tr, value.slot),
                ],
              ),
            ),
            const SizedBox(height: 16),
            if (value.appointmentInfo.items!.services!.isNotEmpty ||
                value.appointmentInfo.items!.packages!.isNotEmpty)
              _buildInfoCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (value.appointmentInfo.items!.services!.isNotEmpty) ...[
                      _buildSectionHeader('Services'.tr),
                      const SizedBox(height: 8),
                      ..._buildServices(value),
                      const SizedBox(height: 16),
                    ],
                    if (value.appointmentInfo.items!.packages!.isNotEmpty) ...[
                      _buildSectionHeader('Packages'.tr),
                      const SizedBox(height: 8),
                      ..._buildPackages(value),
                    ],
                  ],
                ),
              ),
            const SizedBox(height: 16),
            _buildInfoCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildSectionHeader('Pricing'.tr),
                  const SizedBox(height: 12),
                  _buildInfoRow(
                      'Discount'.tr, _formatCurrency(value.discount, value)),
                  const SizedBox(height: 4),
                  _buildInfoRow('Wallet Discount'.tr,
                      _formatCurrency(value.walletDiscount, value)),
                  const SizedBox(height: 4),
                  _buildInfoRow('Distance Cost'.tr,
                      _formatCurrency(value.distanceCost, value)),
                  const SizedBox(height: 4),
                  _buildInfoRow('Service Tax (18%)'.tr,
                      _formatCurrency(value.serviceTax, value)),
                  const SizedBox(height: 4),
                  _buildInfoRow(
                      'Total'.tr, _formatCurrency(value.total, value)),
                  const SizedBox(height: 4),
                  _buildInfoRow(
                      'Payment Method'.tr,
                      value
                          .paymentName[value.appointmentInfo.payMethod as int]),
                  const Divider(height: 24, thickness: 1),
                  _buildInfoRow(
                    'Total Amount'.tr,
                    _formatCurrency(value.grandTotal, value),
                    labelStyle: const TextStyle(
                        fontSize: 16, fontWeight: FontWeight.bold),
                    valueStyle: const TextStyle(
                      color: ThemeProvider.appColor,
                      fontFamily: 'bold',
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoCard({required Widget child}) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: ThemeProvider.whiteColor,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: ThemeProvider.greyColor.withOpacity(0.2),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      padding: const EdgeInsets.all(16),
      child: child,
    );
  }

  Widget _buildGenderIcon(int? gender) {
    if (gender == null) return const SizedBox.shrink();

    IconData icon;
    Color color;
    String text;

    switch (gender) {
      case 0:
        icon = Icons.child_care;
        color = Colors.orange;
        text = 'Kids';
        break;
      case 1:
        icon = Icons.male;
        color = Colors.blue;
        text = 'Male';
        break;
      case 2:
        icon = Icons.female;
        color = Colors.pink;
        text = 'Female';
        break;
      default:
        icon = Icons.group;
        color = Colors.green;
        text = 'Family';
        break;
    }

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 16, color: color),
        const SizedBox(width: 4),
        Text(
          ' $text - ',
          style: TextStyle(
            fontSize: 14,
            color: color,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  Widget _buildProviderInfo(AppointmentDetailController value) {
    final bool isSalon = value.appointmentInfo.salonId != 0;
    final String providerName = isSalon
        ? value.appointmentInfo.salonInfo!.name.toString()
        : '${value.appointmentInfo.ownerInfo!.firstName} ${value.appointmentInfo.ownerInfo!.lastName}';
    final String providerAddress = isSalon
        ? value.appointmentInfo.salonInfo!.address.toString()
        : value.appointmentInfo.individualInfo!.address.toString();
    final String providerImage = isSalon
        ? '${Environments.imageURL}${value.appointmentInfo.salonInfo!.cover}'
        : '${Environments.imageURL}${value.appointmentInfo.ownerInfo!.cover}';
    final String providerId = isSalon
        ? value.appointmentInfo.salonId.toString()
        : value.appointmentInfo.freelancerId.toString();

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: SizedBox.fromSize(
            size: const Size.fromRadius(35),
            child: FadeInImage(
              image: NetworkImage(providerImage),
              placeholder: const AssetImage("assets/images/placeholder.jpeg"),
              imageErrorBuilder: (context, error, stackTrace) {
                return Image.asset(
                  'assets/images/notfound.png',
                  fit: BoxFit.cover,
                  height: 70,
                  width: 70,
                );
              },
              fit: BoxFit.cover,
            ),
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                providerName,
                style: const TextStyle(
                  fontFamily: 'bold',
                  fontSize: 16,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                providerAddress,
                style: const TextStyle(
                  fontSize: 14,
                  color: Colors.grey,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
        IconButton(
          onPressed: () {
            value.onContactInfo(
              providerName,
              value.appointmentInfo.ownerInfo!.mobile!,
              value.appointmentInfo.ownerInfo!.email!,
              providerId,
            );
          },
          icon: const Icon(
            Icons.info_outline,
            color: ThemeProvider.appColor,
          ),
        ),
      ],
    );
  }

  Widget _buildSectionHeader(String title) {
    return Text(
      title,
      style: const TextStyle(
        color: ThemeProvider.appColor,
        fontFamily: 'bold',
        fontSize: 16,
      ),
    );
  }

  Widget _buildInfoRow(String label, String value,
      {TextStyle? labelStyle, TextStyle? valueStyle}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style:
                labelStyle ?? const TextStyle(color: Colors.grey, fontSize: 14),
          ),
          Text(
            value,
            style: valueStyle ??
                const TextStyle(fontWeight: FontWeight.w500, fontSize: 14),
          ),
        ],
      ),
    );
  }

  List<Widget> _buildServices(AppointmentDetailController controller) {
    return List.generate(
      controller.appointmentInfo.items!.services!.length,
      (index) {
        final service = controller.appointmentInfo.items!.services![index];
        return Padding(
          padding: const EdgeInsets.only(bottom: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildGenderIcon(service.gender),
              const SizedBox(
                width: 5,
              ),
              Expanded(
                child: Text(
                  service.name.toString(),
                  style: const TextStyle(fontSize: 14),
                ),
              ),
              RichText(
                text: TextSpan(
                  children: [
                    TextSpan(
                      text: _formatCurrency(service.price, controller),
                      style: const TextStyle(
                        fontSize: 14,
                        color: Colors.grey,
                        decoration: TextDecoration.lineThrough,
                      ),
                    ),
                    const TextSpan(text: '  '),
                    TextSpan(
                      text: _formatCurrency(service.off, controller),
                      style: const TextStyle(
                        fontSize: 14,
                        color: ThemeProvider.blackColor,
                        fontWeight: FontWeight.bold,
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

  List<Widget> _buildPackages(AppointmentDetailController controller) {
    return List.generate(
      controller.appointmentInfo.items!.packages!.length,
      (index) {
        final package = controller.appointmentInfo.items!.packages![index];
        return Container(
          margin: const EdgeInsets.only(bottom: 12),
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.grey.shade50,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      package.name.toString(),
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                    ),
                  ),
                  RichText(
                    text: TextSpan(
                      children: [
                        TextSpan(
                          text: _formatCurrency(package.price, controller),
                          style: const TextStyle(
                            fontSize: 14,
                            color: Colors.grey,
                            decoration: TextDecoration.lineThrough,
                          ),
                        ),
                        const TextSpan(text: '  '),
                        TextSpan(
                          text: _formatCurrency(package.off, controller),
                          style: const TextStyle(
                            fontSize: 14,
                            color: ThemeProvider.blackColor,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                'Included Services:',
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey.shade700,
                ),
              ),
              const SizedBox(height: 4),
              ...List.generate(
                package.services!.length,
                (serviceIndex) => Padding(
                  padding: const EdgeInsets.only(left: 8, top: 4),
                  child: Row(
                    children: [
                      Icon(
                        Icons.check_circle,
                        size: 14,
                        color: Colors.green.shade300,
                      ),
                      const SizedBox(width: 4),
                      _buildGenderIcon(package.services![serviceIndex].gender),
                      const SizedBox(
                        width: 5,
                      ),
                      Expanded(
                        child: Text(
                          package.services![serviceIndex].name.toString(),
                          style: const TextStyle(fontSize: 12),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildBottomBar(AppointmentDetailController value) {
    // Appointment status handling
    if (value.appointmentInfo.status == 1 ||
        value.appointmentInfo.status == 2 ||
        value.appointmentInfo.status == 3 ||
        value.appointmentInfo.status == 7 ||
        value.appointmentInfo.status == 8 ||
        value.appointmentInfo.status == 5 ||
        value.appointmentInfo.status == 6) {
      // Status display
      return Container(
        padding: const EdgeInsets.all(16),
        decoration: const BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 5,
              offset: Offset(0, -2),
            ),
          ],
        ),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            color: ThemeProvider.appColor.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Text(
            '${'Your Appoinments Status'.tr} : ${value.orderStatus}',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontWeight: FontWeight.w500,
              color: ThemeProvider.appColor,
            ),
          ),
        ),
      );
    } else if (value.appointmentInfo.status == 0) {
      // Cancel button
      return Container(
        padding: const EdgeInsets.all(16),
        decoration: const BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 5,
              offset: Offset(0, -2),
            ),
          ],
        ),
        child: SizedBox(
          width: double.infinity,
          height: 48,
          child: ElevatedButton(
            onPressed: () => value.onUpdateAppointmentStatus(5),
            style: ElevatedButton.styleFrom(
              backgroundColor: ThemeProvider.appColor,
              foregroundColor: ThemeProvider.whiteColor,
              elevation: 2,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: Text(
              'Cancel'.tr,
              style: const TextStyle(
                letterSpacing: 1,
                fontSize: 16,
                fontFamily: 'bold',
              ),
            ),
          ),
        ),
      );
    } else if (value.appointmentInfo.status == 4) {
      // Add review button
      return Container(
        padding: const EdgeInsets.all(16),
        decoration: const BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 5,
              offset: Offset(0, -2),
            ),
          ],
        ),
        child: SizedBox(
          width: double.infinity,
          height: 48,
          child: ElevatedButton(
            onPressed: () =>
                value.onAddReview(value.appointmentInfo.freelancerId as int),
            style: ElevatedButton.styleFrom(
              backgroundColor: ThemeProvider.pink,
              foregroundColor: ThemeProvider.whiteColor,
              elevation: 2,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: Text(
              'Add Review'.tr,
              style: const TextStyle(
                letterSpacing: 1,
                fontSize: 16,
                fontFamily: 'bold',
              ),
            ),
          ),
        ),
      );
    } else {
      return const SizedBox();
    }
  }

  String _formatCurrency(
      dynamic amount, AppointmentDetailController controller) {
    return controller.currencySide == 'left'
        ? '${controller.currencySymbol}${amount.toString()}'
        : '${amount.toString()}${controller.currencySymbol}';
  }
}
