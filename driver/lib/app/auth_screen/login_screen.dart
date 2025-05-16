import 'dart:io';

import 'package:driver/app/auth_screen/phone_number_screen.dart';
import 'package:driver/app/auth_screen/signup_screen.dart';
import 'package:driver/app/forgot_password_screen/forgot_password_screen.dart';
import 'package:driver/constant/show_toast_dialog.dart';
import 'package:driver/controllers/login_controller.dart';
import 'package:driver/themes/app_them_data.dart';
import 'package:driver/themes/responsive.dart';
import 'package:driver/themes/round_button_fill.dart';
import 'package:driver/themes/text_field_widget.dart';
import 'package:driver/utils/dark_theme_provider.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final themeChange = Provider.of<DarkThemeProvider>(context);
    return GetX(
        init: LoginController(),
        builder: (controller) {
          return Scaffold(
            appBar: AppBar(
              backgroundColor: themeChange.getThem()
                  ? AppThemeData.surfaceDark
                  : AppThemeData.surface,
            ),
            body: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Log In to Your Account".tr,
                    style: TextStyle(
                        color: themeChange.getThem()
                            ? AppThemeData.grey50
                            : AppThemeData.grey900,
                        fontSize: 22,
                        fontFamily: AppThemeData.semiBold),
                  ),
                  Text(
                    "Sign in to access your Foodie account and manage your deliveries seamlessly."
                        .tr,
                    style: TextStyle(
                        color: themeChange.getThem()
                            ? AppThemeData.grey50
                            : AppThemeData.grey500,
                        fontFamily: AppThemeData.regular),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Text.rich(
                    TextSpan(
                      children: [
                        TextSpan(
                            text: "Didn’t Have an account?".tr,
                            style: TextStyle(
                              color: themeChange.getThem()
                                  ? AppThemeData.grey50
                                  : AppThemeData.grey900,
                              fontFamily: AppThemeData.medium,
                              fontWeight: FontWeight.w500,
                            )),
                        const WidgetSpan(
                            child: SizedBox(
                          width: 10,
                        )),
                        TextSpan(
                            recognizer: TapGestureRecognizer()
                              ..onTap = () {
                                Get.to(const SignupScreen());
                              },
                            text: 'Sign up'.tr,
                            style: const TextStyle(
                                color: AppThemeData.secondary300,
                                fontFamily: AppThemeData.medium,
                                fontWeight: FontWeight.w500,
                                decoration: TextDecoration.underline,
                                decorationColor: AppThemeData.secondary300)),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 32,
                  ),
                  TextFieldWidget(
                    title: 'Email Address'.tr,
                    controller: controller.emailEditingController.value,
                    hintText: 'Enter email address'.tr,
                    prefix: Padding(
                      padding: const EdgeInsets.all(12),
                      child: SvgPicture.asset(
                        "assets/icons/ic_mail.svg",
                        colorFilter: ColorFilter.mode(
                          themeChange.getThem()
                              ? AppThemeData.grey300
                              : AppThemeData.grey600,
                          BlendMode.srcIn,
                        ),
                      ),
                    ),
                  ),
                  TextFieldWidget(
                    title: 'Password'.tr,
                    controller: controller.passwordEditingController.value,
                    hintText: 'Enter password'.tr,
                    obscureText: controller.passwordVisible.value,
                    prefix: Padding(
                      padding: const EdgeInsets.all(12),
                      child: SvgPicture.asset(
                        "assets/icons/ic_lock.svg",
                        colorFilter: ColorFilter.mode(
                          themeChange.getThem()
                              ? AppThemeData.grey300
                              : AppThemeData.grey600,
                          BlendMode.srcIn,
                        ),
                      ),
                    ),
                    suffix: Padding(
                      padding: const EdgeInsets.all(12),
                      child: InkWell(
                          onTap: () {
                            controller.passwordVisible.value =
                                !controller.passwordVisible.value;
                          },
                          child: controller.passwordVisible.value
                              ? SvgPicture.asset(
                                  "assets/icons/ic_password_show.svg",
                                  colorFilter: ColorFilter.mode(
                                    themeChange.getThem()
                                        ? AppThemeData.grey300
                                        : AppThemeData.grey600,
                                    BlendMode.srcIn,
                                  ),
                                )
                              : SvgPicture.asset(
                                  "assets/icons/ic_password_close.svg",
                                  colorFilter: ColorFilter.mode(
                                    themeChange.getThem()
                                        ? AppThemeData.grey300
                                        : AppThemeData.grey600,
                                    BlendMode.srcIn,
                                  ),
                                )),
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      Get.to(const ForgotPasswordScreen());
                    },
                    child: Align(
                      alignment: Alignment.centerRight,
                      child: Text(
                        "Forgot Password".tr,
                        style: TextStyle(
                            decoration: TextDecoration.underline,
                            decorationColor: AppThemeData.secondary300,
                            color: themeChange.getThem()
                                ? AppThemeData.secondary300
                                : AppThemeData.secondary300,
                            fontSize: 14,
                            fontFamily: AppThemeData.medium),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                ],
              ),
            ),
            bottomNavigationBar: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(
                      vertical: Platform.isAndroid ? 10 : 30, horizontal: 16),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      RoundedButtonFill(
                        title: "Continue with Mobile Number".tr,
                        textColor: themeChange.getThem()
                            ? AppThemeData.grey100
                            : AppThemeData.grey900,
                        color: themeChange.getThem()
                            ? AppThemeData.grey900
                            : AppThemeData.grey100,
                        icon: SvgPicture.asset(
                          "assets/icons/ic_phone.svg",
                          colorFilter: const ColorFilter.mode(
                              AppThemeData.grey900, BlendMode.srcIn),
                        ),
                        isRight: false,
                        onPress: () async {
                          Get.to(const PhoneNumberScreen());
                        },
                      ),
                      const SizedBox(
                        height: 12,
                      ),
                      Row(
                        children: [
                          Expanded(
                            child: RoundedButtonFill(
                              title: "with Google".tr,
                              textColor: themeChange.getThem()
                                  ? AppThemeData.grey100
                                  : AppThemeData.grey900,
                              color: themeChange.getThem()
                                  ? AppThemeData.grey900
                                  : AppThemeData.grey100,
                              icon: SvgPicture.asset(
                                  "assets/icons/ic_google.svg"),
                              isRight: false,
                              onPress: () async {
                                controller.loginWithGoogle();
                              },
                            ),
                          ),
                          const SizedBox(
                            width: 10,
                          ),
                          Platform.isIOS
                              ? Expanded(
                                  child: RoundedButtonFill(
                                    title: "with Apple".tr,
                                    textColor: themeChange.getThem()
                                        ? AppThemeData.grey100
                                        : AppThemeData.grey900,
                                    color: themeChange.getThem()
                                        ? AppThemeData.grey900
                                        : AppThemeData.grey100,
                                    icon: SvgPicture.asset(
                                        "assets/icons/ic_apple.svg"),
                                    isRight: false,
                                    onPress: () async {
                                      controller.loginWithApple();
                                    },
                                  ),
                                )
                              : const SizedBox(),
                        ],
                      ),
                    ],
                  ),
                ),
                InkWell(
                  onTap: () {
                    if (controller.emailEditingController.value.text
                        .trim()
                        .isEmpty) {
                      ShowToastDialog.showToast("Please enter valid email".tr);
                    } else if (controller.passwordEditingController.value.text
                        .trim()
                        .isEmpty) {
                      ShowToastDialog.showToast(
                          "Please enter valid password".tr);
                    } else {
                      controller.loginWithEmailAndPassword();
                    }
                  },
                  child: Container(
                    color: AppThemeData.driverApp300,
                    width: Responsive.width(100, context),
                    height: Responsive.width(16, context),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      child: Text(
                        "Log in".tr,
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
              ],
            ),
          );
        });
  }
}
