import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:salon_user/app/controller/categories_controller.dart';
import 'package:salon_user/app/controller/product_cart_controller.dart';
import 'package:salon_user/app/controller/unified_search_controller.dart';
import 'package:salon_user/app/env.dart';
import 'package:salon_user/app/helper/router.dart';
import 'package:salon_user/app/util/theme.dart';
import 'package:salon_user/app/view/sidemenu.dart';
import 'package:salon_user/app/view/widgets/elite_ui.dart';

class CategoriesScreen extends StatefulWidget {
  const CategoriesScreen({Key? key}) : super(key: key);

  @override
  State<CategoriesScreen> createState() => _CategoriesScreenState();
}

class _CategoriesScreenState extends State<CategoriesScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  void _openSearch() {
    Get.delete<UnifiedSearchController>(force: true);
    Get.toNamed(AppRouter.getSearchRoutes());
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<CategoriesController>(
      builder: (controller) {
        return Scaffold(
          key: _scaffoldKey,
          backgroundColor: ThemeProvider.backgroundColor,
          drawer: const SideMenuScreen(),
          body: controller.apiCalled == false
              ? const Center(
                  child: CircularProgressIndicator(color: ThemeProvider.gold),
                )
              : Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SafeArea(
                      bottom: false,
                      child: EliteAppBar(
                        onMenu: () => _scaffoldKey.currentState?.openDrawer(),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(16, 8, 16, 12),
                      child: Text(
                        'Categories'.tr,
                        style: ThemeProvider.serif(
                            size: 28, weight: FontWeight.w700),
                      ),
                    ),
                    EliteSearchBar(
                      hint: 'Search categories...'.tr,
                      onTap: _openSearch,
                    ),
                    const SizedBox(height: 8),
                    Expanded(
                      child: controller.productsList.isEmpty
                          ? const EliteApiUnavailable(minHeight: 180)
                          : ListView.builder(
                              padding: const EdgeInsets.only(bottom: 100),
                              itemCount: controller.productsList.length,
                              itemBuilder: (context, index) {
                                final category = controller.productsList[index];
                                return GestureDetector(
                                  onTap: () => controller
                                      .onSubcategories(category.id as int),
                                  child: Container(
                                    height: 160,
                                    margin: const EdgeInsets.fromLTRB(
                                        16, 0, 16, 12),
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(12),
                                      child: Stack(
                                        fit: StackFit.expand,
                                        children: [
                                          EliteNetworkImage(
                                            url:
                                                '${Environments.imageURL}${category.cover}',
                                          ),
                                          const DecoratedBox(
                                            decoration: BoxDecoration(
                                              gradient: LinearGradient(
                                                begin: Alignment.topCenter,
                                                end: Alignment.bottomCenter,
                                                colors: [
                                                  Colors.transparent,
                                                  Colors.black87,
                                                ],
                                              ),
                                            ),
                                          ),
                                          Positioned(
                                            left: 16,
                                            bottom: 16,
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  category.name ?? '',
                                                  style: ThemeProvider.serif(
                                                    size: 24,
                                                    weight: FontWeight.w700,
                                                  ),
                                                ),
                                                const SizedBox(height: 6),
                                                Container(
                                                  width: 36,
                                                  height: 3,
                                                  color: ThemeProvider.gold,
                                                ),
                                              ],
                                            ),
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
                ),
          bottomNavigationBar:
              Get.find<ProductCartController>().savedInCart.isNotEmpty
                  ? InkWell(
                      onTap: controller.onCart,
                      child: Container(
                        height: 50,
                        color: ThemeProvider.gold,
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              '${Get.find<ProductCartController>().savedInCart.length} ${'Items'.tr}',
                              style: ThemeProvider.sans(
                                size: 13,
                                weight: FontWeight.w600,
                                color: Colors.black,
                              ),
                            ),
                            Text(
                              'Goto Cart'.tr,
                              style: ThemeProvider.sans(
                                size: 13,
                                weight: FontWeight.w700,
                                color: Colors.black,
                              ),
                            ),
                          ],
                        ),
                      ),
                    )
                  : const SizedBox.shrink(),
        );
      },
    );
  }
}
