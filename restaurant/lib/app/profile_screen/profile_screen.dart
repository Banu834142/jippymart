import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:in_app_review/in_app_review.dart';
import 'package:provider/provider.dart';
import 'package:restaurant/app/add_advertisement_screen/advertisement_list_screen.dart';
import 'package:restaurant/app/add_restaurant_screen/add_restaurant_screen.dart';
import 'package:restaurant/app/add_story_screen/add_story_screen.dart';
import 'package:restaurant/app/auth_screen/login_screen.dart';
import 'package:restaurant/app/change%20langauge/change_language_screen.dart';
import 'package:restaurant/app/dine_in_screen/dine_in_create_screen.dart';
import 'package:restaurant/app/driver_screens/driver_list_screen.dart';
import 'package:restaurant/app/edit_profile_screen/edit_profile_screen.dart';
import 'package:restaurant/app/offer_screens/offer_screen.dart';
import 'package:restaurant/app/special_discount_screen/special_discount_screen.dart';
import 'package:restaurant/app/subscription_plan_screen/subscription_history_screen.dart';
import 'package:restaurant/app/subscription_plan_screen/subscription_plan_screen.dart';
import 'package:restaurant/app/terms_and_condition/terms_and_condition_screen.dart';
import 'package:restaurant/app/verification_screen/verification_screen.dart';
import 'package:restaurant/app/withdraw_method_setup_screens/withdraw_method_setup_screen.dart';
import 'package:restaurant/app/working_hours_screen/working_hours_screen.dart';
import 'package:restaurant/constant/constant.dart';
import 'package:restaurant/constant/show_toast_dialog.dart';
import 'package:restaurant/controller/dash_board_controller.dart';
import 'package:restaurant/controller/profile_controller.dart';
import 'package:restaurant/models/user_model.dart';
import 'package:restaurant/service/audio_player_service.dart';
import 'package:restaurant/themes/app_them_data.dart';
import 'package:restaurant/themes/custom_dialog_box.dart';
import 'package:restaurant/themes/responsive.dart';
import 'package:restaurant/themes/round_button_fill.dart';
import 'package:restaurant/utils/dark_theme_provider.dart';
import 'package:restaurant/utils/fire_store_utils.dart';
import 'package:restaurant/utils/network_image_widget.dart';
import 'package:restaurant/utils/preferences.dart';
import 'package:share_plus/share_plus.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final themeChange = Provider.of<DarkThemeProvider>(context);
    return GetX(
        init: ProfileController(),
        builder: (controller) {
          return Scaffold(
            appBar: AppBar(
              backgroundColor: AppThemeData.secondary300,
              centerTitle: false,
              iconTheme:
                  const IconThemeData(color: AppThemeData.grey50, size: 20),
              title: Text(
                "Restaurant Profile".tr,
                style: TextStyle(
                    color: themeChange.getThem()
                        ? AppThemeData.grey900
                        : AppThemeData.grey50,
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
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 20),
                            child: Row(
                              children: [
                                ClipOval(
                                  child: NetworkImageWidget(
                                    imageUrl: controller
                                        .userModel.value.profilePictureURL
                                        .toString(),
                                    width: 80,
                                    height: 80,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                                const SizedBox(
                                  width: 20,
                                ),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        "${controller.userModel.value.fullName()}",
                                        style: TextStyle(
                                            color: themeChange.getThem()
                                                ? AppThemeData.grey50
                                                : AppThemeData.grey900,
                                            fontFamily: AppThemeData.semiBold,
                                            fontWeight: FontWeight.w500,
                                            fontSize: 18),
                                      ),
                                      Text(
                                        controller.userModel.value.email ?? '',
                                        style: TextStyle(
                                            color: themeChange.getThem()
                                                ? AppThemeData.grey400
                                                : AppThemeData.grey500,
                                            fontFamily: AppThemeData.regular,
                                            fontWeight: FontWeight.w500,
                                            fontSize: 12),
                                      ),
                                      const SizedBox(
                                        height: 10,
                                      ),
                                      RoundedButtonFill(
                                        title: "Edit Profile".tr,
                                        color: AppThemeData.secondary50,
                                        textColor: AppThemeData.secondary300,
                                        width: 24,
                                        height: 4,
                                        onPress: () async {
                                          Get.to(const EditProfileScreen())!
                                              .then(
                                            (value) {
                                              if (value == true) {
                                                controller.getUserProfile();
                                              }
                                            },
                                          );
                                        },
                                      ),
                                    ],
                                  ),
                                )
                              ],
                            ),
                          ),
                          if (Constant.isSubscriptionModelApplied == true ||
                              Constant.adminCommission?.isEnabled == true)
                            Visibility(
                              visible: controller.userModel.value
                                      .subscriptionPlanId?.isNotEmpty ==
                                  true,
                              child: Padding(
                                padding: const EdgeInsets.only(bottom: 10),
                                child: SubscriptionPlanWidget(
                                  onClick: () {
                                    Get.to(const SubscriptionPlanScreen(),
                                            arguments: {'isProfile': true})
                                        ?.then((value) {
                                      if (value == true) {
                                        controller.getUserProfile();
                                      }
                                    });
                                  },
                                  userModel: controller.userModel.value,
                                ),
                              ),
                            ),
                          Text(
                            "Restaurant Information".tr,
                            style: TextStyle(
                              color: themeChange.getThem()
                                  ? AppThemeData.grey400
                                  : AppThemeData.grey500,
                              fontFamily: AppThemeData.semiBold,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          Container(
                            width: Responsive.width(100, context),
                            decoration: ShapeDecoration(
                              color: themeChange.getThem()
                                  ? AppThemeData.grey900
                                  : AppThemeData.grey50,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12)),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 8),
                              child: Column(
                                children: [
                                  (Constant.isRestaurantVerification == true &&
                                              controller.userModel.value
                                                      .isDocumentVerify ==
                                                  false) ||
                                          (controller.userModel.value
                                                      .vendorID ==
                                                  null ||
                                              controller.userModel.value
                                                  .vendorID!.isEmpty)
                                      ? const SizedBox()
                                      : Constant.storyEnable == false
                                          ? const SizedBox()
                                          : cardDecoration(
                                              themeChange,
                                              controller,
                                              Container(
                                                width: 44,
                                                height: 44,
                                                decoration: ShapeDecoration(
                                                  color: themeChange.getThem()
                                                      ? AppThemeData
                                                          .secondary600
                                                      : AppThemeData
                                                          .secondary50,
                                                  shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            120),
                                                  ),
                                                ),
                                                child: Padding(
                                                  padding:
                                                      const EdgeInsets.all(10),
                                                  child: SvgPicture.asset(
                                                      "assets/icons/ic_story.svg"),
                                                ),
                                              ),
                                              "Add Story",
                                              () {
                                                Get.to(const AddStoryScreen());
                                              },
                                            ),
                                  Visibility(
                                      visible:
                                          Constant.isEnableAdsFeature == true,
                                      child: (Constant.isRestaurantVerification ==
                                                      true &&
                                                  controller.userModel.value
                                                          .isDocumentVerify ==
                                                      false) ||
                                              (controller.userModel.value
                                                          .vendorID ==
                                                      null ||
                                                  controller.userModel.value
                                                      .vendorID!.isEmpty)
                                          ? const SizedBox()
                                          : Constant.storyEnable == false
                                              ? const SizedBox()
                                              : cardDecoration(
                                                  themeChange,
                                                  controller,
                                                  Container(
                                                    width: 44,
                                                    height: 44,
                                                    decoration: ShapeDecoration(
                                                      color:
                                                          themeChange.getThem()
                                                              ? AppThemeData
                                                                  .secondary600
                                                              : AppThemeData
                                                                  .secondary50,
                                                      shape:
                                                          RoundedRectangleBorder(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(120),
                                                      ),
                                                    ),
                                                    child: Padding(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              10),
                                                      child: SvgPicture.asset(
                                                          "assets/icons/ic_advertisement.svg"),
                                                    ),
                                                  ),
                                                  "Advertisement",
                                                  () {
                                                    Get.to(
                                                        const AdvertisementListScreen());
                                                  },
                                                )),
                                  Constant.isRestaurantVerification == true &&
                                          controller.userModel.value
                                                  .isDocumentVerify ==
                                              false
                                      ? const SizedBox()
                                      : cardDecoration(
                                          themeChange,
                                          controller,
                                          Container(
                                            width: 44,
                                            height: 44,
                                            decoration: ShapeDecoration(
                                              color: themeChange.getThem()
                                                  ? AppThemeData.secondary600
                                                  : AppThemeData.secondary50,
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(120),
                                              ),
                                            ),
                                            child: Padding(
                                              padding: const EdgeInsets.all(10),
                                              child: SvgPicture.asset(
                                                "assets/icons/ic_building_two.svg",
                                                colorFilter: ColorFilter.mode(
                                                    AppThemeData.secondary300,
                                                    BlendMode.srcIn),
                                              ),
                                            ),
                                          ),
                                          "Restaurant Information's",
                                          () {
                                            Get.to(const AddRestaurantScreen())
                                                ?.then((v) {
                                              controller.getUserProfile();
                                            });
                                          },
                                        ),
                                  (Constant.isRestaurantVerification == true &&
                                              controller.userModel.value
                                                      .isDocumentVerify ==
                                                  false) ||
                                          (controller.userModel.value
                                                      .vendorID ==
                                                  null ||
                                              controller.userModel.value
                                                  .vendorID!.isEmpty)
                                      ? const SizedBox()
                                      : cardDecoration(
                                          themeChange,
                                          controller,
                                          Container(
                                            width: 44,
                                            height: 44,
                                            decoration: ShapeDecoration(
                                              color: themeChange.getThem()
                                                  ? AppThemeData.secondary600
                                                  : AppThemeData.secondary50,
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(120),
                                              ),
                                            ),
                                            child: Padding(
                                              padding: const EdgeInsets.all(12),
                                              child: SvgPicture.asset(
                                                  "assets/icons/ic_manage_product.svg"),
                                            ),
                                          ),
                                          "Manage Products",
                                          () {
                                            DashBoardController
                                                dashBoardController =
                                                Get.find<DashBoardController>();
                                            dashBoardController
                                                .selectedIndex.value = Constant
                                                        .isDineInEnable &&
                                                    Constant
                                                            .userModel!
                                                            .subscriptionPlan
                                                            ?.features
                                                            ?.dineIn !=
                                                        false
                                                ? 2
                                                : 1;
                                          },
                                        ),
                                  (Constant.isRestaurantVerification == true &&
                                              controller.userModel.value
                                                      .isDocumentVerify ==
                                                  false) ||
                                          (controller.userModel.value
                                                      .vendorID ==
                                                  null ||
                                              controller.userModel.value
                                                  .vendorID!.isEmpty)
                                      ? const SizedBox()
                                      : cardDecoration(
                                          themeChange,
                                          controller,
                                          Container(
                                            width: 44,
                                            height: 44,
                                            decoration: ShapeDecoration(
                                              color: themeChange.getThem()
                                                  ? AppThemeData.secondary600
                                                  : AppThemeData.secondary50,
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(120),
                                              ),
                                            ),
                                            child: Padding(
                                              padding: const EdgeInsets.all(10),
                                              child: SvgPicture.asset(
                                                  "assets/icons/ic_alarm-clock.svg"),
                                            ),
                                          ),
                                          "Working Hours",
                                          () {
                                            Get.to(const WorkingHoursScreen());
                                          },
                                        ),
                                  cardDecoration(
                                    themeChange,
                                    controller,
                                    Container(
                                      width: 44,
                                      height: 44,
                                      decoration: ShapeDecoration(
                                        color: themeChange.getThem()
                                            ? AppThemeData.secondary600
                                            : AppThemeData.secondary50,
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(120),
                                        ),
                                      ),
                                      child: Padding(
                                        padding: const EdgeInsets.all(10),
                                        child: SvgPicture.asset(
                                          "assets/icons/ic_wallet.svg",
                                          colorFilter: ColorFilter.mode(
                                              AppThemeData.secondary300,
                                              BlendMode.srcIn),
                                        ),
                                      ),
                                    ),
                                    "Withdraw Method",
                                    () {
                                      Get.to(const WithdrawMethodSetupScreen());
                                    },
                                  ),
                                ],
                              ),
                            ),
                          ),
                          if (Constant.isSelfDeliveryFeature == true)
                            Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const SizedBox(
                                    height: 20,
                                  ),
                                  Text(
                                    "Delivery Man Information".tr,
                                    style: TextStyle(
                                      color: themeChange.getThem()
                                          ? AppThemeData.grey400
                                          : AppThemeData.grey500,
                                      fontFamily: AppThemeData.semiBold,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  Container(
                                      width: Responsive.width(100, context),
                                      decoration: ShapeDecoration(
                                        color: themeChange.getThem()
                                            ? AppThemeData.grey900
                                            : AppThemeData.grey50,
                                        shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(12)),
                                      ),
                                      child: Padding(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 10, vertical: 8),
                                          child: Column(children: [
                                            cardDecoration(
                                              themeChange,
                                              controller,
                                              Container(
                                                width: 44,
                                                height: 44,
                                                decoration: ShapeDecoration(
                                                  color: themeChange.getThem()
                                                      ? AppThemeData
                                                          .secondary600
                                                      : AppThemeData
                                                          .goldenrodDark
                                                          .withAlpha(30),
                                                  shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            120),
                                                  ),
                                                ),
                                                child: Padding(
                                                  padding:
                                                      const EdgeInsets.all(12),
                                                  child: SvgPicture.asset(
                                                    "assets/icons/ic_manage_delivery_man.svg",
                                                    colorFilter:
                                                        ColorFilter.mode(
                                                            AppThemeData
                                                                .goldenrodDark,
                                                            BlendMode.srcIn),
                                                  ),
                                                ),
                                              ),
                                              "Manage Delivery Man",
                                              () {
                                                Get.to(DriverListScreen());
                                              },
                                            )
                                          ])))
                                ]),
                          (Constant.isRestaurantVerification == true &&
                                      controller.userModel.value
                                              .isDocumentVerify ==
                                          false) ||
                                  (controller.userModel.value.vendorID ==
                                          null ||
                                      controller
                                          .userModel.value.vendorID!.isEmpty) ||
                                  (controller.userModel.value.subscriptionPlan
                                          ?.features?.dineIn ==
                                      false)
                              ? const SizedBox()
                              : Constant.isDineInEnable
                                  ? Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        const SizedBox(
                                          height: 20,
                                        ),
                                        Text(
                                          "Dine-in Information".tr,
                                          style: TextStyle(
                                            color: themeChange.getThem()
                                                ? AppThemeData.grey400
                                                : AppThemeData.grey500,
                                            fontFamily: AppThemeData.semiBold,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                        const SizedBox(
                                          height: 10,
                                        ),
                                        Container(
                                          width: Responsive.width(100, context),
                                          decoration: ShapeDecoration(
                                            color: themeChange.getThem()
                                                ? AppThemeData.grey900
                                                : AppThemeData.grey50,
                                            shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(12)),
                                          ),
                                          child: Padding(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 10, vertical: 8),
                                            child: Column(
                                              children: [
                                                cardDecoration(
                                                  themeChange,
                                                  controller,
                                                  Container(
                                                    width: 44,
                                                    height: 44,
                                                    decoration: ShapeDecoration(
                                                      color:
                                                          themeChange.getThem()
                                                              ? AppThemeData
                                                                  .primary600
                                                              : AppThemeData
                                                                  .primary50,
                                                      shape:
                                                          RoundedRectangleBorder(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(120),
                                                      ),
                                                    ),
                                                    child: Padding(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              10),
                                                      child: SvgPicture.asset(
                                                          "assets/icons/ic_knife_fork.svg"),
                                                    ),
                                                  ),
                                                  "Dine in Restaurant",
                                                  () {
                                                    Get.to(
                                                        const DineInCreateScreen());
                                                  },
                                                ),
                                                cardDecoration(
                                                  themeChange,
                                                  controller,
                                                  Container(
                                                    width: 44,
                                                    height: 44,
                                                    decoration: ShapeDecoration(
                                                      color:
                                                          themeChange.getThem()
                                                              ? AppThemeData
                                                                  .primary600
                                                              : AppThemeData
                                                                  .primary50,
                                                      shape:
                                                          RoundedRectangleBorder(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(120),
                                                      ),
                                                    ),
                                                    child: Padding(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              10),
                                                      child: SvgPicture.asset(
                                                        "assets/icons/ic_people-unknown.svg",
                                                      ),
                                                    ),
                                                  ),
                                                  "Dine in Requests",
                                                  () {
                                                    DashBoardController
                                                        dashBoardController =
                                                        Get.find<
                                                            DashBoardController>();
                                                    dashBoardController
                                                        .selectedIndex
                                                        .value = 1;
                                                  },
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ],
                                    )
                                  : const SizedBox(),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const SizedBox(
                                height: 20,
                              ),
                              Text(
                                "Subscription Management".tr,
                                style: TextStyle(
                                  color: themeChange.getThem()
                                      ? AppThemeData.grey400
                                      : AppThemeData.grey500,
                                  fontFamily: AppThemeData.semiBold,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              Container(
                                width: Responsive.width(100, context),
                                decoration: ShapeDecoration(
                                  color: themeChange.getThem()
                                      ? AppThemeData.grey900
                                      : AppThemeData.grey50,
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12)),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 10, vertical: 8),
                                  child: Column(
                                    children: [
                                      (Constant.isSubscriptionModelApplied ==
                                                  true ||
                                              Constant.adminCommission
                                                      ?.isEnabled ==
                                                  true)
                                          ? cardDecoration(
                                              themeChange,
                                              controller,
                                              Container(
                                                width: 44,
                                                height: 44,
                                                decoration: ShapeDecoration(
                                                  color: themeChange.getThem()
                                                      ? AppThemeData.driverApp50
                                                          .withAlpha(20)
                                                      : AppThemeData
                                                          .driverApp50,
                                                  shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            120),
                                                  ),
                                                ),
                                                child: Padding(
                                                  padding:
                                                      const EdgeInsets.all(10),
                                                  child: SvgPicture.asset(
                                                      "assets/icons/ic_subscription.svg"),
                                                ),
                                              ),
                                              "Subscription Packages",
                                              () {
                                                Get.to(
                                                    const SubscriptionPlanScreen(),
                                                    arguments: {
                                                      'isProfile': true
                                                    })?.then((value) {
                                                  if (value == true) {
                                                    controller.getUserProfile();
                                                  }
                                                });
                                              },
                                            )
                                          : SizedBox(),
                                      cardDecoration(
                                        themeChange,
                                        controller,
                                        Container(
                                          width: 44,
                                          height: 44,
                                          decoration: ShapeDecoration(
                                            color: themeChange.getThem()
                                                ? AppThemeData.driverApp50
                                                    .withAlpha(20)
                                                : AppThemeData.driverApp50,
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(120),
                                            ),
                                          ),
                                          child: Padding(
                                            padding: const EdgeInsets.all(10),
                                            child: SvgPicture.asset(
                                              "assets/icons/ic_history.svg",
                                            ),
                                          ),
                                        ),
                                        "Subscription History",
                                        () {
                                          Get.to(
                                              const SubscriptionHistoryScreen());
                                        },
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                          (Constant.isRestaurantVerification == true &&
                                      controller.userModel.value
                                              .isDocumentVerify ==
                                          false) ||
                                  (controller.userModel.value.vendorID ==
                                          null ||
                                      controller
                                          .userModel.value.vendorID!.isEmpty)
                              ? const SizedBox()
                              : Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const SizedBox(
                                      height: 20,
                                    ),
                                    Text(
                                      "Offers & Discounts".tr,
                                      style: TextStyle(
                                        color: themeChange.getThem()
                                            ? AppThemeData.grey400
                                            : AppThemeData.grey500,
                                        fontFamily: AppThemeData.semiBold,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    Container(
                                      width: Responsive.width(100, context),
                                      decoration: ShapeDecoration(
                                        color: themeChange.getThem()
                                            ? AppThemeData.grey900
                                            : AppThemeData.grey50,
                                        shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(12)),
                                      ),
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 10, vertical: 8),
                                        child: Column(
                                          children: [
                                            cardDecoration(
                                              themeChange,
                                              controller,
                                              Container(
                                                width: 44,
                                                height: 44,
                                                decoration: ShapeDecoration(
                                                  color: themeChange.getThem()
                                                      ? AppThemeData.success600
                                                      : AppThemeData.success50,
                                                  shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            120),
                                                  ),
                                                ),
                                                child: Padding(
                                                  padding:
                                                      const EdgeInsets.all(10),
                                                  child: SvgPicture.asset(
                                                      "assets/icons/ic_gift_box.svg"),
                                                ),
                                              ),
                                              "Offers",
                                              () {
                                                Get.to(const OfferScreen());
                                              },
                                            ),
                                            Constant.specialDiscountOfferEnable ==
                                                    false
                                                ? const SizedBox()
                                                : cardDecoration(
                                                    themeChange,
                                                    controller,
                                                    Container(
                                                      width: 44,
                                                      height: 44,
                                                      decoration:
                                                          ShapeDecoration(
                                                        color: themeChange
                                                                .getThem()
                                                            ? AppThemeData
                                                                .success600
                                                            : AppThemeData
                                                                .success50,
                                                        shape:
                                                            RoundedRectangleBorder(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(
                                                                      120),
                                                        ),
                                                      ),
                                                      child: Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .all(10),
                                                        child: SvgPicture.asset(
                                                          "assets/icons/ic_coupon.svg",
                                                        ),
                                                      ),
                                                    ),
                                                    "Special Discounts",
                                                    () {
                                                      Get.to(
                                                          const SpecialDiscountScreen());
                                                    },
                                                  ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                          const SizedBox(
                            height: 20,
                          ),
                          Text(
                            "Preferences".tr,
                            style: TextStyle(
                              color: themeChange.getThem()
                                  ? AppThemeData.grey400
                                  : AppThemeData.grey500,
                              fontFamily: AppThemeData.semiBold,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          Container(
                            width: Responsive.width(100, context),
                            decoration: ShapeDecoration(
                              color: themeChange.getThem()
                                  ? AppThemeData.grey900
                                  : AppThemeData.grey50,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12)),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 8),
                              child: Column(
                                children: [
                                  cardDecoration(
                                    themeChange,
                                    controller,
                                    Container(
                                      width: 44,
                                      height: 44,
                                      decoration: ShapeDecoration(
                                        color: themeChange.getThem()
                                            ? AppThemeData.warning600
                                            : AppThemeData.warning50,
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(120),
                                        ),
                                      ),
                                      child: Padding(
                                        padding: const EdgeInsets.all(10),
                                        child: SvgPicture.asset(
                                            "assets/icons/ic_language.svg"),
                                      ),
                                    ),
                                    "Change Language",
                                    () {
                                      Get.to(const ChangeLanguageScreen());
                                    },
                                  ),
                                  cardDecoration(
                                    themeChange,
                                    controller,
                                    Container(
                                      width: 44,
                                      height: 44,
                                      decoration: ShapeDecoration(
                                        color: themeChange.getThem()
                                            ? AppThemeData.warning600
                                            : AppThemeData.warning50,
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(120),
                                        ),
                                      ),
                                      child: Padding(
                                        padding: const EdgeInsets.all(10),
                                        child: SvgPicture.asset(
                                          "assets/icons/ic_darkmode.svg",
                                        ),
                                      ),
                                    ),
                                    "Dark Mode",
                                    () {},
                                  ),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          Text(
                            "Social".tr,
                            style: TextStyle(
                              color: themeChange.getThem()
                                  ? AppThemeData.grey400
                                  : AppThemeData.grey500,
                              fontFamily: AppThemeData.semiBold,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          Container(
                            width: Responsive.width(100, context),
                            decoration: ShapeDecoration(
                              color: themeChange.getThem()
                                  ? AppThemeData.grey900
                                  : AppThemeData.grey50,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12)),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 8),
                              child: Column(
                                children: [
                                  cardDecoration(
                                    themeChange,
                                    controller,
                                    Container(
                                      width: 44,
                                      height: 44,
                                      decoration: ShapeDecoration(
                                        color: themeChange.getThem()
                                            ? AppThemeData.info600
                                            : AppThemeData.info50,
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(120),
                                        ),
                                      ),
                                      child: Padding(
                                        padding: const EdgeInsets.all(10),
                                        child: SvgPicture.asset(
                                            "assets/icons/ic_share.svg"),
                                      ),
                                    ),
                                    "Share app",
                                    () {
                                      Share.share(
                                          '${"Check out Foodie, your ultimate food delivery application! \n\nGoogle Play:".tr} ${Constant.googlePlayLink} ${"\n\nApp Store:".tr} ${Constant.appStoreLink}',
                                          subject: 'Look what I made!'.tr);
                                    },
                                  ),
                                  cardDecoration(
                                    themeChange,
                                    controller,
                                    Container(
                                      width: 44,
                                      height: 44,
                                      decoration: ShapeDecoration(
                                        color: themeChange.getThem()
                                            ? AppThemeData.info600
                                            : AppThemeData.info50,
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(120),
                                        ),
                                      ),
                                      child: Padding(
                                        padding: const EdgeInsets.all(10),
                                        child: SvgPicture.asset(
                                          "assets/icons/ic_rate.svg",
                                        ),
                                      ),
                                    ),
                                    "Rate the app",
                                    () {
                                      final InAppReview inAppReview =
                                          InAppReview.instance;
                                      inAppReview.requestReview();
                                    },
                                  ),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          Text(
                            "Legal".tr,
                            style: TextStyle(
                              color: themeChange.getThem()
                                  ? AppThemeData.grey400
                                  : AppThemeData.grey500,
                              fontFamily: AppThemeData.semiBold,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          Container(
                            width: Responsive.width(100, context),
                            decoration: ShapeDecoration(
                              color: themeChange.getThem()
                                  ? AppThemeData.grey900
                                  : AppThemeData.grey50,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12)),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 8),
                              child: Column(
                                children: [
                                  cardDecoration(
                                    themeChange,
                                    controller,
                                    Container(
                                      width: 44,
                                      height: 44,
                                      decoration: ShapeDecoration(
                                        color: themeChange.getThem()
                                            ? AppThemeData.grey800
                                            : AppThemeData.grey100,
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(120),
                                        ),
                                      ),
                                      child: Padding(
                                        padding: const EdgeInsets.all(10),
                                        child: SvgPicture.asset(
                                            "assets/icons/ic_documention.svg"),
                                      ),
                                    ),
                                    "Document Verifications",
                                    () {
                                      Get.to(const VerificationScreen());
                                    },
                                  ),
                                  cardDecoration(
                                    themeChange,
                                    controller,
                                    Container(
                                      width: 44,
                                      height: 44,
                                      decoration: ShapeDecoration(
                                        color: themeChange.getThem()
                                            ? AppThemeData.grey800
                                            : AppThemeData.grey100,
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(120),
                                        ),
                                      ),
                                      child: Padding(
                                        padding: const EdgeInsets.all(10),
                                        child: SvgPicture.asset(
                                          "assets/icons/ic_terms_condition.svg",
                                        ),
                                      ),
                                    ),
                                    "Terms and Conditions",
                                    () {
                                      Get.to(const TermsAndConditionScreen(
                                        type: "termAndCondition",
                                      ));
                                    },
                                  ),
                                  cardDecoration(
                                    themeChange,
                                    controller,
                                    Container(
                                      width: 44,
                                      height: 44,
                                      decoration: ShapeDecoration(
                                        color: themeChange.getThem()
                                            ? AppThemeData.grey800
                                            : AppThemeData.grey100,
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(120),
                                        ),
                                      ),
                                      child: Padding(
                                        padding: const EdgeInsets.all(10),
                                        child: SvgPicture.asset(
                                          "assets/icons/ic_privacyPolicy.svg",
                                        ),
                                      ),
                                    ),
                                    "Privacy Policy",
                                    () {
                                      Get.to(const TermsAndConditionScreen(
                                        type: "privacy",
                                      ));
                                    },
                                  ),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          Container(
                            width: Responsive.width(100, context),
                            decoration: ShapeDecoration(
                              color: themeChange.getThem()
                                  ? AppThemeData.grey900
                                  : AppThemeData.grey50,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8)),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 6),
                              child: Column(
                                children: [
                                  cardDecoration(
                                      themeChange,
                                      controller,
                                      SvgPicture.asset(
                                          "assets/icons/ic_logout.svg"),
                                      "Log out", () {
                                    showDialog(
                                        context: context,
                                        builder: (BuildContext context) {
                                          return CustomDialogBox(
                                            title: "Log out".tr,
                                            descriptions:
                                                "Are you sure you want to log out? You will need to enter your credentials to log back in."
                                                    .tr,
                                            positiveString: "Log out".tr,
                                            negativeString: "Cancel".tr,
                                            positiveClick: () async {
                                              await AudioPlayerService
                                                  .playSound(false);
                                              Constant.userModel!.fcmToken = "";
                                              await FireStoreUtils.updateUser(
                                                  Constant.userModel!);
                                              Constant.userModel = null;
                                              await FirebaseAuth.instance
                                                  .signOut();
                                              Get.offAll(const LoginScreen());
                                            },
                                            negativeClick: () {
                                              Get.back();
                                            },
                                            img: Image.asset(
                                              'assets/images/ic_logout.gif',
                                              height: 50,
                                              width: 50,
                                            ),
                                          );
                                        });
                                  }),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 20),
                            child: InkWell(
                              onTap: () {
                                showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return CustomDialogBox(
                                        title: "Delete Account".tr,
                                        descriptions:
                                            "Are you sure you want to delete your account? This action is irreversible and will permanently remove all your data."
                                                .tr,
                                        positiveString: "Delete".tr,
                                        negativeString: "Cancel".tr,
                                        positiveClick: () async {
                                          ShowToastDialog.showLoader(
                                              "Please wait".tr);
                                          await controller
                                              .deleteUserFromServer();
                                          await FireStoreUtils.deleteUser()
                                              .then((value) {
                                            ShowToastDialog.closeLoader();
                                            if (value == true) {
                                              ShowToastDialog.showToast(
                                                  "Account deleted successfully"
                                                      .tr);
                                              Get.offAll(const LoginScreen());
                                            } else {
                                              ShowToastDialog.showToast(
                                                  "Contact Administrator".tr);
                                            }
                                          });
                                        },
                                        negativeClick: () {
                                          Get.back();
                                        },
                                        img: Image.asset(
                                          'assets/icons/delete_dialog.gif',
                                          height: 50,
                                          width: 50,
                                        ),
                                      );
                                    });
                              },
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  SvgPicture.asset(
                                      "assets/icons/ic_delete.svg"),
                                  const SizedBox(
                                    width: 10,
                                  ),
                                  Text(
                                    "Delete Account".tr,
                                    textAlign: TextAlign.start,
                                    style: TextStyle(
                                      fontFamily: AppThemeData.medium,
                                      fontSize: 16,
                                      color: themeChange.getThem()
                                          ? AppThemeData.danger300
                                          : AppThemeData.danger300,
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ),
                          Center(
                            child: Text(
                              "V : ${Constant.appVersion}",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontFamily: AppThemeData.medium,
                                fontSize: 14,
                                color: themeChange.getThem()
                                    ? AppThemeData.grey50
                                    : AppThemeData.grey900,
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
          );
        });
  }

  cardDecoration(themeChange, ProfileController controller, Widget image,
      String title, Function()? onPress) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: InkWell(
        onTap: () {
          FocusManager.instance.primaryFocus?.unfocus();
          onPress!();
        },
        child: Row(
          children: [
            image,
            const SizedBox(
              width: 10,
            ),
            Expanded(
              child: Text(
                title.tr,
                textAlign: TextAlign.start,
                style: TextStyle(
                  fontFamily: AppThemeData.medium,
                  fontSize: 16,
                  color: title == "Log out"
                      ? AppThemeData.danger300
                      : themeChange.getThem()
                          ? AppThemeData.grey100
                          : AppThemeData.grey800,
                ),
              ),
            ),
            title == "Dark Mode"
                ? Transform.scale(
                    scale: 0.8,
                    child: CupertinoSwitch(
                      value: controller.isDarkModeSwitch.value,
                      activeColor: AppThemeData.primary300,
                      onChanged: (value) {
                        controller.isDarkModeSwitch.value = value;
                        if (controller.isDarkModeSwitch.value == true) {
                          Preferences.setString(Preferences.themKey, "Dark");
                          themeChange.darkTheme = 0;
                        } else if (controller.isDarkMode.value == "Light") {
                          Preferences.setString(Preferences.themKey, "Light");
                          themeChange.darkTheme = 1;
                        } else {
                          Preferences.setString(Preferences.themKey, "");
                          themeChange.darkTheme = 2;
                        }
                      },
                    ),
                  )
                : const Icon(Icons.keyboard_arrow_right)
          ],
        ),
      ),
    );
  }
}

