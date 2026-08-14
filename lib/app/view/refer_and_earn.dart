import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:salon_user/app/controller/refer_and_earn_controller.dart';
import 'package:salon_user/app/util/theme.dart';
import 'package:salon_user/app/view/widgets/elite_ui.dart';

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
        final amount = (value.referralData.amount ?? 0).toStringAsFixed(0);
        return Scaffold(
          backgroundColor: ThemeProvider.backgroundColor,
          appBar: EliteAppBar(
            showBack: true,
            title: 'Refer & Earn',
            onMore: () {},
          ),
          body: value.apiCalled == false
              ? const Center(
                  child: CircularProgressIndicator(color: ThemeProvider.gold),
                )
              : ListView(
                  padding: const EdgeInsets.fromLTRB(16, 8, 16, 32),
                  children: [
                    EliteCard(
                      child: Column(
                        children: [
                          Text('Refer & Earn',
                              style: ThemeProvider.sans(
                                  size: 12, color: ThemeProvider.greyColor)),
                          const SizedBox(height: 16),
                          Container(
                            width: 72,
                            height: 72,
                            decoration: BoxDecoration(
                              color: ThemeProvider.gold.withValues(alpha: 0.15),
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: const Icon(Icons.card_giftcard,
                                color: ThemeProvider.gold, size: 36),
                          ),
                          const SizedBox(height: 8),
                          const Icon(Icons.pets,
                              color: ThemeProvider.gold, size: 40),
                        ],
                      ),
                    ),
                    Text(
                      'Share the Elite Experience',
                      textAlign: TextAlign.center,
                      style: ThemeProvider.serif(
                          size: 26, color: ThemeProvider.gold),
                    ),
                    const SizedBox(height: 8),
                    Text.rich(
                      TextSpan(
                        style: ThemeProvider.sans(
                            size: 13, color: Colors.white70),
                        children: [
                          const TextSpan(
                              text:
                                  'Invite your friends to Papa Bear and you both receive '),
                          TextSpan(
                            text: '₹$amount',
                            style: const TextStyle(color: ThemeProvider.gold),
                          ),
                          const TextSpan(
                              text:
                                  ' in wallet credit upon their first booking.'),
                        ],
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 16),
                    EliteCard(
                      child: Column(
                        children: [
                          Text(
                            'YOUR EXCLUSIVE REFERRAL CODE',
                            style: ThemeProvider.sans(
                              size: 10,
                              color: ThemeProvider.greyColor,
                              letterSpacing: 1.4,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                value.myCode.isEmpty ? '------' : value.myCode,
                                style: ThemeProvider.serif(
                                    size: 28, color: ThemeProvider.gold),
                              ),
                              const SizedBox(width: 6),
                              const Icon(Icons.verified,
                                  color: ThemeProvider.gold, size: 18),
                            ],
                          ),
                          const SizedBox(height: 12),
                          EliteGoldButton(
                            label: 'COPY CODE',
                            icon: Icons.copy,
                            onTap: value.copyToClipBoard,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'HOW PRIVILEGE SCALES',
                      style: ThemeProvider.sans(
                        size: 10,
                        color: ThemeProvider.greyColor,
                        letterSpacing: 1.4,
                      ),
                    ),
                    const SizedBox(height: 12),
                    _step(Icons.send_outlined, '1. Share your code',
                        'Send your unique link to fellow connoisseurs via any platform.'),
                    _step(Icons.person_add_alt_1_outlined,
                        '2. Friend joins Papa Bear',
                        'Your friend creates an account and makes their first booking.'),
                    _step(Icons.star_outline, '3. Both get ₹$amount',
                        'Rewards are credited to both accounts.'),
                    const SizedBox(height: 8),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        onPressed: value.share,
                        icon: const Icon(Icons.ios_share, color: Colors.black),
                        label: Text('INVITE FRIENDS',
                            style: ThemeProvider.sans(
                              size: 13,
                              weight: FontWeight.w700,
                              color: Colors.black,
                              letterSpacing: 0.8,
                            )),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: ThemeProvider.gold,
                          minimumSize: const Size.fromHeight(48),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10)),
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      'Terms and Conditions apply. Subject to verification.',
                      textAlign: TextAlign.center,
                      style: ThemeProvider.sans(
                          size: 11, color: ThemeProvider.greyColor),
                    ),
                  ],
                ),
        );
      },
    );
  }

  Widget _step(IconData icon, String title, String body) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: ThemeProvider.surface,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, color: ThemeProvider.gold, size: 20),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: ThemeProvider.sans(size: 14, weight: FontWeight.w600)),
                const SizedBox(height: 2),
                Text(body,
                    style: ThemeProvider.sans(
                        size: 12, color: ThemeProvider.greyColor)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
