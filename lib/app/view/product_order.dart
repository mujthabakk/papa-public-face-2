import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jiffy/jiffy.dart';
import 'package:salon_user/app/backend/models/appointment_model.dart';
import 'package:salon_user/app/backend/models/product_salon_model.dart';
import 'package:salon_user/app/controller/add_review_controller.dart';
import 'package:salon_user/app/controller/booking_controller.dart';
import 'package:salon_user/app/controller/product_order_controller.dart';
import 'package:salon_user/app/env.dart';
import 'package:salon_user/app/helper/router.dart';
import 'package:salon_user/app/util/theme.dart';
import 'package:salon_user/app/view/widgets/elite_ui.dart';

class ProductOrderScreen extends StatefulWidget {
  const ProductOrderScreen({Key? key}) : super(key: key);

  @override
  State<ProductOrderScreen> createState() => _ProductOrderScreenState();
}

class _ProductOrderScreenState extends State<ProductOrderScreen> {
  int _tab = 0;

  String _fmt(String? raw) {
    if (raw == null || raw.isEmpty) return '';
    try {
      return Jiffy.parse(raw).format(pattern: 'MMM dd, yyyy');
    } catch (_) {
      return raw;
    }
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ProductOrderController>(
      builder: (c) {
        return Scaffold(
          backgroundColor: ThemeProvider.backgroundColor,
          appBar: EliteAppBar(
            showBack: true,
            title: 'My History',
            onMore: c.getProductById,
          ),
          body: !c.parser.haveLoggedIn()
              ? Center(
                  child: Text('Please log in to view history',
                      style: ThemeProvider.sans(size: 13, color: Colors.white70)),
                )
              : c.apiCalled == false
                  ? const Center(
                      child: CircularProgressIndicator(
                          color: ThemeProvider.gold),
                    )
                  : Column(
                      children: [
                        Container(
                          margin: const EdgeInsets.fromLTRB(16, 8, 16, 12),
                          padding: const EdgeInsets.all(4),
                          decoration: BoxDecoration(
                            color: ThemeProvider.surface,
                            borderRadius: BorderRadius.circular(24),
                          ),
                          child: Row(
                            children: [
                              _seg('Services', 0),
                              _seg('Products', 1),
                            ],
                          ),
                        ),
                        Expanded(
                          child: _tab == 0 ? _services() : _products(c),
                        ),
                      ],
                    ),
        );
      },
    );
  }

