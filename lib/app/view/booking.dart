// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:salon_user/app/controller/booking_controller.dart';
// import 'package:salon_user/app/env.dart';
// import 'package:salon_user/app/util/theme.dart';
// import 'package:skeletons/skeletons.dart';

// class BookingScreen extends StatefulWidget {
//   const BookingScreen({super.key});

//   @override
//   State<BookingScreen> createState() => _BookingScreenState();
// }

// class _BookingScreenState extends State<BookingScreen> {
//   @override
//   Widget build(BuildContext context) {
//     return GetBuilder<BookingController>(
//       builder: (controller) {
//         return Scaffold(
//           backgroundColor: ThemeProvider.whiteColor,
//           appBar: _buildAppBar(controller),
//           body: _buildBody(controller),
//         );
//       },
//     );
//   }

//   // AppBar widget
//   PreferredSizeWidget _buildAppBar(BookingController controller) {
//     return AppBar(
//       automaticallyImplyLeading: false,
//       backgroundColor: ThemeProvider.appColor,
//       elevation: 0,
//       iconTheme: const IconThemeData(color: ThemeProvider.whiteColor),
//       title: Text(
//         'Appointments History'.tr,
//         style: ThemeProvider.titleStyle,
//       ),
//       bottom:
//           controller.parser.haveLoggedIn() ? _buildTabBar(controller) : null,
//     );
//   }

//   // TabBar widget
//   PreferredSizeWidget _buildTabBar(BookingController controller) {
//     return TabBar(
//       controller: controller.tabController,
//       unselectedLabelColor: ThemeProvider.blackColor,
//       labelColor: ThemeProvider.whiteColor,
//       indicatorColor: ThemeProvider.whiteColor,
//       labelStyle: const TextStyle(
//         fontFamily: 'medium',
//         fontSize: 16,
//         color: ThemeProvider.whiteColor,
//       ),
//       unselectedLabelStyle: const TextStyle(
//         fontFamily: 'medium',
//         fontSize: 16,
//         color: ThemeProvider.whiteColor,
//       ),
//       indicatorSize: TabBarIndicatorSize.tab,
//       labelPadding: const EdgeInsets.all(8),
//       tabs: [
//         Text('New'.tr, style: const TextStyle(color: ThemeProvider.whiteColor)),
//         Text('Old'.tr, style: const TextStyle(color: ThemeProvider.whiteColor)),
//       ],
//     );
//   }

//   // Body widget
//   Widget _buildBody(BookingController controller) {
//     if (!controller.parser.haveLoggedIn()) {
//       return _buildLoginPrompt(controller);
//     }

//     return controller.apiCalled
//         ? TabBarView(
//             controller: controller.tabController,
//             children: [
//               _buildAppointmentList(controller.appointmentList, controller,
//                   isNew: true),
//               _buildAppointmentList(controller.appointmentListOld, controller,
//                   isNew: false),
//             ],
//           )
//         : SkeletonListView();
//   }

