import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:get/get.dart';
import 'package:salon_user/app/controller/intro_controller.dart';
import 'package:salon_user/app/helper/router.dart';
import 'package:salon_user/app/util/constant.dart';
import 'package:salon_user/app/util/theme.dart';

class IntroScreen extends StatefulWidget {
  const IntroScreen({Key? key}) : super(key: key);

  @override
  State<IntroScreen> createState() => _IntroScreenState();
}

class _IntroScreenState extends State<IntroScreen> {
  final CarouselSliderController _controller = CarouselSliderController();
  int currentIndex = 0;
  List items = [0, 1, 2, 3];
  @override
  Widget build(BuildContext context) {
    return GetBuilder<IntroController>(builder: (value) {
      return Scaffold(
        extendBodyBehindAppBar: true,
        backgroundColor: ThemeProvider.backgroundColor,
        body: _buildBody(),
        bottomNavigationBar: SafeArea(
          child: SizedBox(
            height: 150,
            child: ListView(
              children: [
                if (currentIndex == 0)
                  _buildBottomNavigationBar1()
                else if (currentIndex == 1)
                  _buildBottomNavigationBar2()
                else if (currentIndex == 2)
                  _buildBottomNavigationBar3()
                else if (currentIndex == 3)
                  _buildBottomNavigationBar4()
              ],
            ),
          ),
        ),
      );
    });
  }