  Widget _seg(String label, int i) {
    final on = _tab == i;
    return Expanded(
      child: GestureDetector(
        onTap: () => setState(() => _tab = i),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 10),
          decoration: BoxDecoration(
            color: on ? ThemeProvider.gold : Colors.transparent,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Text(
            label,
            textAlign: TextAlign.center,
            style: ThemeProvider.sans(
              size: 13,
              weight: FontWeight.w600,
              color: on ? Colors.black : ThemeProvider.greyColor,
            ),
          ),
        ),
      ),
    );
  }

  Widget _services() {
    if (!Get.isRegistered<BookingController>()) {
      return Center(
        child: Text('Open Appointments to load service history',
            style: ThemeProvider.sans(size: 13, color: Colors.white70)),
      );
    }
    return GetBuilder<BookingController>(
      builder: (b) {
        final list = [...b.appointmentList, ...b.appointmentListOld];
        if (list.isEmpty) {
          return const EliteApiUnavailable(minHeight: 180);
        }
        return ListView.builder(
          padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
          itemCount: list.length,
          itemBuilder: (_, i) => _serviceCard(b, list[i]),
        );
      },
    );
  }

  Widget _serviceCard(BookingController b, AppointmentModel a) {
    final title = a.items?.services?.isNotEmpty == true
        ? a.items!.services!.first.name
        : (a.items?.packages?.isNotEmpty == true
            ? a.items!.packages!.first.name
            : a.salonInfo?.name);
    final cover = a.items?.services?.isNotEmpty == true
        ? a.items!.services!.first.cover
        : (a.salonInfo?.cover ?? a.ownerInfo?.cover);
    final provider = a.salonInfo?.name ??
        '${a.ownerInfo?.firstName ?? ''} ${a.ownerInfo?.lastName ?? ''}'.trim();
    final reviewed = a.status == 4;
    return EliteCard(
      padding: EdgeInsets.zero,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
            children: [
              EliteNetworkImage(
                url: '${Environments.imageURL}$cover',
                height: 140,
                width: double.infinity,
                radius:
                    const BorderRadius.vertical(top: Radius.circular(14)),
              ),
              Positioned(
                top: 10,
                right: 10,
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  color: reviewed ? ThemeProvider.gold : Colors.black54,
                  child: Text(
                    (b.statusName[a.status ?? 0]).toUpperCase(),
                    style: ThemeProvider.sans(
                      size: 9,
                      weight: FontWeight.w700,
                      color: reviewed ? Colors.black : Colors.white,
                    ),
                  ),
                ),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.all(14),
            child: Column(
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(title ?? 'Service',
                          style: ThemeProvider.serif(
                              size: 18, color: ThemeProvider.gold)),
                    ),
                    Text(
                      elitePrice(b.currencySide, b.currencySymbol, a.grandTotal,
                          digits: 0),
                      style: ThemeProvider.serif(
                          size: 18, color: ThemeProvider.gold),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                Row(
                  children: [
                    const Icon(Icons.calendar_today,
                        size: 12, color: ThemeProvider.greyColor),
                    Text(' ${_fmt(a.saveDate)}',
                        style: ThemeProvider.sans(
                            size: 12, color: ThemeProvider.greyColor)),
                    const Text('  •  ',
                        style: TextStyle(color: ThemeProvider.greyColor)),
                    const Icon(Icons.person_outline,
                        size: 12, color: ThemeProvider.greyColor),
                    Expanded(
                      child: Text(' $provider',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: ThemeProvider.sans(
                              size: 12, color: ThemeProvider.greyColor)),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    ...List.generate(
                      5,
                      (i) => Icon(
                        reviewed ? Icons.star : Icons.star_border,
                        size: 16,
                        color: reviewed
                            ? ThemeProvider.gold
                            : ThemeProvider.greyColor,
                      ),
                    ),
                    const Spacer(),
                    if (a.status == 4)
                      TextButton(
                        onPressed: () {
                          Get.delete<AddReviewController>(force: true);
                          Get.toNamed(AppRouter.getAddReviewsRoutes(),
                              arguments: [
                                'owner',
                                cover ?? '',
                                provider,
                                ((a.salonId ?? 0) != 0
                                        ? a.salonId
                                        : a.freelancerId)
                                    .toString(),
                              ]);
                        },
                        style: TextButton.styleFrom(
                          backgroundColor: ThemeProvider.gold,
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 6),
                        ),
                        child: Text('WRITE REVIEW',
                            style: ThemeProvider.sans(
                              size: 10,
                              weight: FontWeight.w700,
                              color: ThemeProvider.blackColor,
                            )),
                      )
                    else
                      Text('Reviewed',
                          style: ThemeProvider.sans(
                              size: 12, color: ThemeProvider.greyColor)),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _products(ProductOrderController c) {
    final list = [...c.productSalonList, ...c.productSalonListOld];
    if (list.isEmpty) {
      return const EliteApiUnavailable(minHeight: 180);
    }
    return ListView.builder(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
      itemCount: list.length,
      itemBuilder: (_, i) => _productCard(c, list[i]),
    );
  }

  Widget _productCard(ProductOrderController c, ProductSalonModel o) {
    final name = o.orders?.isNotEmpty == true
        ? o.orders!.first.name
        : 'Product Order';
    final cover = o.orders?.isNotEmpty == true ? o.orders!.first.cover : '';
    final done = o.status == 4;
    return GestureDetector(
      onTap: () => c.onProductDetail(o.id as int),
      child: EliteCard(
        padding: EdgeInsets.zero,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                EliteNetworkImage(
                  url: '${Environments.imageURL}$cover',
                  height: 140,
                  width: double.infinity,
                  radius:
                      const BorderRadius.vertical(top: Radius.circular(14)),
                ),
                Positioned(
                  top: 10,
                  right: 10,
                  child: Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    color: done ? ThemeProvider.gold : Colors.black54,
                    child: Text(
                      (c.statusName[o.status ?? 0]).toUpperCase(),
                      style: ThemeProvider.sans(
                        size: 9,
                        weight: FontWeight.w700,
                        color: done ? Colors.black : Colors.white,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(14),
              child: Row(
                children: [
                  Expanded(
                    child: Text(name ?? '',
                        style: ThemeProvider.serif(
                            size: 18, color: ThemeProvider.gold)),
                  ),
                  Text(
                    elitePrice(c.currencySide, c.currencySymbol, o.grandTotal,
                        digits: 2),
                    style: ThemeProvider.serif(
                        size: 18, color: ThemeProvider.gold),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
