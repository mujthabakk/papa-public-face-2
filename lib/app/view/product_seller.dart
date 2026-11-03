import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:salon_user/app/controller/product_seller_controller.dart';
import 'package:salon_user/app/env.dart';
import 'package:salon_user/app/helper/desktop.dart';
import 'package:salon_user/app/util/theme.dart';
import 'package:salon_user/app/view/widgets/elite_ui.dart';

class ProductSellerScreen extends StatelessWidget {
  const ProductSellerScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ProductSellerController>(
      builder: (c) {
        final listingSellers = c.sellerUid <= 0;
        return Scaffold(
          backgroundColor: ThemeProvider.backgroundColor,
          appBar: EliteAppBar(
            showBack: true,
            title: listingSellers
                ? 'Stores'.tr
                : (c.sellerName.isEmpty ? 'Store'.tr : c.sellerName),
          ),
          body: !c.apiCalled
              ? const Center(
                  child: CircularProgressIndicator(color: ThemeProvider.gold),
                )
              : listingSellers
                  ? _sellers(context, c)
                  : _products(context, c),
        );
      },
    );
  }

  Widget _sellers(BuildContext context, ProductSellerController c) {
    if (c.sellers.isEmpty) {
      return const EliteApiUnavailable(
        title: 'No stores yet',
        icon: Icons.storefront_outlined,
      );
    }
    if (Desktop.of(context)) {
      return GridView.builder(
        padding: const EdgeInsets.fromLTRB(8, 12, 8, 24),
        itemCount: c.sellers.length,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          mainAxisSpacing: 12,
          crossAxisSpacing: 12,
          childAspectRatio: 2.4,
        ),
        itemBuilder: (_, i) {
          final s = c.sellers[i];
          return GestureDetector(
            onTap: () => c.openSeller(s),
            child: EliteCard(
              margin: EdgeInsets.zero,
              child: Row(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: EliteNetworkImage(
                      url: Environments.mediaUrl(s.cover),
                      width: 56,
                      height: 56,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      s.displayName,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: ThemeProvider.serif(size: 14),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      );
    }
    return ListView.separated(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
      itemCount: c.sellers.length,
      separatorBuilder: (_, __) => const SizedBox(height: 10),
      itemBuilder: (_, i) {
        final s = c.sellers[i];
        return GestureDetector(
          onTap: () => c.openSeller(s),
          child: EliteCard(
            child: Row(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: EliteNetworkImage(
                    url: Environments.mediaUrl(s.cover),
                    width: 64,
                    height: 64,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(s.displayName,
                          style: ThemeProvider.serif(size: 16)),
                      if ((s.address ?? '').isNotEmpty)
                        Text(s.address!,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: ThemeProvider.sans(
                                size: 12, color: ThemeProvider.greyColor)),
                      if ((s.productsCount ?? 0) > 0)
                        Text('${s.productsCount} products',
                            style: ThemeProvider.sans(
                                size: 11, color: ThemeProvider.gold)),
                    ],
                  ),
                ),
                const Icon(Icons.chevron_right, color: ThemeProvider.gold),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _products(BuildContext context, ProductSellerController c) {
    return Column(
      children: [
        if (c.sellerCover.isNotEmpty || c.sellerAddress.isNotEmpty)
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 4),
            child: EliteCard(
              child: Row(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: EliteNetworkImage(
                      url: Environments.mediaUrl(c.sellerCover),
                      width: 56,
                      height: 56,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      c.sellerAddress.isEmpty
                          ? c.sellerName
                          : c.sellerAddress,
                      style: ThemeProvider.sans(
                          size: 12, color: Colors.white70),
                    ),
                  ),
                ],
              ),
            ),
          ),
        Expanded(
          child: c.products.isEmpty
              ? const EliteApiUnavailable(
                  title: 'No products from this store',
                  icon: Icons.shopping_bag_outlined,
                )
              : GridView.builder(
                  padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
                  gridDelegate: Desktop.productGridDelegate(context),
                  itemCount: c.products.length,
                  itemBuilder: (_, i) {
                    final p = c.products[i];
                    return GestureDetector(
                      onTap: () => c.onProduct(p.id ?? 0),
                      child: EliteCard(
                        padding: EdgeInsets.zero,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              child: EliteNetworkImage(
                                url: Environments.mediaUrl(p.cover),
                                width: double.infinity,
                                radius: const BorderRadius.vertical(
                                    top: Radius.circular(14)),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(10),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(p.name ?? '',
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                      style: ThemeProvider.serif(size: 14)),
                                  const SizedBox(height: 4),
                                  Text(
                                    elitePrice(
                                      c.currencySide,
                                      c.currencySymbol,
                                      (p.discount ?? 0) > 0
                                          ? p.sellPrice
                                          : p.originalPrice,
                                    ),
                                    style: ThemeProvider.price(
                                        size: 13, color: ThemeProvider.gold),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
        ),
      ],
    );
  }
}
