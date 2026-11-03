import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:salon_user/app/backend/api/handler.dart';
import 'package:salon_user/app/backend/models/cate_info_model.dart';
import 'package:salon_user/app/backend/models/products_list_model.dart';
import 'package:salon_user/app/backend/models/sold_by_model.dart';
import 'package:salon_user/app/backend/models/sub_cate_info_model.dart';
import 'package:salon_user/app/backend/parse/products_details_parse.dart';
import 'package:salon_user/app/controller/cart_controller.dart';
import 'package:salon_user/app/controller/home_controller.dart';
import 'package:salon_user/app/controller/product_cart_controller.dart';
import 'package:salon_user/app/controller/product_seller_controller.dart';
import 'package:salon_user/app/controller/products_controller.dart';
import 'package:salon_user/app/controller/top_products_controller.dart';
import 'package:salon_user/app/helper/router.dart';
import 'package:salon_user/app/util/constant.dart';
import 'package:salon_user/app/util/toast.dart';

class ProductsDetailsController extends GetxController implements GetxService {
  final ProductsDetailsParser parser;

  ProductsListModel _productsList = ProductsListModel();
  ProductsListModel get productsList => _productsList;

  CateInfoModel _cateInfo = CateInfoModel();
  CateInfoModel get cateInfo => _cateInfo;

  List<ProductsListModel> _relatedList = <ProductsListModel>[];
  List<ProductsListModel> get relatedList => _relatedList;

  SubCateInfoModel _subCateInfo = SubCateInfoModel();
  SubCateInfoModel get subCateInfo => _subCateInfo;

  SoldByModel _soldByInfo = SoldByModel();
  SoldByModel get soldByInfo => _soldByInfo;

  Map<String, dynamic> taxMeta = {};
  int selectedImageIndex = 0;
  int selectedVariantIndex = -1;
  String selectedColor = '';
  String selectedSize = '';

  /// Base product snapshot before a variant overrides price / media.
  ProductsListModel? _baseProduct;

  String currencySide = AppConstants.defaultCurrencySide;
  String currencySymbol = AppConstants.defaultCurrencySymbol;

  int selectedproductsId = 0;

  bool apiCalled = false;

  bool isOpen = false;

  ProductsDetailsController({required this.parser});

  bool get hasVariantOptions => _productsList.variants.isNotEmpty;

  /// Product-level color/size when catalog has no variant rows.
  bool get hasSimpleOptions {
    if (hasVariantOptions) return false;
    final c = (_baseProduct?.color ?? _productsList.color ?? '').trim();
    final m =
        (_baseProduct?.measurement ?? _productsList.measurement ?? '').trim();
    return c.isNotEmpty || m.isNotEmpty;
  }

  /// Base catalog row as its own selectable option (e.g. RED · 100 ml).
  bool get hasBaseOption {
    if (!hasVariantOptions || _baseProduct == null) return false;
    final baseColor = (_baseProduct!.color ?? '').trim();
    final baseSize = (_baseProduct!.measurement ?? '').trim();
    if (baseColor.isEmpty && baseSize.isEmpty) return false;
    // Hide base if it duplicates an existing variant.
    for (final v in _productsList.variants) {
      final sameColor = baseColor.isEmpty ||
          (v['color'] ?? '').toString().trim().toLowerCase() ==
              baseColor.toLowerCase();
      final sameSize = baseSize.isEmpty ||
          _variantSizeLabel(v).toLowerCase() == baseSize.toLowerCase();
      if (sameColor && sameSize) return false;
    }
    return true;
  }

  bool get isBaseSelected =>
      hasVariantOptions && selectedVariantIndex < 0 && hasBaseOption;

  String get baseOptionLabel {
    final base = _baseProduct;
    if (base == null) return 'Default'.tr;
    final color = (base.color ?? '').trim();
    final size = (base.measurement ?? '').trim();
    if (size.isNotEmpty && color.isNotEmpty) return '$size · $color';
    if (size.isNotEmpty) return size;
    if (color.isNotEmpty) return color;
    return (base.name ?? 'Default').tr;
  }

  String get baseProductColor => (_baseProduct?.color ?? '').trim();

  double get baseOptionPrice {
    final p = _baseProduct;
    if (p == null) return 0;
    if ((p.customerPays ?? 0) > 0) return p.customerPays!;
    if ((p.sellPrice ?? 0) > 0) return p.sellPrice!;
    return p.originalPrice ?? 0;
  }

