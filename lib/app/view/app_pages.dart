import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:salon_user/app/controller/app_pages_controller.dart';
import 'package:salon_user/app/util/theme.dart';
import 'package:flutter_html/flutter_html.dart';

class AppPagesScreen extends StatefulWidget {
  const AppPagesScreen({Key? key}) : super(key: key);

  @override
  State<AppPagesScreen> createState() => _AppPagesScreenState();
}

class _AppPagesScreenState extends State<AppPagesScreen> {
  @override
  Widget build(BuildContext context) {
    return GetBuilder<AppPagesController>(
      builder: (value) {
        return Scaffold(
          backgroundColor: ThemeProvider.backgroundColor,
          appBar: AppBar(
            backgroundColor: ThemeProvider.appColor,
            iconTheme: const IconThemeData(color: ThemeProvider.whiteColor),
            elevation: 0,
            centerTitle: true,
            title: Text(
              value.title,
              style: ThemeProvider.titleStyle,
            ),
          ),
          body: value.apiCalled == false
              ? const Center(
                  child: CircularProgressIndicator(color: ThemeProvider.gold),
                )
              : (value.content.toString().isEmpty ||
                      value.content.toString() == 'null')
                  ? const Center(
                      child: Text(
                        'API is not available',
                        style: TextStyle(color: ThemeProvider.greyColor),
                      ),
                    )
                  : SingleChildScrollView(
                      child: Padding(
                        padding: const EdgeInsets.all(10),
                        child: Wrap(
                          children: [Html(data: value.content.toString())],
                        ),
                      ),
                    ),
        );
      },
    );
  }
}
