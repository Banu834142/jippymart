import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:restaurant/constant/constant.dart';
import 'package:restaurant/controller/add_advertisement_controller.dart';
import 'package:restaurant/models/advertisement_model.dart';
import 'package:restaurant/themes/app_them_data.dart';
import 'package:restaurant/themes/responsive.dart';
import 'package:restaurant/themes/round_button_fill.dart';
import 'package:restaurant/themes/text_field_widget.dart';
import 'package:restaurant/utils/dark_theme_provider.dart';
import 'package:restaurant/utils/network_image_widget.dart';
import 'package:restaurant/widget/video_widget.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';

class AddAdvertisementScreen extends StatelessWidget {
  const AddAdvertisementScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final themeChange = Provider.of<DarkThemeProvider>(context);
    return GetX(
        init: AddAdvertisementController(),
        builder: (controller) {
          return Scaffold(
            appBar: AppBar(
                backgroundColor: AppThemeData.secondary300,
                centerTitle: false,
                titleSpacing: 0,
                iconTheme: IconThemeData(
                    color: themeChange.getThem()
                        ? AppThemeData.grey800
                        : AppThemeData.grey100,
                    size: 20),
                title: Text(
                  "Your Advertisement".tr,
                  style: TextStyle(
                      color: themeChange.getThem()
                          ? AppThemeData.grey800
                          : AppThemeData.grey100,
                      fontSize: 18,
                      fontFamily: AppThemeData.medium),
                )),
            body: controller.isLoading.value
                ? Constant.loader()
                : Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 10),
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          TextFieldWidget(
                            fontFamilyTitle: AppThemeData.semiBold,
                            title: 'Advertisement Title (Default)'.tr,
                            controller:
                                controller.advertisementTitleController.value,
                            hintText: 'Enter Title here'.tr,
                          ),
                          TextFieldWidget(
                            fontFamilyTitle: AppThemeData.semiBold,
                            title: 'Description:'.tr,
                            controller: controller.descriptionController.value,
                            maxLine: 5,
                            hintText: 'Enter the description'.tr,
                          ),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text("Advertisement Type".tr,
                                  style: TextStyle(
                                      fontFamily: AppThemeData.semiBold,
                                      fontSize: 14,
                                      color: themeChange.getThem()
                                          ? AppThemeData.grey100
                                          : AppThemeData.grey800)),
                              const SizedBox(
                                height: 5,
                              ),
                              DropdownButtonFormField<String>(
                                  hint: Text(
                                    'Select Type'.tr,
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: themeChange.getThem()
                                          ? AppThemeData.grey700
                                          : AppThemeData.grey700,
                                      fontFamily: AppThemeData.regular,
                                    ),
                                  ),
                                  icon: const Icon(Icons.keyboard_arrow_down),
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
                                  value: controller.selectedAdvertisementType
                                                  .value ==
                                              '' ||
                                          controller.selectedAdvertisementType
                                              .value.isEmpty
                                      ? null
                                      : controller
                                          .selectedAdvertisementType.value,
                                  onChanged: (value) {
                                    controller.selectedAdvertisementType.value =
                                        value!;
                                    controller.update();
                                  },
                                  style: TextStyle(
                                      fontSize: 14,
                                      color: themeChange.getThem()
                                          ? AppThemeData.grey50
                                          : AppThemeData.grey900,
                                      fontFamily: AppThemeData.medium),
                                  items:
                                      controller.advertisementType.map((name) {
                                    return DropdownMenuItem<String>(
                                      value: name,
                                      child: Text(name.toString()),
                                    );
                                  }).toList()),
                            ],
                          ),
                          Visibility(
                            visible:
                                controller.selectedAdvertisementType.value !=
                                    'Video Promotion',
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const SizedBox(
                                  height: 10,
                                ),
                                Text("Show Review & Ratings".tr,
                                    style: TextStyle(
                                        fontFamily: AppThemeData.semiBold,
                                        fontSize: 14,
                                        color: themeChange.getThem()
                                            ? AppThemeData.grey100
                                            : AppThemeData.grey800)),
                                const SizedBox(
                                  height: 5,
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Expanded(
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: [
                                          Checkbox(
                                            value: controller
                                                .isReviewSelected.value,
                                            onChanged: (bool? value) {
                                              controller.isReviewSelected
                                                  .value = value!;
                                            },
                                          ),
                                          Text("Review".tr),
                                        ],
                                      ),
                                    ),
                                    Expanded(
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: [
                                          Checkbox(
                                            value: controller
                                                .isRatingsSelected.value,
                                            onChanged: (bool? value) {
                                              controller.isRatingsSelected
                                                  .value = value!;
                                            },
                                          ),
                                          Text("Ratings".tr),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          Column(
                            children: [
                              const SizedBox(
                                height: 10,
                              ),
                              TextFieldWidget(
                                  fontFamilyTitle: AppThemeData.semiBold,
                                  isReadyOnly: true,
                                  onClick: () {
                                    dateValidityPicker(context, controller,
                                        themeChange.getThem());
                                  },
                                  title: 'Validity:'.tr,
                                  controller:
                                      controller.validityController.value,
                                  hintText: 'Select the date durations'.tr,
                                  suffix: Padding(
                                    padding: const EdgeInsets.all(12),
                                    child: SvgPicture.asset(
                                      'assets/icons/ic_calender.svg',
                                      color: themeChange.getThem()
                                          ? AppThemeData.grey600
                                          : AppThemeData.grey400,
                                    ),
                                  )),
                            ],
                          ),
                          Visibility(
                            visible:
                                controller.selectedAdvertisementType.value !=
                                    'Video Promotion',
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text("Upload Related Files".tr,
                                    style: TextStyle(
                                        fontFamily: AppThemeData.semiBold,
                                        fontSize: 16,
                                        color: themeChange.getThem()
                                            ? AppThemeData.grey100
                                            : AppThemeData.grey800)),
                                const SizedBox(
                                  height: 5,
                                ),
                                Row(
                                  children: [
                                    controller.profileImage.value.path
                                                .isEmpty &&
                                            controller
                                                    .profileImageString.value ==
                                                ''
                                        ? InkWell(
                                            onTap: () {
                                              buildProfileBottomSheet(
                                                  context, controller);
                                            },
                                            child: Container(
                                              decoration: BoxDecoration(
                                                border: Border.all(
                                                    width: 1,
                                                    color: themeChange.getThem()
                                                        ? AppThemeData.grey600
                                                        : AppThemeData.grey200),
                                                color: themeChange.getThem()
                                                    ? AppThemeData.grey900
                                                    : AppThemeData.grey50,
                                                borderRadius:
                                                    const BorderRadius.all(
                                                  Radius.circular(8),
                                                ),
                                              ),
                                              child: SizedBox(
                                                  height: Responsive.width(
                                                      30, context),
                                                  width: Responsive.width(
                                                      30, context),
                                                  child: Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .center,
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                    children: [
                                                      SvgPicture.asset(
                                                        'assets/icons/ic_folder.svg',
                                                      ),
                                                      const SizedBox(
                                                        height: 10,
                                                      ),
                                                    ],
                                                  )),
                                            ),
                                          )
                                        : SizedBox(
                                            height:
                                                Responsive.width(30, context),
                                            child: Column(
                                              children: [
                                                Expanded(
                                                  child: Padding(
                                                    padding: const EdgeInsets
                                                        .symmetric(
                                                        horizontal: 5),
                                                    child: Stack(
                                                      children: [
                                                        ClipRRect(
                                                          borderRadius:
                                                              const BorderRadius
                                                                  .all(Radius
                                                                      .circular(
                                                                          10)),
                                                          child: controller
                                                                          .profileImage
                                                                          .value
                                                                          .runtimeType ==
                                                                      XFile &&
                                                                  controller
                                                                          .profileImageString
                                                                          .value ==
                                                                      ''
                                                              ? Image.file(
                                                                  File(controller
                                                                      .profileImage
                                                                      .value
                                                                      .path),
                                                                  fit: BoxFit
                                                                      .cover,
                                                                  width: Responsive
                                                                      .width(30,
                                                                          context),
                                                                  height: Responsive
                                                                      .width(30,
                                                                          context),
                                                                )
                                                              : NetworkImageWidget(
                                                                  imageUrl:
                                                                      controller
                                                                          .profileImageString
                                                                          .value,
                                                                  fit: BoxFit
                                                                      .cover,
                                                                  width: Responsive
                                                                      .width(30,
                                                                          context),
                                                                  height: Responsive
                                                                      .width(30,
                                                                          context),
                                                                ),
                                                        ),
                                                        Positioned(
                                                          top: 8,
                                                          right: 8,
                                                          child: InkWell(
                                                            onTap: () {
                                                              controller
                                                                  .profileImageString
                                                                  .value = '';
                                                              controller
                                                                      .profileImage
                                                                      .value =
                                                                  XFile('');
                                                            },
                                                            child: const Icon(
                                                              Icons.delete,
                                                              size: 22,
                                                              color: AppThemeData
                                                                  .danger300,
                                                            ),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                                const SizedBox(
                                                  height: 10,
                                                ),
                                              ],
                                            ),
                                          ),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Text(
                                            "Profile Image (Ratio - 1:1)".tr,
                                            style: TextStyle(
                                                color: AppThemeData.danger300,
                                                fontFamily: AppThemeData.medium,
                                                fontSize: 14),
                                          ),
                                          const SizedBox(
                                            height: 5,
                                          ),
                                          Text(
                                            "Supports: PNG, JPG, JPEG, WEBP".tr,
                                            style: TextStyle(
                                                fontSize: 12,
                                                color: themeChange.getThem()
                                                    ? AppThemeData.grey200
                                                    : AppThemeData.grey700,
                                                fontFamily:
                                                    AppThemeData.regular),
                                          ),
                                          const SizedBox(
                                            height: 10,
                                          ),
                                          RoundedButtonFill(
                                            radius: 4,
                                            title: "Brows Image".tr,
                                            color: AppThemeData.secondary50,
                                            width: 30,
                                            height: 5,
                                            textColor:
                                                AppThemeData.secondary300,
                                            onPress: () async {
                                              buildProfileBottomSheet(
                                                  context, controller);
                                            },
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 10),
                                controller.coverImage.value.path.isEmpty &&
                                        controller.coverImageString.value == ''
                                    ? Container(
                                        decoration: BoxDecoration(
                                          border: Border.all(
                                              width: 1,
                                              color: themeChange.getThem()
                                                  ? AppThemeData.grey600
                                                  : AppThemeData.grey200),
                                          color: themeChange.getThem()
                                              ? AppThemeData.grey900
                                              : AppThemeData.grey50,
                                          borderRadius: const BorderRadius.all(
                                            Radius.circular(12),
                                          ),
                                        ),
                                        child: SizedBox(
                                            height:
                                                Responsive.height(20, context),
                                            width:
                                                Responsive.width(90, context),
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                SvgPicture.asset(
                                                  'assets/icons/ic_folder.svg',
                                                ),
                                                const SizedBox(
                                                  height: 10,
                                                ),
                                                Text(
                                                  "Upload Cover (Ratio - 2:1)"
                                                      .tr,
                                                  style: TextStyle(
                                                      color: AppThemeData
                                                          .danger300,
                                                      fontFamily:
                                                          AppThemeData.medium,
                                                      fontSize: 14),
                                                ),
                                                const SizedBox(
                                                  height: 5,
                                                ),
                                                Text(
                                                  "Supports: PNG, JPG, JPEG, WEBP"
                                                      .tr,
                                                  style: TextStyle(
                                                      fontSize: 12,
                                                      color: themeChange
                                                              .getThem()
                                                          ? AppThemeData.grey200
                                                          : AppThemeData
                                                              .grey700,
                                                      fontFamily:
                                                          AppThemeData.regular),
                                                ),
                                                const SizedBox(
                                                  height: 10,
                                                ),
                                                RoundedButtonFill(
                                                  radius: 4,
                                                  title: "Brows Image".tr,
                                                  color:
                                                      AppThemeData.secondary50,
                                                  width: 30,
                                                  height: 5,
                                                  textColor:
                                                      AppThemeData.secondary300,
                                                  onPress: () async {
                                                    buildCoverBottomSheet(
                                                        context, controller);
                                                  },
                                                ),
                                              ],
                                            )),
                                      )
                                    : SizedBox(
                                        height: Responsive.height(20, context),
                                        width: Responsive.width(90, context),
                                        child: Column(
                                          children: [
                                            Expanded(
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        horizontal: 5),
                                                child: Stack(
                                                  children: [
                                                    ClipRRect(
                                                      borderRadius:
                                                          const BorderRadius
                                                              .all(
                                                              Radius.circular(
                                                                  10)),
                                                      child: controller
                                                                      .coverImage
                                                                      .value
                                                                      .runtimeType ==
                                                                  XFile &&
                                                              controller
                                                                      .coverImageString
                                                                      .value ==
                                                                  ''
                                                          ? Image.file(
                                                              File(controller
                                                                  .coverImage
                                                                  .value
                                                                  .path),
                                                              fit: BoxFit.cover,
                                                              height: Responsive
                                                                  .height(20,
                                                                      context),
                                                              width: Responsive
                                                                  .width(90,
                                                                      context),
                                                            )
                                                          : NetworkImageWidget(
                                                              imageUrl: controller
                                                                  .coverImageString
                                                                  .value,
                                                              fit: BoxFit.cover,
                                                              height: Responsive
                                                                  .height(20,
                                                                      context),
                                                              width: Responsive
                                                                  .width(90,
                                                                      context),
                                                            ),
                                                    ),
                                                    Positioned(
                                                      top: 8,
                                                      right: 8,
                                                      child: InkWell(
                                                        onTap: () {
                                                          controller
                                                              .coverImageString
                                                              .value = '';
                                                          controller.coverImage
                                                                  .value =
                                                              XFile('');
                                                        },
                                                        child: const Icon(
                                                          Icons.delete,
                                                          size: 22,
                                                          color: AppThemeData
                                                              .danger300,
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                            const SizedBox(
                                              height: 10,
                                            ),
                                          ],
                                        ),
                                      ),
                              ],
                            ),
                          ),
                          if (controller.selectedAdvertisementType.value ==
                              'Video Promotion')
                            controller.thumbnailFile.value.path.isEmpty &&
                                    controller.thumbnailFileString.value == ''
                                ? Container(
                                    decoration: BoxDecoration(
                                      border: Border.all(
                                          width: 1,
                                          color: themeChange.getThem()
                                              ? AppThemeData.grey600
                                              : AppThemeData.grey200),
                                      color: themeChange.getThem()
                                          ? AppThemeData.grey900
                                          : AppThemeData.grey50,
                                      borderRadius: const BorderRadius.all(
                                        Radius.circular(12),
                                      ),
                                    ),
                                    child: SizedBox(
                                        height: Responsive.height(20, context),
                                        width: Responsive.width(90, context),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            SvgPicture.asset(
                                              'assets/icons/ic_folder.svg',
                                            ),
                                            const SizedBox(
                                              height: 10,
                                            ),
                                            Text(
                                              "Upload Video (Ratio - 2:1)".tr,
                                              style: TextStyle(
                                                  color: AppThemeData.danger300,
                                                  fontFamily:
                                                      AppThemeData.medium,
                                                  fontSize: 14),
                                            ),
                                            const SizedBox(
                                              height: 5,
                                            ),
                                            Text(
                                              "Supports: Mp4 and Webm".tr,
                                              style: TextStyle(
                                                  fontSize: 12,
                                                  color: themeChange.getThem()
                                                      ? AppThemeData.grey200
                                                      : AppThemeData.grey700,
                                                  fontFamily:
                                                      AppThemeData.regular),
                                            ),
                                            const SizedBox(
                                              height: 10,
                                            ),
                                            RoundedButtonFill(
                                              radius: 4,
                                              title: "Upload Video".tr,
                                              color: AppThemeData.secondary50,
                                              width: 30,
                                              height: 5,
                                              textColor:
                                                  AppThemeData.secondary300,
                                              onPress: () async {
                                                onCameraClick(
                                                    context, controller);
                                              },
                                            ),
                                          ],
                                        )),
                                  )
                                : SizedBox(
                                    height: Responsive.height(20, context),
                                    width: Responsive.width(90, context),
                                    child: Column(
                                      children: [
                                        Expanded(
                                          child: Padding(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 5),
                                            child: Stack(
                                              children: [
                                                ClipRRect(
                                                    borderRadius: const BorderRadius.all(
                                                        Radius.circular(10)),
                                                    child: controller
                                                                    .thumbnailFile
                                                                    .value
                                                                    .runtimeType ==
                                                                XFile &&
                                                            controller
                                                                    .thumbnailFileString
                                                                    .value ==
                                                                ''
                                                        ? VideoAdvWidget(
                                                            width:
                                                                MediaQuery.of(context)
                                                                    .size
                                                                    .width,
                                                            url: File(controller
                                                                .thumbnailFile
                                                                .value
                                                                .path))
                                                        : VideoAdvWidget(
                                                            width: MediaQuery.of(context).size.width,
                                                            url: controller.thumbnailFileString.value)),
                                                Positioned(
                                                  top: 8,
                                                  right: 8,
                                                  child: InkWell(
                                                    onTap: () {
                                                      controller
                                                          .thumbnailFileString
                                                          .value = '';
                                                      controller.thumbnailFile
                                                          .value = XFile('');
                                                    },
                                                    child: const Icon(
                                                      Icons.delete,
                                                      size: 22,
                                                      color: AppThemeData
                                                          .danger300,
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                        const SizedBox(
                                          height: 10,
                                        ),
                                      ],
                                    ),
                                  ),
                          const SizedBox(
                            height: 10,
                          ),
                        ],
                      ),
                    ),
                  ),
            bottomNavigationBar: Row(
              children: [
                if (controller.advertisementModel.value.id == null)
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                      ),
                      child: Padding(
                        padding: const EdgeInsets.only(bottom: 26),
                        child: RoundedButtonFill(
                          radius: 12,
                          title: "Reset".tr,
                          height: 5.5,
                          color: AppThemeData.grey200,
                          textColor: AppThemeData.grey900,
                          fontSizes: 16,
                          onPress: () async {
                            controller.reset();
                          },
                        ),
                      ),
                    ),
                  ),
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                    ),
                    child: Padding(
                      padding: const EdgeInsets.only(bottom: 26),
                      child: RoundedButtonFill(
                        radius: 12,
                        title: controller.advertisementModel.value.id != null
                            ? "Edit & Save".tr
                            : "Submit".tr,
                        height: 5.5,
                        color: themeChange.getThem()
                            ? AppThemeData.secondary300
                            : AppThemeData.secondary300,
                        textColor: themeChange.getThem()
                            ? AppThemeData.grey900
                            : AppThemeData.grey50,
                        fontSizes: 16,
                        onPress: () async {
                          AdvertisementModel? model =
                              await controller.saveAdvDetails();
                          if (model?.id != null) {
                            if (controller.advertisementModel.value.id ==
                                    null ||
                                controller.isCopy.value == true) {
                              Get.back(result: "Save");
                            } else {
                              Get.back(result: true);
                              Get.back(result: true);
                            }
                          }
                        },
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        });
  }

  buildProfileBottomSheet(
      BuildContext context, AddAdvertisementController controller) {
    return showModalBottomSheet(
        context: context,
        builder: (context) {
          final themeChange = Provider.of<DarkThemeProvider>(context);
          return StatefulBuilder(builder: (context, setState) {
            return SizedBox(
              height: Responsive.height(22, context),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 15),
                    child: Text(
                      "Please Select".tr,
                      style: TextStyle(
                          color: themeChange.getThem()
                              ? AppThemeData.grey50
                              : AppThemeData.grey900,
                          fontFamily: AppThemeData.bold,
                          fontSize: 16),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(18.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            IconButton(
                                onPressed: () => controller.profilePickFile(
                                    source: ImageSource.camera),
                                icon: const Icon(
                                  Icons.camera_alt,
                                  size: 32,
                                )),
                            Padding(
                              padding: const EdgeInsets.only(top: 3),
                              child: Text("Camera".tr),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(18.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            IconButton(
                                onPressed: () => controller.profilePickFile(
                                    source: ImageSource.gallery),
                                icon: const Icon(
                                  Icons.photo_library_sharp,
                                  size: 32,
                                )),
                            Padding(
                              padding: const EdgeInsets.only(top: 3),
                              child: Text("Gallery".tr),
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                ],
              ),
            );
          });
        });
  }

  buildCoverBottomSheet(
      BuildContext context, AddAdvertisementController controller) {
    return showModalBottomSheet(
        context: context,
        builder: (context) {
          final themeChange = Provider.of<DarkThemeProvider>(context);
          return StatefulBuilder(builder: (context, setState) {
            return SizedBox(
              height: Responsive.height(22, context),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 15),
                    child: Text(
                      "Please Select".tr,
                      style: TextStyle(
                          color: themeChange.getThem()
                              ? AppThemeData.grey50
                              : AppThemeData.grey900,
                          fontFamily: AppThemeData.bold,
                          fontSize: 16),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(18.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            IconButton(
                                onPressed: () => controller.coverPickFile(
                                    source: ImageSource.camera),
                                icon: const Icon(
                                  Icons.camera_alt,
                                  size: 32,
                                )),
                            Padding(
                              padding: const EdgeInsets.only(top: 3),
                              child: Text("Camera".tr),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(18.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            IconButton(
                                onPressed: () => controller.coverPickFile(
                                    source: ImageSource.gallery),
                                icon: const Icon(
                                  Icons.photo_library_sharp,
                                  size: 32,
                                )),
                            Padding(
                              padding: const EdgeInsets.only(top: 3),
                              child: Text("Gallery".tr),
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                ],
              ),
            );
          });
        });
  }
}

String prettyDuration(double duration) {
  var seconds = duration / 1000.round();
  return '$seconds';
}

dateValidityPicker(BuildContext context, AddAdvertisementController controller,
    bool isDarkMode) {
  return showModalBottomSheet(
    context: context,
    builder: (BuildContext context) {
      return Container(
        height: 440, // Height of the bottom sheet
        color: isDarkMode ? AppThemeData.grey900 : AppThemeData.grey50,
        child: Column(
          children: [
            SfDateRangePicker(
              backgroundColor:
                  isDarkMode ? AppThemeData.grey900 : AppThemeData.grey50,
              onSelectionChanged: (DateRangePickerSelectionChangedArgs args) {
                if (args.value is PickerDateRange) {
                  controller.startValidityDate.value = args.value.startDate;
                  controller.endValidityDate.value = args.value.endDate;
                }
              },
              selectionMode: DateRangePickerSelectionMode.range,
              minDate: DateTime.now(),
              maxDate: DateTime.now().add(Duration(days: 5 * 365)),
              initialSelectedRange: PickerDateRange(
                controller.startValidityDate.value,
                controller.endValidityDate.value,
              ),
            ),
            SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: RoundedButtonFill(
                title: "Apply".tr,
                color: AppThemeData.secondary300,
                textColor:
                    isDarkMode ? AppThemeData.grey900 : AppThemeData.grey50,
                onPress: () async {
                  Get.back();
                  controller.selectValidityDate();
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: RoundedButtonFill(
                title: "Cancel".tr,
                color: isDarkMode ? AppThemeData.grey900 : AppThemeData.grey50,
                textColor: AppThemeData.secondary300,
                onPress: () async {
                  Get.back();
                  controller.validityController.value.text = '';
                },
              ),
            ),
          ],
        ),
      );
    },
  );
}

final ImagePicker imagePickerForVideo = ImagePicker();

onCameraClick(BuildContext context, AddAdvertisementController controller) {
  final action = CupertinoActionSheet(
    message: Text(
      'Send Video'.tr,
      style: TextStyle(fontSize: 15.0),
    ),
    actions: <Widget>[
      CupertinoActionSheetAction(
        isDefaultAction: false,
        onPressed: () async {
          Navigator.pop(context);
          XFile? galleryVideo =
              await imagePickerForVideo.pickVideo(source: ImageSource.gallery);
          if (galleryVideo != null) {
            controller.thumbnailFile.value = XFile('');
            controller.thumbnailFile.value = galleryVideo;
          }
        },
        child: Text('Choose Video File'.tr),
      ),
    ],
    cancelButton: CupertinoActionSheetAction(
      child: Text(
        'Cancel'.tr,
      ),
      onPressed: () {
        Navigator.pop(context);
      },
    ),
  );
  showCupertinoModalPopup(context: context, builder: (context) => action);
}
