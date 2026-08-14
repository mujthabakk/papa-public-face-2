import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:salon_user/app/controller/top_offers_controller.dart';
import 'package:salon_user/app/env.dart';
import 'package:salon_user/app/helper/router.dart';
import 'package:salon_user/app/util/theme.dart';
import 'package:salon_user/app/view/widgets/elite_ui.dart';
import 'package:skeletons/skeletons.dart';

class TopOffersScreen extends StatefulWidget {
  const TopOffersScreen({Key? key}) : super(key: key);

  @override
  State<TopOffersScreen> createState() => _TopOffersScreenState();
}

class _TopOffersScreenState extends State<TopOffersScreen> {
  @override
  Widget build(BuildContext context) {
    return GetBuilder<TopOffersController>(
      builder: (value) {
        return Scaffold(
          backgroundColor: ThemeProvider.backgroundColor,
          appBar: const EliteAppBar(
            showBack: true,
            title: 'Wellness Centers',
          ),
          body: value.apiCalled == false
              ? Padding(
                  padding: const EdgeInsets.all(16),
                  child: SkeletonParagraph(),
                )
              : ListView(
                  padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
                  children: [
                    Text(
                      'Curated Exclusives.',
                      style:
                          ThemeProvider.serif(size: 28, weight: FontWeight.w700),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'A definitive collection of the world\'s most prestigious wellness sanctuaries, vetted for peak performance and unparalleled luxury.',
                      style: ThemeProvider.sans(
                        size: 13,
                        color: Colors.white70,
                      ),
                    ),
                    const SizedBox(height: 18),
                    if (value.topSalonList.isNotEmpty)
                      _heroCard(value, value.topSalonList.first),
                    const SizedBox(height: 18),
                    Center(
                      child: Text(
                        'Featured Centers - View All',
                        style: ThemeProvider.sans(
                          size: 12,
                          color: ThemeProvider.greyColor,
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    ...value.topSalonList
                        .skip(value.topSalonList.length > 1 ? 1 : 0)
                        .toList()
                        .asMap()
                        .entries
                        .map((e) => _centerCard(
                              value,
                              e.value,
                              solid: e.key.isEven,
                            )),
                  ],
                ),
          bottomNavigationBar: Container(
            color: ThemeProvider.backgroundColor,
            padding: const EdgeInsets.fromLTRB(16, 10, 16, 16),
            child: SafeArea(
              child: Row(
                children: [
                  Container(
                    width: 3,
                    height: 18,
                    color: ThemeProvider.gold,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'Concierge service available 24/7',
                      style: ThemeProvider.sans(size: 12),
                    ),
                  ),
                  GestureDetector(
                    onTap: () => Get.toNamed(AppRouter.contactUsRoutes),
                    child: Text(
                      'CONTACT',
                      style: ThemeProvider.sans(
                        size: 12,
                        weight: FontWeight.w700,
                        color: ThemeProvider.gold,
                        letterSpacing: 1,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _heroCard(TopOffersController value, dynamic item) {
    return GestureDetector(
      onTap: () => value.onServices(item.uid as int),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: SizedBox(
          height: 200,
          child: Stack(
            fit: StackFit.expand,
            children: [
              EliteNetworkImage(
                url: '${Environments.imageURL}${item.cover}',
              ),
              const DecoratedBox(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [Colors.transparent, Colors.black87],
                  ),
                ),
              ),
              Positioned(
                left: 16,
                right: 16,
                bottom: 16,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item.name ?? '',
                      style: ThemeProvider.serif(size: 22, weight: FontWeight.w700),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      item.address ?? '',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: ThemeProvider.sans(size: 12, color: Colors.white70),
                    ),
                    const SizedBox(height: 10),
                    EliteGoldButton(
                      label: 'BOOK NOW',
                      onTap: () => value.onServices(item.uid as int),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _centerCard(TopOffersController value, dynamic item,
      {required bool solid}) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: ThemeProvider.surface,
        borderRadius: BorderRadius.circular(16),
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          EliteNetworkImage(
            url: '${Environments.imageURL}${item.cover}',
            height: 160,
            width: double.infinity,
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(14, 12, 14, 14),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        (item.address ?? '').toString().toUpperCase(),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: ThemeProvider.sans(
                          size: 10,
                          color: ThemeProvider.greyColor,
                          letterSpacing: 1.2,
                        ),
                      ),
                    ),
                    const Icon(Icons.star, color: ThemeProvider.gold, size: 14),
                    const SizedBox(width: 4),
                    Text(
                      (item.rating ?? 0).toStringAsFixed(1),
                      style: ThemeProvider.sans(
                        size: 12,
                        color: ThemeProvider.gold,
                        weight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                Text(
                  item.name ?? '',
                  style: ThemeProvider.serif(size: 20),
                ),
                const SizedBox(height: 6),
                Text(
                  item.address ?? '',
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: ThemeProvider.sans(
                    size: 13,
                    color: Colors.white70,
                  ),
                ),
                const SizedBox(height: 12),
                SizedBox(
                  width: double.infinity,
                  child: EliteGoldButton(
                    label: 'BOOK NOW',
                    outlined: !solid,
                    onTap: () => value.onServices(item.uid as int),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
