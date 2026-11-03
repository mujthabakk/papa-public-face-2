import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:salon_user/app/controller/address_list_controller.dart';
import 'package:salon_user/app/helper/desktop.dart';
import 'package:salon_user/app/util/theme.dart';
import 'package:salon_user/app/view/widgets/elite_ui.dart';

class AddressListScreen extends StatefulWidget {
  const AddressListScreen({Key? key}) : super(key: key);

  @override
  State<AddressListScreen> createState() => _AddressListScreenState();
}

class _AddressListScreenState extends State<AddressListScreen> {
  @override
  Widget build(BuildContext context) {
    return GetBuilder<AddressListController>(
      builder: (value) {
        final desktop = Desktop.of(context);
        return Scaffold(
          backgroundColor: ThemeProvider.backgroundColor,
          appBar: desktop
              ? null
              : EliteAppBar(
                  showBack: true,
                  title: 'Select Address'.tr,
                  onMore: value.onNewAddress,
                ),
          body: value.apiCalled == false
              ? const Center(
                  child: CircularProgressIndicator(color: ThemeProvider.gold),
                )
              : desktop
                  ? WebInnerPage(
                      title: 'Select Address'.tr,
                      expandMain: true,
                      main: value.addressList.isEmpty
                          ? const EliteApiUnavailable(
                              minHeight: 180,
                              title: 'No saved addresses',
                              subtitle: 'Add an address to continue.',
                              icon: Icons.location_on_outlined,
                            )
                          : GridView.builder(
                              padding: EdgeInsets.zero,
                              itemCount: value.addressList.length,
                              gridDelegate:
                                  const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 2,
                                mainAxisSpacing: 12,
                                crossAxisSpacing: 12,
                                childAspectRatio: 2.4,
                              ),
                              itemBuilder: (context, i) {
                                final a = value.addressList[i];
                                final selected =
                                    value.selectedAddressId == a.id.toString();
                                return EliteCard(
                                  margin: EdgeInsets.zero,
                                  borderColor:
                                      selected ? ThemeProvider.gold : null,
                                  child: RadioListTile<String>(
                                    value: a.id.toString(),
                                    groupValue: value.selectedAddressId,
                                    activeColor: ThemeProvider.gold,
                                    onChanged: (data) =>
                                        value.saveAdd(data.toString()),
                                    title: Text(
                                      value.titles[a.title as int],
                                      style: ThemeProvider.serif(size: 16),
                                    ),
                                    subtitle: Text(
                                      '${a.address} ${a.house} ${a.landmark} ${a.pincode}',
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                      style: ThemeProvider.sans(
                                          size: 12,
                                          color: ThemeProvider.greyColor),
                                    ),
                                  ),
                                );
                              },
                            ),
                    )
              : value.addressList.isEmpty
                  ? const EliteApiUnavailable(
                      minHeight: 180,
                      title: 'No saved addresses',
                      subtitle: 'Add an address to continue.',
                      icon: Icons.location_on_outlined,
                    )
                  : ListView.builder(
                      padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
                      itemCount: value.addressList.length,
                      itemBuilder: (context, i) {
                        final a = value.addressList[i];
                        final selected =
                            value.selectedAddressId == a.id.toString();
                        return EliteCard(
                          borderColor: selected ? ThemeProvider.gold : null,
                          child: RadioListTile<String>(
                            value: a.id.toString(),
                            groupValue: value.selectedAddressId,
                            activeColor: ThemeProvider.gold,
                            onChanged: (data) =>
                                value.saveAdd(data.toString()),
                            title: Text(
                              value.titles[a.title as int],
                              style: ThemeProvider.serif(size: 16),
                            ),
                            subtitle: Text(
                              '${a.address} ${a.house} ${a.landmark} ${a.pincode}',
                              style: ThemeProvider.sans(
                                  size: 12, color: ThemeProvider.greyColor),
                            ),
                          ),
                        );
                      },
                    ),
          bottomNavigationBar: value.addressList.isEmpty
              ? const SizedBox()
              : SafeArea(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(16, 8, 16, 12),
                    child: Row(
                      children: [
                        Expanded(
                          child: EliteGoldButton(
                            label: 'SAVE'.tr,
                            onTap: value.saveAndClose,
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: EliteGoldButton(
                            label: 'CANCEL'.tr,
                            outlined: true,
                            onTap: () => Get.back(),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
        );
      },
    );
  }
}
