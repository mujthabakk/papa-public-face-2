import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:salon_user/app/backend/models/products_model.dart';
import 'package:salon_user/app/controller/categories_controller.dart';
import 'package:salon_user/app/env.dart';
import 'package:salon_user/app/util/theme.dart';
import 'package:salon_user/app/view/widgets/elite_ui.dart';

class SubcategoriesScreen extends StatefulWidget {
  const SubcategoriesScreen({Key? key}) : super(key: key);

  @override
  State<SubcategoriesScreen> createState() => _SubcategoriesScreenState();
}

class _SubcategoriesScreenState extends State<SubcategoriesScreen> {
  @override
  Widget build(BuildContext context) {
    final cateId = (Get.arguments is List && Get.arguments.isNotEmpty)
        ? Get.arguments[0].toString()
        : '';
    return GetBuilder<CategoriesController>(
      builder: (value) {
        ProductsModel? category;
        for (final item in value.productsList) {
          if (item.id.toString() == cateId) {
            category = item;
            break;
          }
        }
        final subs = category?.subCates ?? <SubCates>[];
        return Scaffold(
          backgroundColor: ThemeProvider.backgroundColor,
          appBar: EliteAppBar(
            showBack: true,
            title: category?.name ?? 'Subcategories',
          ),
          body: value.apiCalled == false
              ? const Center(
                  child: CircularProgressIndicator(color: ThemeProvider.gold),
                )
              : subs.isEmpty
                  ? const EliteApiUnavailable(minHeight: 180)
                  : ListView.builder(
                      padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
                      itemCount: subs.length,
                      itemBuilder: (context, index) {
                        final sub = subs[index];
                        return EliteCard(
                          child: ListTile(
                            contentPadding: EdgeInsets.zero,
                            leading: ClipRRect(
                              borderRadius: BorderRadius.circular(10),
                              child: SizedBox(
                                width: 52,
                                height: 52,
                                child: EliteNetworkImage(
                                  url:
                                      '${Environments.imageURL}${sub.cover}',
                                ),
                              ),
                            ),
                            title: Text(
                              sub.name ?? '',
                              style: ThemeProvider.serif(size: 16),
                            ),
                            trailing: const Icon(Icons.chevron_right,
                                color: ThemeProvider.gold),
                            onTap: () => value.onProducts(
                              int.tryParse(cateId) ?? 0,
                              sub.id ?? 0,
                            ),
                          ),
                        );
                      },
                    ),
        );
      },
    );
  }
}
