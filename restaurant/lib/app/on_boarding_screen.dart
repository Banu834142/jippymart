import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:restaurant/app/auth_screen/login_screen.dart';
import 'package:restaurant/controller/on_boarding_controller.dart';
import 'package:restaurant/themes/app_them_data.dart';
import 'package:restaurant/themes/round_button_fill.dart';
import 'package:restaurant/utils/dark_theme_provider.dart';
import 'package:restaurant/utils/preferences.dart';

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
                  decoration: BoxDecoration(
                      image: DecorationImage(
                          image:
                              AssetImage(controller.selectedPageIndex.value == 0
                                  ? "assets/images/image_1.png"
                                  : controller.selectedPageIndex.value == 1
                                      ? "assets/images/image_2.png"
                                      : "assets/images/image_3.png"),
                          fit: BoxFit.cover)),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 20, horizontal: 16),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: PageView.builder(
                              controller: controller.pageController,
                              onPageChanged: controller.selectedPageIndex.call,
                              itemCount: controller.onBoardingList.length,
                              itemBuilder: (context, index) {
                                return Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 10),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Image.asset(
                                        "assets/images/ic_logo.png",
                                        width: 72,
                                        height: 72,
                                      ),
                                      Text(
                                        "Foodie".tr,
                                        style: TextStyle(
                                            color: themeChange.getThem()
                                                ? AppThemeData.grey50
                                                : AppThemeData.grey50,
                                            fontSize: 24,
                                            fontFamily: AppThemeData.bold),
                                      ),
                                      const SizedBox(
                                        height: 30,
                                      ),
                                      Text(
                                        controller.onBoardingList[index].title
                                            .toString()
                                            .tr,
                                        textAlign: TextAlign.start,
                                        style: TextStyle(
                                          color: themeChange.getThem()
                                              ? AppThemeData.grey50
                                              : AppThemeData.grey50,
                                          fontSize: 28,
                                          fontFamily: AppThemeData.bold,
                                          fontWeight: FontWeight.w400,
                                        ),
                                      ),
                                      Text(
                                        controller
                                            .onBoardingList[index].description
                                            .toString()
                                            .tr,
                                        textAlign: TextAlign.start,
                                        style: TextStyle(
                                          color: themeChange.getThem()
                                              ? AppThemeData.grey600
                                              : AppThemeData.grey300,
                                          fontSize: 16,
                                          fontFamily: AppThemeData.regular,
                                          fontWeight: FontWeight.w400,
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              }),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        RoundedButtonFill(
                          title: "Get Started".tr,
                          color: AppThemeData.secondary300,
                          textColor: AppThemeData.grey50,
                          onPress: () {
                            if (controller.selectedPageIndex.value == 2) {
                              Preferences.setBoolean(
                                  Preferences.isFinishOnBoardingKey, true);
                              Get.offAll(const LoginScreen());
                            } else {
                              controller.pageController.jumpToPage(
                                  controller.selectedPageIndex.value + 1);
                            }
                          },
                        ),
                        const SizedBox(
                          height: 50,
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