  Widget getLanguages() {
    return PopupMenuButton(
      onSelected: (value) {},
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 20),
        child: IconButton(
          icon: const Icon(Icons.translate),
          color: ThemeProvider.gold,
          tooltip: "Save Todo and Retrun to List".tr,
          onPressed: () {},
        ),
      ),
      itemBuilder: (context) => AppConstants.languages
          .map((e) => PopupMenuItem<String>(
                value: e.languageCode.toString(),
                onTap: () {
                  var locale = Locale(e.languageCode.toString());
                  Get.updateLocale(locale);
                  Get.find<IntroController>().saveLanguage(e.languageCode);
                },
                child: Text(e.languageName.toString()),
              ))
          .toList(),
    );
  }

  Widget _buildBody() {
    return CarouselSlider(
      options: CarouselOptions(
        onPageChanged: (index, reason) {
          setState(() {
            currentIndex = index;
          });
        },
        height: double.infinity,
        viewportFraction: 1.0,
        initialPage: 0,
        enableInfiniteScroll: false,
        reverse: false,
        autoPlay: false,
        enlargeCenterPage: true,
        scrollDirection: Axis.horizontal,
      ),
      carouselController: _controller,
      items: items.map((i) {
        return Builder(
          builder: (BuildContext context) {
            return Container(
              width: double.infinity,
              height: double.infinity,
              margin: const EdgeInsets.symmetric(horizontal: 0),
              child: Column(
                children: [
                  if (i == 0)
                    _buildSlide1(context)
                  else if (i == 1)
                    _buildSlide2(context)
                  else if (i == 2)
                    _buildSlide3(context)
                  else if (i == 3)
                    _buildSlide4(context),
                  _buildDots()
                ],
              ),
            );
          },
        );
      }).toList(),
    );
  }

  Widget _slideCopy(String title, String body) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          child: Text(
            title,
            textAlign: TextAlign.center,
            style: ThemeProvider.serif(
              size: 22,
              weight: FontWeight.w700,
              color: ThemeProvider.gold,
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(
              top: 8.0, right: 18, left: 18, bottom: 8),
          child: Text(
            body,
            textAlign: TextAlign.center,
            style: ThemeProvider.sans(
              size: 15,
              weight: FontWeight.w500,
              color: Colors.white70,
            ),
          ),
        ),
      ],
    );
  }

  Widget _slideImage(String asset) {
    return Container(
      height: 360,
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage(asset),
          fit: BoxFit.contain,
        ),
      ),
    );
  }

  Widget _buildSlide1(BuildContext context) {
    return Column(
      children: [
        _slideImage('assets/sliders/1.png'),
        _slideCopy(
          'Discover Your Perfect Hair Look'.tr,
          'Book top-rated hair stylists for cuts, colors, and styles that suit your vibe'
              .tr,
        ),
      ],
    );
  }

  Widget _buildSlide2(BuildContext context) {
    return Column(
      children: [
        _slideImage('assets/sliders/2.png'),
        _slideCopy(
          'Glow Up Starts Here'.tr,
          'Facials, makeup, skincare & more — all at your fingertips.'.tr,
        ),
      ],
    );
  }

  Widget _buildSlide3(BuildContext context) {
    return Column(
      children: [
        _slideImage('assets/sliders/3.png'),
        _slideCopy(
          'Crush Your Fitness Goals'.tr,
          'Find the best gyms and certified trainers near you. Book your session today!'
              .tr,
        ),
      ],
    );
  }

  Widget _buildSlide4(BuildContext context) {
    return Column(
      children: [
        _slideImage('assets/sliders/4.png'),
        _slideCopy(
          'Relax. Recharge. Repeat'.tr,
          'Pamper yourself with spa therapies, massages, and self-care treatments'
              .tr,
        ),
      ],
    );
  }

  Widget _buildDots() {
    return Padding(
      padding: const EdgeInsets.only(top: 30),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: items.asMap().entries.map((entry) {
              return GestureDetector(
                onTap: () => _controller.animateToPage(entry.key),
                child: Container(
                  width: 8.0,
                  height: 8.0,
                  margin: const EdgeInsets.symmetric(
                      vertical: 8.0, horizontal: 4.0),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: ThemeProvider.gold.withValues(
                      alpha: currentIndex == entry.key ? 0.9 : 0.35,
                    ),
                  ),
                ),
              );
            }).toList(),
          )
        ],
      ),
    );
  }

  ButtonStyle get _goldButton {
    return ElevatedButton.styleFrom(
      backgroundColor: ThemeProvider.gold,
      foregroundColor: ThemeProvider.blackColor,
      elevation: 0,
      shadowColor: ThemeProvider.appColorShadow,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(32.0)),
      minimumSize: const Size(100, 40),
    );
  }

  Widget _primaryAction(String label, VoidCallback onPressed) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: SizedBox(
        height: 50,
        child: ElevatedButton(
          style: _goldButton,
          onPressed: onPressed,
          child: Center(
            child: Text(
              label,
              style: ThemeProvider.sans(
                size: 15,
                weight: FontWeight.w700,
                color: ThemeProvider.blackColor,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _textAction(String label, VoidCallback onPressed) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: TextButton(
        onPressed: onPressed,
        child: Center(
          child: Text(
            label,
            style: ThemeProvider.sans(
              size: 15,
              weight: FontWeight.w700,
              color: ThemeProvider.gold,
            ),
          ),
        ),
      ),
    );
  }

  Widget _bar({required Widget primary, required Widget secondary}) {
    return Container(
      color: ThemeProvider.backgroundColor,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [primary, secondary],
      ),
    );
  }

  Widget _buildBottomNavigationBar1() {
    return _bar(
      primary: _primaryAction('Next'.tr, () => _controller.nextPage()),
      secondary: _textAction(
        'Skip'.tr,
        () => Get.toNamed(AppRouter.chooseLocationRoutes),
      ),
    );
  }

  Widget _buildBottomNavigationBar2() {
    return _bar(
      primary: _primaryAction('Previous'.tr, () => _controller.previousPage()),
      secondary: _textAction('Next'.tr, () => _controller.nextPage()),
    );
  }

  Widget _buildBottomNavigationBar3() {
    return _bar(
      primary: _primaryAction('Previous'.tr, () => _controller.previousPage()),
      secondary: _textAction('Next'.tr, () => _controller.nextPage()),
    );
  }

  Widget _buildBottomNavigationBar4() {
    return _bar(
      primary: _primaryAction(
        'Get Started'.tr,
        () => Get.toNamed(AppRouter.chooseLocationRoutes),
      ),
      secondary: _textAction('Previous'.tr, () => _controller.previousPage()),
    );
  }
}
