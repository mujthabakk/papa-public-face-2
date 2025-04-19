import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:salon_user/app/controller/product_order_controller.dart';
import 'package:salon_user/app/env.dart';
import 'package:salon_user/app/util/theme.dart';
import 'package:skeletons/skeletons.dart';

class ProductOrderScreen extends StatefulWidget {
  const ProductOrderScreen({Key? key}) : super(key: key);

  @override
  State<ProductOrderScreen> createState() => _ProductOrderScreenState();
}

class _ProductOrderScreenState extends State<ProductOrderScreen> {
  @override
  Widget build(BuildContext context) {
    return GetBuilder<ProductOrderController>(builder: (controller) {
      return Scaffold(
        backgroundColor: Color.fromARGB(255, 225, 225, 225),
        appBar: AppBar(
          title: Text('Order History'.tr,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w600,
                color: Colors.white,
              )),
          centerTitle: true,
          flexibleSpace: Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [ThemeProvider.appColor, ThemeProvider.appColor],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
          ),
          bottom: controller.parser.haveLoggedIn() == true
              ? TabBar(
                  controller: controller.tabController,
                  indicatorColor: Colors.white,
                  indicatorWeight: 3,
                  labelStyle: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w500,
                  ),
                  tabs: [
                    Tab(text: 'New'.tr),
                    Tab(text: 'Old'.tr),
                  ],
                )
              : null,
        ),
        body: controller.apiCalled == false
            ? _buildShimmerLoader()
            : TabBarView(
                controller: controller.tabController,
                children: [
                  _buildOrderList(controller.productSalonList, 'New'),
                  _buildOrderList(controller.productSalonListOld, 'Old'),
                ],
              ),
      );
    });
  }

  Widget _buildOrderList(List<dynamic> orders, String type) {
    return orders.isEmpty
        ? _buildEmptyState(type)
        : ListView.separated(
            padding: const EdgeInsets.all(16),
            itemCount: orders.length,
            separatorBuilder: (_, __) => const SizedBox(height: 16),
            itemBuilder: (context, index) => _OrderCard(order: orders[index]),
          );
  }

  Widget _buildEmptyState(String type) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset('assets/images/empty-order.png', width: 150, height: 150),
          const SizedBox(height: 24),
          Text(
            type == 'New' ? 'No New Orders!'.tr : 'No Past Orders!'.tr,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: ThemeProvider.appColor,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Your orders will appear here'.tr,
            style: const TextStyle(color: ThemeProvider.greyColor),
          ),
        ],
      ),
    );
  }

  Widget _buildShimmerLoader() {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: 5,
      itemBuilder: (_, __) => Container(
        margin: const EdgeInsets.only(bottom: 16),
        child: SkeletonItem(
          child: Column(
            children: [
              SkeletonAvatar(
                style: SkeletonAvatarStyle(
                  width: double.infinity,
                  height: 160,
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              const SizedBox(height: 12),
              SkeletonParagraph(
                style: SkeletonParagraphStyle(
                  lines: 3,
                  spacing: 6,
                  lineStyle: SkeletonLineStyle(
                    height: 12,
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
              const SizedBox(height: 12),
              SkeletonParagraph(
                style: SkeletonParagraphStyle(
                  lines: 3,
                  spacing: 6,
                  lineStyle: SkeletonLineStyle(
                    height: 12,
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _OrderCard extends StatelessWidget {
  final dynamic order;

  const _OrderCard({required this.order});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<ProductOrderController>();
    final status = controller.statusName[order.status as int].tr;

    return InkWell(
      onTap: () {
        controller.onProductDetail(order.id as int);
      },
      child: Card(
        elevation: 2,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  _buildProviderImage(),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          order.type == 'salon'
                              ? order.salonInfo!.name.toString()
                              : '${order.freelancerInfo!.firstName} ${order.freelancerInfo!.lastName}',
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          '${order.address!.address} • ${order.address!.pincode}',
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontSize: 12,
                            color: ThemeProvider.greyColor,
                          ),
                        ),
                      ],
                    ),
                  ),
                  _buildStatusChip(status),
                ],
              ),
              const SizedBox(height: 16),
              ...order.orders!
                  .map<Widget>((item) => Padding(
                        padding: const EdgeInsets.symmetric(vertical: 4),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Flexible(
                              child: Text.rich(
                                TextSpan(
                                  children: [
                                    TextSpan(text: '${item.name} '),
                                    TextSpan(
                                      text: '× ${item.quantity}',
                                      style: const TextStyle(
                                          color: ThemeProvider.greyColor),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            Text(
                              controller.currencySide == 'left'
                                  ? '${controller.currencySymbol}${item.sellPrice}'
                                  : '${item.sellPrice}${controller.currencySymbol}',
                              style:
                                  const TextStyle(fontWeight: FontWeight.w500),
                            ),
                          ],
                        ),
                      ))
                  .toList(),
              const Divider(height: 32),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Grand Total:'.tr,
                      style: const TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 14,
                      )),
                  Text(
                    controller.currencySide == 'left'
                        ? '${controller.currencySymbol}${order.grandTotal}'
                        : '${order.grandTotal}${controller.currencySymbol}',
                    style: const TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 14,
                      color: ThemeProvider.appColor,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Order Date:'.tr,
                      style: const TextStyle(
                        fontSize: 12,
                        color: ThemeProvider.greyColor,
                      )),
                  Text(
                    order.createdAt.toString(),
                    style: const TextStyle(
                      fontSize: 12,
                      color: ThemeProvider.greyColor,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildProviderImage() {
    final controller = Get.find<ProductOrderController>();
    return ClipRRect(
      borderRadius: BorderRadius.circular(8),
      child: FadeInImage(
        image: NetworkImage(
          '${Environments.imageURL}${order.type == 'salon' ? order.salonInfo!.cover : order.freelancerInfo!.cover}',
        ),
        placeholder: const AssetImage("assets/images/placeholder.jpeg"),
        width: 50,
        height: 50,
        fit: BoxFit.cover,
        imageErrorBuilder: (_, __, ___) => Container(
          width: 50,
          height: 50,
          color: ThemeProvider.greyColor,
          child: const Icon(Icons.business, color: Colors.white),
        ),
      ),
    );
  }

  Widget _buildStatusChip(String status) {
    Color statusColor = ThemeProvider.appColor;
    if (status.toLowerCase() == 'completed') statusColor = Colors.green;
    if (status.toLowerCase() == 'cancelled') statusColor = Colors.red;

    return Chip(
      label: Text(status,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 12,
          )),
      backgroundColor: statusColor,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
    );
  }
}