class SubscriptionPlanWidget extends StatelessWidget {
  final VoidCallback onClick;
  final UserModel userModel;

  const SubscriptionPlanWidget({
    super.key,
    required this.onClick,
    required this.userModel,
  });

  @override
  Widget build(BuildContext context) {
    final themeChange = Provider.of<DarkThemeProvider>(context);
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 2, vertical: 4),
      decoration: BoxDecoration(
        border: Border.all(
            color: themeChange.getThem()
                ? AppThemeData.grey800
                : AppThemeData.grey200),
        color:
            themeChange.getThem() ? AppThemeData.grey50 : AppThemeData.grey800,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Stack(
        children: [
          Positioned(
              bottom: 0,
              top: 10,
              child: Opacity(
                  opacity: 0.8,
                  child: Image.asset(
                    width: Responsive.width(100, context),
                    height: Responsive.height(100, context),
                    "assets/images/ic_gradient.png",
                    color: AppThemeData.secondary300,
                    fit: BoxFit.fill,
                  ))),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    NetworkImageWidget(
                      imageUrl: userModel.subscriptionPlan?.image ?? '',
                      fit: BoxFit.cover,
                      width: 50,
                      height: 50,
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                userModel.subscriptionPlan?.name ?? '',
                                style: TextStyle(
                                  color: themeChange.getThem()
                                      ? AppThemeData.grey900
                                      : AppThemeData.grey50,
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  fontFamily: AppThemeData.semiBold,
                                ),
                              ),
                              Text(
                                userModel.subscriptionPlan?.type == 'free'
                                    ? userModel.subscriptionPlan?.description ??
                                        ''
                                    : Constant.amountShow(
                                        amount:
                                            userModel.subscriptionPlan?.price),
                                style: const TextStyle(
                                  fontFamily: AppThemeData.medium,
                                  fontSize: 14,
                                  color: AppThemeData.grey400,
                                ),
                              ),
                            ],
                          ),
                          if (userModel.subscriptionPlan?.type == 'paid')
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Expiry Date'.tr,
                                  style: TextStyle(
                                    fontFamily: AppThemeData.medium,
                                    fontSize: 12,
                                    color: themeChange.getThem()
                                        ? AppThemeData.grey900
                                        : AppThemeData.grey50,
                                  ),
                                ),
                                Text(
                                  userModel.subscriptionPlan!.expiryDay == "-1"
                                      ? "LifeTime"
                                      : Constant.timestampToDate(
                                          userModel.subscriptionExpiryDate!),
                                  style: const TextStyle(
                                    fontFamily: AppThemeData.regular,
                                    fontSize: 12,
                                    color: AppThemeData.grey400,
                                  ),
                                ),
                              ],
                            )
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 30),
                RoundedButtonFill(
                  radius: 14,
                  textColor: AppThemeData.grey200,
                  title: "Change Plan".tr,
                  color: AppThemeData.secondary300,
                  width: 80,
                  height: 5,
                  onPress: onClick,
                ),
                if (Constant.adminCommission?.isEnabled == true)
                  Padding(
                    padding: const EdgeInsets.only(top: 10),
                    child: Text(
                      Constant.userModel!.vendorID != null &&
                              Constant.userModel!.vendorID!.isNotEmpty
                          ? "${Constant.vendorAdminCommission?.commissionType == 'Percent' ? "${Constant.vendorAdminCommission?.amount} %" : "${Constant.amountShow(amount: Constant.vendorAdminCommission?.amount)} Flat"} ${"admin commission will be charged from customer billing orders and the admin charge will be earned after the order is accepted by the restaurant.".tr}"
                          : "${Constant.adminCommission?.commissionType == 'Percent' ? "${Constant.adminCommission?.amount} %" : "${Constant.amountShow(amount: Constant.adminCommission?.amount)} Flat"} ${"admin commission will be charged from customer billing orders and the admin charge will be earned after the order is accepted by the restaurant.".tr}",
                      style: const TextStyle(
                        fontFamily: AppThemeData.medium,
                        fontSize: 9,
                        color: AppThemeData.grey400,
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