  double? get baseProductMrp {
    final p = _baseProduct;
    if (p == null) return null;
    final pay = baseOptionPrice;
    if ((p.originalPrice ?? 0) > pay) return p.originalPrice;
    return null;
  }

  int get baseOptionStock => _baseProduct?.inStock ?? 0;

  List<String> get colorOptions {
    final seen = <String>{};
    final out = <String>[];
    void add(String c) {
      final t = c.trim();
      if (t.isEmpty) return;
      final key = t.toLowerCase();
      if (seen.contains(key)) return;
      seen.add(key);
      out.add(t);
    }

    if (hasBaseOption) add(_baseProduct?.color ?? '');
    for (final v in _productsList.variants) {
      add((v['color'] ?? '').toString());
    }
    return out;
  }

  List<String> get sizeOptions {
    final seen = <String>{};
    final out = <String>[];
    void add(String s) {
      final t = s.trim();
      if (t.isEmpty) return;
      final key = t.toLowerCase();
      if (seen.contains(key)) return;
      seen.add(key);
      out.add(t);
    }

    if (hasBaseOption) add(_baseProduct?.measurement ?? '');
    for (final v in _productsList.variants) {
      add(_variantSizeLabel(v));
    }
    return out;
  }

  Map<String, dynamic>? get selectedVariant {
    if (selectedVariantIndex < 0 ||
        selectedVariantIndex >= _productsList.variants.length) {
      return null;
    }
    return _productsList.variants[selectedVariantIndex];
  }

  String get selectedOptionLabel {
    if (selectedVariant != null) return _variantTitle(selectedVariant!);
    if (hasBaseOption) return baseOptionLabel;
    return '';
  }

  double get displayPrice {
    final p = _productsList;
    // PDF: prefer customer_pays, then sell_price / shop_price, else MRP.
    if ((p.customerPays ?? 0) > 0) return p.customerPays!;
    if ((p.sellPrice ?? 0) > 0) return p.sellPrice!;
    if ((p.shopPrice ?? 0) > 0) return p.shopPrice!;
    return p.originalPrice ?? 0;
  }

  double? get displayMrp {
    final p = _productsList;
    final pay = displayPrice;
    if ((p.originalPrice ?? 0) > pay) return p.originalPrice;
    return null;
  }

  int get displayStock {
    final v = selectedVariant;
    if (v != null) {
      return int.tryParse(
              '${v['in_stock'] ?? v['stock'] ?? v['stock_qty'] ?? 0}') ??
          0;
    }
    return _productsList.inStock ?? 0;
  }

  String get paymentSummary {
    final codes = _productsList.paymentMethodCodes;
    if (codes.isEmpty) return '';
    return codes
        .map((c) => c.toUpperCase() == 'COD' ? 'COD' : c.toUpperCase())
        .join(' · ');
  }

  String get returnSummary {
    final days = _productsList.returnDays ?? 0;
    final ok = (_productsList.returnable ?? 0) == 1 || days > 0;
    if (!ok) return '';
    if (days > 0) return '$days day return';
    return 'Returnable';
  }

  @override
  void onInit() {
    super.onInit();
    selectedproductsId = Get.arguments[0].toInt();
    update();
    debugPrint('products id ==> $selectedproductsId');
    getProducts(selectedproductsId);
    currencySide = parser.getCurrencySide();
    currencySymbol = parser.getCurrencySymbol();
  }

  void onRateExpand() {
    isOpen = !isOpen;
    update();
  }

  void selectImage(int index) {
    selectedImageIndex = index;
    update();
  }

  String _variantSizeLabel(Map<String, dynamic> v) {
    final m = (v['measurement'] ?? '').toString().trim();
    if (m.isNotEmpty) return m;
    final value = (v['measurement_value'] ?? '').toString().trim();
    final type = (v['measurement_type'] ?? '').toString().trim();
    if (value.isNotEmpty && type.isNotEmpty) return '$value $type';
    if (value.isNotEmpty) return value;
    final name = (v['name'] ?? v['title'] ?? v['sku'] ?? '').toString().trim();
    return name;
  }

  String _variantTitle(Map<String, dynamic> v) {
    final size = _variantSizeLabel(v);
    final color = (v['color'] ?? '').toString().trim();
    if (size.isNotEmpty && color.isNotEmpty) return '$size · $color';
    if (size.isNotEmpty) return size;
    if (color.isNotEmpty) return color;
    return (v['name'] ?? 'Option').toString();
  }

