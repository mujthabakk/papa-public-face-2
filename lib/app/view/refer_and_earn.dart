import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:salon_user/app/controller/refer_and_earn_controller.dart';
import 'package:salon_user/app/util/theme.dart';
import 'dart:ui';

class ReferAndEarnScreen extends StatefulWidget {
  const ReferAndEarnScreen({Key? key}) : super(key: key);

  @override
  State<ReferAndEarnScreen> createState() => _ReferAndEarnScreenState();
}

class _ReferAndEarnScreenState extends State<ReferAndEarnScreen> {
  @override
  Widget build(BuildContext context) {
    return GetBuilder<ReferAndEarnController>(
      builder: (value) {
        return Scaffold(
          backgroundColor: ThemeProvider.backgroundColor,
          appBar: AppBar(
            backgroundColor: ThemeProvider.appColor,
            iconTheme: const IconThemeData(color: ThemeProvider.whiteColor),
            elevation: 0,
            centerTitle: true,
            title: Text(
              'Refer & Earn'.tr,
              style: ThemeProvider.titleStyle,
            ),
          ),
          body: value.apiCalled == false
              ? const Center(
                  child: CircularProgressIndicator(
                    color: ThemeProvider.appColor,
                  ),
                )
              : SingleChildScrollView(
                  child: Column(
                    children: [
                      // Top curved background with illustration
                      Container(
                        height: 200,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: ThemeProvider.appColor,
                          borderRadius: const BorderRadius.only(
                            bottomLeft: Radius.circular(30),
                            bottomRight: Radius.circular(30),
                          ),
                        ),
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            Positioned(
                              right: -30,
                              top: -30,
                              child: Container(
                                height: 120,
                                width: 120,
                                decoration: BoxDecoration(
                                  color: Colors.white.withOpacity(0.1),
                                  shape: BoxShape.circle,
                                ),
                              ),
                            ),
                            Positioned(
                              left: -20,
                              bottom: -20,
                              child: Container(
                                height: 100,
                                width: 100,
                                decoration: BoxDecoration(
                                  color: Colors.white.withOpacity(0.1),
                                  shape: BoxShape.circle,
                                ),
                              ),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Image.asset(
                                  'assets/images/gift.png',
                                  height: 120,
                                  fit: BoxFit.contain,
                                ),
                                const SizedBox(width: 20),
                                const Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Invite Friends',
                                      style: TextStyle(
                                        color: ThemeProvider.whiteColor,
                                        fontFamily: 'bold',
                                        fontSize: 24,
                                      ),
                                    ),
                                    Text(
                                      'Earn Rewards',
                                      style: TextStyle(
                                        color: ThemeProvider.whiteColor,
                                        fontFamily: 'medium',
                                        fontSize: 20,
                                      ),
                                    ),
                                  ],
                                )
                              ],
                            ),
                          ],
                        ),
                      ),

                      Padding(
                        padding: const EdgeInsets.all(20),
                        child: Column(
                          children: [
                            // How it works section
                            Container(
                              padding: const EdgeInsets.all(20),
                              decoration: BoxDecoration(
                                color: ThemeProvider.whiteColor,
                                borderRadius: BorderRadius.circular(16),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.grey.withOpacity(0.1),
                                    spreadRadius: 1,
                                    blurRadius: 10,
                                    offset: const Offset(0, 1),
                                  ),
                                ],
                              ),
                              child: Column(
                                children: [
                                  Text(
                                    value.referralData.title.toString(),
                                    style: const TextStyle(
                                      color: ThemeProvider.appColor,
                                      fontFamily: 'bold',
                                      fontSize: 18,
                                    ),
                                  ),
                                  const SizedBox(height: 16),
                                  Text(
                                    value.referralData.message.toString(),
                                    textAlign: TextAlign.center,
                                    style: const TextStyle(
                                      color: Colors.black54,
                                      fontSize: 14,
                                      height: 1.5,
                                    ),
                                  ),
                                  const SizedBox(height: 20),

                                  // Steps to refer
                                  _buildStep(
                                      icon: Icons.content_copy,
                                      title: 'Share your code',
                                      color: Colors.blue),
                                  _buildStepConnector(),
                                  _buildStep(
                                      icon: Icons.person_add,
                                      title: 'Friends sign up using your code',
                                      color: Colors.green),
                                  _buildStepConnector(),
                                  _buildStep(
                                      icon: Icons.card_giftcard,
                                      title: 'You both get rewards',
                                      color: Colors.orange),
                                ],
                              ),
                            ),

                            const SizedBox(height: 30),

                            // Referral code card
                            Container(
                              padding: const EdgeInsets.all(24),
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  colors: [
                                    ThemeProvider.appColor,
                                    ThemeProvider.appColor.withOpacity(0.8),
                                  ],
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                ),
                                borderRadius: BorderRadius.circular(16),
                                boxShadow: [
                                  BoxShadow(
                                    color:
                                        ThemeProvider.appColor.withOpacity(0.3),
                                    spreadRadius: 1,
                                    blurRadius: 10,
                                    offset: const Offset(0, 4),
                                  ),
                                ],
                              ),
                              child: Column(
                                children: [
                                  const Text(
                                    'Your Referral Code',
                                    style: TextStyle(
                                      color: ThemeProvider.whiteColor,
                                      fontFamily: 'medium',
                                      fontSize: 16,
                                    ),
                                  ),
                                  const SizedBox(height: 16),
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 10,
                                      vertical: 16,
                                    ),
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          value.myCode.toString(),
                                          style: const TextStyle(
                                            color: ThemeProvider.appColor,
                                            fontFamily: 'bold',
                                            fontSize: 16,
                                            letterSpacing: 1.5,
                                          ),
                                        ),
                                        const SizedBox(width: 16),
                                        IconButton(
                                          onPressed: () {
                                            value.copyToClipBoard();
                                          },
                                          icon: Icon(
                                            Icons.copy,
                                            color: ThemeProvider.appColor,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),

                            const SizedBox(height: 30),

                            // Share button
                            SizedBox(
                              width: double.infinity,
                              height: 55,
                              child: ElevatedButton.icon(
                                onPressed: () {
                                  value.share();
                                },
                                icon: const Icon(
                                  Icons.share,
                                  color: ThemeProvider.whiteColor,
                                ),
                                label: Text(
                                  'Invite Friends Now'.tr,
                                  style: const TextStyle(
                                    color: ThemeProvider.whiteColor,
                                    fontFamily: 'medium',
                                    fontSize: 16,
                                  ),
                                ),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: ThemeProvider.appColor,
                                  foregroundColor: ThemeProvider.whiteColor,
                                  elevation: 2,
                                  shadowColor:
                                      ThemeProvider.appColor.withOpacity(0.5),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
        );
      },
    );
  }

  Widget _buildStep(
      {required IconData icon, required String title, required Color color}) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            shape: BoxShape.circle,
          ),
          child: Icon(
            icon,
            color: color,
            size: 22,
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Text(
            title,
            style: const TextStyle(
              fontFamily: 'medium',
              fontSize: 14,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildStepConnector() {
    return Container(
      margin: const EdgeInsets.only(left: 15),
      height: 30,
      width: 1,
      color: Colors.grey.withOpacity(0.3),
    );
  }
}
