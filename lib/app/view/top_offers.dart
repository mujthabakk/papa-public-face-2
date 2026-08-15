import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:salon_user/app/controller/top_offers_controller.dart';
import 'package:salon_user/app/env.dart';
import 'package:salon_user/app/util/theme.dart';
import 'package:salon_user/app/view/widgets/elite_ui.dart';

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
            title: 'Featured Centers',
          ),
          body: value.apiCalled == false
              ? const Center(
                  child: CircularProgressIndicator(color: ThemeProvider.gold),
                )
              : value.topSalonList.isEmpty
                  ? const EliteApiUnavailable(minHeight: 180)
                  : ListView.builder(
                      padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
                      itemCount: value.topSalonList.length,
                      itemBuilder: (context, i) =>
                          _centerCard(value, value.topSalonList[i]),
                    ),
        );
      },
    );
  }

  Widget _centerCard(TopOffersController value, dynamic item) {
    return GestureDetector(
      onTap: () => value.onServices(item.uid as int),
      child: Container(
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
                    onTap: () => value.onServices(item.uid as int),
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
}