  void selectVariant(int index) {
    if (index < 0 || index >= _productsList.variants.length) return;
    final v = _productsList.variants[index];
    final stock = int.tryParse('${v['in_stock'] ?? v['stock'] ?? 0}') ?? 0;
    final status = int.tryParse('${v['status'] ?? 1}') ?? 1;
    if (status == 0 || stock <= 0) {
      showToast('Out of stock'.tr);
      return;
    }
    selectedVariantIndex = index;
    selectedColor = (v['color'] ?? '').toString().trim();
    selectedSize = _variantSizeLabel(v);
    _applyVariant(v);
    update();
  }

  /// Restore default catalog product (not a variant row).
  void selectBaseProduct() {
    final base = _baseProduct;
    if (base == null) return;
    if ((base.inStock ?? 0) <= 0) {
      showToast('Out of stock'.tr);
      return;
    }
    selectedVariantIndex = -1;
    selectedColor = (base.color ?? '').trim();
    selectedSize = (base.measurement ?? '').trim();
    _restoreBaseProduct();
    update();
  }

  void _restoreBaseProduct() {
    final base = _baseProduct;
    if (base == null) return;
    _productsList.variantId = null;
    _productsList.color = base.color;
    _productsList.measurement = base.measurement;
    _productsList.measurementType = base.measurementType;
    _productsList.measurementValue = base.measurementValue;
    _productsList.originalPrice = base.originalPrice;
    _productsList.sellPrice = base.sellPrice;
    _productsList.discount = base.discount;
    _productsList.customerPays = base.customerPays;
    _productsList.shopPrice = base.shopPrice;
    _productsList.inStock = base.inStock;
    _productsList.cover = base.cover;
    _productsList.images = List<String>.from(base.images ?? const []);
    selectedImageIndex = 0;
  }

  void selectColor(String color) {
    selectedColor = color;
    // Base product match?
    if (hasBaseOption) {
      final baseColor = (_baseProduct?.color ?? '').trim().toLowerCase();
      final baseSize = (_baseProduct?.measurement ?? '').trim();
      if (baseColor == color.toLowerCase()) {
        if (selectedSize.isEmpty ||
            selectedSize.toLowerCase() == baseSize.toLowerCase() ||
            !_sizeExistsInVariants(selectedSize)) {
          selectBaseProduct();
          return;
        }
      }
    }
    final match = _findVariantIndex(
      color: color,
      size: selectedSize.isNotEmpty ? selectedSize : null,
    );
    if (match >= 0) {
      selectVariant(match);
      return;
    }
    for (final s in sizeOptions) {
      final i = _findVariantIndex(color: color, size: s);
      if (i >= 0) {
        selectVariant(i);
        return;
      }
    }
    final any = _findVariantIndex(color: color);
    if (any >= 0) selectVariant(any);
    update();
  }

  void selectSize(String size) {
    selectedSize = size;
    if (hasBaseOption) {
      final baseSize = (_baseProduct?.measurement ?? '').trim().toLowerCase();
      final baseColor = (_baseProduct?.color ?? '').trim();
      if (baseSize == size.toLowerCase()) {
        if (selectedColor.isEmpty ||
            selectedColor.toLowerCase() == baseColor.toLowerCase() ||
            !_colorExistsInVariants(selectedColor)) {
          selectBaseProduct();
          return;
        }
      }
    }
    final match = _findVariantIndex(
      size: size,
      color: selectedColor.isNotEmpty ? selectedColor : null,
    );
    if (match >= 0) {
      selectVariant(match);
      return;
    }
    final any = _findVariantIndex(size: size);
    if (any >= 0) selectVariant(any);
    update();
  }

  bool _colorExistsInVariants(String color) {
    final key = color.toLowerCase();
    for (final v in _productsList.variants) {
      if ((v['color'] ?? '').toString().trim().toLowerCase() == key) {
        return true;
      }
    }
    return false;
  }

  bool _sizeExistsInVariants(String size) {
    final key = size.toLowerCase();
    for (final v in _productsList.variants) {
      if (_variantSizeLabel(v).toLowerCase() == key) return true;
    }
    return false;
  }

