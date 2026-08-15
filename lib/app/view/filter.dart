import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:get/get.dart';
import 'package:salon_user/app/controller/unified_search_controller.dart';
import 'package:salon_user/app/helper/router.dart';
import 'package:salon_user/app/util/theme.dart';
import 'package:salon_user/app/view/widgets/elite_ui.dart';

class FilterScreen extends StatefulWidget {
  const FilterScreen({Key? key}) : super(key: key);

  @override
  State<FilterScreen> createState() => _FilterScreenState();
}

class _FilterScreenState extends State<FilterScreen> {
  void _apply(UnifiedSearchController controller) {
    controller.getSearchResult(controller.lastSearch);
    Get.back();
    if (Get.currentRoute != AppRouter.searchRoutes) {
      Get.toNamed(AppRouter.getSearchRoutes());
    }
  }

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
          appBar: AppBar(
            backgroundColor: ThemeProvider.backgroundColor,
            elevation: 0,
            automaticallyImplyLeading: false,
            titleSpacing: 16,
            title: Row(
              children: [
                GestureDetector(
                  onTap: () => Get.back(),
                  child: Text(
                    'Cancel'.tr,
                    style: ThemeProvider.sans(
                      size: 14,
                      color: ThemeProvider.gold,
                    ),
                  ),
                ),
                Expanded(
                  child: Text(
                    'Filters'.tr,
                    textAlign: TextAlign.center,
                    style: ThemeProvider.serif(
                      size: 22,
                      weight: FontWeight.w700,
                      color: ThemeProvider.gold,
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () => _apply(controller),
                  child: Text(
                    'Done'.tr,
                    style: ThemeProvider.sans(
                      size: 14,
                      weight: FontWeight.w600,
                      color: ThemeProvider.gold,
                    ),
                  ),
                ),
              ],
            ),
          ),
          body: ListView(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      'Categories'.tr,
                      style: ThemeProvider.serif(size: 18),
                    ),
                  ),
                  GestureDetector(
                    onTap: controller.clearFilters,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 7),
                      decoration: BoxDecoration(
                        color: const Color(0xFFE53935),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.close, size: 12, color: Colors.white),
                          const SizedBox(width: 4),
                          Text(
                            'Clear Filters'.tr,
                            style: ThemeProvider.sans(
                              size: 11,
                              weight: FontWeight.w600,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              if (controller.categoriesList.isEmpty)
                const EliteApiUnavailable()
              else
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: List.generate(
                    controller.categoriesList.length,
                    (i) => _chip(
                      label: controller.categoriesList[i].name ?? '',
                      selected: controller.isSelectedCat.length > i &&
                          controller.isSelectedCat[i],
                      onTap: () => controller.toggleChipCat(i),
                    ),
                  ),
                ),
              const SizedBox(height: 22),
              Text('Facilities'.tr, style: ThemeProvider.serif(size: 18)),
              const SizedBox(height: 12),
              if (controller.chipLabels.isEmpty)
                const EliteApiUnavailable()
              else
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: List.generate(
                    controller.chipLabels.length,
                    (i) => _chip(
                      label: controller.chipLabels[i].name ?? '',
                      selected: controller.isSelected.length > i &&
                          controller.isSelected[i],
                      onTap: () => controller.toggleChip(i),
                    ),
                  ),
                ),
              const SizedBox(height: 22),
              Text('Rating'.tr, style: ThemeProvider.serif(size: 18)),
              const SizedBox(height: 10),
              Obx(() {
                return Row(
                  children: [
                    RatingBar.builder(
                      initialRating: controller.starValue.value,
                      minRating: 1,
                      direction: Axis.horizontal,
                      allowHalfRating: true,
                      itemCount: 5,
                      itemSize: 28,
                      unratedColor: const Color(0xFF3A3A3A),
                      itemBuilder: (context, _) => const Icon(
                        Icons.star,
                        color: ThemeProvider.gold,
                      ),
                      onRatingUpdate: controller.updateRating,
                    ),
                    const SizedBox(width: 10),
                    Text(
                      '${controller.starValue.value} Star',
                      style: ThemeProvider.sans(
                        size: 13,
                        color: ThemeProvider.greyColor,
                      ),
                    ),
                  ],
                );
              }),
              const SizedBox(height: 22),
              Text('Type'.tr, style: ThemeProvider.serif(size: 18)),
              Obx(() {
                return Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    _typeChip(controller, Gender.male, 'Male'.tr),
                    _typeChip(controller, Gender.female, 'Female'.tr),
                    _typeChip(controller, Gender.kid, 'Kids'.tr),
                    _typeChip(controller, Gender.family, 'Family'.tr),
                  ],
                );
              }),
              const SizedBox(height: 22),
              Text('Distance Range'.tr, style: ThemeProvider.serif(size: 18)),
              Obx(() {
                return Column(
                  children: [
                    RangeSlider(
                      values: controller.currentRangeValues.value,
                      max: 200,
                      divisions: 50,
                      activeColor: ThemeProvider.gold,
                      inactiveColor: const Color(0xFF2A2A2A),
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
                    ),
                    Text(
                      '${controller.currentRangeValues.value.start.round()} - ${controller.currentRangeValues.value.end.round()} km',
                      style: ThemeProvider.sans(
                        size: 12,
                        color: ThemeProvider.greyColor,
                      ),
                    ),
                  ],
                );
              }),
              const SizedBox(height: 22),
              Text('Sort by'.tr, style: ThemeProvider.serif(size: 18)),
              const SizedBox(height: 10),
              Obx(() {
                return Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  decoration: BoxDecoration(
                    color: ThemeProvider.surface,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: const Color(0xFF2A2A2A)),
                  ),
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton<String>(
                      value: controller.selectedSortOption.value,
                      isExpanded: true,
                      dropdownColor: ThemeProvider.surface,
                      iconEnabledColor: ThemeProvider.gold,
                      style: ThemeProvider.sans(size: 14),
                      onChanged: controller.updateSortOption,
                      items: controller.sortingOptions
                          .map((value) => DropdownMenuItem<String>(
                                value: value,
                                child: Text(value),
                              ))
                          .toList(),
                    ),
                  ),
                );
              }),
              const SizedBox(height: 22),
              Text('Price Range'.tr, style: ThemeProvider.serif(size: 18)),
              Obx(() {
                return Column(
                  children: [
                    RangeSlider(
                      values: controller.currentRangeValuesPrice.value,
                      max: 70000,
                      divisions: 100,
                      activeColor: ThemeProvider.gold,
                      inactiveColor: const Color(0xFF2A2A2A),
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
                    ),
                    Text(
                      '${controller.currentRangeValuesPrice.value.start.round()} - ${controller.currentRangeValuesPrice.value.end.round()}',
                      style: ThemeProvider.sans(
                        size: 12,
                        color: ThemeProvider.greyColor,
                      ),
                    ),
                  ],
                );
              }),
            ],
          ),
          bottomNavigationBar: SafeArea(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 12),
              child: SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: () => _apply(controller),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: ThemeProvider.gold,
                    foregroundColor: Colors.black,
                    elevation: 0,
                  ),
                  child: Text(
                    'Done'.tr,
                    style: ThemeProvider.serif(
                      size: 18,
                      weight: FontWeight.w700,
                      color: Colors.black,
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _typeChip(
      UnifiedSearchController controller, Gender value, String label) {
    final selected = controller.selectedGender.value == value;
    return _chip(
      label: label,
      selected: selected,
      onTap: () => controller.updateGender(value),
    );
  }

  Widget _chip({
    required String label,
    required bool selected,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 9),
        decoration: BoxDecoration(
          color: selected ? ThemeProvider.gold : ThemeProvider.surface,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: selected ? ThemeProvider.gold : const Color(0xFF3A3A3A),
          ),
        ),
        child: Text(
          label,
          style: ThemeProvider.sans(
            size: 12,
            weight: FontWeight.w600,
            color: selected ? Colors.black : Colors.white,
          ),
        ),
      ),
    );
  }
}
