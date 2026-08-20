import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:salon_user/app/controller/unified_search_controller.dart';
import 'package:salon_user/app/env.dart';
import 'package:salon_user/app/helper/router.dart';
import 'package:salon_user/app/util/theme.dart';
import 'package:salon_user/app/view/widgets/elite_ui.dart';

class UnifiedSearchScreen extends StatefulWidget {
  const UnifiedSearchScreen({Key? key}) : super(key: key);

  @override
  State<UnifiedSearchScreen> createState() => _UnifiedSearchScreenState();
}

class _UnifiedSearchScreenState extends State<UnifiedSearchScreen> {

  String _imageUrl(String? path) {
    if (path == null || path.isEmpty) return '';
    if (path.startsWith('http://') || path.startsWith('https://')) return path;
    return '${Environments.imageURL}$path';
  }

  String _genderLabel(int? gender) {
    switch (gender) {
      case 0:
        return 'Kid';
      case 2:
        return 'Female';
      case 3:
        return 'Family';
      default:
        return 'Male';
    }
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<UnifiedSearchController>(
      builder: (value) {
        return GestureDetector(
          onTap: () => FocusScope.of(context).unfocus(),
          child: Scaffold(
            backgroundColor: ThemeProvider.backgroundColor,
            appBar: EliteAppBar(
              showBack: true,
              title: value.isCategoryMode
                  ? (value.selectedCateName.isEmpty
                      ? 'Hair & Skin'
                      : value.selectedCateName)
                  : null,
            ),
            body: value.isCategoryMode ? _category(value) : _search(value),
          ),
        );
      },
    );
  }

