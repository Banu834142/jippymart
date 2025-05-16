import 'package:country_code_picker/country_code_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:restaurant/constant/constant.dart';
import 'package:restaurant/constant/show_toast_dialog.dart';
import 'package:restaurant/controller/add_driver_controller.dart';
import 'package:restaurant/models/zone_model.dart';
import 'package:restaurant/themes/app_them_data.dart';
import 'package:restaurant/themes/round_button_fill.dart';
import 'package:restaurant/themes/text_field_widget.dart';
import 'package:restaurant/utils/dark_theme_provider.dart';

class AddDriverScreen extends StatefulWidget {
  const AddDriverScreen({super.key});

  @override
  State<AddDriverScreen> createState() => _AddDriverScreenState();
}

class _AddDriverScreenState extends State<AddDriverScreen> {
  @override
  Widget build(BuildContext context) {
    final themeChange = Provider.of<DarkThemeProvider>(context);
    return GetX(
        init: AddDriverController(),
        builder: (controller) {
          return controller.isLoading.value
              ? Constant.loader()
              : Scaffold(
                  appBar: AppBar(
                    backgroundColor: AppThemeData.secondary300,
                    centerTitle: false,
                    iconTheme: const IconThemeData(color: AppThemeData.grey50),
                    title: Text(
                      controller.driverModel.value.id == null
                          ? "Add Delivery Man".tr
                          : "Edit Delivery Man".tr,
                      style: TextStyle(
                          color: themeChange.getThem()
                              ? AppThemeData.grey900
                              : AppThemeData.grey50,
                          fontSize: 18,
                          fontFamily: AppThemeData.medium),
                    ),
                  ),
                  body: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 10),
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(top: 20),
                            child: Row(
                              children: [
                                Expanded(
                                  child: TextFieldWidget(
                                    title: 'First Name'.tr,
                                    controller: controller
                                        .firstNameEditingController.value,
                                    hintText: 'Enter First Name'.tr,
                                    prefix: Padding(
                                      padding: const EdgeInsets.all(12),
                                      child: SvgPicture.asset(
                                        "assets/icons/ic_user.svg",
                                        colorFilter: ColorFilter.mode(
                                          themeChange.getThem()
                                              ? AppThemeData.grey300
                                              : AppThemeData.grey600,
                                          BlendMode.srcIn,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(
                                  width: 10,
                                ),
                                Expanded(
                                  child: TextFieldWidget(
                                    title: 'Last Name'.tr,
                                    controller: controller
                                        .lastNameEditingController.value,
                                    hintText: 'Enter Last Name'.tr,
                                    prefix: Padding(
                                      padding: const EdgeInsets.all(12),
                                      child: SvgPicture.asset(
                                        "assets/icons/ic_user.svg",
                                        colorFilter: ColorFilter.mode(
                                          themeChange.getThem()
                                              ? AppThemeData.grey300
                                              : AppThemeData.grey600,
                                          BlendMode.srcIn,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          TextFieldWidget(
                            isReadyOnly:
                                (controller.driverModel.value.id != null &&
                                    controller.driverModel.value.id != ''),
                            title: 'Email Address'.tr,
                            textInputType: TextInputType.emailAddress,
                            controller: controller.emailEditingController.value,
                            hintText: 'Enter Email Address'.tr,
                            enable: true,
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
                            title: 'Phone Number'.tr,
                            controller:
                                controller.phoneNUmberEditingController.value,
                            hintText: 'Enter Phone Number'.tr,
                            enable: true,
                            textInputType:
                                const TextInputType.numberWithOptions(
                                    signed: true, decimal: true),
                            textInputAction: TextInputAction.done,
                            inputFormatters: [
                              FilteringTextInputFormatter.allow(
                                  RegExp('[0-9]')),
                            ],
                            prefix: CountryCodePicker(
                              enabled: true,
                              onChanged: (value) {
                                controller.countryCodeEditingController.value
                                    .text = value.dialCode.toString();
                              },
                              dialogTextStyle: TextStyle(
                                  color: themeChange.getThem()
                                      ? AppThemeData.grey50
                                      : AppThemeData.grey900,
                                  fontWeight: FontWeight.w500,
                                  fontFamily: AppThemeData.medium),
                              dialogBackgroundColor: themeChange.getThem()
                                  ? AppThemeData.grey800
                                  : AppThemeData.grey100,
                              initialSelection: controller
                                  .countryCodeEditingController.value.text,
                              comparator: (a, b) =>
                                  b.name!.compareTo(a.name.toString()),
                              textStyle: TextStyle(
                                  fontSize: 14,
                                  color: themeChange.getThem()
                                      ? AppThemeData.grey50
                                      : AppThemeData.grey900,
                                  fontFamily: AppThemeData.medium),
                              searchDecoration: InputDecoration(
                                  iconColor: themeChange.getThem()
                                      ? AppThemeData.grey50
                                      : AppThemeData.grey900),
                              searchStyle: TextStyle(
                                  color: themeChange.getThem()
                                      ? AppThemeData.grey50
                                      : AppThemeData.grey900,
                                  fontWeight: FontWeight.w500,
                                  fontFamily: AppThemeData.medium),
                            ),
                          ),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text("Zone".tr,
                                  style: TextStyle(
                                      fontFamily: AppThemeData.semiBold,
                                      fontSize: 14,
                                      color: themeChange.getThem()
                                          ? AppThemeData.grey100
                                          : AppThemeData.grey800)),
                              const SizedBox(
                                height: 5,
                              ),
                              DropdownButtonFormField<ZoneModel>(
                                  hint: Text(
                                    'Select zone'.tr,
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: themeChange.getThem()
                                          ? AppThemeData.grey700
                                          : AppThemeData.grey700,
                                      fontFamily: AppThemeData.regular,
                                    ),
                                  ),
                                  decoration: InputDecoration(
                                    errorStyle:
                                        const TextStyle(color: Colors.red),
                                    isDense: true,
                                    filled: true,
                                    fillColor: themeChange.getThem()
                                        ? AppThemeData.grey900
                                        : AppThemeData.grey50,
                                    disabledBorder: UnderlineInputBorder(
                                      borderRadius: const BorderRadius.all(
                                          Radius.circular(10)),
                                      borderSide: BorderSide(
                                          color: themeChange.getThem()
                                              ? AppThemeData.grey900
                                              : AppThemeData.grey50,
                                          width: 1),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderRadius: const BorderRadius.all(
                                          Radius.circular(10)),
                                      borderSide: BorderSide(
                                          color: themeChange.getThem()
                                              ? AppThemeData.secondary300
                                              : AppThemeData.secondary300,
                                          width: 1),
                                    ),
                                    enabledBorder: OutlineInputBorder(
                                      borderRadius: const BorderRadius.all(
                                          Radius.circular(10)),
                                      borderSide: BorderSide(
                                          color: themeChange.getThem()
                                              ? AppThemeData.grey900
                                              : AppThemeData.grey50,
                                          width: 1),
                                    ),
                                    errorBorder: OutlineInputBorder(
                                      borderRadius: const BorderRadius.all(
                                          Radius.circular(10)),
                                      borderSide: BorderSide(
                                          color: themeChange.getThem()
                                              ? AppThemeData.grey900
                                              : AppThemeData.grey50,
                                          width: 1),
                                    ),
                                    border: OutlineInputBorder(
                                      borderRadius: const BorderRadius.all(
                                          Radius.circular(10)),
                                      borderSide: BorderSide(
                                          color: themeChange.getThem()
                                              ? AppThemeData.grey900
                                              : AppThemeData.grey50,
                                          width: 1),
                                    ),
                                  ),
                                  value:
                                      controller.selectedZone.value.id == null
                                          ? null
                                          : controller.selectedZone.value,
                                  onChanged: (value) {
                                    controller.selectedZone.value = value!;
                                    controller.update();
                                  },
                                  style: TextStyle(
                                      fontSize: 14,
                                      color: themeChange.getThem()
                                          ? AppThemeData.grey50
                                          : AppThemeData.grey900,
                                      fontFamily: AppThemeData.medium),
                                  items: controller.zoneList.map((item) {
                                    return DropdownMenuItem<ZoneModel>(
                                      value: item,
                                      child: Text(item.name.toString()),
                                    );
                                  }).toList()),
                            ],
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          Visibility(
                            visible: controller.driverModel.value.id == null,
                            child: Column(
                              children: [
                                TextFieldWidget(
                                  title: 'Password'.tr,
                                  controller: controller
                                      .passwordEditingController.value,
                                  hintText: 'Enter Password'.tr,
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
                                TextFieldWidget(
                                  title: 'Confirm Password'.tr,
                                  controller: controller
                                      .conformPasswordEditingController.value,
                                  hintText: 'Enter Confirm Password'.tr,
                                  obscureText:
                                      controller.conformPasswordVisible.value,
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
                                          controller.conformPasswordVisible
                                                  .value =
                                              !controller
                                                  .conformPasswordVisible.value;
                                        },
                                        child: controller
                                                .conformPasswordVisible.value
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
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  bottomNavigationBar: Container(
                    color: themeChange.getThem()
                        ? AppThemeData.grey900
                        : AppThemeData.grey50,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 20),
                    child: Padding(
                      padding: const EdgeInsets.only(bottom: 20),
                      child: RoundedButtonFill(
                        title: "Save Details".tr,
                        height: 5.5,
                        color: themeChange.getThem()
                            ? AppThemeData.secondary300
                            : AppThemeData.secondary300,
                        textColor: themeChange.getThem()
                            ? AppThemeData.grey900
                            : AppThemeData.grey50,
                        fontSizes: 16,
                        onPress: () async {
                          if (controller
                              .firstNameEditingController.value.text.isEmpty) {
                            ShowToastDialog.showToast(
                                "Please enter first name".tr);
                          } else if (controller
                              .lastNameEditingController.value.text.isEmpty) {
                            ShowToastDialog.showToast(
                                "Please enter last name".tr);
                          } else if (controller
                              .emailEditingController.value.text.isEmpty) {
                            ShowToastDialog.showToast(
                                "Please enter valid email".tr);
                          } else if (controller.phoneNUmberEditingController
                              .value.text.isEmpty) {
                            ShowToastDialog.showToast(
                                "Please enter Phone number".tr);
                          } else if (controller.passwordEditingController.value
                                  .text.isEmpty &&
                              controller.driverModel.value.id == null) {
                            ShowToastDialog.showToast(
                                "Please enter password".tr);
                          } else if (controller.conformPasswordEditingController
                                  .value.text.isEmpty &&
                              controller.driverModel.value.id == null) {
                            ShowToastDialog.showToast(
                                "Please enter Confirm password".tr);
                          } else if (controller
                                      .passwordEditingController.value.text !=
                                  controller.conformPasswordEditingController
                                      .value.text &&
                              controller.driverModel.value.id == null) {
                            ShowToastDialog.showToast(
                                "Password and Confirm password doesn't match"
                                    .tr);
                          } else if (controller.selectedZone.value.id == null) {
                            ShowToastDialog.showToast("Please select zone".tr);
                          } else {
                            controller.signUpWithEmailAndPassword();
                          }
                        },
                      ),
                    ),
                  ),
                );
        });
  }
}