  int _findVariantIndex({String? color, String? size}) {
    for (var i = 0; i < _productsList.variants.length; i++) {
      final v = _productsList.variants[i];
      final status = int.tryParse('${v['status'] ?? 1}') ?? 1;
      final stock = int.tryParse('${v['in_stock'] ?? v['stock'] ?? 0}') ?? 0;
      if (status == 0) continue;
      if (color != null &&
          color.isNotEmpty &&
          (v['color'] ?? '').toString().trim().toLowerCase() !=
              color.toLowerCase()) {
        continue;
      }
      if (size != null &&
          size.isNotEmpty &&
          _variantSizeLabel(v).toLowerCase() != size.toLowerCase()) {
        continue;
      }
      if (stock <= 0) continue;
      return i;
    }
    // Allow out-of-stock match so UI can still highlight selection.
    for (var i = 0; i < _productsList.variants.length; i++) {
      final v = _productsList.variants[i];
      if (color != null &&
          color.isNotEmpty &&
          (v['color'] ?? '').toString().trim().toLowerCase() !=
              color.toLowerCase()) {
        continue;
      }
      if (size != null &&
          size.isNotEmpty &&
          _variantSizeLabel(v).toLowerCase() != size.toLowerCase()) {
        continue;
      }
      return i;
    }
    return -1;
  }

  void _applyVariant(Map<String, dynamic> v) {
    final base = _baseProduct;
    _productsList.variantId = int.tryParse('${v['id'] ?? ''}');
    _productsList.color = (v['color'] ?? '').toString();
    _productsList.measurement = _variantSizeLabel(v);
    _productsList.measurementType = (v['measurement_type'] ?? '').toString();
    _productsList.measurementValue = (v['measurement_value'] ?? '').toString();

    final op = double.tryParse('${v['original_price'] ?? ''}');
    final sp = double.tryParse('${v['sell_price'] ?? ''}');
    final disc = double.tryParse('${v['discount'] ?? ''}');
    final pays = double.tryParse('${v['customer_pays'] ?? ''}');
    if (op != null) _productsList.originalPrice = op;
    if (sp != null) _productsList.sellPrice = sp;
    if (disc != null) _productsList.discount = disc;
    if (pays != null && pays > 0) {
      _productsList.customerPays = pays;
    } else if (sp != null) {
      _productsList.customerPays = sp;
    }

    final stock = int.tryParse(
        '${v['in_stock'] ?? v['stock'] ?? v['stock_qty'] ?? ''}');
    if (stock != null) _productsList.inStock = stock;

    final cover = (v['cover'] ?? v['image'] ?? v['picture'] ?? '')
        .toString()
        .trim();
    if (cover.isNotEmpty) _productsList.cover = cover;

    final imgs = <String>[];
    if (cover.isNotEmpty) imgs.add(cover);
    imgs.addAll(
        _parseVariantMedia(v['images_list'] ?? v['gallery'] ?? v['images']));
    if (imgs.isEmpty && base != null) {
      imgs.addAll(base.images ?? []);
      if ((base.cover ?? '').isNotEmpty) imgs.insert(0, base.cover!);
    }
    if (imgs.isNotEmpty) {
      _productsList.images = imgs.toSet().toList();
      selectedImageIndex = 0;
    }
  }

  List<String> _parseVariantMedia(dynamic raw) {
    if (raw is! List) return const [];
    final out = <String>[];
    for (final item in raw) {
      if (item is String && item.trim().isNotEmpty) {
        out.add(item.trim());
      } else if (item is Map) {
        final u = (item['url'] ??
                item['image'] ??
                item['cover'] ??
                item['path'] ??
                '')
            .toString()
            .trim();
        if (u.isNotEmpty) out.add(u);
      }
    }
    return out;
  }

  void _autoSelectFirstVariant() {
    if (_productsList.variants.isEmpty) {
      selectedVariantIndex = -1;
      selectedColor = (_productsList.color ?? '').trim();
      selectedSize = (_productsList.measurement ?? '').trim();
      return;
    }
    // Prefer base catalog option when it is distinct & in stock,
    // so user can clearly switch between default and variants.
    if (hasBaseOption && baseOptionStock > 0) {
      selectBaseProduct();
      return;
    }
    var pick = -1;
    for (var i = 0; i < _productsList.variants.length; i++) {
      final v = _productsList.variants[i];
      final status = int.tryParse('${v['status'] ?? 1}') ?? 1;
      final stock = int.tryParse('${v['in_stock'] ?? v['stock'] ?? 0}') ?? 0;
      if (status != 0 && stock > 0) {
        pick = i;
        break;
      }
    }
    if (pick < 0) pick = 0;
    selectedVariantIndex = pick;
    final v = _productsList.variants[pick];
    selectedColor = (v['color'] ?? '').toString().trim();
    selectedSize = _variantSizeLabel(v);
    _applyVariant(v);
  }

