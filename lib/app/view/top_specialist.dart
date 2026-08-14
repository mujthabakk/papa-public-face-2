import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:salon_user/app/controller/top_specialist_controller.dart';
import 'package:salon_user/app/env.dart';
import 'package:salon_user/app/helper/router.dart';
import 'package:salon_user/app/util/theme.dart';
import 'package:salon_user/app/view/widgets/elite_ui.dart';
import 'package:skeletons/skeletons.dart';

class TopSpecialistScreen extends StatefulWidget {
  const TopSpecialistScreen({Key? key}) : super(key: key);

  @override
  State<TopSpecialistScreen> createState() => _TopSpecialistScreenState();
}

class _TopSpecialistScreenState extends State<TopSpecialistScreen> {
  bool _sortByRating = false;

  @override
  Widget build(BuildContext context) {
    return GetBuilder<TopSpecialistController>(
      builder: (value) {
        final list = [...value.topFreelancerList];
        if (_sortByRating) {
          list.sort((a, b) => (b.rating ?? 0).compareTo(a.rating ?? 0));
        }
        return Scaffold(
          backgroundColor: ThemeProvider.backgroundColor,
          appBar: const EliteAppBar(
            showBack: true,
            title: 'Wellness Experts',
          ),
          body: value.apiCalled == false
              ? Padding(
                  padding: const EdgeInsets.all(16),
                  child: SkeletonParagraph(),
                )
              : list.isEmpty
                  ? Center(
                      child: Text(
                        'No Data Found'.tr,
                        style: ThemeProvider.serif(
                            size: 16, color: ThemeProvider.gold),
                      ),
                    )
                  : ListView(
                  padding: const EdgeInsets.fromLTRB(16, 8, 16, 32),
                  children: [
                    Text(
                      'Wellness Experts'.tr,
                      style: ThemeProvider.serif(size: 28, weight: FontWeight.w700),
                    ),
                    const SizedBox(height: 14),
                    Row(
                      children: [
                        Expanded(
                          child: _outlineBtn(
                            Icons.tune,
                            'FILTER',
                            () => Get.toNamed(AppRouter.getFilterRoutes(),
                                arguments: ['']),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: _outlineBtn(
                            Icons.sort,
                            'SORT',
                            () => setState(() => _sortByRating = !_sortByRating),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 18),
                    ...list.map((item) => _expertCard(value, item)),
                  ],
                ),
        );
      },
    );
  }

  Widget _outlineBtn(IconData icon, String label, VoidCallback onTap) {
    return OutlinedButton.icon(
      onPressed: onTap,
      icon: Icon(icon, size: 16, color: Colors.white),
      label: Text(
        label,
        style: ThemeProvider.sans(
          size: 12,
          weight: FontWeight.w600,
          color: Colors.white,
          letterSpacing: 1,
        ),
      ),
      style: OutlinedButton.styleFrom(
        side: const BorderSide(color: Colors.white24),
        padding: const EdgeInsets.symmetric(vertical: 12),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
    );
  }

  Widget _expertCard(TopSpecialistController value, dynamic item) {
    final name =
        '${item.userInfo?.firstName ?? ''} ${item.userInfo?.lastName ?? ''}'
            .trim();
    final tags = (item.categories as List?) ?? [];
    final price = value.currencySide == 'left'
        ? '${value.currencySymbol}${(item.feeStart ?? 0).toStringAsFixed(0)}'
        : '${(item.feeStart ?? 0).toStringAsFixed(0)}${value.currencySymbol}';
    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: ThemeProvider.surface,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Stack(
                children: [
                  Container(
                    padding: const EdgeInsets.all(1.5),
                    decoration: BoxDecoration(
                      border: Border.all(color: ThemeProvider.gold, width: 1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: EliteNetworkImage(
                      url: '${Environments.imageURL}${item.userInfo?.cover ?? ''}',
                      width: 64,
                      height: 64,
                      radius: BorderRadius.circular(10),
                    ),
                  ),
                  Positioned(
                    right: 0,
                    bottom: 0,
                    child: Container(
                      width: 18,
                      height: 18,
                      decoration: const BoxDecoration(
                        color: ThemeProvider.gold,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.check, size: 12, color: Colors.black),
                    ),
                  ),
                ],
              ),
              const Spacer(),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Row(
                    children: [
                      const Icon(Icons.star, color: ThemeProvider.gold, size: 16),
                      const SizedBox(width: 4),
                      Text(
                        (item.rating ?? 0).toStringAsFixed(1),
                        style: ThemeProvider.sans(
                          size: 14,
                          weight: FontWeight.w700,
                          color: ThemeProvider.gold,
                        ),
                      ),
                    ],
                  ),
                  Text(
                    '(${item.totalRating ?? 0} Reviews)',
                    style: ThemeProvider.sans(
                      size: 11,
                      color: ThemeProvider.greyColor,
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(name, style: ThemeProvider.serif(size: 22)),
          const SizedBox(height: 4),
          Text(
            tags.isNotEmpty
                ? (tags.first.name ?? 'Wellness Specialist')
                : 'Wellness Specialist',
            style: ThemeProvider.sans(size: 13, color: ThemeProvider.greyColor),
          ),
          const SizedBox(height: 10),
          Wrap(
            spacing: 6,
            runSpacing: 6,
            children: tags.take(3).map<Widget>((cate) {
              return Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                decoration: BoxDecoration(
                  color: const Color(0xFF2A2A2A),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  (cate.name ?? '').toString().toUpperCase(),
                  style: ThemeProvider.sans(
                    size: 10,
                    color: Colors.white70,
                    letterSpacing: 0.6,
                  ),
                ),
              );
            }).toList(),
          ),
          const SizedBox(height: 14),
          Row(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Starting at',
                    style: ThemeProvider.sans(
                      size: 11,
                      color: ThemeProvider.greyColor,
                    ),
                  ),
                  Text(
                    price,
                    style: ThemeProvider.serif(
                      size: 22,
                      color: ThemeProvider.gold,
                      weight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
              const Spacer(),
              EliteGoldButton(
                label: 'BOOK NOW',
                onTap: () => value.onSpecialist(item.uid as int),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
