import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:salon_user/app/backend/models/products_model.dart';
import 'package:salon_user/app/controller/categories_controller.dart';
import 'package:salon_user/app/controller/product_cart_controller.dart';
import 'package:salon_user/app/env.dart';
import 'package:salon_user/app/util/theme.dart';

class CategoriesScreen extends StatelessWidget {
  const CategoriesScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    // Calculate responsive values
    int crossAxisCount = screenWidth > 600 ? 4 : 3;
    double itemSpacing = screenWidth * 0.02;
    double cardPadding = screenWidth * 0.025;
    double imageHeightRatio = screenHeight > 800 ? 0.12 : 0.10;
    double fontSize = screenWidth > 600 ? 14 : 11;

    return GetBuilder<CategoriesController>(
      builder: (controller) {
        return Scaffold(
          appBar: AppBar(
            automaticallyImplyLeading: false,
            backgroundColor: ThemeProvider.appColor,
            title: Text('Categories'.tr, style: ThemeProvider.titleStyle),
            centerTitle: true,
          ),
          bottomNavigationBar: Get.find<ProductCartController>()
                  .savedInCart
                  .isNotEmpty
              ? SizedBox(
                  height: 50,
                  child: Column(
                    children: [
                      SizedBox(
                        height: 50,
                        child: InkWell(
                          onTap: () {
                            controller.onCart();
                          },
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 20),
                            decoration: const BoxDecoration(
                              color: ThemeProvider.pink,
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  controller.currencySide == 'left'
                                      ? '${Get.find<ProductCartController>().savedInCart.length} ${'Items'.tr} ${controller.currencySymbol} ${Get.find<ProductCartController>().totalPrice}'
                                      : ' ${Get.find<ProductCartController>().savedInCart.length} ${'Items'.tr} ${Get.find<ProductCartController>().totalPrice}${controller.currencySymbol}',
                                  style: const TextStyle(
                                      color: ThemeProvider.whiteColor),
                                ),
                                Text(
                                  'Goto Cart'.tr,
                                  style: const TextStyle(
                                      color: ThemeProvider.whiteColor),
                                ),
                              ],
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                )
              : const SizedBox(),
          body: controller.apiCalled == false
              ? const Center(child: CircularProgressIndicator())
              : controller.productsList.isNotEmpty
                  ? GridView.builder(
                      padding: EdgeInsets.all(cardPadding),
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: crossAxisCount,
                        crossAxisSpacing: itemSpacing,
                        mainAxisSpacing: itemSpacing,
                        childAspectRatio: 0.75,
                      ),
                      itemCount: controller.productsList.length,
                      itemBuilder: (context, index) {
                        final category = controller.productsList[index];

                        return InkWell(
                          onTap: () {
                            controller.onSubcategories(category.id as int);
                          },
                          child: Container(
                            margin: EdgeInsets.all(cardPadding * 0.5),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(12),
                              boxShadow: const [
                                BoxShadow(
                                  color: ThemeProvider.greyColor,
                                  blurRadius: 5.0,
                                  offset: Offset(0, 2),
                                ),
                              ],
                            ),
                            child: Column(
                              children: [
                                Expanded(
                                  flex: 7,
                                  child: ClipRRect(
                                    borderRadius: const BorderRadius.only(
                                      topLeft: Radius.circular(12),
                                      topRight: Radius.circular(12),
                                    ),
                                    child: Image.network(
                                      '${Environments.imageURL}${category.cover}',
                                      width: double.infinity,
                                      fit: BoxFit.cover,
                                      errorBuilder: (context, error, stackTrace) =>
                                          Image.asset(
                                        'assets/images/notfound.png',
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  ),
                                ),
                                Expanded(
                                  flex: 3,
                                  child: Padding(
                                    padding: EdgeInsets.symmetric(
                                      horizontal: cardPadding,
                                      vertical: cardPadding * 0.5,
                                    ),
                                    child: Center(
                                      child: Text(
                                        category.name.toString(),
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                          fontSize: fontSize,
                                          color: const Color.fromARGB(255, 87, 87, 87),
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    )
                  : Center(
                      child: Text('No Categories Found'.tr,
                          style: ThemeProvider.titleStyle),
                    ),
        );
      },
    );
  }
}

class SubcategoriesScreen extends StatelessWidget {
  const SubcategoriesScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final categoryId = Get.arguments[0]; // Pass the selected category ID
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    // Calculate responsive values
    int crossAxisCount = screenWidth > 600 ? 4 : 3;
    double itemSpacing = screenWidth * 0.02;
    double cardPadding = screenWidth * 0.025;
    double imageHeightRatio = screenHeight > 800 ? 0.12 : 0.10;
    double fontSize = screenWidth > 600 ? 14 : 11;

    return GetBuilder<CategoriesController>(
      builder: (controller) {
        // Find the category with the matching categoryId
        final category = controller.productsList.firstWhere(
          (element) => element.id.toString() == categoryId.toString(),
          orElse: () => ProductsModel(),
        );

        // Extract subcategories from the selected category
        final subCategories = category.subCates ?? [];

        return Scaffold(
          appBar: AppBar(
            backgroundColor: ThemeProvider.appColor,
            title: Text(
              category.name ?? 'Category',
              style: ThemeProvider.titleStyle,
            ),
            centerTitle: true,
          ),
          body: controller.apiCalled
              ? subCategories.isNotEmpty
                  ? GridView.builder(
                      padding: EdgeInsets.all(cardPadding),
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: crossAxisCount,
                        crossAxisSpacing: itemSpacing,
                        mainAxisSpacing: itemSpacing,
                        childAspectRatio: 0.75,
                      ),
                      itemCount: subCategories.length,
                      itemBuilder: (context, index) {
                        final subCategory = subCategories[index];

                        return InkWell(
                          onTap: () {
                            controller.onProducts(
                              categoryId as int,
                              subCategory.id as int,
                            );
                          },
                          child: Container(
                            margin: EdgeInsets.all(cardPadding * 0.5),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(12),
                              boxShadow: const [
                                BoxShadow(
                                  color: ThemeProvider.greyColor,
                                  blurRadius: 5.0,
                                  offset: Offset(0, 2),
                                ),
                              ],
                            ),
                            child: Column(
                              children: [
                                Expanded(
                                  flex: 7,
                                  child: ClipRRect(
                                    borderRadius: const BorderRadius.only(
                                      topLeft: Radius.circular(12),
                                      topRight: Radius.circular(12),
                                    ),
                                    child: Image.network(
                                      '${Environments.imageURL}${subCategory.cover}',
                                      width: double.infinity,
                                      fit: BoxFit.cover,
                                      errorBuilder: (context, error, stackTrace) =>
                                          Image.asset(
                                        'assets/images/notfound.png',
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  ),
                                ),
                                Expanded(
                                  flex: 3,
                                  child: Padding(
                                    padding: EdgeInsets.symmetric(
                                      horizontal: cardPadding,
                                      vertical: cardPadding * 0.5,
                                    ),
                                    child: Center(
                                      child: Text(
                                        subCategory.name ?? '',
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                          fontSize: fontSize,
                                          color: const Color.fromARGB(255, 87, 87, 87),
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    )
                  : Center(
                      child: Text(
                        'No Subcategories Found'.tr,
                        style: ThemeProvider.titleStyle,
                      ),
                    )
              : const Center(
                  child: CircularProgressIndicator(),
                ),
        );
      },
    );
  }
}
