import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:salon_user/app/controller/find_location_controller.dart';
import 'package:salon_user/app/controller/languages_controller.dart';
import 'package:salon_user/app/helper/desktop.dart';
import 'package:salon_user/app/helper/map_style.dart';
import 'package:salon_user/app/util/theme.dart';
import 'package:salon_user/app/view/widgets/elite_ui.dart';

class FindLocationScreen extends StatefulWidget {
  const FindLocationScreen({Key? key}) : super(key: key);

  @override
  State<FindLocationScreen> createState() => _FindLocationScreenState();
}

class _FindLocationScreenState extends State<FindLocationScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Get.find<FindLocationController>().resetSearch();
    });
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<LanguagesController>(
      builder: (_) {
        return GetBuilder<FindLocationController>(builder: (value) {
          final desktop = Desktop.of(context);
          return Scaffold(
            backgroundColor: ThemeProvider.backgroundColor,
            appBar: EliteAppBar(
              showBack: true,
              title: 'Find Location'.tr,
              leadingLabel: 'Cancel'.tr,
            ),
            body: Padding(
              padding: EdgeInsets.fromLTRB(
                  desktop ? 24 : 16, 8, desktop ? 24 : 16, 16),
              child: desktop ? _web(value) : _mobile(value),
            ),
          );
        });
      },
    );
  }

  Widget _web(FindLocationController value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Expanded(child: _map(value)),
        const SizedBox(width: 24),
        SizedBox(
          width: 400,
          child: Column(
            children: [
              _search(value),
              ..._saved(value),
              const SizedBox(height: 8),
              _useCurrent(value),
              const SizedBox(height: 8),
              Expanded(child: _suggestions(value)),
              const SizedBox(height: 12),
              _confirm(value),
            ],
          ),
        ),
      ],
    );
  }

  Widget _mobile(FindLocationController value) {
    return Column(
      children: [
        _search(value),
        ..._saved(value),
        const SizedBox(height: 8),
        _useCurrent(value),
        const SizedBox(height: 8),
        Expanded(child: _map(value)),
        const SizedBox(height: 12),
        _confirm(value),
      ],
    );
  }

  Widget _search(FindLocationController value) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        color: ThemeProvider.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFF2C2C2C)),
      ),
      child: Row(
        children: [
          const Icon(Icons.search, color: ThemeProvider.gold),
          const SizedBox(width: 8),
          Expanded(
            child: TextField(
              controller: value.searchbarText,
              onChanged: value.onSearchChanged,
              style: ThemeProvider.sans(size: 14),
              cursorColor: ThemeProvider.gold,
              decoration: InputDecoration(
                border: InputBorder.none,
                hintText: 'Search location'.tr,
                hintStyle: ThemeProvider.sans(
                    size: 14, color: ThemeProvider.greyColor),
              ),
            ),
          ),
          if (value.searchbarText.text.isNotEmpty)
            IconButton(
              icon: const Icon(Icons.clear,
                  color: ThemeProvider.greyColor, size: 18),
              onPressed: () {
                value.searchbarText.clear();
                value.onSearchChanged('');
              },
            ),
        ],
      ),
    );
  }

  List<Widget> _saved(FindLocationController value) {
    if (value.savedAddress.isEmpty) return [];
    return [
      const SizedBox(height: 12),
      InkWell(
        onTap: value.useSavedLocation,
        child: EliteCard(
          margin: EdgeInsets.zero,
          child: Row(
            children: [
              const Icon(Icons.location_on, color: ThemeProvider.gold),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Current Active Location'.tr,
                      style: ThemeProvider.sans(
                        size: 11,
                        weight: FontWeight.w700,
                        color: ThemeProvider.gold,
                      ),
                    ),
                    Text(
                      value.savedAddress,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: ThemeProvider.sans(
                          size: 12, color: ThemeProvider.greyColor),
                    ),
                  ],
                ),
              ),
              const Icon(Icons.arrow_forward_ios,
                  size: 14, color: ThemeProvider.gold),
            ],
          ),
        ),
      ),
    ];
  }

  Widget _useCurrent(FindLocationController value) {
    return TextButton(
      onPressed: value.getLocation,
      child: Text(
        'Use My Current Location'.tr.toUpperCase(),
        style: ThemeProvider.sans(
          size: 12,
          weight: FontWeight.w700,
          color: ThemeProvider.gold,
          letterSpacing: 1,
        ),
      ),
    );
  }

  Widget _suggestions(FindLocationController value) {
    if (value.getList.isEmpty) {
      return const SizedBox.expand();
    }
    return Material(
      color: ThemeProvider.surface,
      elevation: 6,
      borderRadius: BorderRadius.circular(12),
      child: ListView.separated(
        padding: EdgeInsets.zero,
        itemCount: value.getList.length,
        separatorBuilder: (_, __) => const Divider(
          height: 1,
          color: Color(0xFF2A2A2A),
        ),
        itemBuilder: (context, index) {
          final item = value.getList[index];
          return ListTile(
            dense: true,
            onTap: () => value.selectPlace(item),
            leading: const Icon(Icons.search, color: ThemeProvider.gold, size: 20),
            title: Text(
              item.description ?? '',
              style: ThemeProvider.sans(size: 13),
            ),
          );
        },
      ),
    );
  }

  Widget _map(FindLocationController value) {
    return Stack(
      children: [
        Positioned.fill(
          child: !value.hasMapPosition
              ? const Center(
                  child: CircularProgressIndicator(color: ThemeProvider.gold),
                )
              : ClipRRect(
                  borderRadius: BorderRadius.circular(14),
                  child: GoogleMap(
                    key: ValueKey('find_location_map_${value.mapRevision}'),
                    style: Utils.mapStyles,
                    myLocationButtonEnabled: true,
                    myLocationEnabled: true,
                    zoomControlsEnabled: true,
                    onMapCreated: value.onMapCreated,
                    markers: Set<Marker>.from(value.markers),
                    initialCameraPosition: CameraPosition(
                      target: LatLng(value.myLat.value, value.myLng.value),
                      zoom: value.mapZoom,
                    ),
                    onTap: (position) {
                      value.moveMapToPosition(
                          position.latitude, position.longitude);
                    },
                  ),
                ),
        ),
        if (!Desktop.of(context) && value.getList.isNotEmpty)
          Positioned(
            left: 0,
            right: 0,
            top: 0,
            child: Material(
              color: ThemeProvider.surface,
              elevation: 6,
              borderRadius: BorderRadius.circular(12),
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxHeight: 220),
                child: ListView.separated(
                  shrinkWrap: true,
                  padding: EdgeInsets.zero,
                  itemCount: value.getList.length,
                  separatorBuilder: (_, __) => const Divider(
                    height: 1,
                    color: Color(0xFF2A2A2A),
                  ),
                  itemBuilder: (context, index) {
                    final item = value.getList[index];
                    return ListTile(
                      dense: true,
                      onTap: () => value.selectPlace(item),
                      leading: const Icon(Icons.search,
                          color: ThemeProvider.gold, size: 20),
                      title: Text(
                        item.description ?? '',
                        style: ThemeProvider.sans(size: 13),
                      ),
                    );
                  },
                ),
              ),
            ),
          ),
      ],
    );
  }

  Widget _confirm(FindLocationController value) {
    return value.hasMapPosition
        ? EliteGoldButton(
            label: 'Confirm Location'.tr.toUpperCase(),
            onTap: value.onConfirmLocation,
          )
        : const SizedBox();
  }
}