  bool get mustPickVariant =>
      hasVariantOptions && selectedVariantIndex < 0 && !hasBaseOption;

  Future<void> getProducts(int selectedproductsIds) async {
    apiCalled = false;
    selectedproductsId = selectedproductsIds;
    selectedImageIndex = 0;
    selectedVariantIndex = -1;
    selectedColor = '';
    selectedSize = '';
    _baseProduct = null;
    update();

    final response =
        await parser.getProductsInfo({"id": selectedproductsIds});
    apiCalled = true;
    if (response.statusCode == 200) {
      final myMap = Map<String, dynamic>.from(response.body as Map);
      final body = myMap['data'];
      final cateInfo = myMap['cateInfo'];
      final subCateInfo = myMap['subCateInfo'];
      final soldBy = myMap['soldby'] ?? myMap['soldBy'] ?? myMap['seller'];
      final related = myMap['related'];
      taxMeta = myMap['tax'] is Map
          ? Map<String, dynamic>.from(myMap['tax'])
          : {};

      _relatedList = [];
      if (related is List) {
        for (final data in related) {
          if (data is! Map) continue;
          try {
            _relatedList.add(
                ProductsListModel.fromJson(Map<String, dynamic>.from(data)));
          } catch (_) {}
        }
      }

      if (body is Map) {
        _productsList =
            ProductsListModel.fromJson(Map<String, dynamic>.from(body));
      } else {
        _productsList = ProductsListModel();
      }

      final imgs = _productsList.images ?? [];
      final cover = _productsList.cover ?? '';
      if (cover.isNotEmpty && !imgs.contains(cover)) {
        _productsList.images = [cover, ...imgs];
      }

      if (Get.isRegistered<ProductCartController>() &&
          Get.find<ProductCartController>()
                  .checkProductInCart(_productsList.id ?? 0) ==
              true) {
        _productsList.quantity = Get.find<ProductCartController>()
            .getQuantity(_productsList.id as int);
      } else {
        _productsList.quantity = 0;
      }

      try {
        _cateInfo = cateInfo is Map
            ? CateInfoModel.fromJson(Map<String, dynamic>.from(cateInfo))
            : CateInfoModel();
      } catch (_) {
        _cateInfo = CateInfoModel();
      }
      try {
        _subCateInfo = subCateInfo is Map
            ? SubCateInfoModel.fromJson(Map<String, dynamic>.from(subCateInfo))
            : SubCateInfoModel();
      } catch (_) {
        _subCateInfo = SubCateInfoModel();
      }
      try {
        _soldByInfo = soldBy is Map
            ? SoldByModel.fromJson(Map<String, dynamic>.from(soldBy))
            : SoldByModel();
      } catch (_) {
        _soldByInfo = SoldByModel();
      }

      await _hydrateGalleryAndVariants(selectedproductsIds);
      _baseProduct = ProductsListModel.fromJson(_productsList.toJson());
      _autoSelectFirstVariant();
      update();
    } else {
      ApiChecker.checkApi(response);
    }
    update();
  }

  /// PDF split endpoints when getById omits gallery / variants.
  Future<void> _hydrateGalleryAndVariants(int productId) async {
    final needGallery = (_productsList.images ?? []).length <= 1;
    // Always try getVariants when empty — has_variants flag can lag.
    final needVariants = _productsList.variants.isEmpty;
    if (!needGallery && !needVariants) return;

    if (needGallery) {
      try {
        final g = await parser.getGallery(productId);
        if (g.statusCode == 200) {
          final list = _mediaFromBody(g.body);
          if (list.isNotEmpty) {
            final cover = _productsList.cover ?? '';
            final merged = <String>{
              if (cover.isNotEmpty) cover,
              ...?_productsList.images,
              ...list,
            }.toList();
            _productsList.images = merged;
          }
        }
      } catch (e) {
        debugPrint('getGallery: $e');
      }
    }

    if (needVariants) {
      try {
        final v = await parser.getVariants(productId);
        if (v.statusCode == 200) {
          final raw = v.body;
          List? list;
          if (raw is Map) {
            list = raw['variants'] ?? raw['data'] ?? raw['items'];
          } else if (raw is List) {
            list = raw;
          }
          if (list is List) {
            _productsList.variants = [
              for (final item in list)
                if (item is Map) Map<String, dynamic>.from(item)
            ];
            if (_productsList.variants.isNotEmpty) {
              _productsList.hasVariants = true;
            }
          }
        }
      } catch (e) {
        debugPrint('getVariants: $e');
      }
    }
  }