//   // Login prompt widget
//   Widget _buildLoginPrompt(BookingController controller) {
//     return Center(
//       child: Column(
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: [
//           Image.asset('assets/images/no-data.png', width: 60, height: 60),
//           const SizedBox(height: 30),
//           TextButton(
//             onPressed: controller.onLoginRoutes,
//             child: Text(
//               'Oops, Please Login or Register first!'.tr,
//               style: const TextStyle(
//                 fontFamily: 'bold',
//                 color: ThemeProvider.appColor,
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   // Appointment list widget
//   Widget _buildAppointmentList(
//       List<dynamic> appointments, BookingController controller,
//       {required bool isNew}) {
//     return SingleChildScrollView(
//       child: Padding(
//         padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
//         child: appointments.isNotEmpty
//             ? Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: List.generate(
//                   appointments.length,
//                   (index) =>
//                       _buildAppointmentCard(appointments[index], controller),
//                 ),
//               )
//             : _buildNoAppointmentsFound(isNew),
//       ),
//     );
//   }

//   // Appointment card widget
//   Widget _buildAppointmentCard(
//       dynamic appointment, BookingController controller) {
//     return Container(
//       padding: const EdgeInsets.all(10),
//       margin: const EdgeInsets.symmetric(vertical: 10),
//       decoration: BoxDecoration(
//         borderRadius: BorderRadius.circular(5),
//         color: ThemeProvider.whiteColor,
//         boxShadow: const [
//           BoxShadow(color: ThemeProvider.greyColor, blurRadius: 5.0),
//         ],
//       ),
//       child: InkWell(
//         onTap: () => controller.onAppointment(appointment.id as int),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             _buildHeader(appointment, controller),
//             _buildDivider(),
//             _buildServicesAndPackages(appointment, controller),
//             _buildDivider(),
//             _buildGrandTotal(appointment, controller),
//             _buildDivider(),
//             _buildAppointmentTime(appointment),
//           ],
//         ),
//       ),
//     );
//   }

//   // Header section with salon/individual info and status
//   Widget _buildHeader(dynamic appointment, BookingController controller) {
//     final isSalon = appointment.salonId != 0;
//     final imageUrl = isSalon
//         ? '${Environments.imageURL}${appointment.salonInfo!.cover}'
//         : '${Environments.imageURL}${appointment.individualInfo!.background}';
//     final name = isSalon
//         ? appointment.salonInfo!.name
//         : '${appointment.individualInfo!.firstName} ${appointment.individualInfo!.lastName}';
//     final address = isSalon
//         ? appointment.salonInfo!.address
//         : appointment.individualInfo!.address;

//     return Row(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         _buildImage(imageUrl),
//         const SizedBox(width: 10),
//         Expanded(
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 children: [
//                   Text(
//                     name,
//                     overflow: TextOverflow.ellipsis,
//                     style: const TextStyle(
//                       fontFamily: 'bold',
//                       fontSize: 12,
//                       color: ThemeProvider.blackColor,
//                     ),
//                   ),
//                   _buildStatusBadge(appointment.status, controller),
//                 ],
//               ),
//               Text(
//                 address,
//                 overflow: TextOverflow.ellipsis,
//                 maxLines: 2,
//                 style: const TextStyle(
//                   fontSize: 11,
//                   color: ThemeProvider.blackColor,
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ],
//     );
//   }

//   // Image widget
//   Widget _buildImage(String imageUrl) {
//     return ClipRRect(
//       borderRadius: BorderRadius.circular(5),
//       child: SizedBox.fromSize(
//         size: const Size.fromRadius(25),
//         child: FadeInImage(
//           image: NetworkImage(imageUrl),
//           placeholder: const AssetImage('assets/images/placeholder.jpeg'),
//           imageErrorBuilder: (context, error, stackTrace) => Image.asset(
//             'assets/images/notfound.png',
//             fit: BoxFit.cover,
//             height: 25,
//             width: 25,
//           ),
//           fit: BoxFit.cover,
//           height: 25,
//           width: 25,
//         ),
//       ),
//     );
//   }

//   // Status badge widget
//   Widget _buildStatusBadge(int status, BookingController controller) {
//     return Container(
//       padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 2),
//       decoration: BoxDecoration(
//         color: controller.statusColors[status] ?? ThemeProvider.appColor,
//         borderRadius: BorderRadius.circular(3),
//       ),
//       child: Text(
//         controller.statusName[status]!.tr,
//         style: const TextStyle(
//           fontWeight: FontWeight.w900,
//           color: Colors.white,
//         ),
//       ),
//     );
//   }

//   // Divider widget
//   Widget _buildDivider() {
//     return Container(
//       height: 1,
//       margin: const EdgeInsets.symmetric(vertical: 10),
//       decoration: const BoxDecoration(
//         border:
//             Border(bottom: BorderSide(color: ThemeProvider.backgroundColor)),
//       ),
//     );
//   }

//   // Services and packages section
//   Widget _buildServicesAndPackages(
//       dynamic appointment, BookingController controller) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         if (appointment.items!.services!.isNotEmpty) ...[
//           Text(
//             'Services'.tr,
//             style: const TextStyle(
//               fontFamily: 'bold',
//               fontSize: 12,
//               color: ThemeProvider.blackColor,
//             ),
//           ),
//           const SizedBox(height: 10),
//           ...appointment.items!.services!
//               .map((service) => _buildServiceItem(service, controller)),
//         ],
//         if (appointment.items!.packages!.isNotEmpty) ...[
//           const SizedBox(height: 10),
//           Text(
//             'Packages'.tr,
//             style: const TextStyle(
//               fontFamily: 'bold',
//               fontSize: 12,
//               color: ThemeProvider.blackColor,
//             ),
//           ),
//           ...appointment.items!.packages!
//               .map((package) => _buildPackageItem(package, controller)),
//         ],
//       ],
//     );
//   }

//   // Service item widget
//   Widget _buildServiceItem(dynamic service, BookingController controller) {
//     return Padding(
//       padding: const EdgeInsets.only(bottom: 5),
//       child: Row(
//         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//         children: [
//           Text(
//             service.name,
//             overflow: TextOverflow.ellipsis,
//             style: const TextStyle(
//               fontFamily: 'regular',
//               fontSize: 10,
//               color: ThemeProvider.blackColor,
//             ),
//           ),
//           RichText(
//             text: TextSpan(
//               children: [
//                 TextSpan(
//                   text: controller.currencySide == 'left'
//                       ? '${controller.currencySymbol}${service.price}'
//                       : '${service.price}${controller.currencySymbol}',
//                   style: const TextStyle(
//                     fontSize: 10,
//                     color: ThemeProvider.blackColor,
//                     decoration: TextDecoration.lineThrough,
//                   ),
//                 ),
//                 const TextSpan(text: ' '),
//                 TextSpan(
//                   text: controller.currencySide == 'left'
//                       ? '${controller.currencySymbol}${service.off}'
//                       : '${service.off}${controller.currencySymbol}',
//                   style: const TextStyle(
//                     fontSize: 10,
//                     color: ThemeProvider.blackColor,
//                     fontFamily: 'bold',
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   // Package item widget
//   Widget _buildPackageItem(dynamic package, BookingController controller) {
//     return Padding(
//       padding: const EdgeInsets.only(bottom: 5),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Row(
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             children: [
//               Text(
//                 package.name,
//                 overflow: TextOverflow.ellipsis,
//                 style: const TextStyle(
//                   fontFamily: 'regular',
//                   fontSize: 10,
//                   color: ThemeProvider.blackColor,
//                 ),
//               ),
//               RichText(
//                 text: TextSpan(
//                   children: [
//                     TextSpan(
//                       text: controller.currencySide == 'left'
//                           ? '${controller.currencySymbol}${package.price}'
//                           : '${package.price}${controller.currencySymbol}',
//                       style: const TextStyle(
//                         fontSize: 10,
//                         color: ThemeProvider.blackColor,
//                         decoration: TextDecoration.lineThrough,
//                       ),
//                     ),
//                     const TextSpan(text: ' '),
//                     TextSpan(
//                       text: controller.currencySide == 'left'
//                           ? '${controller.currencySymbol}${package.off}'
//                           : '${package.off}${controller.currencySymbol}',
//                       style: const TextStyle(
//                         fontSize: 10,
//                         color: ThemeProvider.blackColor,
//                         fontFamily: 'bold',
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             ],
//           ),
//           ...package.services!.map((service) => Padding(
//                 padding: const EdgeInsets.only(left: 10, top: 2),
//                 child: Row(
//                   children: [
//                     const Text(
//                       '-',
//                       style: TextStyle(
//                         fontSize: 8,
//                         fontFamily: 'regular',
//                         color: ThemeProvider.blackColor,
//                       ),
//                     ),
//                     const SizedBox(width: 5),
//                     Text(
//                       service.name,
//                       style: const TextStyle(
//                         fontSize: 8,
//                         fontFamily: 'regular',
//                         color: ThemeProvider.blackColor,
//                       ),
//                     ),
//                   ],
//                 ),
//               )),
//         ],
//       ),
//     );
//   }

//   // Grand total widget
//   Widget _buildGrandTotal(dynamic appointment, BookingController controller) {
//     return Row(
//       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//       children: [
//         Text(
//           'Grand Total:'.tr,
//           style: const TextStyle(
//             fontSize: 12,
//             fontFamily: 'bold',
//             color: ThemeProvider.blackColor,
//           ),
//         ),
//         Text(
//           controller.currencySide == 'left'
//               ? '${controller.currencySymbol}${appointment.grandTotal}'
//               : '${appointment.grandTotal}${controller.currencySymbol}',
//           style: const TextStyle(
//             fontSize: 12,
//             fontFamily: 'bold',
//             color: ThemeProvider.blackColor,
//           ),
//         ),
//       ],
//     );
//   }

//   // Appointment time widget
//   Widget _buildAppointmentTime(dynamic appointment) {
//     return Row(
//       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//       children: [
//         Text(
//           'Appointment at:'.tr,
//           style: const TextStyle(
//             fontSize: 12,
//             color: ThemeProvider.appColor,
//           ),
//         ),
//         Text(
//           '${appointment.saveDate} ${appointment.slot}',
//           style: const TextStyle(fontSize: 12),
//         ),
//       ],
//     );
//   }

//   // No appointments found widget
//   Widget _buildNoAppointmentsFound(bool isNew) {
//     return Center(
//       child: Column(
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: [
//           Image.asset('assets/images/no-data.png', width: 60, height: 60),
//           const SizedBox(height: 30),
//           Text(
//             isNew
//                 ? 'No New Appointment Found!'.tr
//                 : 'No Past Appointment Found!'.tr,
//             style: const TextStyle(
//               fontFamily: 'bold',
//               color: ThemeProvider.appColor,
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:salon_user/app/controller/booking_controller.dart';
import 'package:salon_user/app/env.dart';
import 'package:salon_user/app/util/theme.dart';
import 'package:skeletons/skeletons.dart';
import 'package:intl/intl.dart';

class BookingScreen extends StatefulWidget {
  const BookingScreen({super.key});

  @override
  State<BookingScreen> createState() => _BookingScreenState();
}

class _BookingScreenState extends State<BookingScreen>
    with SingleTickerProviderStateMixin {
  late final Animation<double> _fadeAnimation;
  late final AnimationController _animationController;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeIn),
    );
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<BookingController>(
      builder: (controller) {
        return Scaffold(
          backgroundColor: Color.fromARGB(255, 216, 216, 216),
          appBar: _buildAppBar(controller),
          body: _buildBody(controller),
        );
      },
    );
  }

  // AppBar widget
  PreferredSizeWidget _buildAppBar(BookingController controller) {
    return AppBar(
      backgroundColor: ThemeProvider.appColor,
      elevation: 10,
      systemOverlayStyle: const SystemUiOverlayStyle(
        statusBarColor: ThemeProvider.appColor,
        statusBarIconBrightness: Brightness.light,
      ),
      centerTitle: true,
      // leading: IconButton(
      //   icon: const Icon(Icons.arrow_back_ios_new_rounded),
      //   onPressed: () => Navigator.of(context).pop(),
      // ),
      actions: [
        IconButton(
          icon: const Icon(Icons.refresh),
          onPressed: () => controller.getAppointmentById(),
        ),
        SizedBox(width: 10),
      ],
      iconTheme: const IconThemeData(color: ThemeProvider.whiteColor),
      title: Text(
        'My Appointments'.tr,
        style: const TextStyle(
          color: ThemeProvider.whiteColor,
          fontSize: 16,
          fontFamily: 'semibold',
        ),
      ),
      bottom:
          controller.parser.haveLoggedIn() ? _buildTabBar(controller) : null,
    );
  }

  // TabBar widget
  PreferredSizeWidget _buildTabBar(BookingController controller) {
    return TabBar(
      controller: controller.tabController,
      unselectedLabelColor: ThemeProvider.whiteColor.withOpacity(0.7),
      labelColor: ThemeProvider.whiteColor,
      indicatorColor: ThemeProvider.whiteColor,
      indicatorWeight: 3,
      labelStyle: const TextStyle(
        fontFamily: 'semibold',
        fontSize: 14,
      ),
      unselectedLabelStyle: const TextStyle(
        fontFamily: 'regular',
        fontSize: 14,
      ),
      indicatorSize: TabBarIndicatorSize.tab,
      labelPadding: const EdgeInsets.all(10),
      tabs: [
        _buildTab('New'.tr, Icons.access_time),
        _buildTab('History'.tr, Icons.history),
      ],
    );
  }

  // Tab widget
  Widget _buildTab(String title, IconData icon) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(icon, size: 18),
        const SizedBox(width: 8),
        Text(title),
      ],
    );
  }

  // Body widget
  Widget _buildBody(BookingController controller) {
    if (!controller.parser.haveLoggedIn()) {
      return _buildLoginPrompt(controller);
    }

    return controller.apiCalled
        ? FadeTransition(
            opacity: _fadeAnimation,
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 15),
              child: TabBarView(
                controller: controller.tabController,
                children: [
                  _buildAppointmentList(controller.appointmentList, controller,
                      isNew: true),
                  _buildAppointmentList(
                      controller.appointmentListOld, controller,
                      isNew: false),
                ],
              ),
            ),
          )
        : _buildLoadingView();
  }

  // Loading view
  Widget _buildLoadingView() {
    return Container(
      padding: const EdgeInsets.all(15),
      child: SkeletonListView(
        itemCount: 4,
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.only(bottom: 15),
            child: SkeletonItem(
              child: Column(
                children: [
                  SkeletonAvatar(
                    style: SkeletonAvatarStyle(
                      width: double.infinity,
                      height: 180,
                      borderRadius: BorderRadius.circular(15),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  // Login prompt widget
  Widget _buildLoginPrompt(BookingController controller) {
    return Center(
      child: Container(
        padding: const EdgeInsets.all(20),
        margin: const EdgeInsets.symmetric(horizontal: 20),
        decoration: BoxDecoration(
          color: ThemeProvider.whiteColor,
          borderRadius: BorderRadius.circular(15),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.1),
              offset: const Offset(0, 2),
              blurRadius: 10,
              spreadRadius: 2,
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Image.asset(
              'assets/images/login_required.png',
              width: 150,
              height: 150,
            ),
            const SizedBox(height: 20),
            Text(
              'Access Your Appointments'.tr,
              style: const TextStyle(
                fontFamily: 'bold',
                fontSize: 18,
                color: ThemeProvider.blackColor,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              'Please log in or create an account to view your appointments.'
                  .tr,
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: ThemeProvider.greyColor,
                fontSize: 14,
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: controller.onLoginRoutes,
              style: ElevatedButton.styleFrom(
                backgroundColor: ThemeProvider.appColor,
                foregroundColor: ThemeProvider.whiteColor,
                minimumSize: const Size(double.infinity, 50),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                elevation: 0,
              ),
              child: Text(
                'Login / Register'.tr,
                style: const TextStyle(
                  fontFamily: 'semibold',
                  fontSize: 16,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Appointment list widget
  Widget _buildAppointmentList(
      List<dynamic> appointments, BookingController controller,
      {required bool isNew}) {
    return appointments.isNotEmpty
        ? ListView.builder(
            padding: const EdgeInsets.only(top: 15, bottom: 20),
            itemCount: appointments.length,
            itemBuilder: (context, index) {
              return _buildAppointmentCard(appointments[index], controller);
            },
          )
        : _buildNoAppointmentsFound(isNew);
  }

  // Appointment card widget
  Widget _buildAppointmentCard(
      dynamic appointment, BookingController controller) {
    return Card(
      elevation: 6,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      color: ThemeProvider.whiteColor,
      margin: const EdgeInsets.only(bottom: 18),
      // decoration: BoxDecoration(
      //   color: ThemeProvider.whiteColor,
      //   borderRadius: BorderRadius.circular(15),
      //   boxShadow: [
      //     BoxShadow(
      //       color: Colors.grey.withOpacity(0.1),
      //       offset: const Offset(0, 2),
      //       blurRadius: 10,
      //       spreadRadius: 2,
      //     ),
      //   ],
      // ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(15),
          onTap: () => controller.onAppointment(appointment.id as int),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildCardHeader(appointment, controller),
              _buildCardBody(appointment, controller),
            ],
          ),
        ),
      ),
    );
  }

  // Card header with image
  Widget _buildCardHeader(dynamic appointment, BookingController controller) {
    final isSalon = appointment.salonId != 0;
    final imageUrl = isSalon
        ? '${Environments.imageURL}${appointment.salonInfo!.cover}'
        : '${Environments.imageURL}${appointment.individualInfo!.background}';

    return Stack(
      children: [
        ClipRRect(
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(15),
            topRight: Radius.circular(15),
          ),
          child: SizedBox(
            height: 120,
            width: double.infinity,
            child: FadeInImage.assetNetwork(
              placeholder: 'assets/images/placeholder.jpeg',
              image: imageUrl,
              fit: BoxFit.cover,
              imageErrorBuilder: (context, error, stackTrace) {
                return Image.asset(
                  'assets/images/placeholder.jpeg',
                  fit: BoxFit.cover,
                );
              },
            ),
          ),
        ),
        Positioned(
          top: 15,
          right: 15,
          child: _buildStatusBadge(appointment.status, controller),
        ),
        Positioned(
          bottom: 0,
          left: 0,
          right: 0,
          child: Container(
            height: 30,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [Colors.transparent, Colors.black54],
              ),
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(15),
                topRight: Radius.circular(15),
              ),
            ),
          ),
        ),
      ],
    );
  }

  // Card body with salon/individual info
  Widget _buildCardBody(dynamic appointment, BookingController controller) {
    final isSalon = appointment.salonId != 0;
    final name = isSalon
        ? appointment.salonInfo!.name
        : '${appointment.individualInfo!.firstName} ${appointment.individualInfo!.lastName}';
    final address = isSalon
        ? appointment.salonInfo!.address
        : appointment.individualInfo!.address;

    return Padding(
      padding: const EdgeInsets.all(15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      name,
                      style: const TextStyle(
                        fontFamily: 'semibold',
                        fontSize: 16,
                        color: ThemeProvider.blackColor,
                      ),
                    ),
                    const SizedBox(height: 5),
                    Row(
                      children: [
                        const Icon(
                          Icons.location_on_outlined,
                          size: 14,
                          color: ThemeProvider.greyColor,
                        ),
                        const SizedBox(width: 5),
                        Expanded(
                          child: Text(
                            address,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              fontSize: 12,
                              color: ThemeProvider.greyColor,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                decoration: BoxDecoration(
                  color: ThemeProvider.appColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  controller.currencySide == 'left'
                      ? '${controller.currencySymbol}${appointment.grandTotal}'
                      : '${appointment.grandTotal}${controller.currencySymbol}',
                  style: const TextStyle(
                    fontSize: 16,
                    fontFamily: 'semibold',
                    color: ThemeProvider.appColor,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 15),
          _buildDivider(),
          const SizedBox(height: 15),
          _buildServicesSection(appointment, controller),
          const SizedBox(height: 15),
          _buildDivider(),
          const SizedBox(height: 15),
          _buildAppointmentDateTime(appointment),
        ],
      ),
    );
  }

  // Status badge widget
  Widget _buildStatusBadge(int status, BookingController controller) {
    Color badgeColor =
        controller.statusColors[status] ?? ThemeProvider.appColor;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: badgeColor,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: badgeColor.withOpacity(0.4),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Text(
        controller.statusName[status]!.tr,
        style: const TextStyle(
          fontSize: 12,
          fontFamily: 'semibold',
          color: ThemeProvider.whiteColor,
        ),
      ),
    );
  }

  // Services section
  Widget _buildServicesSection(
      dynamic appointment, BookingController controller) {
    bool hasServices = appointment.items!.services!.isNotEmpty;
    bool hasPackages = appointment.items!.packages!.isNotEmpty;

    if (!hasServices && !hasPackages) {
      return const SizedBox.shrink();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Booking Details'.tr,
          style: const TextStyle(
            fontFamily: 'semibold',
            fontSize: 14,
            color: ThemeProvider.blackColor,
          ),
        ),
        const SizedBox(height: 10),
        if (hasServices) ..._buildServicesList(appointment, controller),
        if (hasServices && hasPackages) const SizedBox(height: 10),
        if (hasPackages) ..._buildPackagesList(appointment, controller),
      ],
    );
  }

  Widget _buildGenderIcon(int? gender) {
    if (gender == null) return const SizedBox.shrink();
    switch (gender) {
      case 0:
        return const Icon(Icons.child_care, size: 16, color: Colors.orange);
      case 1:
        return const Icon(Icons.male, size: 16, color: Colors.blue);
      case 2:
        return const Icon(Icons.female, size: 16, color: Colors.pink);
      default:
        return const Icon(Icons.group, size: 16, color: Colors.green);
    }
  }

  List<Widget> _buildServicesList(
      dynamic appointment, BookingController controller) {
    return [
      Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: ThemeProvider.backgroundColor,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.spa_outlined,
                    size: 16, color: ThemeProvider.appColor),
                const SizedBox(width: 5),
                Text('Services'.tr,
                    style: const TextStyle(fontFamily: 'medium', fontSize: 13)),
              ],
            ),
            const SizedBox(height: 5),
            ...appointment.items!.services!.map<Widget>((service) => Padding(
                  padding: const EdgeInsets.only(top: 8),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Row(
                          children: [
                            _buildGenderIcon(service.gender),
                            const SizedBox(width: 5),
                            Expanded(
                              child: Text(
                                service.name,
                                style: const TextStyle(fontSize: 12),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Text(
                        controller.currencySide == 'left'
                            ? '${controller.currencySymbol}${service.off}'
                            : '${service.off}${controller.currencySymbol}',
                        style:
                            const TextStyle(fontSize: 12, fontFamily: 'medium'),
                      ),
                    ],
                  ),
                )),
          ],
        ),
      ),
    ];
  }
//package wit gender details - change once api is completed

  // List<Widget> _buildPackagesList(
  //     dynamic appointment, BookingController controller) {
  //   return [
  //     Container(
  //       padding: const EdgeInsets.all(10),
  //       decoration: BoxDecoration(
  //         color: ThemeProvider.backgroundColor,
  //         borderRadius: BorderRadius.circular(8),
  //       ),
  //       child: Column(
  //         crossAxisAlignment: CrossAxisAlignment.start,
  //         children: [
  //           Row(
  //             children: [
  //               const Icon(Icons.card_giftcard_outlined,
  //                   size: 16, color: ThemeProvider.appColor),
  //               const SizedBox(width: 5),
  //               Text('Packages'.tr,
  //                   style: const TextStyle(fontFamily: 'medium', fontSize: 13)),
  //             ],
  //           ),
  //           const SizedBox(height: 5),
  //           ...appointment.items!.packages!.map<Widget>((package) => Column(
  //                 crossAxisAlignment: CrossAxisAlignment.start,
  //                 children: [
  //                   Padding(
  //                     padding: const EdgeInsets.only(top: 8),
  //                     child: Row(
  //                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //                       children: [
  //                         Expanded(
  //                           child: Text(package.name,
  //                               style: const TextStyle(
  //                                   fontSize: 12, fontFamily: 'medium')),
  //                         ),
  //                         Text(
  //                           controller.currencySide == 'left'
  //                               ? '${controller.currencySymbol}${package.off}'
  //                               : '${package.off}${controller.currencySymbol}',
  //                           style: const TextStyle(
  //                               fontSize: 12, fontFamily: 'medium'),
  //                         ),
  //                       ],
  //                     ),
  //                   ),
  //                   ...package.services!.map<Widget>((service) => Padding(
  //                         padding: const EdgeInsets.only(left: 10, top: 5),
  //                         child: Row(
  //                           children: [
  //                             Container(
  //                               width: 4,
  //                               height: 4,
  //                               decoration: const BoxDecoration(
  //                                 color: ThemeProvider.greyColor,
  //                                 shape: BoxShape.circle,
  //                               ),
  //                             ),
  //                             const SizedBox(width: 5),
  //                             _buildGenderIcon(service.gender),
  //                             const SizedBox(width: 5),
  //                             Expanded(
  //                               child: Text(
  //                                 service.name,
  //                                 style: const TextStyle(
  //                                     fontSize: 11,
  //                                     color: ThemeProvider.greyColor),
  //                               ),
  //                             ),
  //                           ],
  //                         ),
  //                       )),
  //                 ],
  //               )),
  //         ],
  //       ),
  //     ),
  //   ];
  // }

  // Packages list
  List<Widget> _buildPackagesList(
      dynamic appointment, BookingController controller) {
    return [
      Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: ThemeProvider.backgroundColor,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(
                  Icons.card_giftcard_outlined,
                  size: 16,
                  color: ThemeProvider.appColor,
                ),
                const SizedBox(width: 5),
                Text(
                  'Packages'.tr,
                  style: const TextStyle(
                    fontFamily: 'medium',
                    fontSize: 13,
                    color: ThemeProvider.blackColor,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 5),
            ...appointment.items!.packages!.map<Widget>((package) => Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 8),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Text(
                              package.name,
                              style: const TextStyle(
                                fontSize: 12,
                                fontFamily: 'medium',
                                color: ThemeProvider.blackColor,
                              ),
                            ),
                          ),
                          Text(
                            controller.currencySide == 'left'
                                ? '${controller.currencySymbol}${package.off}'
                                : '${package.off}${controller.currencySymbol}',
                            style: const TextStyle(
                              fontSize: 12,
                              fontFamily: 'medium',
                              color: ThemeProvider.blackColor,
                            ),
                          ),
                        ],
                      ),
                    ),
                    ...package.services!.asMap().entries.map<Widget>((entry) {
                      int index = entry.key;
                      var service = entry.value;
                      return Padding(
                        padding: const EdgeInsets.only(left: 10, top: 5),
                        child: Row(
                          children: [
                            Icon(
                              Icons.check_circle,
                              size: 14,
                              color: Colors.green.shade300,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              '${index + 1}', // Showing index (1-based)
                              style: const TextStyle(fontSize: 12),
                            ),
                            const SizedBox(width: 4),
                            _buildGenderIcon(service.gender),
                            const SizedBox(width: 5),
                            Expanded(
                              child: Text(
                                service.name.toString(),
                                style: const TextStyle(fontSize: 12),
                              ),
                            ),
                          ],
                        ),
                      );
                    }),
                  ],
                )),
          ],
        ),
      ),
    ];
  }

  // Appointment date and time
  Widget _buildAppointmentDateTime(dynamic appointment) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: ThemeProvider.appColor.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: const Icon(
            Icons.calendar_today_outlined,
            color: ThemeProvider.appColor,
            size: 18,
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Appointment Date & Time'.tr,
                style: const TextStyle(
                  fontSize: 12,
                  color: ThemeProvider.greyColor,
                ),
              ),
              const SizedBox(height: 3),
              Text(
                '${appointment.saveDate} | ${appointment.slot}',
                style: const TextStyle(
                  fontSize: 14,
                  fontFamily: 'medium',
                  color: ThemeProvider.blackColor,
                ),
              ),
            ],
          ),
        ),
        Container(
          decoration: BoxDecoration(
            color: ThemeProvider.appColor,
            borderRadius: BorderRadius.circular(8),
          ),
          child: const Icon(
            Icons.arrow_forward_ios_rounded,
            color: ThemeProvider.whiteColor,
            size: 16,
            semanticLabel: 'View Details',
          ),
        ),
      ],
    );
  }

  // Divider widget
  Widget _buildDivider() {
    return const Divider(
      color: ThemeProvider.backgroundColor,
      thickness: 1,
    );
  }

  // No appointments found widget
  Widget _buildNoAppointmentsFound(bool isNew) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(
            'assets/images/no_appointments.svg',
            width: 120,
            height: 120,
          ),
          const SizedBox(height: 20),
          Text(
            isNew ? 'No Upcoming Appointments'.tr : 'No Past Appointments'.tr,
            style: const TextStyle(
              fontFamily: 'semibold',
              fontSize: 18,
              color: ThemeProvider.blackColor,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            isNew
                ? 'Book a service to see your appointments here'.tr
                : 'Your appointment history will appear here'.tr,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 14,
              color: ThemeProvider.greyColor,
            ),
          ),
          const SizedBox(height: 20),
          // if (isNew)
          //   ElevatedButton(
          //     onPressed: () => null,
          //     style: ElevatedButton.styleFrom(
          //       backgroundColor: ThemeProvider.appColor,
          //       foregroundColor: ThemeProvider.whiteColor,
          //       shape: RoundedRectangleBorder(
          //         borderRadius: BorderRadius.circular(8),
          //       ),
          //       padding:
          //           const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          //     ),
          //     child: Text(
          //       'Book Now'.tr,
          //       style: const TextStyle(
          //         fontFamily: 'semibold',
          //         fontSize: 14,
          //       ),
          //     ),
          //   ),
        ],
      ),
    );
  }
}

Widget _buildGenderIcon(int? gender) {
  if (gender == null) return const SizedBox.shrink();
  switch (gender) {
    case 0:
      return const Icon(Icons.child_care, size: 16, color: Colors.orange);
    case 1:
      return const Icon(Icons.male, size: 16, color: Colors.blue);
    case 2:
      return const Icon(Icons.female, size: 16, color: Colors.pink);
    default:
      return const Icon(Icons.group, size: 16, color: Colors.green);
  }
}
