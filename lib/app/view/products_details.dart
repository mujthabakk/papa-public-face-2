import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:salon_user/app/controller/products_details_controller.dart';
import 'package:salon_user/app/env.dart';
import 'package:salon_user/app/helper/desktop.dart';
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
            title: 'Product Details'.tr,
            onMore: () {},
          ),
          body: value.apiCalled == false
              ? const Center(
                  child: CircularProgressIndicator(color: ThemeProvider.gold),
                )
              : Desktop.of(context)
                  ? _desktopBody(value)
                  : ListView(
                  padding: const EdgeInsets.fromLTRB(16, 8, 16, 100),
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
                        maxLines: 3,
                        overflow: TextOverflow.ellipsis,
                        style: ThemeProvider.serif(
                            size: 28, weight: FontWeight.w700)),
                    Wrap(
                      crossAxisAlignment: WrapCrossAlignment.end,
                      spacing: 10,
                      children: [
                        Text(
                          elitePrice(
                            value.currencySide,
                            value.currencySymbol,
                            value.displayPrice,
                          ),
                          style: ThemeProvider.price(
                              size: 26,
                              color: ThemeProvider.gold,
                              weight: FontWeight.w700),
                        ),
                        if (value.displayMrp != null)
                          Text(
                            elitePrice(
                              value.currencySide,
                              value.currencySymbol,
                              value.displayMrp,
                            ),
                            style: ThemeProvider.price(
                              size: 14,
                              color: ThemeProvider.greyColor,
                            ).copyWith(
                              decoration: TextDecoration.lineThrough,
                            ),
                          ),
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 4),
                      child: Text(
                        value.displayStock <= 0
                            ? 'Out of stock'.tr
                            : (value.displayStock <= 5
                                ? 'Only ${value.displayStock} left'.tr
                                : 'In stock'.tr),
                        style: ThemeProvider.sans(
                          size: 12,
                          color: value.displayStock <= 0
                              ? Colors.redAccent
                              : (value.displayStock <= 5
                                  ? Colors.orangeAccent
                                  : const Color(0xFF7DCEA0)),
                        ),
                      ),
                    ),
                    if (value.paymentSummary.isNotEmpty ||
                        value.returnSummary.isNotEmpty) ...[
                      const SizedBox(height: 8),
                      Wrap(
                        spacing: 8,
                        runSpacing: 6,
                        children: [
                          if (value.paymentSummary.isNotEmpty)
                            _metaChip(Icons.payments_outlined,
                                value.paymentSummary),
                          if (value.returnSummary.isNotEmpty)
                            _metaChip(Icons.assignment_return_outlined,
                                value.returnSummary),
                        ],
                      ),
                    ],
                    // Variant just above quantity (after name / price).
                    if (value.hasVariantOptions) ...[
                      const SizedBox(height: 14),
                      _variantPicker(value),
                    ] else if (value.hasSimpleOptions) ...[
                      const SizedBox(height: 14),
                      _simpleOptions(value),
                    ],
                    const SizedBox(height: 14),
                    Text('QUANTITY'.tr,
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
                    if (value.soldByInfo.displayName.isNotEmpty) ...[
                      const SizedBox(height: 12),
                      GestureDetector(
                        onTap: value.openSellerStore,
                        child: Row(
                          children: [
                            Text('Sold by '.tr,
                                style: ThemeProvider.sans(
                                    size: 12, color: ThemeProvider.greyColor)),
                            Flexible(
                              child: Text(
                                value.soldByInfo.displayName,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: ThemeProvider.sans(
                                  size: 12,
                                  weight: FontWeight.w700,
                                  color: ThemeProvider.gold,
                                ),
                              ),
                            ),
                            const Icon(Icons.chevron_right,
                                size: 16, color: ThemeProvider.gold),
                          ],
                        ),
                      ),
                    ],
                    const SizedBox(height: 12),
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
                    const SizedBox(height: 24),
                    Center(
                      child: Column(
                        children: [
                          Text('The Science of Radiance'.tr,
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
                      EliteSectionBar(title: 'You May Also Like'.tr),
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
          bottomNavigationBar: value.apiCalled && !Desktop.of(context)
              ? Container(
                  color: ThemeProvider.backgroundColor,
                  padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
                  child: SafeArea(
                    child: ElevatedButton(
                      onPressed: value.productsList.quantity == 0
                          ? (value.hasVariantOptions &&
                                  value.displayStock <= 0
                              ? null
                              : value.addToCart)
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

  Widget _desktopBody(ProductsDetailsController value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          flex: 5,
          child: ListView(
            padding: const EdgeInsets.fromLTRB(24, 8, 16, 32),
            children: [
              _hero(value, tall: true),
              if (value.relatedList.isNotEmpty) ...[
                const SizedBox(height: 24),
                EliteSectionBar(title: 'You May Also Like'.tr),
                const SizedBox(height: 8),
                GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: value.relatedList.length,
                  gridDelegate:
                      const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    mainAxisSpacing: 12,
                    crossAxisSpacing: 12,
                    childAspectRatio: 0.78,
                  ),
                  itemBuilder: (_, i) {
                    final p = value.relatedList[i];
                    return GestureDetector(
                      onTap: () => value.getProducts(p.id as int),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: EliteNetworkImage(
                              url: '${Environments.imageURL}${p.cover}',
                              width: double.infinity,
                              radius: BorderRadius.circular(10),
                            ),
                          ),
                          const SizedBox(height: 6),
                          Text(p.name ?? '',
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: ThemeProvider.serif(size: 13)),
                          Text(
                            elitePrice(value.currencySide,
                                value.currencySymbol, p.sellPrice),
                            style: ThemeProvider.sans(
                                size: 12, color: ThemeProvider.gold),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ],
            ],
          ),
        ),
        Expanded(
          flex: 4,
          child: ListView(
            padding: const EdgeInsets.fromLTRB(8, 8, 24, 32),
            children: [
              ..._buyInfo(value),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: value.productsList.quantity == 0
                    ? (value.hasVariantOptions && value.displayStock <= 0
                        ? null
                        : value.addToCart)
                    : value.onCheckout,
                style: ElevatedButton.styleFrom(
                  backgroundColor: ThemeProvider.gold,
                  foregroundColor: Colors.black,
                  minimumSize: const Size.fromHeight(52),
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
            ],
          ),
        ),
      ],
    );
  }

  List<Widget> _buyInfo(ProductsDetailsController value) {
    return [
      Text(
        (value.cateInfo.name ?? 'ADVANCED SKIN ALCHEMY').toUpperCase(),
        style: ThemeProvider.serif(
          size: 12,
          color: ThemeProvider.gold,
          letterSpacing: 1.4,
        ),
      ),
      const SizedBox(height: 4),
      Text(value.productsList.name ?? '',
          maxLines: 3,
          overflow: TextOverflow.ellipsis,
          style: ThemeProvider.serif(size: 28, weight: FontWeight.w700)),
      Wrap(
        crossAxisAlignment: WrapCrossAlignment.end,
        spacing: 10,
        children: [
          Text(
            elitePrice(
              value.currencySide,
              value.currencySymbol,
              value.displayPrice,
            ),
            style: ThemeProvider.price(
                size: 26, color: ThemeProvider.gold, weight: FontWeight.w700),
          ),
          if (value.displayMrp != null)
            Text(
              elitePrice(
                value.currencySide,
                value.currencySymbol,
                value.displayMrp,
              ),
              style: ThemeProvider.price(
                size: 14,
                color: ThemeProvider.greyColor,
              ).copyWith(decoration: TextDecoration.lineThrough),
            ),
        ],
      ),
      Padding(
        padding: const EdgeInsets.only(top: 4),
        child: Text(
          value.displayStock <= 0
              ? 'Out of stock'.tr
              : (value.displayStock <= 5
                  ? 'Only ${value.displayStock} left'.tr
                  : 'In stock'.tr),
          style: ThemeProvider.sans(
            size: 12,
            color: value.displayStock <= 0
                ? Colors.redAccent
                : (value.displayStock <= 5
                    ? Colors.orangeAccent
                    : const Color(0xFF7DCEA0)),
          ),
        ),
      ),
      if (value.paymentSummary.isNotEmpty || value.returnSummary.isNotEmpty) ...[
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          runSpacing: 6,
          children: [
            if (value.paymentSummary.isNotEmpty)
              _metaChip(Icons.payments_outlined, value.paymentSummary),
            if (value.returnSummary.isNotEmpty)
              _metaChip(
                  Icons.assignment_return_outlined, value.returnSummary),
          ],
        ),
      ],
      if (value.hasVariantOptions) ...[
        const SizedBox(height: 14),
        _variantPicker(value),
      ] else if (value.hasSimpleOptions) ...[
        const SizedBox(height: 14),
        _simpleOptions(value),
      ],
      const SizedBox(height: 14),
      Text('QUANTITY'.tr,
          style: ThemeProvider.sans(
            size: 10,
            color: ThemeProvider.greyColor,
            letterSpacing: 1.2,
          )),
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
      if (value.soldByInfo.displayName.isNotEmpty) ...[
        const SizedBox(height: 12),
        GestureDetector(
          onTap: value.openSellerStore,
          child: Row(
            children: [
              Text('Sold by '.tr,
                  style: ThemeProvider.sans(
                      size: 12, color: ThemeProvider.greyColor)),
              Flexible(
                child: Text(
                  value.soldByInfo.displayName,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: ThemeProvider.sans(
                    size: 12,
                    weight: FontWeight.w700,
                    color: ThemeProvider.gold,
                  ),
                ),
              ),
              const Icon(Icons.chevron_right,
                  size: 16, color: ThemeProvider.gold),
            ],
          ),
        ),
      ],
      const SizedBox(height: 12),
      Text(
        value.productsList.descriptions ?? '',
        style: ThemeProvider.sans(size: 13, color: Colors.white70)
            .copyWith(height: 1.5),
      ),
    ];
  }

  Widget _hero(ProductsDetailsController value, {bool tall = false}) {
    final images = value.productsList.images ?? [];
    final cover = images.isNotEmpty
        ? images[value.selectedImageIndex.clamp(0, images.length - 1)]
        : (value.productsList.cover ?? '');
    return Column(
      children: [
        EliteCard(
          padding: EdgeInsets.zero,
          child: Stack(
            children: [
              EliteNetworkImage(
                url: Environments.mediaUrl(cover),
                height: tall ? 420 : 280,
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
        ),
        if (images.length > 1) ...[
          const SizedBox(height: 10),
          SizedBox(
            height: 64,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: images.length,
              separatorBuilder: (_, __) => const SizedBox(width: 8),
              itemBuilder: (_, i) {
                final on = value.selectedImageIndex == i;
                return GestureDetector(
                  onTap: () => value.selectImage(i),
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(
                        color: on ? ThemeProvider.gold : Colors.transparent,
                        width: 1.4,
                      ),
                    ),
                    child: EliteNetworkImage(
                      url: Environments.mediaUrl(images[i]),
                      width: 64,
                      height: 64,
                      radius: BorderRadius.circular(9),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ],
    );
  }

  Widget _simpleOptions(ProductsDetailsController value) {
    final color = (value.productsList.color ?? '').trim();
    final size = (value.productsList.measurement ?? '').trim();
    final label = [
      if (size.isNotEmpty) size,
      if (color.isNotEmpty) color,
    ].join(' · ');
    return EliteCard(
      margin: EdgeInsets.zero,
      padding: const EdgeInsets.fromLTRB(14, 12, 14, 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            'SELECT VARIANT'.tr,
            style: ThemeProvider.sans(
              size: 10,
              color: ThemeProvider.greyColor,
              letterSpacing: 1.2,
              weight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 12),
          _variantOptionTile(
            value: value,
            label: label.isEmpty ? (value.productsList.name ?? 'Default') : label,
            colorName: color,
            price: value.displayPrice,
            mrp: value.displayMrp,
            stock: value.displayStock,
            selected: true,
            onTap: null,
          ),
        ],
      ),
    );
  }

  Widget _variantPicker(ProductsDetailsController value) {
    final variants = value.productsList.variants;

    return EliteCard(
      margin: EdgeInsets.zero,
      padding: const EdgeInsets.fromLTRB(14, 12, 14, 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              Text(
                'SELECT VARIANT'.tr,
                style: ThemeProvider.sans(
                  size: 10,
                  color: ThemeProvider.greyColor,
                  letterSpacing: 1.2,
                  weight: FontWeight.w700,
                ),
              ),
              const Spacer(),
              if (value.selectedOptionLabel.isNotEmpty)
                Flexible(
                  child: Text(
                    value.selectedOptionLabel,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.end,
                    style: ThemeProvider.sans(
                      size: 11,
                      weight: FontWeight.w600,
                      color: ThemeProvider.gold,
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 12),
          if (value.hasBaseOption)
            _variantOptionTile(
              value: value,
              label: value.baseOptionLabel,
              colorName: (value.baseProductColor),
              price: value.baseOptionPrice,
              mrp: value.baseProductMrp,
              stock: value.baseOptionStock,
              selected: value.isBaseSelected,
              onTap: value.selectBaseProduct,
            ),
          ...List.generate(variants.length, (i) {
            final v = variants[i];
            final stock =
                int.tryParse('${v['in_stock'] ?? v['stock'] ?? 0}') ?? 0;
            final status = int.tryParse('${v['status'] ?? 1}') ?? 1;
            final disabled = status == 0 || stock <= 0;
            final price = double.tryParse('${v['customer_pays'] ?? ''}') ??
                double.tryParse('${v['sell_price'] ?? ''}') ??
                double.tryParse('${v['original_price'] ?? ''}') ??
                0;
            final mrp = double.tryParse('${v['original_price'] ?? ''}');
            return Padding(
              padding: EdgeInsets.only(
                  top: (value.hasBaseOption || i > 0) ? 8 : 0),
              child: _variantOptionTile(
                value: value,
                label: _variantChipLabel(v),
                colorName: (v['color'] ?? '').toString(),
                price: price,
                mrp: (mrp != null && mrp > price) ? mrp : null,
                stock: stock,
                selected: value.selectedVariantIndex == i,
                disabled: disabled,
                onTap: disabled ? null : () => value.selectVariant(i),
              ),
            );
          }),
        ],
      ),
    );
  }

  Widget _variantOptionTile({
    required ProductsDetailsController value,
    required String label,
    required String colorName,
    required double price,
    double? mrp,
    required int stock,
    required bool selected,
    bool disabled = false,
    VoidCallback? onTap,
  }) {
    final swatch = _colorFromName(colorName);
    return Opacity(
      opacity: disabled ? 0.45 : 1,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(12),
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
            decoration: BoxDecoration(
              color: selected
                  ? ThemeProvider.gold.withValues(alpha: 0.16)
                  : ThemeProvider.backgroundColor,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: selected
                    ? ThemeProvider.gold
                    : ThemeProvider.gold.withValues(alpha: 0.35),
                width: selected ? 1.4 : 0.8,
              ),
            ),
            child: Row(
              children: [
                Icon(
                  selected
                      ? Icons.check_circle
                      : Icons.radio_button_unchecked,
                  size: 22,
                  color: selected
                      ? ThemeProvider.gold
                      : ThemeProvider.greyColor,
                ),
                const SizedBox(width: 10),
                if (swatch != null) ...[
                  Container(
                    width: 16,
                    height: 16,
                    decoration: BoxDecoration(
                      color: swatch,
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.white24),
                    ),
                  ),
                  const SizedBox(width: 10),
                ],
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        label,
                        style: ThemeProvider.sans(
                          size: 13,
                          weight: FontWeight.w700,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        stock <= 0
                            ? 'Out of stock'.tr
                            : (stock <= 5
                                ? 'Only $stock left'.tr
                                : 'In stock'.tr),
                        style: ThemeProvider.sans(
                          size: 11,
                          color: stock <= 0
                              ? Colors.redAccent
                              : ThemeProvider.greyColor,
                        ),
                      ),
                    ],
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      elitePrice(
                          value.currencySide, value.currencySymbol, price),
                      style: ThemeProvider.price(
                        size: 14,
                        weight: FontWeight.w700,
                        color: ThemeProvider.gold,
                      ),
                    ),
                    if (mrp != null)
                      Text(
                        elitePrice(
                            value.currencySide, value.currencySymbol, mrp),
                        style: ThemeProvider.price(
                          size: 11,
                          color: ThemeProvider.greyColor,
                        ).copyWith(decoration: TextDecoration.lineThrough),
                      ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _metaChip(IconData icon, String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: ThemeProvider.surface,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: ThemeProvider.gold.withValues(alpha: 0.35)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: ThemeProvider.gold),
          const SizedBox(width: 6),
          Text(
            label,
            style: ThemeProvider.sans(
              size: 11,
              weight: FontWeight.w600,
              color: ThemeProvider.gold,
            ),
          ),
        ],
      ),
    );
  }

  String _variantChipLabel(Map<String, dynamic> v) {
    final size = (v['measurement'] ?? '').toString().trim();
    final color = (v['color'] ?? '').toString().trim();
    final name = (v['name'] ?? '').toString().trim();
    if (size.isNotEmpty && color.isNotEmpty) return '$size · $color';
    if (size.isNotEmpty) return size;
    if (color.isNotEmpty && name.isNotEmpty && name.toLowerCase() != color.toLowerCase()) {
      return '$name · $color';
    }
    if (color.isNotEmpty) return color;
    if (name.isNotEmpty) return name;
    return 'Option';
  }

  Color? _colorFromName(String name) {
    const map = <String, Color>{
      'red': Color(0xFFE74C3C),
      'green': Color(0xFF27AE60),
      'blue': Color(0xFF3498DB),
      'black': Color(0xFF111111),
      'white': Color(0xFFF5F5F5),
      'yellow': Color(0xFFF1C40F),
      'orange': Color(0xFFE67E22),
      'pink': Color(0xFFE91E63),
      'purple': Color(0xFF9B59B6),
      'brown': Color(0xFF8D6E63),
      'grey': Color(0xFF9E9E9E),
      'gray': Color(0xFF9E9E9E),
      'gold': Color(0xFFD4AF37),
    };
    return map[name.trim().toLowerCase()];
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
