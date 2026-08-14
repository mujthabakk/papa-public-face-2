import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:salon_user/app/controller/products_controller.dart';
import 'package:salon_user/app/util/theme.dart';

class SortByScreen extends StatelessWidget {
  final ProductsController controller = Get.find<ProductsController>();

  final List<Map<String, dynamic>> sortOptions = [
    {'label': 'Customer Rating', 'value': 'rating'},
    {'label': 'Price: Low to High', 'value': 'low_to_high'},
    {'label': 'Price: High to Low', 'value': 'high_to_low'},
    {'label': 'Name: A to Z', 'value': 'a_to_z'},
    {'label': 'Name: Z to A', 'value': 'z_to_a'},
    {'label': 'Discount: High to Low', 'value': 'discount'},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ThemeProvider.backgroundColor,
      appBar: AppBar(
        title: Text('Sort By',
            style: ThemeProvider.serif(size: 20, color: ThemeProvider.gold)),
        backgroundColor: ThemeProvider.backgroundColor,
        iconTheme: const IconThemeData(color: ThemeProvider.gold),
      ),
      body: ListView.builder(
        itemCount: sortOptions.length,
        itemBuilder: (context, index) {
          return Obx(() => ListTile(
                title: Text(sortOptions[index]['label']),
                trailing:
                    controller.selectedSort.value == sortOptions[index]['value']
                        ? Icon(Icons.check, color: ThemeProvider.appColor)
                        : null,
                onTap: () {
                  controller.sortProducts(sortOptions[index]['value']);
                  Get.back(); // Close the sorting screen
                },
              ));
        },
      ),
    );
  }
}
