import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:salon_user/app/controller/address_list_controller.dart';
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
        return Scaffold(
          backgroundColor: ThemeProvider.backgroundColor,
          appBar: EliteAppBar(
            showBack: true,
            title: 'Select Address',
            onMore: value.onNewAddress,
          ),
          body: value.apiCalled == false
              ? const Center(
                  child: CircularProgressIndicator(color: ThemeProvider.gold),
                )
              : value.addressList.isEmpty
                  ? const EliteApiUnavailable(minHeight: 180)
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
                            label: 'SAVE',
                            onTap: value.saveAndClose,
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: EliteGoldButton(
                            label: 'CANCEL',
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
