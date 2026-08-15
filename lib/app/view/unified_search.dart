import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:salon_user/app/controller/unified_search_controller.dart';
import 'package:salon_user/app/env.dart';
import 'package:salon_user/app/util/theme.dart';
import 'package:salon_user/app/view/widgets/elite_ui.dart';

class UnifiedSearchScreen extends StatefulWidget {
  const UnifiedSearchScreen({Key? key}) : super(key: key);

  @override
  State<UnifiedSearchScreen> createState() => _UnifiedSearchScreenState();
}

class _UnifiedSearchScreenState extends State<UnifiedSearchScreen> {
  @override
  Widget build(BuildContext context) {
    return GetBuilder<UnifiedSearchController>(
      builder: (value) {
        return Scaffold(
          backgroundColor: ThemeProvider.backgroundColor,
          appBar: EliteAppBar(
            showBack: true,
            title: value.isCategoryMode
                ? (value.selectedCateName.isEmpty
                    ? 'Hair & Skin'
                    : value.selectedCateName)
                : 'Search',
            onMore: () {},
          ),
          body: value.isCategoryMode ? _category(value) : _search(value),
        );
      },
    );
  }

  Widget _search(UnifiedSearchController value) {
    return Column(
                          children: [
                            Padding(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
          child: Row(
                                    children: [
              Expanded(
                child: TextField(
                  controller: value.searchController,
                  style: ThemeProvider.sans(size: 14),
                  onSubmitted: value.getSearchResult,
                                            decoration: InputDecoration(
                    prefixIcon: const Icon(Icons.search,
                        color: ThemeProvider.gold, size: 18),
                    hintText: 'Search elite collections...',
                    hintStyle: ThemeProvider.sans(
                        size: 13, color: ThemeProvider.greyColor),
                                              filled: true,
                    fillColor: ThemeProvider.surface,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide.none,
                    ),
                                                ),
                                              ),
                                            ),
              const SizedBox(width: 8),
              GestureDetector(
                onTap: value.onFilter,
                child: Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    color: ThemeProvider.surface,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Icon(Icons.tune, color: ThemeProvider.gold),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
        Expanded(
          child: value.isLoading
              ? const Center(
                  child: CircularProgressIndicator(color: ThemeProvider.gold),
                )
              : ListView(
                  padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
                  children: [
                    if (value.salonList.isNotEmpty) ...[
                      const EliteSectionBar(title: 'Centers'),
                      ...value.salonList.map((s) => _salonTile(value, s)),
                    ],
                    if (value.individualList.isNotEmpty) ...[
                      const EliteSectionBar(title: 'Experts'),
                      ...value.individualList
                          .map((s) => _expertTile(value, s)),
                    ],
                    if (value.salonList.isEmpty &&
                        value.individualList.isEmpty)
                      const EliteApiUnavailable(),
                  ],
                ),
        ),
      ],
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
                  onTap: () => value.onServices(s.uid as int),
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
                            elitePrice('left', '\$', s.off ?? s.price),
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
      onTap: () => value.onServices(s.uid as int),
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
                        elitePrice('left', '\$', s.off ?? s.price),
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
      onTap: () => value.onSpecialist(s.uid as int),
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

  Widget _salonTile(UnifiedSearchController value, dynamic s) {
    return GestureDetector(
      onTap: () => value.onServices(s.uid as int),
      child: EliteCard(
      child: Row(
        children: [
            EliteNetworkImage(
              url: '${Environments.imageURL}${s.cover}',
              width: 64,
              height: 64,
              radius: BorderRadius.circular(10),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(s.name ?? '', style: ThemeProvider.serif(size: 16)),
                  Text(s.address ?? '',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: ThemeProvider.sans(
                          size: 11, color: ThemeProvider.greyColor)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _expertTile(UnifiedSearchController value, dynamic s) {
    return _expert(value, s);
  }
}