  List<String> _mediaFromBody(dynamic body) {
    dynamic src = body;
    if (body is Map) {
      src = body['gallery'] ??
          body['images'] ??
          body['data'] ??
          body['items'] ??
          body;
    }
    if (src is! List) return const [];
    final out = <String>[];
    for (final item in src) {
      if (item is String && item.trim().isNotEmpty) {
        out.add(item.trim());
      } else if (item is Map) {
        final u = (item['url'] ??
                item['image'] ??
                item['cover'] ??
                item['path'] ??
                '')
            .toString()
            .trim();
        if (u.isNotEmpty) out.add(u);
      }
    }
    return out;
  }

  void openSellerStore() {
    final uid = soldByInfo.sellerUid;
    if (uid <= 0) {
      showToast('Store not available'.tr);
      return;
    }
    Get.delete<ProductSellerController>(force: true);
    Get.toNamed(AppRouter.getProductSellerRoutes(), arguments: [
      uid,
      soldByInfo.displayName,
      soldByInfo.cover ?? '',
      soldByInfo.address ?? '',
    ]);
  }

  onCheckout() {
    Get.delete<CartController>(force: true);
    Get.toNamed(AppRouter.getCartRoutes());
  }

  void _syncCartBadges() {
    if (Get.isRegistered<HomeController>()) {
      Get.find<HomeController>().checkCartData();
    }
    if (Get.isRegistered<TopProductsControllrer>()) {
      Get.find<TopProductsControllrer>().checkCartData();
    }
    if (Get.isRegistered<ProductsController>()) {
      Get.find<ProductsController>().checkCartData();
    }
  }

  void updateProductQuantity() {
    _productsList.quantity = _productsList.quantity + 1;
    Get.find<ProductCartController>().addQuantity(_productsList);
    _syncCartBadges();
    update();
  }

  void updateProductQuantityRemove() {
    if (_productsList.quantity == 1) {
      _productsList.quantity = 0;
      Get.find<ProductCartController>().removeItem(_productsList);
    } else {
      _productsList.quantity = _productsList.quantity - 1;
      Get.find<ProductCartController>().addQuantity(_productsList);
    }
    _syncCartBadges();
    update();
  }

  double getTotal() {
    return (productsList.discount ?? 0) > 0
        ? (productsList.sellPrice ?? 0) * productsList.quantity
        : (productsList.originalPrice ?? 0) * productsList.quantity;
  }

  void addToCart() {
    if (hasVariantOptions && selectedVariantIndex < 0) {
      showToast('Please select a variant'.tr);
      return;
    }
    if (hasVariantOptions && displayStock <= 0) {
      showToast('Out of stock'.tr);
      return;
    }
    // Keep variant label in cart line for clarity.
    final v = selectedVariant;
    if (v != null) {
      final label = _variantTitle(v);
      final baseName = (_baseProduct?.name ?? _productsList.name ?? '').trim();
      if (label.isNotEmpty &&
          baseName.isNotEmpty &&
          !baseName.toLowerCase().contains(label.toLowerCase())) {
        _productsList.name = '$baseName ($label)';
      }
    }

    if (Get.find<ProductCartController>().savedInCart.isEmpty) {
      _productsList.quantity = 1;
      Get.find<ProductCartController>().addItem(_productsList);
      _syncCartBadges();
      update();
    } else {
      int freelancerId =
          Get.find<ProductCartController>().getFreelancerId(_productsList);
      if (freelancerId == _productsList.freelacerId) {
        _productsList.quantity = 1;
        Get.find<ProductCartController>().addItem(_productsList);
        _syncCartBadges();
        update();
      } else {
        showToast('We already have product with other freelancer'.tr);
        update();
      }
    }
  }
}
