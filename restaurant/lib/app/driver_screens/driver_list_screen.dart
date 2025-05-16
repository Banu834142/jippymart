import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:restaurant/app/add_restaurant_screen/add_restaurant_screen.dart';
import 'package:restaurant/app/driver_screens/add_driver_screen.dart';
import 'package:restaurant/app/verification_screen/verification_screen.dart';
import 'package:restaurant/constant/constant.dart';
import 'package:restaurant/controller/driver_list_controller.dart';
import 'package:restaurant/themes/app_them_data.dart';
import 'package:restaurant/themes/responsive.dart';
import 'package:restaurant/themes/round_button_fill.dart';
import 'package:restaurant/utils/dark_theme_provider.dart';
import 'package:restaurant/utils/network_image_widget.dart';

class DriverListScreen extends StatelessWidget {
  const DriverListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final themeChange = Provider.of<DarkThemeProvider>(context);
    return GetX(
        init: DriverListController(),
        builder: (controller) {
          return Scaffold(
            appBar: AppBar(
              backgroundColor: AppThemeData.secondary300,
              centerTitle: false,
              iconTheme: IconThemeData(
                  color: themeChange.getThem()
                      ? AppThemeData.grey800
                      : AppThemeData.grey100,
                  size: 20),
              title: Text(
                "Manage Delivery Man".tr,
                style: TextStyle(
                    color: themeChange.getThem()
                        ? AppThemeData.grey900
                        : AppThemeData.grey50,
                    fontSize: 18,
                    fontFamily: AppThemeData.medium),
              ),
              actions: [
                ((Constant.isRestaurantVerification == true &&
                            Constant.userModel?.isDocumentVerify == false) ||
                        (Constant.userModel?.vendorID == null ||
                            Constant.userModel?.vendorID?.isEmpty == true))
                    ? SizedBox()
                    : InkWell(
                        splashColor: Colors.transparent,
                        onTap: () {
                          Get.to(const AddDriverScreen())?.then((value) {
                            if (value == true) {
                              controller.getAllDriverList();
                            }
                          });
                        },
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          child: Row(
                            children: [
                              Icon(
                                Icons.add,
                                color: themeChange.getThem()
                                    ? AppThemeData.grey50
                                    : AppThemeData.grey50,
                              ),
                              const SizedBox(
                                width: 5,
                              ),
                              Text(
                                "Add".tr,
                                style: TextStyle(
                                    color: themeChange.getThem()
                                        ? AppThemeData.grey50
                                        : AppThemeData.grey50,
                                    fontSize: 18,
                                    fontFamily: AppThemeData.medium),
                              )
                            ],
                          ),
                        ),
                      )
              ],
            ),
            body: controller.isLoading.value
                ? Constant.loader()
                : (Constant.isRestaurantVerification == true &&
                        Constant.userModel?.isDocumentVerify == false)
                    ? Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Container(
                              decoration: ShapeDecoration(
                                color: themeChange.getThem()
                                    ? AppThemeData.grey700
                                    : AppThemeData.grey200,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(120),
                                ),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(20),
                                child: SvgPicture.asset(
                                    "assets/icons/ic_document.svg"),
                              ),
                            ),
                            const SizedBox(
                              height: 12,
                            ),
                            Text(
                              "Document Verification in Pending".tr,
                              style: TextStyle(
                                  color: themeChange.getThem()
                                      ? AppThemeData.grey100
                                      : AppThemeData.grey800,
                                  fontSize: 22,
                                  fontFamily: AppThemeData.semiBold),
                            ),
                            const SizedBox(
                              height: 5,
                            ),
                            Text(
                              "Your documents are being reviewed. We will notify you once the verification is complete."
                                  .tr,
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  color: themeChange.getThem()
                                      ? AppThemeData.grey50
                                      : AppThemeData.grey500,
                                  fontSize: 16,
                                  fontFamily: AppThemeData.bold),
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            RoundedButtonFill(
                              title: "View Status".tr,
                              width: 55,
                              height: 5.5,
                              color: AppThemeData.secondary300,
                              textColor: AppThemeData.grey50,
                              onPress: () async {
                                Get.to(const VerificationScreen());
                              },
                            ),
                          ],
                        ),
                      )
                    : (Constant.userModel?.vendorID?.isEmpty == true ||
                            Constant.userModel?.vendorID == null)
                        ? Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Container(
                                  decoration: ShapeDecoration(
                                    color: themeChange.getThem()
                                        ? AppThemeData.grey700
                                        : AppThemeData.grey200,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(120),
                                    ),
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.all(20),
                                    child: SvgPicture.asset(
                                        "assets/icons/ic_building_two.svg"),
                                  ),
                                ),
                                const SizedBox(
                                  height: 12,
                                ),
                                Text(
                                  "Add Your First Restaurant".tr,
                                  style: TextStyle(
                                      color: themeChange.getThem()
                                          ? AppThemeData.grey100
                                          : AppThemeData.grey800,
                                      fontSize: 22,
                                      fontFamily: AppThemeData.semiBold),
                                ),
                                const SizedBox(
                                  height: 5,
                                ),
                                Text(
                                  "Get started by adding your restaurant details to manage your delivery men."
                                      .tr,
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      color: themeChange.getThem()
                                          ? AppThemeData.grey50
                                          : AppThemeData.grey500,
                                      fontSize: 16,
                                      fontFamily: AppThemeData.bold),
                                ),
                                const SizedBox(
                                  height: 20,
                                ),
                                RoundedButtonFill(
                                  title: "Add Restaurant".tr,
                                  width: 55,
                                  height: 5.5,
                                  color: AppThemeData.secondary300,
                                  textColor: AppThemeData.grey50,
                                  onPress: () async {
                                    Get.to(const AddRestaurantScreen());
                                  },
                                ),
                              ],
                            ),
                          )
                        : controller.driverUserList.isEmpty
                            ? Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 16),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    SvgPicture.asset(
                                      "assets/icons/ic_manage_deliveryman.svg",
                                    ),
                                    const SizedBox(
                                      height: 12,
                                    ),
                                    Text(
                                      "No Delivery Men Available".tr,
                                      style: TextStyle(
                                          color: themeChange.getThem()
                                              ? AppThemeData.grey100
                                              : AppThemeData.grey800,
                                          fontSize: 22,
                                          fontFamily: AppThemeData.semiBold),
                                    ),
                                    const SizedBox(
                                      height: 5,
                                    ),
                                    Text(
                                      "No Delivery Men found! Add your first Delivery Man to start using the self-delivery feature."
                                          .tr,
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                          color: themeChange.getThem()
                                              ? AppThemeData.grey50
                                              : AppThemeData.grey500,
                                          fontSize: 16,
                                          fontFamily: AppThemeData.bold),
                                    ),
                                    const SizedBox(
                                      height: 20,
                                    ),
                                    RoundedButtonFill(
                                        title: "Add Delivery Man".tr,
                                        width: 55,
                                        height: 5.5,
                                        color: AppThemeData.secondary300,
                                        textColor: AppThemeData.grey50,
                                        onPress: () async {
                                          Get.to(const AddDriverScreen())
                                              ?.then((value) {
                                            if (value == true) {
                                              controller.getAllDriverList();
                                            }
                                          });
                                        }),
                                  ],
                                ),
                              )
                            : Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 16, vertical: 10),
                                child: ListView.builder(
                                  itemCount: controller.driverUserList.length,
                                  shrinkWrap: true,
                                  itemBuilder: (context, index) {
                                    return InkWell(
                                      onTap: () {
                                        Get.to(const AddDriverScreen(),
                                                arguments: {
                                              "driverModel": controller
                                                  .driverUserList[index]
                                            })!
                                            .then(
                                          (value) {
                                            if (value == true) {
                                              controller.getAllDriverList();
                                            }
                                          },
                                        );
                                      },
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 5),
                                        child: Container(
                                          decoration: ShapeDecoration(
                                            color: themeChange.getThem()
                                                ? AppThemeData.grey900
                                                : AppThemeData.grey50,
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(16),
                                            ),
                                          ),
                                          child: Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Row(
                                              children: [
                                                controller.driverUserList[index]
                                                                .profilePictureURL ==
                                                            null ||
                                                        controller
                                                                .driverUserList[
                                                                    index]
                                                                .profilePictureURL ==
                                                            ''
                                                    ? ClipRRect(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(60),
                                                        child: Image.asset(
                                                          Constant
                                                              .userPlaceHolder,
                                                          height:
                                                              Responsive.width(
                                                                  20, context),
                                                          width:
                                                              Responsive.width(
                                                                  20, context),
                                                          fit: BoxFit.cover,
                                                        ),
                                                      )
                                                    : ClipRRect(
                                                        borderRadius:
                                                            const BorderRadius
                                                                .all(
                                                                Radius.circular(
                                                                    60)),
                                                        child:
                                                            NetworkImageWidget(
                                                          imageUrl: controller
                                                              .driverUserList[
                                                                  index]
                                                              .profilePictureURL
                                                              .toString(),
                                                          fit: BoxFit.cover,
                                                          height:
                                                              Responsive.width(
                                                                  20, context),
                                                          width:
                                                              Responsive.width(
                                                                  20, context),
                                                        )),
                                                const SizedBox(
                                                  width: 10,
                                                ),
                                                Expanded(
                                                  child: SizedBox(
                                                    height: Responsive.width(
                                                        18, context),
                                                    child: Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceEvenly,
                                                      children: [
                                                        Text(
                                                          "${controller.driverUserList[index].firstName ?? ''} ${controller.driverUserList[index].lastName ?? ''}",
                                                          style: TextStyle(
                                                            fontSize: 18,
                                                            color: themeChange
                                                                    .getThem()
                                                                ? AppThemeData
                                                                    .grey50
                                                                : AppThemeData
                                                                    .grey900,
                                                            fontFamily:
                                                                AppThemeData
                                                                    .semiBold,
                                                            fontWeight:
                                                                FontWeight.w600,
                                                          ),
                                                        ),
                                                        Text(
                                                          "${controller.driverUserList[index].countryCode} ${controller.driverUserList[index].phoneNumber}",
                                                          maxLines: 1,
                                                          style: TextStyle(
                                                            fontSize: 14,
                                                            color: themeChange
                                                                    .getThem()
                                                                ? AppThemeData
                                                                    .grey50
                                                                : AppThemeData
                                                                    .grey900,
                                                            fontFamily:
                                                                AppThemeData
                                                                    .regular,
                                                          ),
                                                        ),
                                                        Text(
                                                          controller
                                                              .driverUserList[
                                                                  index]
                                                              .email
                                                              .toString(),
                                                          maxLines: 1,
                                                          style: TextStyle(
                                                            fontSize: 14,
                                                            color: themeChange
                                                                    .getThem()
                                                                ? AppThemeData
                                                                    .grey50
                                                                : AppThemeData
                                                                    .grey900,
                                                            fontFamily:
                                                                AppThemeData
                                                                    .regular,
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                                GetBuilder<
                                                        DriverListController>(
                                                    builder: (controller) {
                                                  return Transform.scale(
                                                    scale: 0.8,
                                                    child: CupertinoSwitch(
                                                      value: controller
                                                              .driverUserList[
                                                                  index]
                                                              .active ??
                                                          false,
                                                      onChanged: (value) {
                                                        controller
                                                            .driverUserList[
                                                                index]
                                                            .active = value;
                                                        controller.updateDriver(
                                                            controller
                                                                    .driverUserList[
                                                                index]);
                                                        controller.update();
                                                      },
                                                    ),
                                                  );
                                                }),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              ),
          );
        });
  }
}