  Widget _search(UnifiedSearchController value) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
          child: SizedBox(
            height: 44,
            child: Stack(
              children: [
                Autocomplete<String>(
                  optionsBuilder: (TextEditingValue textEditingValue) async {
                    if (textEditingValue.text.trim().isEmpty) {
                      return const Iterable<String>.empty();
                    }
                    try {
                      return await value
                          .fetchAutoCompleteServices(textEditingValue.text);
                    } catch (_) {
                      return const Iterable<String>.empty();
                    }
                  },
                  onSelected: (String selection) {
                    value.setSearchValue(selection);
                    value.searchProducts(context, selection);
                    FocusScope.of(context).unfocus();
                  },
                  optionsViewBuilder: (context, onSelected, options) {
                    return Align(
                      alignment: Alignment.topLeft,
                      child: Material(
                        color: ThemeProvider.surface,
                        elevation: 6,
                        borderRadius: BorderRadius.circular(10),
                        child: ConstrainedBox(
                          constraints: const BoxConstraints(maxHeight: 220),
                          child: ListView.builder(
                            padding: EdgeInsets.zero,
                            shrinkWrap: true,
                            itemCount: options.length,
                            itemBuilder: (context, index) {
                              final option = options.elementAt(index);
                              return ListTile(
                                dense: true,
                                title: Text(option,
                                    style: ThemeProvider.sans(size: 13)),
                                onTap: () => onSelected(option),
                              );
                            },
                          ),
                        ),
                      ),
                    );
                  },
                  fieldViewBuilder:
                      (context, textController, focusNode, onFieldSubmitted) {
                    return TextField(
                      controller: textController,
                      focusNode: focusNode,
                      style: ThemeProvider.sans(size: 14),
                      textInputAction: TextInputAction.search,
                      onChanged: value.setSearchValue,
                      onSubmitted: (query) {
                        value.searchProducts(context, query);
                        onFieldSubmitted();
                      },
                      decoration: InputDecoration(
                        prefixIcon: const Icon(Icons.search,
                            color: ThemeProvider.gold, size: 18),
                        hintText: 'Search For Services...'.tr,
                        hintStyle: ThemeProvider.sans(
                            size: 13, color: ThemeProvider.greyColor),
                        filled: true,
                        fillColor: ThemeProvider.surface,
                        contentPadding: const EdgeInsets.only(
                            left: 10, right: 112, top: 0, bottom: 0),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide.none,
                        ),
                      ),
                    );
                  },
                ),
                Align(
                  alignment: Alignment.centerRight,
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        onPressed: () => value.genderDialog(context),
                        icon: const Icon(Icons.person,
                            color: ThemeProvider.gold, size: 20),
                      ),
                      IconButton(
                        onPressed: () =>
                            Get.toNamed(AppRouter.getFindLocationRoutes()),
                        icon: const Icon(Icons.location_on,
                            color: ThemeProvider.gold, size: 18),
                      ),
                      IconButton(
                        onPressed: value.onFilter,
                        icon: const Icon(Icons.manage_search,
                            color: ThemeProvider.gold, size: 20),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 4, 16, 10),
          child: Container(
            height: 44,
            padding: const EdgeInsets.all(4),
            decoration: BoxDecoration(
              color: ThemeProvider.surface,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: const Color(0xFF2A2A2A)),
            ),
            child: Row(
              children: [
                _modeButton(
                  label: 'Shops',
                  selected: value.tabID.value == 0,
                  onTap: () => value.updateTabID(0),
                ),
                const SizedBox(width: 4),
                _modeButton(
                  label: 'Freelancers',
                  selected: value.tabID.value == 1,
                  onTap: () => value.updateTabID(1),
                ),
              ],
            ),
          ),
        ),
        Expanded(
          child: value.isLoading
              ? const Center(
                  child: CircularProgressIndicator(color: ThemeProvider.gold),
                )
              : value.tabID.value == 0
                  ? _resultList(
                      banners: value.bannerList,
                      searched: value.hasSearched,
                      empty: value.isEmptySearchSalon || value.salonList.isEmpty,
                      children: value.salonList
                          .map((s) => _resultCard(
                                cover: s.cover,
                                title: s.serviceName ?? s.name ?? '',
                                subtitle: s.name ?? '',
                                address: s.address,
                                distance: s.distance,
                                duration: s.duration,
                                gender: s.gender,
                                rating: s.rating,
                                reviews: s.reviewCount ?? s.totalRating,
                                price: s.price,
                                offer: s.off,
                                discount: s.discount,
                                isPremium: s.isPremium == true,
                                onTap: () => value.onServices(s.uid ?? 0),
                              ))
                          .toList(),
                      onBanner: value.onBanner,
                    )
                  : _resultList(
                      banners: value.bannerList,
                      searched: value.hasSearched,
                      empty: value.isEmptySearchFreelancer ||
                          value.individualList.isEmpty,
                      children: value.individualList
                          .map((s) => _resultCard(
                                cover: s.cover,
                                title: s.serviceName ?? s.name ?? '',
                                subtitle: s.name ?? '',
                                address: s.address,
                                distance: s.distance,
                                duration: s.duration,
                                gender: s.gender,
                                rating: s.rating,
                                reviews: s.reviewCount ?? s.totalRating,
                                price: s.price,
                                offer: s.off,
                                discount: s.discount,
                                isPremium: s.isPremium == true,
                                onTap: () => value.onSpecialist(s.uid ?? 0),
                              ))
                          .toList(),
                      onBanner: value.onBanner,
                    ),
        ),
      ],
    );
  }

  Widget _modeButton({
    required String label,
    required bool selected,
    required VoidCallback onTap,
  }) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: selected ? ThemeProvider.gold : Colors.transparent,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Text(
            label,
            style: ThemeProvider.sans(
              size: 13,
              weight: FontWeight.w700,
              color: selected ? ThemeProvider.blackColor : Colors.white70,
            ),
          ),
        ),
      ),
    );
  }

  Widget _resultList({
    required List banners,
    required bool searched,
    required bool empty,
    required List<Widget> children,
    required void Function(String, String) onBanner,
  }) {
    return ListView(
      padding: const EdgeInsets.fromLTRB(12, 12, 12, 24),
      children: [
        if (banners.isNotEmpty) _searchBanners(banners, onBanner),
        if (!searched)
          const SizedBox.shrink()
        else if (empty)
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 40),
            child: Column(
              children: [
                Icon(Icons.search_off, size: 48, color: Colors.grey.shade500),
                const SizedBox(height: 12),
                Text(
                  'Result Not Found',
                  style: ThemeProvider.sans(
                      size: 16, weight: FontWeight.w600, color: Colors.white70),
                ),
              ],
            ),
          )
        else
          ...children,
      ],
    );
  }

  Widget _searchBanners(List banners, void Function(String, String) onBanner) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: CarouselSlider.builder(
        itemCount: banners.length,
        itemBuilder: (context, index, realIndex) {
          final item = banners[index];
          return GestureDetector(
            onTap: () => onBanner(item.value ?? '', '${item.type ?? 0}'),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: EliteNetworkImage(
                url: _imageUrl(item.cover),
                width: double.infinity,
                height: 140,
              ),
            ),
          );
        },
        options: CarouselOptions(
          height: 140,
          viewportFraction: 1,
          autoPlay: banners.length > 1,
        ),
      ),
    );
  }

  Widget _resultCard({
    required String? cover,
    required String title,
    required String subtitle,
    required String? address,
    required double? distance,
    required int? duration,
    required int? gender,
    required double? rating,
    required int? reviews,
    required double? price,
    required double? offer,
    required double? discount,
    required bool isPremium,
    required VoidCallback onTap,
  }) {
    final original = price ?? 0;
    final sell = (offer != null && offer > 0) ? offer : original;
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: ThemeProvider.surface,
          borderRadius: BorderRadius.circular(12),
          boxShadow: const [
            BoxShadow(
              color: Color(0x33000000),
              blurRadius: 8,
              offset: Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            EliteNetworkImage(
              url: _imageUrl(cover),
              width: 92,
              height: 128,
              radius: BorderRadius.circular(8),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: ThemeProvider.serif(size: 16)),
                  Text(subtitle,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: ThemeProvider.sans(
                          size: 12, color: ThemeProvider.gold)),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      const Icon(Icons.location_on,
                          size: 13, color: ThemeProvider.gold),
                      const SizedBox(width: 2),
                      Text(
                        '${(distance ?? 0).toStringAsFixed(1)} KM',
                        style: ThemeProvider.sans(
                            size: 11, color: ThemeProvider.greyColor),
                      ),
                      const SizedBox(width: 6),
                      Expanded(
                        child: Text(
                          address ?? '',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: ThemeProvider.sans(
                              size: 11, color: ThemeProvider.greyColor),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      const Icon(Icons.timer_outlined,
                          size: 13, color: Colors.white70),
                      Text(
                        ' ${duration ?? 0} min',
                        style: ThemeProvider.sans(
                            size: 11, color: Colors.white70),
                      ),
                      const SizedBox(width: 10),
                      const Icon(Icons.person_outline,
                          size: 13, color: Colors.white70),
                      Text(
                        ' ${_genderLabel(gender)}',
                        style: ThemeProvider.sans(
                            size: 11, color: Colors.white70),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      const Icon(Icons.star, color: ThemeProvider.gold, size: 14),
                      const SizedBox(width: 4),
                      Text(
                        '${(rating ?? 0).toStringAsFixed(1)}  ${reviews ?? 0} Reviews',
                        style: ThemeProvider.sans(
                            size: 11, color: ThemeProvider.greyColor),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      if (original > 0 && sell != original)
                        Text(
                          '₹ ${original.toStringAsFixed(2)}',
                          style: ThemeProvider.sans(
                            size: 12,
                            color: ThemeProvider.gold,
                          ).copyWith(decoration: TextDecoration.lineThrough),
                        ),
                      if (original > 0 && sell != original)
                        const SizedBox(width: 8),
                      if ((discount ?? 0) > 0)
                        Text(
                          '${discount!.toStringAsFixed(1)} % off',
                          style: ThemeProvider.sans(
                              size: 12, color: ThemeProvider.gold),
                        ),
                    ],
                  ),
                  Align(
                    alignment: Alignment.centerRight,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        if (sell > 0)
                          Text(
                            '₹ ${sell.toStringAsFixed(2)}',
                            style: ThemeProvider.sans(
                              size: 18,
                              weight: FontWeight.w700,
                              color: Colors.white,
                            ),
                          ),
                        Text(
                          'Free cancellation',
                          style: ThemeProvider.sans(
                              size: 10, color: ThemeProvider.greenColor),
                        ),
                        Text(
                          isPremium
                              ? 'No payment needed, Pay at shop'
                              : 'Pay at shop not available',
                          textAlign: TextAlign.right,
                          style: ThemeProvider.sans(
                            size: 10,
                            color: isPremium
                                ? ThemeProvider.greenColor
                                : ThemeProvider.redColor,
                          ),
                        ),
                      ],
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

  Widget _category(UnifiedSearchController value) {
    if (value.isLoading) {
      return const Center(
          child: CircularProgressIndicator(color: ThemeProvider.gold));
    }
    final hero = value.salonList.isNotEmpty
        ? value.salonList.first.cover
        : (value.individualList.isNotEmpty
            ? value.individualList.first.cover
            : '');
    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(14),
          child: Stack(
            children: [
              EliteNetworkImage(
                url: '${Environments.imageURL}$hero',
                height: 210,
                width: double.infinity,
              ),
              Container(
                height: 210,
                width: double.infinity,
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [Colors.transparent, Color(0xE60D0D0D)],
                  ),
                ),
                padding: const EdgeInsets.all(16),
                alignment: Alignment.bottomLeft,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'PREMIER CATEGORY',
                      style: ThemeProvider.sans(
                        size: 10,
                        color: ThemeProvider.gold,
                        letterSpacing: 1.4,
                      ),
                    ),
                    Text(
                      'The Art of Restoration',
                      style: ThemeProvider.serif(
                          size: 24, color: ThemeProvider.gold),
                    ),
                    Text(
                      'A curated alchemy of rare botanical extracts and artisanal techniques designed for the modern elite.',
                      style: ThemeProvider.sans(
                          size: 12, color: Colors.white70),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 18),
        Row(
          children: [
            Expanded(
              child: Text('Curated Treatments',
                  style: ThemeProvider.serif(size: 20)),
            ),
            Text(
              '${value.salonList.length} Services Available',
              style: ThemeProvider.sans(size: 11, color: ThemeProvider.gold),
            ),
          ],
        ),
        const SizedBox(height: 10),
        ...value.salonList.map((s) => _treatment(value, s)),
        if (value.salonList.length > 1) ...[
          const SizedBox(height: 8),
          Text('Shop Selection', style: ThemeProvider.serif(size: 20)),
          const SizedBox(height: 10),
          SizedBox(
            height: 88,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: value.salonList.take(6).length,
              separatorBuilder: (_, __) => const SizedBox(width: 10),
              itemBuilder: (_, i) {
                final s = value.salonList[i];
                return GestureDetector(
                  onTap: () => value.onServices(s.uid ?? 0),
                  child: EliteCard(
                    margin: EdgeInsets.zero,
                    child: SizedBox(
                      width: 130,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(s.name ?? '',
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: ThemeProvider.serif(size: 13)),
                          Text(
                            elitePrice('left', '₹', s.off ?? s.price),
                            style: ThemeProvider.sans(
                                size: 12, color: ThemeProvider.gold),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
        const SizedBox(height: 16),
        Text('Expert Freelancers', style: ThemeProvider.serif(size: 20)),
        const SizedBox(height: 10),
        ...value.individualList.map((s) => _expert(value, s)),
      ],
    );
  }

  Widget _treatment(UnifiedSearchController value, dynamic s) {
    return GestureDetector(
      onTap: () => value.onServices(s.uid ?? 0),
      child: EliteCard(
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(s.serviceName ?? s.name ?? '',
                      style: ThemeProvider.serif(size: 16)),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      const Icon(Icons.access_time,
                          size: 13, color: Colors.white70),
                      Text(' ${s.duration ?? 60} min',
                          style: ThemeProvider.sans(
                              size: 12, color: Colors.white70)),
                      const SizedBox(width: 8),
                      Text('·', style: ThemeProvider.sans(size: 12)),
                      const SizedBox(width: 8),
                      Text(
                        elitePrice('left', '₹', s.off ?? s.price),
                        style: ThemeProvider.sans(
                            size: 12, color: ThemeProvider.gold),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                border: Border.all(color: ThemeProvider.gold),
                borderRadius: BorderRadius.circular(6),
              ),
              child: const Icon(Icons.chevron_right,
                  color: ThemeProvider.gold, size: 18),
            ),
          ],
        ),
      ),
    );
  }

  Widget _expert(UnifiedSearchController value, dynamic s) {
    return GestureDetector(
      onTap: () => value.onSpecialist(s.uid ?? 0),
      child: EliteCard(
        child: Row(
          children: [
            EliteNetworkImage(
              url: '${Environments.imageURL}${s.cover}',
              width: 48,
              height: 48,
              radius: BorderRadius.circular(10),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(s.name ?? '', style: ThemeProvider.serif(size: 16)),
                  Text(
                    (s.serviceName ?? 'LEAD STYLIST').toUpperCase(),
                    style: ThemeProvider.sans(
                        size: 10, color: ThemeProvider.gold, letterSpacing: 1),
                  ),
                ],
              ),
            ),
            const Icon(Icons.verified, color: ThemeProvider.gold, size: 18),
          ],
        ),
      ),
    );
  }
}
