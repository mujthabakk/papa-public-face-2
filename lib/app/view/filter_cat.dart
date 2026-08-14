import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:get/get.dart';
import 'package:salon_user/app/controller/unified_search_controller.dart';
import 'package:salon_user/app/util/theme.dart';

class FilterScreenCat extends StatefulWidget {
  const FilterScreenCat({Key? key}) : super(key: key);

  @override
  State<FilterScreenCat> createState() => _FilterScreenState();
}

class _FilterScreenState extends State<FilterScreenCat> {
  @override
  Widget build(BuildContext context) {
    return GetBuilder<UnifiedSearchController>(
      init: Get.isRegistered<UnifiedSearchController>()
          ? Get.find<UnifiedSearchController>()
          : UnifiedSearchController(parser: Get.find()),
      autoRemove: false,
      builder: (controller) {
      return Scaffold(
        backgroundColor: ThemeProvider.backgroundColor,
        body: CustomScrollView(
          slivers: [
            SliverAppBar(
              backgroundColor: ThemeProvider.appColor,
              floating: true,
              toolbarHeight: 70,
              pinned: true,
              snap: false,
              elevation: 0,
              iconTheme: const IconThemeData(color: ThemeProvider.whiteColor),
              automaticallyImplyLeading: false,
              title: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      InkWell(
                        onTap: () {
                          Get.back();
                        },
                        child: Text(
                          'Cancel'.tr,
                          style: const TextStyle(
                              fontSize: 15, color: ThemeProvider.whiteColor),
                        ),
                      ),
                      Text(
                        'Filters'.tr,
                        style: const TextStyle(
                            fontFamily: 'bold',
                            fontSize: 16,
                            color: ThemeProvider.whiteColor),
                      ),
                      InkWell(
                        onTap: () {
                          Get.back();
                          controller.getSearchResult(controller.lastSearch);
                        },
                        child: Text(
                          'Done'.tr,
                          style: const TextStyle(
                              fontSize: 15, color: ThemeProvider.whiteColor),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            SliverList(
              delegate: SliverChildListDelegate(
                [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            _buildTitle('Categories'.tr),
                            Align(
                              alignment: Alignment.topRight,
                              child: ElevatedButton.icon(
                                  style: const ButtonStyle(
                                      backgroundColor: MaterialStatePropertyAll(
                                          Color.fromARGB(236, 242, 10, 10))),
                                  onPressed: () {
                                    controller.clearFilters();
                                  },
                                  icon: const Icon(
                                    Icons.clear,
                                    size: 12,
                                  ),
                                  label: const Text(
                                    'Clear Filters',
                                    style: TextStyle(fontSize: 11),
                                  )),
                            ),
                          ],
                        ),
                        Wrap(
                          direction: Axis.horizontal,
                          spacing: 2.0,
                          runSpacing: 1.0,
                          children: List.generate(
                            controller.categoriesList.length,
                            (index) => Padding(
                              padding: const EdgeInsets.all(2),
                              child: _buildChipCat(controller, index),
                            ),
                          ),
                        ),
                        _buildTitle('Services'.tr),
                        Wrap(
                          direction: Axis.horizontal,
                          spacing: 2.0,
                          runSpacing: 1.0,
                          children: List.generate(
                            controller.chipLabels.length,
                            (index) => Padding(
                              padding: const EdgeInsets.all(2),
                              child: _buildChip(controller, index),
                            ),
                          ),
                        ),
                        _buildTitle('Rating'.tr),
                        Obx(() {
                          return Row(
                            children: [
                              RatingBar.builder(
                                initialRating: controller.starValue.value,
                                minRating: 1,
                                direction: Axis.horizontal,
                                allowHalfRating: true,
                                itemCount: 5,
                                itemSize: 30,
                                itemBuilder: (context, _) => const Icon(
                                  Icons.star,
                                  color: ThemeProvider.appColor,
                                  size: 30,
                                ),
                                onRatingUpdate: controller.updateRating,
                              ),
                              const SizedBox(width: 8),
                              Text(
                                '${controller.starValue.value} Star',
                                style: const TextStyle(
                                    color: ThemeProvider.greyColor,
                                    fontFamily: 'bold'),
                              ),
                            ],
                          );
                        }),
                        _buildTitle('Type'.tr),
                        Obx(() {
                          return Row(
                            children: [
                              Expanded(
                                child: ListTile(
                                  contentPadding: EdgeInsets.zero,
                                  title: Text(
                                    'Male'.tr,
                                    style: TextStyle(fontSize: 13),
                                  ),
                                  horizontalTitleGap: 2,
                                  leading: Radio<Gender>(
                                    value: Gender.male,
                                    activeColor: ThemeProvider.appColor,
                                    groupValue: controller.selectedGender.value,
                                    onChanged: controller.updateGender,
                                  ),
                                ),
                              ),
                              Expanded(
                                child: ListTile(
                                  contentPadding: EdgeInsets.zero,
                                  title: Text(
                                    'Female'.tr,
                                    style: TextStyle(fontSize: 13),
                                  ),
                                  horizontalTitleGap: 2,
                                  leading: Radio<Gender>(
                                    value: Gender.female,
                                    activeColor: ThemeProvider.appColor,
                                    groupValue: controller.selectedGender.value,
                                    onChanged: controller.updateGender,
                                  ),
                                ),
                              ),
                            ],
                          );
                        }),
                        Obx(() {
                          return Row(
                            children: [
                              Expanded(
                                child: ListTile(
                                  contentPadding: EdgeInsets.zero,
                                  title: Text(
                                    'Kids'.tr,
                                    style: TextStyle(fontSize: 13),
                                  ),
                                  horizontalTitleGap: 2,
                                  leading: Radio<Gender>(
                                    value: Gender.kid,
                                    activeColor: ThemeProvider.appColor,
                                    groupValue: controller.selectedGender.value,
                                    onChanged: controller.updateGender,
                                  ),
                                ),
                              ),
                              Expanded(
                                child: ListTile(
                                  contentPadding: EdgeInsets.zero,
                                  title: const Text(
                                    'Family',
                                    style: TextStyle(fontSize: 13),
                                  ),
                                  horizontalTitleGap: 2,
                                  leading: Radio<Gender>(
                                    value: Gender.family,
                                    activeColor: ThemeProvider.appColor,
                                    groupValue: controller.selectedGender.value,
                                    onChanged: controller.updateGender,
                                  ),
                                ),
                              ),
                            ],
                          );
                        }),
                        _buildTitle('Distance Range'.tr),
                        Obx(() {
                          return RangeSlider(
                            values: controller.currentRangeValues.value,
                            max: 200,
                            divisions: 50,
                            activeColor: ThemeProvider.appColor,
                            labels: RangeLabels(
                              controller.currentRangeValues.value.start
                                  .round()
                                  .toString(),
                              controller.currentRangeValues.value.end
                                  .round()
                                  .toString(),
                            ),
                            onChanged: (values) {
                              controller.currentRangeValues.value = values;
                            },
                          );
                        }),
                        _buildTitle('Sort by'.tr),
                        Obx(() {
                          return InputDecorator(
                            decoration: const InputDecoration(
                                border: OutlineInputBorder()),
                            child: DropdownButtonHideUnderline(
                              child: DropdownButton<String>(
                                value: controller.selectedSortOption.value,
                                isDense: true,
                                elevation: 16,
                                isExpanded: true,
                                onChanged: controller.updateSortOption,
                                items: controller.sortingOptions
                                    .map<DropdownMenuItem<String>>(
                                        (String value) {
                                  return DropdownMenuItem<String>(
                                    value: value,
                                    child: Text(value),
                                  );
                                }).toList(),
                              ),
                            ),
                          );
                        }),
                        _buildTitle('Price Range'.tr),
                        Obx(() {
                          return RangeSlider(
                            values: controller.currentRangeValuesPrice.value,
                            max: 70000,
                            divisions: 10000,
                            activeColor: ThemeProvider.appColor,
                            labels: RangeLabels(
                              controller.currentRangeValuesPrice.value.start
                                  .round()
                                  .toString(),
                              controller.currentRangeValuesPrice.value.end
                                  .round()
                                  .toString(),
                            ),
                            onChanged: (values) {
                              controller.currentRangeValuesPrice.value = values;
                            },
                          );
                        }),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      );
    });
  }

  Widget _buildTitle(String txt) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            txt,
            style: const TextStyle(fontSize: 14, fontFamily: 'bold'),
          ),
        ],
      ),
    );
  }

  Widget _buildChip(UnifiedSearchController controller, int index) {
    return ActionChip(
      elevation: 6.0,
      padding: const EdgeInsets.all(2.0),
      label: Text(
        controller.chipLabels[index].name.toString(),
        style: TextStyle(
            color: controller.isSelected[index] ? Colors.white : Colors.black),
      ),
      onPressed: () {
        controller.toggleChip(index);
      },
      backgroundColor:
          controller.isSelected[index] ? ThemeProvider.appColor : Colors.white,
      shape: const StadiumBorder(
        side: BorderSide(
          color: Colors.grey,
        ),
      ),
    );
  }

  Widget _buildChipCat(UnifiedSearchController controller, int index) {
    return ActionChip(
      elevation: 6.0,
      padding: const EdgeInsets.all(2.0),
      label: Text(
        controller.categoriesList[index].name.toString(),
        style: TextStyle(
            color:
                controller.isSelectedCat[index] ? Colors.white : Colors.black),
      ),
      onPressed: () {
        controller.toggleChipCat(index);
      },
      backgroundColor: controller.isSelectedCat[index]
          ? ThemeProvider.appColor
          : Colors.white,
      shape: const StadiumBorder(
        side: BorderSide(
          color: Colors.grey,
        ),
      ),
    );
  }
}
