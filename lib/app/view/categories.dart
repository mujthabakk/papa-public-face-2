import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:salon_user/app/backend/models/products_model.dart';
import 'package:salon_user/app/controller/categories_controller.dart';
import 'package:salon_user/app/controller/product_cart_controller.dart';
import 'package:salon_user/app/env.dart';
import 'package:salon_user/app/util/theme.dart';

// class CategoriesScreen extends StatefulWidget {
//   const CategoriesScreen({Key? key}) : super(key: key);

//   @override
//   State<CategoriesScreen> createState() => _CategoriesScreenState();
// }

// class _CategoriesScreenState extends State<CategoriesScreen> {
//   @override
//   Widget build(BuildContext context) {
//     return GetBuilder<CategoriesController>(
//       builder: (value) {
//         return Scaffold(
//           backgroundColor: ThemeProvider.whiteColor,
//           appBar: AppBar(
//             backgroundColor: ThemeProvider.appColor,
//             elevation: 0,
//             iconTheme: const IconThemeData(color: ThemeProvider.whiteColor),
//             titleSpacing: 0,
//             automaticallyImplyLeading: false,
//             centerTitle: true,
//             title: Text(
//               'Categories'.tr,
//               style: ThemeProvider.titleStyle,
//             ),
//           ),
//           bottomNavigationBar: Get.find<ProductCartController>()
//                   .savedInCart
//                   .isNotEmpty
//               ? SizedBox(
//                   height: 50,
//                   child: Column(
//                     children: [
//                       SizedBox(
//                         height: 50,
//                         child: InkWell(
//                           onTap: () {
//                             value.onCart();
//                           },
//                           child: Container(
//                             padding: const EdgeInsets.symmetric(horizontal: 20),
//                             decoration: const BoxDecoration(
//                               color: ThemeProvider.appColor,
//                             ),
//                             child: Row(
//                               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                               children: [
//                                 Text(
//                                   value.currencySide == 'left'
//                                       ? '${Get.find<ProductCartController>().savedInCart.length} ${'Items'.tr} ${value.currencySymbol} ${Get.find<ProductCartController>().totalPrice}'
//                                       : ' ${Get.find<ProductCartController>().savedInCart.length} ${'Items'.tr} ${Get.find<ProductCartController>().totalPrice}${value.currencySymbol}',
//                                   style: const TextStyle(
//                                       color: ThemeProvider.whiteColor),
//                                 ),
//                                 Text(
//                                   'Payments'.tr,
//                                   style: const TextStyle(
//                                       color: ThemeProvider.whiteColor),
//                                 ),
//                               ],
//                             ),
//                           ),
//                         ),
//                       )
//                     ],
//                   ),
//                 )
//               : const SizedBox(),
//           body: value.apiCalled == false
//               ? SkeletonListView()
//               : value.productsList.isNotEmpty
//                   ? SingleChildScrollView(
//                       child: Padding(
//                         padding: const EdgeInsets.all(10.0),
//                         child: Column(
//                           children: [
//                             Column(
//                               children: List.generate(
//                                 value.productsList.length,
//                                 (index) => Column(
//                                   children: [
//                                     Stack(
//                                       alignment: Alignment.center,
//                                       children: [
//                                         Container(
//                                           height: 150,
//                                           width: double.infinity,
//                                           margin: const EdgeInsets.symmetric(
//                                               vertical: 5),
//                                           child: FadeInImage(
//                                             image: NetworkImage(
//                                                 '${Environments.imageURL}${value.productsList[index].cover.toString()}'),
//                                             placeholder: const AssetImage(
//                                                 "assets/images/placeholder.jpeg"),
//                                             imageErrorBuilder:
//                                                 (context, error, stackTrace) {
//                                               return Image.asset(
//                                                   'assets/images/notfound.png',
//                                                   fit: BoxFit.cover);
//                                             },
//                                             fit: BoxFit.cover,
//                                           ),
//                                         ),
//                                         Padding(
//                                           padding: const EdgeInsets.symmetric(
//                                               vertical: 5),
//                                           child: InkWell(
//                                             onTap: () {
//                                               value.onCategoryExpand(value
//                                                   .productsList[index].id
//                                                   .toString());
//                                             },
//                                             child: Container(
//                                               height: 150,
//                                               width: double.infinity,
//                                               decoration: BoxDecoration(
//                                                 color: ThemeProvider.blackColor
//                                                     .withOpacity(0.5),
//                                                 borderRadius:
//                                                     BorderRadius.circular(5),
//                                               ),
//                                               child: Center(
//                                                 child: Row(
//                                                   mainAxisAlignment:
//                                                       MainAxisAlignment.center,
//                                                   children: [
//                                                     Text(
//                                                       value.productsList[index]
//                                                           .name
//                                                           .toString(),
//                                                       style: const TextStyle(
//                                                           color: ThemeProvider
//                                                               .whiteColor,
//                                                           fontSize: 17),
//                                                     ),
//                                                     Icon(
//                                                         value.selectedCategory ==
//                                                                 value
//                                                                     .productsList[
//                                                                         index]
//                                                                     .id
//                                                                     .toString()
//                                                             ? Icons
//                                                                 .keyboard_arrow_down
//                                                             : Icons
//                                                                 .keyboard_arrow_up,
//                                                         color: Colors.white),
//                                                   ],
//                                                 ),
//                                               ),
//                                             ),
//                                           ),
//                                         ),
//                                       ],
//                                     ),
//                                     value.selectedCategory ==
//                                             value.productsList[index].id
//                                                 .toString()
//                                         ? Column(
//                                             children: List.generate(
//                                               value.productsList[index]
//                                                   .subCates!.length,
//                                               (subIndex) => Column(
//                                                 children: [
//                                                   Container(
//                                                     decoration:
//                                                         const BoxDecoration(
//                                                       border: Border(
//                                                         bottom: BorderSide(
//                                                             color: ThemeProvider
//                                                                 .greyColor),
//                                                       ),
//                                                     ),
//                                                     child: ListTile(
//                                                       onTap: () {
//                                                         value.onProducts(
//                                                           value
//                                                               .productsList[
//                                                                   index]
//                                                               .id as int,
//                                                           value
//                                                               .productsList[
//                                                                   index]
//                                                               .subCates![
//                                                                   subIndex]
//                                                               .id as int,
//                                                         );
//                                                       },
//                                                       contentPadding:
//                                                           const EdgeInsets
//                                                               .symmetric(
//                                                               horizontal: 10),
//                                                       title: Text(
//                                                         value
//                                                             .productsList[index]
//                                                             .subCates![subIndex]
//                                                             .name
//                                                             .toString(),
//                                                       ),
//                                                     ),
//                                                   ),
//                                                 ],
//                                               ),
//                                             ),
//                                           )
//                                         : const SizedBox(),
//                                   ],
//                                 ),
//                               ),
//                             ),
//                           ],
//                         ),
//                       ),
//                     )
//                   : Column(
//                       crossAxisAlignment: CrossAxisAlignment.center,
//                       mainAxisAlignment: MainAxisAlignment.center,
//                       children: [
//                         const SizedBox(height: 20),
//                         SizedBox(
//                           height: 80,
//                           width: 80,
//                           child: Image.asset(
//                             "assets/images/no-data.png",
//                             fit: BoxFit.cover,
//                           ),
//                         ),
//                         const SizedBox(
//                           height: 30,
//                         ),
//                         Center(
//                           child: Text(
//                             'No Data Found!'.tr,
//                             style: const TextStyle(fontFamily: 'bold'),
//                           ),
//                         ),
//                       ],
//                     ),
//         );
//       },
//     );
//   }
// }

