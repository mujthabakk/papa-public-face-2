import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:salon_user/app/controller/product_cart_controller.dart';
import 'package:salon_user/app/controller/top_products_controller.dart';
import 'package:salon_user/app/env.dart';
import 'package:salon_user/app/helper/router.dart';
import 'package:salon_user/app/util/theme.dart';
import 'package:salon_user/app/view/widgets/elite_ui.dart';

class TopProductScreen extends StatefulWidget {
  const TopProductScreen({Key? key}) : super(key: key);

  @override
  State<TopProductScreen> createState() => _TopProductScreenState();
}

class _TopProductScreenState extends State<TopProductScreen> {
  final _search = TextEditingController();
  int? _cate;
  final _liked = <int>{};
  bool _wishlistOnly = false;

  static const _chips = [
    (Icons.spa_outlined, 'Skin'),
    (Icons.content_cut, 'Hair'),
    (Icons.medication_outlined, 'Supplements'),
    (Icons.water_drop_outlined, 'Fragrance'),
    (Icons.brush_outlined, 'Body'),
  ];

  @override
  void dispose() {
    _search.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<TopProductsControllrer>(
      builder: (value) {
        var list = value.productsList.where((p) {
          final q = _search.text.trim().toLowerCase();
          final nameOk =
              q.isEmpty || (p.name ?? '').toLowerCase().contains(q);
          final cateOk = _cate == null || p.cateId == _cate;
          final likeOk = !_wishlistOnly || _liked.contains(p.id);
          return nameOk && cateOk && likeOk;
        }).toList();
        return Scaffold(
          backgroundColor: ThemeProvider.backgroundColor,
          appBar: EliteAppBar(
            showBack: true,
            title: _wishlistOnly ? 'Wishlist' : 'Products',
            onMore: () => setState(() => _wishlistOnly = !_wishlistOnly),
          ),
          body: value.apiCalled == false
              ? const Center(
                  child: CircularProgressIndicator(color: ThemeProvider.gold),
                )
              : CustomScrollView(
                  slivers: [
                    SliverToBoxAdapter(
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
                        child: Column(
                          children: [
                            Row(
                              children: [
                                Expanded(
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 12),
                                    decoration: BoxDecoration(
                                      color: ThemeProvider.surface,
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: TextField(
                                      controller: _search,
                                      onChanged: (_) => setState(() {}),
                                      style: ThemeProvider.sans(size: 13),
                                      decoration: InputDecoration(
                                        icon: const Icon(Icons.search,
                                            color: ThemeProvider.gold,
                                            size: 18),
                                        hintText: 'Search elite collections...',
                                        hintStyle: ThemeProvider.sans(
                                            size: 13,
                                            color: ThemeProvider.greyColor),
                                        border: InputBorder.none,
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 8),
                                GestureDetector(
                                  onTap: () => Get.toNamed(
                                      AppRouter.getSortByRoutes()),
                                  child: Container(
                                    width: 44,
                                    height: 44,
                                    decoration: BoxDecoration(
                                      color: ThemeProvider.surface,
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: const Icon(Icons.tune,
                                        color: ThemeProvider.gold),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 14),
                            SizedBox(
                              height: 74,
                              child: ListView.separated(
                                scrollDirection: Axis.horizontal,
                                itemCount: _chips.length,
                                separatorBuilder: (_, __) =>
                                    const SizedBox(width: 10),
                                itemBuilder: (_, i) {
                                  final ids = value.productsList
                                      .map((p) => p.cateId)
                                      .whereType<int>()
                                      .toSet()
                                      .toList();
                                  final id =
                                      i < ids.length ? ids[i] : (i + 1);
                                  final on = _cate == id;
                                  return GestureDetector(
                                    onTap: () => setState(
                                        () => _cate = on ? null : id),
                                    child: Column(
                                      children: [
                                        Container(
                                          width: 48,
                                          height: 48,
                                          decoration: BoxDecoration(
                                            color: on
                                                ? ThemeProvider.gold
                                                : ThemeProvider.surface,
                                            borderRadius:
                                                BorderRadius.circular(12),
                                          ),
                                          child: Icon(
                                            _chips[i].$1,
                                            color: on
                                                ? Colors.black
                                                : Colors.white,
                                            size: 22,
                                          ),
                                        ),
                                        const SizedBox(height: 6),
                                        Text(
                                          _chips[i].$2,
                                          style: ThemeProvider.sans(
                                            size: 11,
                                            color: on
                                                ? ThemeProvider.gold
                                                : ThemeProvider.greyColor,
                                          ),
                                        ),
                                      ],
                                    ),
                                  );
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    SliverPadding(
                      padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
                      sliver: SliverGrid(
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          mainAxisSpacing: 12,
                          crossAxisSpacing: 12,
                          childAspectRatio: 0.68,
                        ),
                        delegate: SliverChildBuilderDelegate(
                          (context, i) {
                            final p = list[i];
                            return _product(value, p, i);
                          },
                          childCount: list.length,
                        ),
                      ),
                    ),
                  ],
                ),
          bottomNavigationBar: Get.find<ProductCartController>()
                  .savedInCart
                  .isNotEmpty
              ? Container(
                  color: ThemeProvider.backgroundColor,
                  padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
                  child: SafeArea(
                    child: EliteGoldButton(
                      label: 'VIEW CART',
                      onTap: value.onCart,
                    ),
                  ),
                )
              : null,
        );
      },
    );
  }

  Widget _product(TopProductsControllrer value, dynamic p, int i) {
    final liked = _liked.contains(p.id);
    return GestureDetector(
      onTap: () => value.onProduct(p.id as int),
      child: EliteCard(
        margin: EdgeInsets.zero,
        padding: EdgeInsets.zero,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            EliteNetworkImage(
              url: '${Environments.imageURL}${p.cover}',
              height: 120,
              width: double.infinity,
              radius: const BorderRadius.vertical(top: Radius.circular(14)),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(10, 8, 10, 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(p.name ?? '',
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: ThemeProvider.sans(size: 12)),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      const Icon(Icons.star, size: 12, color: ThemeProvider.gold),
                      Text(
                        ' ${(p.rating ?? 0).toStringAsFixed(1)}',
                        style: ThemeProvider.sans(
                            size: 11, color: ThemeProvider.gold),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          elitePrice(
                              value.currencySide,
                              value.currencySymbol,
                              (p.discount ?? 0) > 0
                                  ? p.sellPrice
                                  : p.originalPrice),
                          style: ThemeProvider.serif(
                              size: 16, color: ThemeProvider.gold),
                        ),
                      ),
                      GestureDetector(
                        onTap: () => setState(() {
                          if (liked) {
                            _liked.remove(p.id);
                          } else {
                            _liked.add(p.id as int);
                          }
                        }),
                        child: Icon(
                          liked ? Icons.favorite : Icons.favorite_border,
                          size: 16,
                          color: liked ? ThemeProvider.gold : Colors.white,
                        ),
                      ),
                      const SizedBox(width: 8),
                      GestureDetector(
                        onTap: () => value.addToCart(
                            value.productsList.indexWhere((e) => e.id == p.id)),
                        child: const Icon(Icons.add_shopping_cart,
                            size: 16, color: Colors.white),
                      ),
                    ],
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
