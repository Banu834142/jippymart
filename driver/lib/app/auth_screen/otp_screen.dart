import 'dart:io';

import 'package:driver/app/auth_screen/login_screen.dart';
import 'package:driver/app/auth_screen/signup_screen.dart';
import 'package:driver/app/dash_board_screen/dash_board_screen.dart';
import 'package:driver/constant/constant.dart';
import 'package:driver/constant/show_toast_dialog.dart';
import 'package:driver/controllers/otp_controller.dart';
import 'package:driver/models/user_model.dart';
import 'package:driver/themes/app_them_data.dart';
import 'package:driver/themes/responsive.dart';
import 'package:driver/utils/dark_theme_provider.dart';
import 'package:driver/utils/fire_store_utils.dart';
import 'package:driver/utils/notification_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:provider/provider.dart';

class OtpScreen extends StatelessWidget {
  const OtpScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final themeChange = Provider.of<DarkThemeProvider>(context);
    return GetX<OtpController>(
        init: OtpController(),
        builder: (controller) {
          return Scaffold(
            appBar: AppBar(
              backgroundColor: themeChange.getThem()
                  ? AppThemeData.surfaceDark
                  : AppThemeData.surface,
            ),
            body: controller.isLoading.value
                ? Constant.loader()
                : SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 24, vertical: 10),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Verify Your Mobile Number".tr,
                            style: TextStyle(
                                color: themeChange.getThem()
                                    ? AppThemeData.grey50
                                    : AppThemeData.grey900,
                                fontSize: 22,
                                fontFamily: AppThemeData.semiBold),
                          ),
                          Text(
                            "Enter the OTP sent to your mobile number to verify and secure your account."
                                .tr,
                            textAlign: TextAlign.start,
                            style: TextStyle(
                              color: themeChange.getThem()
                                  ? AppThemeData.grey200
                                  : AppThemeData.grey700,
                              fontFamily: AppThemeData.regular,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                          const SizedBox(
                            height: 60,
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 10),
                            child: PinCodeTextField(
                              length: 6,
                              appContext: context,
                              keyboardType: TextInputType.phone,
                              enablePinAutofill: true,
                              hintCharacter: "-",
                              hintStyle: TextStyle(
                                  color: themeChange.getThem()
                                      ? AppThemeData.grey50
                                      : AppThemeData.grey900,
                                  fontFamily: AppThemeData.regular),
                              textStyle: TextStyle(
                                  color: themeChange.getThem()
                                      ? AppThemeData.grey50
                                      : AppThemeData.grey900,
                                  fontFamily: AppThemeData.regular),
                              pinTheme: PinTheme(
                                  fieldHeight: 50,
                                  fieldWidth: 50,
                                  inactiveFillColor: themeChange.getThem()
                                      ? AppThemeData.grey900
                                      : AppThemeData.grey50,
                                  selectedFillColor: themeChange.getThem()
                                      ? AppThemeData.grey900
                                      : AppThemeData.grey50,
                                  activeFillColor: themeChange.getThem()
                                      ? AppThemeData.grey900
                                      : AppThemeData.grey50,
                                  selectedColor: themeChange.getThem()
                                      ? AppThemeData.grey900
                                      : AppThemeData.grey50,
                                  activeColor: themeChange.getThem()
                                      ? AppThemeData.secondary300
                                      : AppThemeData.secondary300,
                                  inactiveColor: themeChange.getThem()
                                      ? AppThemeData.grey900
                                      : AppThemeData.grey50,
                                  disabledColor: themeChange.getThem()
                                      ? AppThemeData.grey900
                                      : AppThemeData.grey50,
                                  shape: PinCodeFieldShape.box,
                                  errorBorderColor: themeChange.getThem()
                                      ? AppThemeData.grey600
                                      : AppThemeData.grey300,
                                  borderRadius: const BorderRadius.all(
                                      Radius.circular(10))),
                              cursorColor: AppThemeData.secondary300,
                              enableActiveFill: true,
                              controller: controller.otpController.value,
                              onCompleted: (v) async {},
                              onChanged: (value) {},
                            ),
                          ),
                          const SizedBox(
                            height: 50,
                          ),
                          Center(
                            child: Text.rich(
                              textAlign: TextAlign.center,
                              TextSpan(
                                text: "${'Did’t receive any code? '.tr} ",
                                style: TextStyle(
                                  fontWeight: FontWeight.w500,
                                  fontSize: 14,
                                  fontFamily: AppThemeData.medium,
                                  color: themeChange.getThem()
                                      ? AppThemeData.grey100
                                      : AppThemeData.grey800,
                                ),
                                children: <TextSpan>[
                                  TextSpan(
                                    recognizer: TapGestureRecognizer()
                                      ..onTap = () {
                                        controller.otpController.value.clear();
                                        controller.sendOTP();
                                      },
                                    text: 'Send Again'.tr,
                                    style: TextStyle(
                                        color: themeChange.getThem()
                                            ? AppThemeData.driverApp300
                                            : AppThemeData.driverApp300,
                                        fontWeight: FontWeight.w500,
                                        fontSize: 14,
                                        fontFamily: AppThemeData.medium,
                                        decoration: TextDecoration.underline,
                                        decorationColor:
                                            AppThemeData.driverApp300),
                                  ),
                                ],
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
            bottomNavigationBar: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(
                      vertical: Platform.isAndroid ? 10 : 30),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text.rich(
                        TextSpan(
                          children: [
                            TextSpan(
                                text: 'Already Have an account?'.tr,
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
                                    Get.offAll(const LoginScreen());
                                  },
                                text: 'Log in'.tr,
                                style: const TextStyle(
                                    color: AppThemeData.secondary300,
                                    fontFamily: AppThemeData.medium,
                                    fontWeight: FontWeight.w500,
                                    decoration: TextDecoration.underline,
                                    decorationColor:
                                        AppThemeData.secondary300)),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                InkWell(
                  onTap: () async {
                    if (controller.otpController.value.text.length == 6) {
                      ShowToastDialog.showLoader("Verify otp".tr);

                      PhoneAuthCredential credential =
                          PhoneAuthProvider.credential(
                              verificationId: controller.verificationId.value,
                              smsCode: controller.otpController.value.text);
                      String fcmToken = await NotificationService.getToken();
                      await FirebaseAuth.instance
                          .signInWithCredential(credential)
                          .then((value) async {
                        if (value.additionalUserInfo!.isNewUser) {
                          UserModel userModel = UserModel();
                          userModel.id = value.user!.uid;
                          userModel.countryCode = controller.countryCode.value;
                          userModel.phoneNumber = controller.phoneNumber.value;
                          userModel.fcmToken = fcmToken;
                          userModel.provider = 'phone';

                          ShowToastDialog.closeLoader();
                          Get.off(const SignupScreen(), arguments: {
                            "userModel": userModel,
                            "type": "mobileNumber",
                          });
                        } else {
                          await FireStoreUtils.userExistOrNot(value.user!.uid)
                              .then((userExit) async {
                            ShowToastDialog.closeLoader();
                            if (userExit == true) {
                              UserModel? userModel =
                                  await FireStoreUtils.getUserProfile(
                                      value.user!.uid);
                              if (userModel!.role == Constant.userRoleDriver) {
                                if (userModel.active == true) {
                                  userModel.fcmToken =
                                      await NotificationService.getToken();
                                  await FireStoreUtils.updateUser(userModel);
                                  Get.offAll(const DashBoardScreen());
                                } else {
                                  ShowToastDialog.showToast(
                                      "This user is disable please contact to administrator"
                                          .tr);
                                  await FirebaseAuth.instance.signOut();
                                  Get.offAll(const LoginScreen());
                                }
                              } else {
                                ShowToastDialog.showToast(
                                    "Account already created in other application. You are not able login this application."
                                        .tr);
                                await FirebaseAuth.instance.signOut();
                                Get.offAll(const LoginScreen());
                              }
                            } else {
                              UserModel userModel = UserModel();
                              userModel.id = value.user!.uid;
                              userModel.countryCode =
                                  controller.countryCode.value;
                              userModel.phoneNumber =
                                  controller.phoneNumber.value;
                              userModel.fcmToken = fcmToken;
                              userModel.provider = 'phone';

                              Get.off(const SignupScreen(), arguments: {
                                "userModel": userModel,
                                "type": "mobileNumber",
                              });
                            }
                          });
                        }
                      }).catchError((error) {
                        ShowToastDialog.closeLoader();
                        ShowToastDialog.showToast("Invalid Code".tr);
                      });
                    } else {
                      ShowToastDialog.showToast("Enter Valid otp".tr);
                    }
                  },
                  child: Container(
                    color: AppThemeData.driverApp300,
                    width: Responsive.width(100, context),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      child: Text(
                        "Send Code".tr,
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
