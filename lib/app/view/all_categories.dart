import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:salon_user/app/controller/all_categories_controller.dart';
import 'package:salon_user/app/env.dart';
import 'package:salon_user/app/util/theme.dart';
import 'package:salon_user/app/view/widgets/elite_ui.dart';

class AllCategoriesScreen extends StatefulWidget {
  const AllCategoriesScreen({Key? key}) : super(key: key);

  @override
  State<AllCategoriesScreen> createState() => _AllCategoriesScreenState();
}

class _AllCategoriesScreenState extends State<AllCategoriesScreen> {
  static const _icons = [
    Icons.spa_outlined,
    Icons.self_improvement,
    Icons.brush_outlined,
    Icons.back_hand_outlined,
    Icons.water_drop_outlined,
    Icons.auto_awesome,
  ];

  IconData _icon(String? name, int i) {
    final n = (name ?? '').toLowerCase();
    if (n.contains('hair') || n.contains('skin')) return Icons.spa_outlined;
    if (n.contains('therap') || n.contains('massage')) {
      return Icons.self_improvement;
    }
    if (n.contains('tatto')) return Icons.brush_outlined;
    if (n.contains('nail')) return Icons.back_hand_outlined;
    if (n.contains('infus') || n.contains('iv')) {
      return Icons.water_drop_outlined;
    }
    return _icons[i % _icons.length];
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<AllCategoriesController>(
      builder: (value) {
        return Scaffold(
          backgroundColor: ThemeProvider.backgroundColor,
          appBar: EliteAppBar(
            showBack: true,
            title: 'Top Services',
            onMore: () {},
          ),
          body: value.apiCalled == false
              ? const Center(
                  child: CircularProgressIndicator(color: ThemeProvider.gold),
                )
              : value.categoriesList.isEmpty
                  ? Center(
                      child: Padding(
                        padding: const EdgeInsets.only(top: 80),
                        child: Text(
                          'No Categories'.tr,
                          style: ThemeProvider.serif(
                              size: 16, color: ThemeProvider.gold),
                        ),
                      ),
                    )
                  : ListView(
                  padding: const EdgeInsets.fromLTRB(16, 8, 16, 32),
                  children: [
                    Text(
                      'Top Services'.tr,
                      style: ThemeProvider.serif(
                        size: 32,
                        weight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 20),
                    ...value.categoriesList.asMap().entries.map((e) {
                      final item = e.value;
                      final featured = e.key == 0;
                      return featured
                          ? _featured(value, item, e.key)
                          : _card(value, item, e.key);
                    }),
                  ],
                ),
        );
      },
    );
  }

  Widget _featured(AllCategoriesController value, dynamic item, int i) {
    return GestureDetector(
      onTap: () =>
          value.onCategoriesList(item.id as int, item.name.toString()),
      child: Container(
        margin: const EdgeInsets.only(bottom: 14),
        height: 220,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(14),
        ),
        clipBehavior: Clip.antiAlias,
        child: Stack(
          fit: StackFit.expand,
          children: [
            EliteNetworkImage(
              url: '${Environments.imageURL}${item.cover}',
              fit: BoxFit.cover,
            ),
            Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Colors.transparent, Color(0xE60D0D0D)],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(_icon(item.name, i), color: ThemeProvider.gold),
                  const Spacer(),
                  Text(item.name ?? '',
                      style: ThemeProvider.serif(size: 24)),
                  if ((item.extraField ?? '').toString().isNotEmpty) ...[
                    const SizedBox(height: 6),
                    Text(
                      item.extraField.toString(),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: ThemeProvider.sans(size: 12, color: Colors.white70),
                    ),
                  ],
                  const SizedBox(height: 12),
                  EliteGoldButton(
                    label: 'VIEW TREATMENTS',
                    onTap: () => value.onCategoriesList(
                        item.id as int, item.name.toString()),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _card(AllCategoriesController value, dynamic item, int i) {
    return GestureDetector(
      onTap: () =>
          value.onCategoriesList(item.id as int, item.name.toString()),
      child: EliteCard(
        child: Stack(
          children: [
            Positioned(
              right: 0,
              top: 0,
              child: Icon(
                _icon(item.name, i),
                size: 72,
                color: ThemeProvider.gold.withValues(alpha: 0.08),
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 36,
                  height: 36,
                  decoration: BoxDecoration(
                    border: Border.all(color: ThemeProvider.gold),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(_icon(item.name, i),
                      color: ThemeProvider.gold, size: 18),
                ),
                const SizedBox(height: 12),
                Text(item.name ?? '', style: ThemeProvider.serif(size: 22)),
                if ((item.extraField ?? '').toString().isNotEmpty) ...[
                  const SizedBox(height: 6),
                  Text(
                    item.extraField.toString(),
                    style: ThemeProvider.sans(size: 13, color: Colors.white70)
                        .copyWith(height: 1.45),
                  ),
                ],
              ],
            ),
          ],
        ),
      ),
    );
  }
}
