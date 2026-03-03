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
        // appBar: AppBar(
        //   elevation: 0,
        //   backgroundColor: ThemeProvider.whiteColor,
        //   title: Row(
        //     mainAxisAlignment: MainAxisAlignment.end,
        //   ),
        //   actions: <Widget>[getLanguages()],
        // ),
        backgroundColor: ThemeProvider.whiteColor,
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
                // else if (currentIndex == 4)
                //   _buildBottomNavigationBar5()
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
          color: ThemeProvider.appColor,
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
                  // else if (i == 4)
                  //   _buildSlide5(context),
                  _buildDots()
                ],
              ),
            );
          },
        );
      }).toList(),
    );
  }

  Widget _buildSlide1(BuildContext context) {
    return Column(
      children: [
        Container(
          height: 360,
          decoration: const BoxDecoration(
            image: DecorationImage(
                image: AssetImage(
                  'assets/sliders/1.png',
                ),
                fit: BoxFit.contain),
          ),
        ),
        Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: Text(
                'Discover Your Perfect Hair Look'.tr,
                textAlign: TextAlign.center,
                style: const TextStyle(
                    fontFamily: 'bold',
                    color: ThemeProvider.blackColor,
                    fontSize: 19),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(
                  top: 8.0, right: 18, left: 18, bottom: 8),
              child: Text(
                'Book top-rated hair stylists for cuts, colors, and styles that suit your vibe'
                    .tr,
                textAlign: TextAlign.center,
                style: const TextStyle(
                    color: Color.fromARGB(255, 62, 62, 62),
                    fontSize: 15,
                    fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildSlide2(BuildContext context) {
    return Column(
      children: [
        Container(
          height: 360,
          decoration: const BoxDecoration(
            image: DecorationImage(
                image: AssetImage(
                  'assets/sliders/2.png',
                ),
                fit: BoxFit.contain),
          ),
        ),
        Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: Text(
                'Glow Up Starts Here'.tr,
                textAlign: TextAlign.center,
                style: const TextStyle(
                    fontFamily: 'bold',
                    color: ThemeProvider.blackColor,
                    fontSize: 19),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(
                  top: 8.0, right: 18, left: 18, bottom: 8),
              child: Text(
                'Facials, makeup, skincare & more — all at your fingertips.'.tr,
                textAlign: TextAlign.center,
                style: const TextStyle(
                    color: Color.fromARGB(255, 62, 62, 62),
                    fontSize: 15,
                    fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildSlide3(BuildContext context) {
    return Column(
      children: [
        Container(
          height: 360,
          decoration: const BoxDecoration(
            image: DecorationImage(
                image: AssetImage(
                  'assets/sliders/3.png',
                ),
                fit: BoxFit.contain),
          ),
        ),
        Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: Text(
                'Crush Your Fitness Goals'.tr,
                textAlign: TextAlign.center,
                style: const TextStyle(
                    fontFamily: 'bold',
                    color: ThemeProvider.blackColor,
                    fontSize: 19),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(
                  top: 8.0, right: 18, left: 18, bottom: 8),
              child: Text(
                'Find the best gyms and certified trainers near you. Book your session today!'
                    .tr,
                textAlign: TextAlign.center,
                style: const TextStyle(
                    color: Color.fromARGB(255, 62, 62, 62),
                    fontSize: 15,
                    fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildSlide4(BuildContext context) {
    return Column(
      children: [
        Container(
          height: 360,
          decoration: const BoxDecoration(
            image: DecorationImage(
                image: AssetImage(
                  'assets/sliders/4.png',
                ),
                fit: BoxFit.contain),
          ),
        ),
        Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: Text(
                'Relax. Recharge. Repeat'.tr,
                textAlign: TextAlign.center,
                style: const TextStyle(
                    fontFamily: 'bold',
                    color: ThemeProvider.blackColor,
                    fontSize: 19),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(
                  top: 8.0, right: 18, left: 18, bottom: 8),
              child: Text(
                'Pamper yourself with spa therapies, massages, and self-care treatments'
                    .tr,
                textAlign: TextAlign.center,
                style: const TextStyle(
                    color: Color.fromARGB(255, 62, 62, 62),
                    fontSize: 15,
                    fontWeight: FontWeight.bold),
              ),
            ),
          ],
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
                      color: (Theme.of(context).brightness == Brightness.dark
                              ? ThemeProvider.whiteColor
                              : ThemeProvider.blackColor)
                          .withOpacity(currentIndex == entry.key ? 0.9 : 0.4)),
                ),
              );
            }).toList(),
          )
        ],
      ),
    );
  }

  Widget _buildBottomNavigationBar1() {
    return Container(
      decoration: const BoxDecoration(
        color: ThemeProvider.whiteColor,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: SizedBox(
              height: 50,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: ThemeProvider.appColor,
                  shadowColor: ThemeProvider.appColorShadow,
                  elevation: 3,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(32.0)),
                  minimumSize: const Size(100, 40), //////// HERE
                ),
                onPressed: () {
                  _controller.nextPage();
                },
                child: Center(
                  child: Text(
                    'Next'.tr,
                    style: const TextStyle(
                        fontFamily: 'bold', color: ThemeProvider.whiteColor),
                  ),
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: TextButton(
              onPressed: () {
                Get.toNamed(AppRouter.chooseLocationRoutes);
              },
              child: Center(
                child: Text(
                  'Skip'.tr,
                  style: const TextStyle(
                      fontFamily: 'bold', color: ThemeProvider.blackColor),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomNavigationBar2() {
    return Container(
      decoration: const BoxDecoration(
        color: ThemeProvider.whiteColor,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: SizedBox(
              height: 50,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: ThemeProvider.appColor,
                  shadowColor: ThemeProvider.appColorShadow,
                  elevation: 3,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(32.0)),
                  minimumSize: const Size(100, 40), //////// HERE
                ),
                onPressed: () {
                  _controller.previousPage();
                },
                child: Center(
                  child: Text(
                    'Previous'.tr,
                    style: const TextStyle(
                        fontFamily: 'bold', color: ThemeProvider.whiteColor),
                  ),
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: TextButton(
              onPressed: () {
                // Get.toNamed(AppRouter.chooseLocationRoutes);
                _controller.nextPage();
              },
              child: Center(
                child: Text(
                  'Next'.tr,
                  style: const TextStyle(
                      fontFamily: 'bold', color: ThemeProvider.blackColor),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomNavigationBar3() {
    return Container(
      decoration: const BoxDecoration(
        color: ThemeProvider.whiteColor,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: SizedBox(
              height: 50,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: ThemeProvider.appColor,
                  shadowColor: ThemeProvider.appColorShadow,
                  elevation: 3,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(32.0)),
                  minimumSize: const Size(100, 40), //////// HERE
                ),
                onPressed: () {
                  _controller.previousPage();
                },
                child: Center(
                  child: Text(
                    'Previous'.tr,
                    style: const TextStyle(
                        fontFamily: 'bold', color: ThemeProvider.whiteColor),
                  ),
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: TextButton(
              onPressed: () {
                // Get.toNamed(AppRouter.chooseLocationRoutes);
                _controller.nextPage();
              },
              child: Center(
                child: Text(
                  'Next'.tr,
                  style: const TextStyle(
                      fontFamily: 'bold', color: ThemeProvider.blackColor),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomNavigationBar4() {
    return Container(
      decoration: const BoxDecoration(
        color: ThemeProvider.whiteColor,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: SizedBox(
              height: 50,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: ThemeProvider.appColor,
                  shadowColor: ThemeProvider.appColorShadow,
                  elevation: 3,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(32.0)),
                  minimumSize: const Size(100, 40), //////// HERE
                ),
                onPressed: () {
                  Get.toNamed(AppRouter.chooseLocationRoutes);
                },
                child: Center(
                  child: Text(
                    'Get Started'.tr,
                    style: const TextStyle(
                        fontFamily: 'bold', color: ThemeProvider.whiteColor),
                  ),
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: TextButton(
              onPressed: () {
                _controller.previousPage();
              },
              child: Center(
                child: Text(
                  'Previous'.tr,
                  style: const TextStyle(
                      fontFamily: 'bold', color: ThemeProvider.blackColor),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

contentButtonStyle1() {
  return const BoxDecoration(
    borderRadius: BorderRadius.all(
      Radius.circular(50.0),
    ),
    color: ThemeProvider.blackColor,
  );
}

contentButtonStyle2() {
  return const BoxDecoration(
    borderRadius: BorderRadius.all(
      Radius.circular(50.0),
    ),
    color: ThemeProvider.appColor,
  );
}

contentButtonStyle3() {
  return const BoxDecoration(
    borderRadius: BorderRadius.all(
      Radius.circular(50.0),
    ),
    color: ThemeProvider.redColor,
  );
}
