import 'dart:io';

import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:restaurant/constant/constant.dart';
import 'package:restaurant/constant/show_toast_dialog.dart';
import 'package:restaurant/controller/dine_in_create_controller.dart';
import 'package:restaurant/themes/app_them_data.dart';
import 'package:restaurant/themes/responsive.dart';
import 'package:restaurant/themes/round_button_fill.dart';
import 'package:restaurant/themes/text_field_widget.dart';
import 'package:restaurant/utils/dark_theme_provider.dart';
import 'package:restaurant/utils/network_image_widget.dart';

class DineInCreateScreen extends StatelessWidget {
  const DineInCreateScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final themeChange = Provider.of<DarkThemeProvider>(context);
    return GetX(
        init: DineInCreateController(),
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
                "Add Dine in".tr,
                style: TextStyle(
                    color: themeChange.getThem()
                        ? AppThemeData.grey800
                        : AppThemeData.grey100,
                    fontSize: 18,
                    fontFamily: AppThemeData.medium),
              ),
            ),
            body: controller.isLoading.value
                ? Constant.loader()
                : Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 10),
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Expanded(
                                child: Text(
                                  "Active".tr,
                                  style: TextStyle(
                                    color: themeChange.getThem()
                                        ? AppThemeData.grey100
                                        : AppThemeData.grey800,
                                    fontSize: 18,
                                    fontFamily: AppThemeData.medium,
                                  ),
                                ),
                              ),
                              Transform.scale(
                                scale: 0.8,
                                child: CupertinoSwitch(
                                  value: controller.active.value,
                                  onChanged: (value) {
                                    controller.active.value = value;
                                  },
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          DottedBorder(
                            borderType: BorderType.RRect,
                            radius: const Radius.circular(12),
                            dashPattern: const [6, 6, 6, 6],
                            color: themeChange.getThem()
                                ? AppThemeData.grey700
                                : AppThemeData.grey200,
                            child: Container(
                              decoration: BoxDecoration(
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
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      SvgPicture.asset(
                                        'assets/icons/ic_folder.svg',
                                      ),
                                      const SizedBox(
                                        height: 10,
                                      ),
                                      Text(
                                        "Choose a image and upload here".tr,
                                        style: TextStyle(
                                            color: themeChange.getThem()
                                                ? AppThemeData.grey100
                                                : AppThemeData.grey800,
                                            fontFamily: AppThemeData.medium,
                                            fontSize: 16),
                                      ),
                                      const SizedBox(
                                        height: 5,
                                      ),
                                      Text(
                                        "JPEG, PNG".tr,
                                        style: TextStyle(
                                            fontSize: 12,
                                            color: themeChange.getThem()
                                                ? AppThemeData.grey200
                                                : AppThemeData.grey700,
                                            fontFamily: AppThemeData.regular),
                                      ),
                                      const SizedBox(
                                        height: 10,
                                      ),
                                      RoundedButtonFill(
                                        title: "Brows Image".tr,
                                        color: AppThemeData.secondary50,
                                        width: 30,
                                        height: 5,
                                        textColor: AppThemeData.secondary300,
                                        onPress: () async {
                                          buildBottomSheet(context, controller);
                                        },
                                      ),
                                    ],
                                  )),
                            ),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          SizedBox(
                            height: 80,
                            child: ListView.builder(
                              itemCount: controller.images.length,
                              shrinkWrap: true,
                              scrollDirection: Axis.horizontal,
                              physics: const NeverScrollableScrollPhysics(),
                              itemBuilder: (context, index) {
                                return Padding(
                                  padding:
                                      const EdgeInsets.symmetric(horizontal: 5),
                                  child: Stack(
                                    children: [
                                      ClipRRect(
                                        borderRadius: const BorderRadius.all(
                                            Radius.circular(10)),
                                        child: controller.images[index]
                                                    .runtimeType ==
                                                XFile
                                            ? Image.file(
                                                File(controller
                                                    .images[index].path),
                                                fit: BoxFit.cover,
                                                width: 80,
                                                height: 80,
                                              )
                                            : NetworkImageWidget(
                                                imageUrl:
                                                    controller.images[index],
                                                fit: BoxFit.cover,
                                                width: 80,
                                                height: 80,
                                              ),
                                      ),
                                      Positioned(
                                        bottom: 0,
                                        top: 0,
                                        left: 0,
                                        right: 0,
                                        child: InkWell(
                                          onTap: () {
                                            controller.images.removeAt(index);
                                          },
                                          child: const Icon(
                                            Icons.remove_circle,
                                            size: 28,
                                            color: AppThemeData.danger300,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              },
                            ),
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          TextFieldWidget(
                            title: 'Price (approx for 2 per.)'.tr,
                            controller: controller.priceController.value,
                            hintText: 'Enter price for 2 per.'.tr,
                            textInputType:
                                const TextInputType.numberWithOptions(
                                    signed: true, decimal: true),
                            textInputAction: TextInputAction.done,
                            inputFormatters: [
                              FilteringTextInputFormatter.allow(
                                  RegExp('[0-9]')),
                            ],
                            prefix: Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 16, vertical: 14),
                              child: Text(
                                "${Constant.currencyModel!.symbol}".tr,
                                style: TextStyle(
                                    color: themeChange.getThem()
                                        ? AppThemeData.grey50
                                        : AppThemeData.grey900,
                                    fontFamily: AppThemeData.semiBold,
                                    fontSize: 18),
                              ),
                            ),
                          ),
                          Text(
                            'Timing'.tr,
                            style: TextStyle(
                              fontFamily: AppThemeData.medium,
                              fontSize: 16,
                              color: themeChange.getThem()
                                  ? AppThemeData.grey50
                                  : AppThemeData.grey900,
                            ),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          Row(
                            children: [
                              Expanded(
                                child: InkWell(
                                  onTap: () async {
                                    TimeOfDay? pickedTime =
                                        await showTimePicker(
                                      initialTime: TimeOfDay.now(),
                                      context: context,
                                    );

                                    if (pickedTime != null) {
                                      controller
                                              .startDateController.value.text =
                                          pickedTime
                                              .format(context); //set the value
                                    }
                                  },
                                  child: TextFieldWidget(
                                    controller:
                                        controller.startDateController.value,
                                    hintText: '6:00 AM',
                                    enable: false,
                                    prefix: Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 16, vertical: 14),
                                      child: SvgPicture.asset(
                                        "assets/icons/ic_alarm-clock.svg",
                                        colorFilter: ColorFilter.mode(
                                            themeChange.getThem()
                                                ? AppThemeData.grey50
                                                : AppThemeData.grey800,
                                            BlendMode.srcIn),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(
                                width: 10,
                              ),
                              Expanded(
                                child: InkWell(
                                  onTap: () async {
                                    TimeOfDay? pickedTime =
                                        await showTimePicker(
                                      initialTime: TimeOfDay.now(),
                                      context: context,
                                    );
                                    if (pickedTime != null) {
                                      controller.endDateDateController.value
                                          .text = pickedTime.format(context);

                                      DateTime startDate = DateFormat("hh:mm a")
                                          .parse(controller
                                              .startDateController.value.text
                                              .toString());
                                      DateTime endDate = DateFormat("hh:mm a")
                                          .parse(controller
                                              .endDateDateController.value.text
                                              .toString());

                                      if (endDate.isAfter(startDate)) {
                                        controller.isTimeValid.value = true;
                                      } else {
                                        controller.isTimeValid.value = false;
                                      }
                                    }
                                  },
                                  child: TextFieldWidget(
                                    controller:
                                        controller.endDateDateController.value,
                                    hintText: '9:00 PM',
                                    enable: false,
                                    prefix: Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 16, vertical: 14),
                                      child: SvgPicture.asset(
                                        "assets/icons/ic_alarm-clock.svg",
                                        colorFilter: ColorFilter.mode(
                                            themeChange.getThem()
                                                ? AppThemeData.grey50
                                                : AppThemeData.grey800,
                                            BlendMode.srcIn),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          )
                        ],
                      ),
                    ),
                  ),
            bottomNavigationBar: Container(
              color: themeChange.getThem()
                  ? AppThemeData.grey900
                  : AppThemeData.grey50,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
              child: Padding(
                  padding: const EdgeInsets.only(bottom: 20),
                  child: RoundedButtonFill(
                    title: "Save Details".tr,
                    height: 5.5,
                    color: AppThemeData.secondary300,
                    textColor: AppThemeData.grey50,
                    fontSizes: 16,
                    onPress: () async {
                      if (controller.priceController.value.text.isEmpty) {
                        ShowToastDialog.showToast("Please Enter Price".tr);
                      } else if (controller
                          .startDateController.value.text.isEmpty) {
                        ShowToastDialog.showToast(
                            "Please select start time".tr);
                      } else if (controller
                          .endDateDateController.value.text.isEmpty) {
                        ShowToastDialog.showToast("Please select end time".tr);
                      } else {
                        controller.saveDetails();
                      }
                    },
                  )),
            ),
          );
        });
  }

  buildBottomSheet(BuildContext context, DineInCreateController controller) {
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
                                onPressed: () => controller.pickFile(
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
                                onPressed: () => controller.pickFile(
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
