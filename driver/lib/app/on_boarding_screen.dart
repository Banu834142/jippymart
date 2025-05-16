import 'package:driver/app/auth_screen/login_screen.dart';
import 'package:driver/controllers/on_boarding_controller.dart';
import 'package:driver/themes/app_them_data.dart';
import 'package:driver/themes/responsive.dart';
import 'package:driver/utils/dark_theme_provider.dart';
import 'package:driver/utils/preferences.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

import '../../constant/constant.dart';

class OnBoardingScreen extends StatelessWidget {
  const OnBoardingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final themeChange = Provider.of<DarkThemeProvider>(context);
    return GetX<OnBoardingController>(
      init: OnBoardingController(),
      builder: (controller) {
        return Scaffold(
          body: controller.isLoading.value
              ? Constant.loader()
              : Container(
                  decoration: const BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage("assets/images/onbording_bg.png"),
                      fit: BoxFit.cover,
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        InkWell(
                          onTap: () {
                            Preferences.setBoolean(
                                Preferences.isFinishOnBoardingKey, true);
                            Get.offAll(const LoginScreen());
                          },
                          child: Padding(
                            padding: const EdgeInsets.only(top: 40),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Text(
                                  "Skip".tr,
                                  style: TextStyle(
                                      color: themeChange.getThem()
                                          ? AppThemeData.grey800
                                          : AppThemeData.grey800,
                                      fontSize: 16,
                                      fontFamily: AppThemeData.bold),
                                ),
                                const Icon(Icons.chevron_right)
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 50,
                        ),
                        Image.asset(
                          "assets/images/driver_logo.png",
                          height: 120,
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        Expanded(
                          child: PageView.builder(
                              controller: controller.pageController,
                              onPageChanged: controller.selectedPageIndex.call,
                              itemCount: controller.onBoardingList.length,
                              itemBuilder: (context, index) {
                                return Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Text(
                                      controller.onBoardingList[index].title
                                          .toString()
                                          .tr,
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        color: themeChange.getThem()
                                            ? AppThemeData.grey900
                                            : AppThemeData.grey900,
                                        fontSize: 22,
                                        fontFamily: AppThemeData.bold,
                                        fontWeight: FontWeight.w400,
                                      ),
                                    ),
                                    Text(
                                      controller
                                          .onBoardingList[index].description
                                          .toString()
                                          .tr,
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        color: themeChange.getThem()
                                            ? AppThemeData.grey600
                                            : AppThemeData.grey600,
                                        fontSize: 16,
                                        fontFamily: AppThemeData.regular,
                                        fontWeight: FontWeight.w400,
                                      ),
                                    ),
                                  ],
                                );
                              }),
                        ),
                        Expanded(
                          flex: 4,
                          child: Container(
                            transform: Matrix4.translationValues(0, 30, 0),
                            child: Image.asset(
                              controller.selectedPageIndex.value == 0
                                  ? "assets/images/image_1.png"
                                  : controller.selectedPageIndex.value == 1
                                      ? "assets/images/image_2.png"
                                      : "assets/images/image_3.png",
                              fit: BoxFit.fill,
                              width: Responsive.width(60, context),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
          bottomNavigationBar: InkWell(
            onTap: () {
              if (controller.selectedPageIndex.value == 2) {
                Preferences.setBoolean(Preferences.isFinishOnBoardingKey, true);
                Get.offAll(const LoginScreen());
              } else {
                controller.pageController
                    .jumpToPage(controller.selectedPageIndex.value + 1);
              }
            },
            child: Container(
              color: controller.selectedPageIndex.value == 2
                  ? AppThemeData.driverApp300
                  : AppThemeData.grey900,
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 14),
                child: Text(
                  controller.selectedPageIndex.value == 2
                      ? "Get Started".tr
                      : "Next".tr,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: themeChange.getThem()
                        ? AppThemeData.grey50
                        : AppThemeData.grey50,
                    fontSize: 16,
                    fontFamily: AppThemeData.medium,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
