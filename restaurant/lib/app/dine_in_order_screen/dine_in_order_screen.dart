import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:restaurant/app/add_restaurant_screen/add_restaurant_screen.dart';
import 'package:restaurant/app/dine_in_screen/dine_in_create_screen.dart';
import 'package:restaurant/app/verification_screen/verification_screen.dart';
import 'package:restaurant/constant/constant.dart';
import 'package:restaurant/constant/send_notification.dart';
import 'package:restaurant/constant/show_toast_dialog.dart';
import 'package:restaurant/controller/dine_in_order_controller.dart';
import 'package:restaurant/models/dine_in_booking_model.dart';
import 'package:restaurant/themes/app_them_data.dart';
import 'package:restaurant/themes/responsive.dart';
import 'package:restaurant/themes/round_button_fill.dart';
import 'package:restaurant/utils/dark_theme_provider.dart';
import 'package:restaurant/utils/fire_store_utils.dart';
import 'package:restaurant/utils/network_image_widget.dart';
import 'package:restaurant/widget/my_separator.dart';

class DineInOrderScreen extends StatelessWidget {
  const DineInOrderScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final themeChange = Provider.of<DarkThemeProvider>(context);
    return GetX(
        init: DineInOrderController(),
        builder: (controller) {
          return controller.isLoading.value
              ? Constant.loader()
              : DefaultTabController(
                  length: 2,
                  child: Scaffold(
                    appBar: AppBar(
                      backgroundColor: AppThemeData.secondary300,
                      centerTitle: false,
                      title: Row(
                        children: [
                          ClipOval(
                            child: NetworkImageWidget(
                              imageUrl: controller
                                  .userModel.value.profilePictureURL
                                  .toString(),
                              height: 42,
                              width: 42,
                              fit: BoxFit.cover,
                            ),
                          ),
                          const SizedBox(
                            width: 12,
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Welcome to Foodie Restaurant".tr,
                                style: TextStyle(
                                    color: themeChange.getThem()
                                        ? AppThemeData.grey900
                                        : AppThemeData.grey50,
                                    fontSize: 12,
                                    fontFamily: AppThemeData.regular),
                              ),
                              Text(
                                "${controller.userModel.value.fullName()}".tr,
                                style: TextStyle(
                                    color: themeChange.getThem()
                                        ? AppThemeData.grey900
                                        : AppThemeData.grey50,
                                    fontSize: 16,
                                    fontFamily: AppThemeData.semiBold),
                              ),
                            ],
                          ),
                        ],
                      ),
                      bottom: TabBar(
                        onTap: (value) {
                          controller.selectedTabIndex.value = value;
                        },
                        labelStyle:
                            const TextStyle(fontFamily: AppThemeData.semiBold),
                        labelColor: themeChange.getThem()
                            ? AppThemeData.grey50
                            : AppThemeData.grey50,
                        unselectedLabelStyle:
                            const TextStyle(fontFamily: AppThemeData.medium),
                        unselectedLabelColor: themeChange.getThem()
                            ? AppThemeData.secondary100
                            : AppThemeData.secondary100,
                        indicatorColor: AppThemeData.secondary300,
                        isScrollable: false,
                        dividerColor: Colors.transparent,
                        tabs: [
                          Tab(
                            text: "New".tr,
                          ),
                          Tab(
                            text: "History".tr,
                          ),
                        ],
                      ),
                    ),
                    body: Constant.isRestaurantVerification == true &&
                            controller.userModel.value.isDocumentVerify == false
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
                        : controller.userModel.value.vendorID == null ||
                                controller.userModel.value.vendorID!.isEmpty
                            ? Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 16),
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
                                          borderRadius:
                                              BorderRadius.circular(120),
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
                                      "Get started by adding your restaurant details to manage your menu, orders, and reservations."
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
                            : (controller.vendorModel.value.restaurantCost ==
                                        null ||
                                    controller.vendorModel.value.restaurantCost!
                                        .isEmpty)
                                ? Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 16),
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        Container(
                                          decoration: ShapeDecoration(
                                            color: themeChange.getThem()
                                                ? AppThemeData.grey700
                                                : AppThemeData.grey200,
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(120),
                                            ),
                                          ),
                                          child: Padding(
                                            padding: const EdgeInsets.all(20),
                                            child: SvgPicture.asset(
                                                "assets/icons/ic_dinein.svg"),
                                          ),
                                        ),
                                        const SizedBox(
                                          height: 12,
                                        ),
                                        Text(
                                          "Dine-In Details Missing".tr,
                                          style: TextStyle(
                                              color: themeChange.getThem()
                                                  ? AppThemeData.grey100
                                                  : AppThemeData.grey800,
                                              fontSize: 22,
                                              fontFamily:
                                                  AppThemeData.semiBold),
                                        ),
                                        const SizedBox(
                                          height: 5,
                                        ),
                                        Text(
                                          "Please add your restaurant’s dine-in details to start accepting reservations."
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
                                          title: "Add Dine in".tr,
                                          width: 55,
                                          height: 5.5,
                                          color: AppThemeData.secondary300,
                                          textColor: AppThemeData.grey50,
                                          onPress: () async {
                                            Get.to(const DineInCreateScreen());
                                          },
                                        ),
                                      ],
                                    ),
                                  )
                                : Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 16, vertical: 10),
                                    child: TabBarView(
                                      children: [
                                        controller.featureList.isEmpty
                                            ? Constant.showEmptyView(
                                                message:
                                                    "Upcoming Booking not found."
                                                        .tr)
                                            : RefreshIndicator(
                                                onRefresh: () =>
                                                    controller.getDineBooking(),
                                                child: ListView.builder(
                                                  shrinkWrap: true,
                                                  padding: EdgeInsets.zero,
                                                  scrollDirection:
                                                      Axis.vertical,
                                                  itemCount: controller
                                                      .featureList.length,
                                                  itemBuilder:
                                                      (BuildContext context,
                                                          int index) {
                                                    DineInBookingModel
                                                        dineBookingModel =
                                                        controller
                                                            .featureList[index];
                                                    return itemView(
                                                        themeChange,
                                                        context,
                                                        dineBookingModel,
                                                        true,
                                                        controller);
                                                  },
                                                ),
                                              ),
                                        controller.historyList.isEmpty
                                            ? Constant.showEmptyView(
                                                message:
                                                    "History not found.".tr)
                                            : RefreshIndicator(
                                                onRefresh: () =>
                                                    controller.getDineBooking(),
                                                child: ListView.builder(
                                                  itemCount: controller
                                                      .historyList.length,
                                                  shrinkWrap: true,
                                                  padding: EdgeInsets.zero,
                                                  itemBuilder:
                                                      (context, index) {
                                                    DineInBookingModel
                                                        dineBookingModel =
                                                        controller
                                                            .historyList[index];
                                                    return itemView(
                                                        themeChange,
                                                        context,
                                                        dineBookingModel,
                                                        false,
                                                        controller);
                                                  },
                                                ),
                                              ),
                                      ],
                                    ),
                                  ),
                  ),
                );
        });
  }

  itemView(
      DarkThemeProvider themeChange,
      BuildContext context,
      DineInBookingModel orderModel,
      bool isNew,
      DineInOrderController controller) {
    return InkWell(
      onTap: () {},
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 5),
        child: Container(
          decoration: ShapeDecoration(
            color: themeChange.getThem()
                ? AppThemeData.grey900
                : AppThemeData.grey50,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                Row(
                  children: [
                    ClipRRect(
                      borderRadius: const BorderRadius.all(Radius.circular(16)),
                      child: Stack(
                        children: [
                          NetworkImageWidget(
                            imageUrl: orderModel.vendor!.photo.toString(),
                            fit: BoxFit.cover,
                            height: Responsive.height(10, context),
                            width: Responsive.width(20, context),
                          ),
                          Container(
                            height: Responsive.height(10, context),
                            width: Responsive.width(20, context),
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                begin: const Alignment(0.00, 1.00),
                                end: const Alignment(0, -1),
                                colors: [
                                  Colors.black.withOpacity(0),
                                  AppThemeData.grey900
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            orderModel.status.toString(),
                            textAlign: TextAlign.right,
                            style: TextStyle(
                              color: Constant.statusColor(
                                  status: orderModel.status.toString()),
                              fontFamily: AppThemeData.semiBold,
                              fontWeight: FontWeight.w500,
                              fontSize: 12,
                            ),
                          ),
                          const SizedBox(
                            height: 5,
                          ),
                          Text(
                            orderModel.vendor!.title.toString(),
                            style: TextStyle(
                              fontSize: 16,
                              color: themeChange.getThem()
                                  ? AppThemeData.grey50
                                  : AppThemeData.grey900,
                              fontFamily: AppThemeData.medium,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                          const SizedBox(
                            height: 5,
                          ),
                          Text(
                            Constant.timestampToDateTime(orderModel.createdAt!),
                            style: TextStyle(
                              color: themeChange.getThem()
                                  ? AppThemeData.grey300
                                  : AppThemeData.grey600,
                              fontFamily: AppThemeData.medium,
                              fontWeight: FontWeight.w500,
                            ),
                          )
                        ],
                      ),
                    ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  child: MySeparator(
                      color: themeChange.getThem()
                          ? AppThemeData.grey700
                          : AppThemeData.grey200),
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Text(
                        "Name".tr,
                        style: TextStyle(
                          color: themeChange.getThem()
                              ? AppThemeData.grey300
                              : AppThemeData.grey600,
                          fontFamily: AppThemeData.regular,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ),
                    Expanded(
                      child: Text(
                        "${orderModel.guestFirstName} ${orderModel.guestLastName}",
                        textAlign: TextAlign.end,
                        style: TextStyle(
                          color: themeChange.getThem()
                              ? AppThemeData.grey50
                              : AppThemeData.grey900,
                          fontFamily: AppThemeData.semiBold,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 5,
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Text(
                        "Phone number".tr,
                        style: TextStyle(
                          color: themeChange.getThem()
                              ? AppThemeData.grey300
                              : AppThemeData.grey600,
                          fontFamily: AppThemeData.regular,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ),
                    Expanded(
                      child: Text(
                        "${orderModel.guestPhone}",
                        textAlign: TextAlign.end,
                        style: TextStyle(
                          color: themeChange.getThem()
                              ? AppThemeData.grey50
                              : AppThemeData.grey900,
                          fontFamily: AppThemeData.semiBold,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 5,
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Text(
                        "Date and Time".tr,
                        style: TextStyle(
                          color: themeChange.getThem()
                              ? AppThemeData.grey300
                              : AppThemeData.grey600,
                          fontFamily: AppThemeData.regular,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ),
                    Expanded(
                      child: Text(
                        Constant.timestampToDateTime(orderModel.date!),
                        textAlign: TextAlign.end,
                        style: TextStyle(
                          color: themeChange.getThem()
                              ? AppThemeData.grey50
                              : AppThemeData.grey900,
                          fontFamily: AppThemeData.semiBold,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 5,
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Text(
                        "Guest".tr,
                        style: TextStyle(
                          color: themeChange.getThem()
                              ? AppThemeData.grey300
                              : AppThemeData.grey600,
                          fontFamily: AppThemeData.regular,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ),
                    Expanded(
                      child: Text(
                        orderModel.totalGuest!,
                        textAlign: TextAlign.end,
                        style: TextStyle(
                          color: themeChange.getThem()
                              ? AppThemeData.grey50
                              : AppThemeData.grey900,
                          fontFamily: AppThemeData.semiBold,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 5,
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Text(
                        "Discount".tr,
                        style: TextStyle(
                          color: themeChange.getThem()
                              ? AppThemeData.grey300
                              : AppThemeData.grey600,
                          fontFamily: AppThemeData.regular,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ),
                    Expanded(
                      child: Text(
                        "${orderModel.discount} ${orderModel.discountType == "amount" ? Constant.currencyModel!.symbol : "%"} ${'Off'.tr}",
                        textAlign: TextAlign.end,
                        style: TextStyle(
                          color: themeChange.getThem()
                              ? AppThemeData.grey50
                              : AppThemeData.grey900,
                          fontFamily: AppThemeData.semiBold,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 10,
                ),
                isNew == false ||
                        (orderModel.status == Constant.orderAccepted ||
                            orderModel.status == Constant.orderRejected)
                    ? const SizedBox()
                    : Row(
                        children: [
                          Expanded(
                            child: RoundedButtonFill(
                              title: "Reject".tr,
                              color: AppThemeData.danger300,
                              textColor: AppThemeData.grey50,
                              height: 5,
                              onPress: () async {
                                ShowToastDialog.showLoader("Please wait.".tr);
                                orderModel.status = Constant.orderRejected;
                                await FireStoreUtils.setBookedOrder(orderModel);
                                SendNotification.sendFcmMessage(
                                    Constant.dineInAccepted,
                                    orderModel.author!.fcmToken.toString(), {});
                                controller.getDineBooking();
                                ShowToastDialog.closeLoader();
                              },
                            ),
                          ),
                          const SizedBox(
                            width: 10,
                          ),
                          Expanded(
                            child: RoundedButtonFill(
                              title: "Accept".tr,
                              height: 5,
                              color: AppThemeData.success400,
                              textColor: AppThemeData.grey50,
                              onPress: () async {
                                ShowToastDialog.showLoader("Please wait.".tr);
                                orderModel.status = Constant.orderAccepted;
                                await FireStoreUtils.setBookedOrder(orderModel);
                                SendNotification.sendFcmMessage(
                                    Constant.dineInAccepted,
                                    orderModel.author!.fcmToken.toString(), {});
                                controller.getDineBooking();
                                ShowToastDialog.closeLoader();
                              },
                            ),
                          ),
                        ],
                      )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
