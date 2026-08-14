import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:salon_user/app/controller/products_details_controller.dart';
import 'package:salon_user/app/env.dart';
import 'package:salon_user/app/util/theme.dart';
import 'package:salon_user/app/view/widgets/elite_ui.dart';

class ProductsDetailsScreen extends StatefulWidget {
  const ProductsDetailsScreen({Key? key}) : super(key: key);

  @override
  State<ProductsDetailsScreen> createState() => _ProductsDetailsScreenState();
}

class _ProductsDetailsScreenState extends State<ProductsDetailsScreen> {
  int _tab = 0;

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ProductsDetailsController>(
      builder: (value) {
        return Scaffold(
          backgroundColor: ThemeProvider.backgroundColor,
          appBar: EliteAppBar(
            showBack: true,
            title: 'Product Details',
            onMore: () {},
          ),
          body: value.apiCalled == false
              ? const Center(
                  child: CircularProgressIndicator(color: ThemeProvider.gold),
                )
              : ListView(
                  padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
                  children: [
                    _hero(value),
                    const SizedBox(height: 16),
                    Text(
                      (value.cateInfo.name ?? 'ADVANCED SKIN ALCHEMY')
                          .toUpperCase(),
                      style: ThemeProvider.serif(
                        size: 12,
                        color: ThemeProvider.gold,
                        letterSpacing: 1.4,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(value.productsList.name ?? '',
                        style: ThemeProvider.serif(
                            size: 28, weight: FontWeight.w700)),
                    Text(
                      elitePrice(
                        value.currencySide,
                        value.currencySymbol,
                        (value.productsList.discount ?? 0) > 0
                            ? value.productsList.sellPrice
                            : value.productsList.originalPrice,
                      ),
                      style: ThemeProvider.serif(
                          size: 26, color: ThemeProvider.gold),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      value.productsList.descriptions ?? '',
                      style: ThemeProvider.sans(size: 13, color: Colors.white70)
                          .copyWith(height: 1.5),
                    ),
                    const SizedBox(height: 14),
                    _features(value),
                    const SizedBox(height: 18),
                    Row(
                      children: [
                        _tabBtn('INGREDIENTS', 0),
                        const SizedBox(width: 18),
                        _tabBtn('RITUAL', 1),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      _tab == 0
                          ? (value.productsList.keyFeatures ??
                              value.productsList.descriptions ??
                              '')
                          : (value.productsList.disclaimer ??
                              'Apply morning and evening to cleansed skin.'),
                      style: ThemeProvider.sans(
                        size: 13,
                        color: Colors.white70,
                        style: FontStyle.italic,
                      ),
                    ),
                    const SizedBox(height: 18),
                    Text(
                      'QUANTITY',
                      style: ThemeProvider.sans(
                        size: 10,
                        color: ThemeProvider.greyColor,
                        letterSpacing: 1.2,
                      ),
                    ),
                    const SizedBox(height: 8),
                    EliteQtyStepper(
                      quantity: value.productsList.quantity < 1
                          ? 1
                          : value.productsList.quantity,
                      onMinus: () {
                        if (value.productsList.quantity > 0) {
                          value.updateProductQuantityRemove();
                        }
                      },
                      onPlus: () {
                        if (value.productsList.quantity == 0) {
                          value.addToCart();
                        } else {
                          value.updateProductQuantity();
                        }
                      },
                    ),
                    const SizedBox(height: 24),
                    Center(
                      child: Column(
                        children: [
                          Text('The Science of Radiance',
                              style: ThemeProvider.serif(size: 20)),
                          const SizedBox(height: 6),
                          Container(
                              width: 40, height: 2, color: ThemeProvider.gold),
                        ],
                      ),
                    ),
                    const SizedBox(height: 14),
                    _science('Molecular Purity', Icons.science_outlined,
                        'Laboratory-grade actives with uncompromising purity.'),
                    _science('Luminous Finish', Icons.auto_awesome,
                        'Optical diffusion for an editorial glow.'),
                    _science('Botanical Integrity', Icons.eco_outlined,
                        'Ethically sourced botanicals, never diluted.'),
                    if ((value.productsList.disclaimer ?? '').isNotEmpty) ...[
                      const SizedBox(height: 8),
                      GestureDetector(
                        onTap: value.onRateExpand,
                        child: Text(
                          value.isOpen ? 'Hide disclaimer' : 'View disclaimer',
                          style: ThemeProvider.sans(
                              size: 12, color: ThemeProvider.gold),
                        ),
                      ),
                      if (value.isOpen)
                        Text(
                          value.productsList.disclaimer ?? '',
                          style: ThemeProvider.sans(
                              size: 12, color: Colors.white70),
                        ),
                    ],
                    if (value.relatedList.isNotEmpty) ...[
                      const SizedBox(height: 18),
                      const EliteSectionBar(title: 'You May Also Like'),
                      SizedBox(
                        height: 180,
                        child: ListView.separated(
                          scrollDirection: Axis.horizontal,
                          itemCount: value.relatedList.length,
                          separatorBuilder: (_, __) =>
                              const SizedBox(width: 10),
                          itemBuilder: (_, i) {
                            final p = value.relatedList[i];
                            return GestureDetector(
                              onTap: () => value.getProducts(p.id as int),
                              child: SizedBox(
                                width: 130,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    EliteNetworkImage(
                                      url:
                                          '${Environments.imageURL}${p.cover}',
                                      height: 110,
                                      width: 130,
                                      radius: BorderRadius.circular(10),
                                    ),
                                    const SizedBox(height: 6),
                                    Text(p.name ?? '',
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        style: ThemeProvider.serif(size: 13)),
                                    Text(
                                      elitePrice(
                                          value.currencySide,
                                          value.currencySymbol,
                                          p.sellPrice),
                                      style: ThemeProvider.sans(
                                          size: 12,
                                          color: ThemeProvider.gold),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  ],
                ),
          bottomNavigationBar: value.apiCalled
              ? Container(
                  color: ThemeProvider.backgroundColor,
                  padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
                  child: SafeArea(
                    child: ElevatedButton(
                      onPressed: value.productsList.quantity == 0
                          ? value.addToCart
                          : value.onCheckout,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: ThemeProvider.gold,
                        foregroundColor: Colors.black,
                        minimumSize: const Size.fromHeight(48),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10)),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            value.productsList.quantity == 0
                                ? 'Add to Cart'
                                : 'Go to Cart',
                            style: ThemeProvider.serif(
                                size: 18, color: Colors.black),
                          ),
                          const SizedBox(width: 8),
                          const Icon(Icons.shopping_bag_outlined, size: 18),
                        ],
                      ),
                    ),
                  ),
                )
              : null,
        );
      },
    );
  }

  Widget _hero(ProductsDetailsController value) {
    final images = value.productsList.images ?? [];
    final cover = images.isNotEmpty
        ? images.first
        : (value.productsList.cover ?? '');
    return EliteCard(
      padding: EdgeInsets.zero,
      child: Stack(
        children: [
          EliteNetworkImage(
            url: '${Environments.imageURL}$cover',
            height: 280,
            width: double.infinity,
            radius: BorderRadius.circular(14),
          ),
          Positioned(
            top: 14,
            left: 14,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _badge('LIMITED RELEASE', gold: true),
                const SizedBox(height: 6),
                _badge('ETHICALLY SOURCED'),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _badge(String text, {bool gold = false}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: gold ? const Color(0x66D4AF37) : Colors.black54,
        borderRadius: BorderRadius.circular(20),
        border: gold ? Border.all(color: ThemeProvider.gold) : null,
      ),
      child: Text(
        text,
        style: ThemeProvider.sans(
          size: 9,
          weight: FontWeight.w700,
          color: gold ? ThemeProvider.gold : Colors.white,
          letterSpacing: 1,
        ),
      ),
    );
  }

  Widget _features(ProductsDetailsController value) {
    return Row(
      children: [
        Expanded(
          child: _featBox(
            'DEEP HYDRATION',
            value.subCateInfo.name ?? 'Intensive moisture restoration.',
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: _featBox(
            'ILLUMINATION',
            'Visible radiance, refined texture.',
          ),
        ),
      ],
    );
  }

  Widget _featBox(String title, String body) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        border: Border.all(color: ThemeProvider.gold.withValues(alpha: 0.5)),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: ThemeProvider.sans(
              size: 10,
              color: ThemeProvider.gold,
              letterSpacing: 1,
            ),
          ),
          const SizedBox(height: 6),
          Text(body,
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
              style: ThemeProvider.sans(size: 11, color: Colors.white70)),
        ],
      ),
    );
  }

  Widget _tabBtn(String label, int i) {
    final on = _tab == i;
    return GestureDetector(
      onTap: () => setState(() => _tab = i),
      child: Text(
        label,
        style: ThemeProvider.sans(
          size: 12,
          weight: FontWeight.w700,
          color: on ? Colors.white : ThemeProvider.greyColor,
          letterSpacing: 1,
        ),
      ),
    );
  }

  Widget _science(String title, IconData icon, String body) {
    return EliteCard(
      child: Column(
        children: [
          Icon(icon, color: ThemeProvider.gold, size: 28),
          const SizedBox(height: 8),
          Text(title, style: ThemeProvider.serif(size: 16)),
          const SizedBox(height: 4),
          Text(body,
              textAlign: TextAlign.center,
              style: ThemeProvider.sans(
                  size: 12, color: ThemeProvider.greyColor)),
        ],
      ),
    );
  }
}