class CategoriesScreen extends StatelessWidget {
  const CategoriesScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
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
                              color: ThemeProvider.appColor,
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
                      padding: const EdgeInsets.all(10),
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 3,
                        crossAxisSpacing: 2,
                        mainAxisSpacing: 2,
                        childAspectRatio: 2.9 / 4,
                      ),
                      itemCount: controller.productsList.length,
                      itemBuilder: (context, index) {
                        final category = controller.productsList[index];

                        return InkWell(
                          onTap: () {
                            controller.onSubcategories(category.id as int);
                          },
                          child: Container(
                            height: 80,
                            width: 150,
                            margin: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(10),
                              boxShadow: const [
                                BoxShadow(
                                  color: ThemeProvider.greyColor,
                                  blurRadius: 5.0,
                                ),
                              ],
                            ),
                            child: Column(
                              children: [
                                Align(
                                  alignment: Alignment.topCenter,
                                  child: SizedBox(
                                    height: 80,
                                    width: double.infinity,
                                    child: ClipRRect(
                                      borderRadius: const BorderRadius.only(
                                        topLeft: Radius.circular(10),
                                        topRight: Radius.circular(10),
                                      ),
                                      child: Image.network(
                                        '${Environments.imageURL}${category.cover}',
                                        fit: BoxFit.cover,
                                        errorBuilder: (context, error,
                                                stackTrace) =>
                                            Image.asset(
                                                'assets/images/notfound.png'),
                                      ),
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 0, horizontal: 10),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      const SizedBox(
                                        height: 8,
                                      ),
                                      Text(
                                        category.name.toString(),
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                        textAlign: TextAlign.center,
                                        style: const TextStyle(
                                            fontSize: 12.5,
                                            color:
                                                Color.fromARGB(255, 87, 87, 87),
                                            fontWeight: FontWeight.w600),
                                      ),
                                    ],
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
              category.name!,
              style: ThemeProvider.titleStyle,
            ),
            centerTitle: true,
          ),
          body: controller.apiCalled
              ? subCategories.isNotEmpty
                  ? GridView.builder(
                      padding: const EdgeInsets.all(10),
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 3,
                        crossAxisSpacing: 2,
                        mainAxisSpacing: 2,
                        childAspectRatio: 3.0 / 4,
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
                            height: 80,
                            width: 150,
                            margin: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(10),
                              boxShadow: const [
                                BoxShadow(
                                  color: ThemeProvider.greyColor,
                                  blurRadius: 5.0,
                                ),
                              ],
                            ),
                            child: Column(
                              children: [
                                Align(
                                  alignment: Alignment.topCenter,
                                  child: SizedBox(
                                    height: 80,
                                    width: double.infinity,
                                    child: ClipRRect(
                                      borderRadius: const BorderRadius.only(
                                        topLeft: Radius.circular(10),
                                        topRight: Radius.circular(10),
                                      ),
                                      child: Image.network(
                                        '${Environments.imageURL}${subCategory.cover}',
                                        fit: BoxFit.cover,
                                        errorBuilder:
                                            (context, error, stackTrace) =>
                                                Image.asset(
                                          'assets/images/notfound.png',
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 0, horizontal: 10),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      const SizedBox(
                                        height: 8,
                                      ),
                                      Text(
                                        subCategory.name ?? '',
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                        textAlign: TextAlign.center,
                                        style: const TextStyle(
                                            fontSize: 12.5,
                                            color:
                                                Color.fromARGB(255, 87, 87, 87),
                                            fontWeight: FontWeight.w600),
                                      ),
                                    ],
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
