import 'package:driver/app/home_screen/home_screen.dart';
import 'package:driver/constant/constant.dart';
import 'package:driver/controllers/dash_board_controller.dart';
import 'package:driver/controllers/home_screen_multiple_order_controller.dart';
import 'package:driver/models/order_model.dart';
import 'package:driver/themes/app_them_data.dart';
import 'package:driver/themes/round_button_fill.dart';
import 'package:driver/utils/dark_theme_provider.dart';
import 'package:driver/utils/fire_store_utils.dart';
import 'package:driver/widget/my_separator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:timelines_plus/timelines_plus.dart';

class HomeScreenMultipleOrder extends StatelessWidget {
  const HomeScreenMultipleOrder({super.key});

  @override
  Widget build(BuildContext context) {
    final themeChange = Provider.of<DarkThemeProvider>(context);

    return GetX(
        init: HomeScreenMultipleOrderController(),
        builder: (controller) {
          return Scaffold(
            body: controller.isLoading.value
                ? Constant.loader()
                : Constant.userModel?.vendorID?.isEmpty == true &&
                        Constant.isDriverVerification == true &&
                        Constant.userModel!.isDocumentVerify == false
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
                                DashBoardController dashBoardController =
                                    Get.put(DashBoardController());
                                dashBoardController.drawerIndex.value = 4;
                              },
                            ),
                          ],
                        ),
                      )
                    : Column(
                        children: [
                          Constant.userModel?.vendorID?.isEmpty == true &&
                                  double.parse(controller
                                          .driverModel.value.walletAmount
                                          .toString()) <
                                      double.parse(
                                          Constant.minimumDepositToRideAccept)
                              ? Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(
                                    "${'You have to minimum'.tr} ${Constant.amountShow(amount: Constant.minimumDepositToRideAccept.toString())} ${'wallet amount to receiving Order'.tr}",
                                    style: TextStyle(
                                        color: themeChange.getThem()
                                            ? AppThemeData.grey50
                                            : AppThemeData.grey900,
                                        fontSize: 14,
                                        fontFamily: AppThemeData.semiBold),
                                  ),
                                )
                              : const SizedBox(),
                          Expanded(
                            child: DefaultTabController(
                              length:
                                  Constant.userModel?.vendorID?.isEmpty == true
                                      ? 1
                                      : 2,
                              child: Column(
                                children: [
                                  Container(
                                    color: themeChange.getThem()
                                        ? AppThemeData.grey900
                                        : AppThemeData.grey50,
                                    child: TabBar(
                                      onTap: (value) {
                                        controller.selectedTabIndex.value =
                                            value;
                                      },
                                      labelStyle: const TextStyle(
                                          fontFamily: AppThemeData.semiBold),
                                      labelColor: themeChange.getThem()
                                          ? AppThemeData.driverApp300
                                          : AppThemeData.driverApp300,
                                      unselectedLabelStyle: const TextStyle(
                                          fontFamily: AppThemeData.medium),
                                      unselectedLabelColor:
                                          themeChange.getThem()
                                              ? AppThemeData.grey500
                                              : AppThemeData.grey400,
                                      indicatorColor: AppThemeData.driverApp300,
                                      isScrollable: false,
                                      dividerColor: Colors.transparent,
                                      tabs: [
                                        if (Constant
                                                .userModel?.vendorID?.isEmpty ==
                                            true)
                                          Tab(
                                            text: "New".tr,
                                          ),
                                        Tab(
                                          text: "Active".tr,
                                        ),
                                      ],
                                    ),
                                  ),
                                  Expanded(
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 16, vertical: 10),
                                      child: TabBarView(
                                        children: [
                                          if (Constant.userModel?.vendorID
                                                  ?.isEmpty ==
                                              true)
                                            controller.newOrder.isEmpty
                                                ? Constant.showEmptyView(
                                                    message:
                                                        "New Order not found."
                                                            .tr)
                                                : ListView.builder(
                                                    shrinkWrap: true,
                                                    padding: EdgeInsets.zero,
                                                    scrollDirection:
                                                        Axis.vertical,
                                                    itemCount: controller
                                                        .newOrder.length,
                                                    itemBuilder:
                                                        (BuildContext context,
                                                            int index) {
                                                      return Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .symmetric(
                                                                vertical: 5),
                                                        child: Container(
                                                          decoration:
                                                              ShapeDecoration(
                                                            color: themeChange
                                                                    .getThem()
                                                                ? AppThemeData
                                                                    .grey900
                                                                : AppThemeData
                                                                    .grey50,
                                                            shape:
                                                                RoundedRectangleBorder(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          16),
                                                            ),
                                                          ),
                                                          child: Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                    .all(8.0),
                                                            child:
                                                                FutureBuilder(
                                                                    future: FireStoreUtils.getOrderById(
                                                                        controller.newOrder[
                                                                            index]),
                                                                    builder:
                                                                        (context,
                                                                            snapshot) {
                                                                      if (snapshot
                                                                              .connectionState ==
                                                                          ConnectionState
                                                                              .waiting) {
                                                                        return const SizedBox();
                                                                      } else {
                                                                        if (snapshot
                                                                            .hasError) {
                                                                          return Center(
                                                                              child: Text('Error: ${snapshot.error}'));
                                                                        } else if (snapshot.data ==
                                                                            null) {
                                                                          return const SizedBox();
                                                                        } else {
                                                                          OrderModel
                                                                              orderModel =
                                                                              snapshot.data!;
                                                                          double distanceInMeters = Geolocator.distanceBetween(
                                                                              orderModel.vendor!.latitude ?? 0.0,
                                                                              orderModel.vendor!.longitude ?? 0.0,
                                                                              orderModel.address!.location!.latitude ?? 0.0,
                                                                              orderModel.address!.location!.longitude ?? 0.0);
                                                                          double
                                                                              kilometer =
                                                                              distanceInMeters / 1000;
                                                                          return InkWell(
                                                                            onTap:
                                                                                () {
                                                                              Get
                                                                                  .to(
                                                                                      const HomeScreen(
                                                                                        isAppBarShow: true,
                                                                                      ),
                                                                                      arguments: {
                                                                                    "orderModel": orderModel
                                                                                  });
                                                                            },
                                                                            child:
                                                                                Column(
                                                                              children: [
                                                                                Timeline.tileBuilder(
                                                                                  shrinkWrap: true,
                                                                                  padding: EdgeInsets.zero,
                                                                                  physics: const NeverScrollableScrollPhysics(),
                                                                                  theme: TimelineThemeData(
                                                                                    nodePosition: 0,
                                                                                    // indicatorPosition: 0,
                                                                                  ),
                                                                                  builder: TimelineTileBuilder.connected(
                                                                                    contentsAlign: ContentsAlign.basic,
                                                                                    indicatorBuilder: (context, index) {
                                                                                      return index == 0
                                                                                          ? Container(
                                                                                              decoration: ShapeDecoration(
                                                                                                color: AppThemeData.primary50,
                                                                                                shape: RoundedRectangleBorder(
                                                                                                  borderRadius: BorderRadius.circular(120),
                                                                                                ),
                                                                                              ),
                                                                                              child: Padding(
                                                                                                padding: const EdgeInsets.all(10),
                                                                                                child: SvgPicture.asset(
                                                                                                  "assets/icons/ic_building.svg",
                                                                                                  colorFilter: const ColorFilter.mode(AppThemeData.primary300, BlendMode.srcIn),
                                                                                                ),
                                                                                              ),
                                                                                            )
                                                                                          : Container(
                                                                                              decoration: ShapeDecoration(
                                                                                                color: AppThemeData.driverApp50,
                                                                                                shape: RoundedRectangleBorder(
                                                                                                  borderRadius: BorderRadius.circular(120),
                                                                                                ),
                                                                                              ),
                                                                                              child: Padding(
                                                                                                padding: const EdgeInsets.all(10),
                                                                                                child: SvgPicture.asset(
                                                                                                  "assets/icons/ic_location.svg",
                                                                                                  colorFilter: ColorFilter.mode(AppThemeData.driverApp300, BlendMode.srcIn),
                                                                                                ),
                                                                                              ),
                                                                                            );
                                                                                    },
                                                                                    connectorBuilder: (context, index, connectorType) {
                                                                                      return const DashedLineConnector(
                                                                                        color: AppThemeData.grey300,
                                                                                        gap: 3,
                                                                                      );
                                                                                    },
                                                                                    contentsBuilder: (context, index) {
                                                                                      return Padding(
                                                                                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                                                                                        child: index == 0
                                                                                            ? Column(
                                                                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                                                                children: [
                                                                                                  Text(
                                                                                                    "${orderModel.vendor!.title}",
                                                                                                    textAlign: TextAlign.start,
                                                                                                    style: TextStyle(
                                                                                                      fontFamily: AppThemeData.semiBold,
                                                                                                      fontSize: 16,
                                                                                                      color: themeChange.getThem() ? AppThemeData.grey50 : AppThemeData.grey900,
                                                                                                    ),
                                                                                                  ),
                                                                                                  Text(
                                                                                                    "${orderModel.vendor!.location}",
                                                                                                    textAlign: TextAlign.start,
                                                                                                    style: TextStyle(
                                                                                                      fontFamily: AppThemeData.medium,
                                                                                                      fontSize: 14,
                                                                                                      color: themeChange.getThem() ? AppThemeData.grey300 : AppThemeData.grey600,
                                                                                                    ),
                                                                                                  ),
                                                                                                ],
                                                                                              )
                                                                                            : Column(
                                                                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                                                                children: [
                                                                                                  Text(
                                                                                                    "Deliver to the".tr,
                                                                                                    textAlign: TextAlign.start,
                                                                                                    style: TextStyle(
                                                                                                      fontFamily: AppThemeData.semiBold,
                                                                                                      fontSize: 16,
                                                                                                      color: themeChange.getThem() ? AppThemeData.grey50 : AppThemeData.grey900,
                                                                                                    ),
                                                                                                  ),
                                                                                                  Text(
                                                                                                    orderModel.address!.getFullAddress(),
                                                                                                    textAlign: TextAlign.start,
                                                                                                    style: TextStyle(
                                                                                                      fontFamily: AppThemeData.medium,
                                                                                                      fontSize: 14,
                                                                                                      color: themeChange.getThem() ? AppThemeData.grey300 : AppThemeData.grey600,
                                                                                                    ),
                                                                                                  ),
                                                                                                ],
                                                                                              ),
                                                                                      );
                                                                                    },
                                                                                    itemCount: 2,
                                                                                  ),
                                                                                ),
                                                                                Padding(
                                                                                  padding: const EdgeInsets.symmetric(vertical: 5),
                                                                                  child: MySeparator(color: themeChange.getThem() ? AppThemeData.grey700 : AppThemeData.grey200),
                                                                                ),
                                                                                Row(
                                                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                                                  children: [
                                                                                    Expanded(
                                                                                      child: Text(
                                                                                        "Trip Distance".tr,
                                                                                        textAlign: TextAlign.start,
                                                                                        style: TextStyle(
                                                                                          fontFamily: AppThemeData.regular,
                                                                                          color: themeChange.getThem() ? AppThemeData.grey300 : AppThemeData.grey600,
                                                                                          fontSize: 16,
                                                                                        ),
                                                                                      ),
                                                                                    ),
                                                                                    Text(
                                                                                      "${double.parse(kilometer.toString()).toStringAsFixed(2)} ${Constant.distanceType}",
                                                                                      textAlign: TextAlign.start,
                                                                                      style: TextStyle(
                                                                                        fontFamily: AppThemeData.semiBold,
                                                                                        color: themeChange.getThem() ? AppThemeData.grey50 : AppThemeData.grey900,
                                                                                        fontSize: 16,
                                                                                      ),
                                                                                    ),
                                                                                  ],
                                                                                ),
                                                                                Visibility(
                                                                                  visible: (controller.driverModel.value.vendorID?.isEmpty == true),
                                                                                  child: Column(
                                                                                    children: [
                                                                                      const SizedBox(
                                                                                        height: 5,
                                                                                      ),
                                                                                      Row(
                                                                                        crossAxisAlignment: CrossAxisAlignment.start,
                                                                                        children: [
                                                                                          Expanded(
                                                                                            child: Text(
                                                                                              "Delivery Charge".tr,
                                                                                              textAlign: TextAlign.start,
                                                                                              style: TextStyle(
                                                                                                fontFamily: AppThemeData.regular,
                                                                                                color: themeChange.getThem() ? AppThemeData.grey300 : AppThemeData.grey600,
                                                                                                fontSize: 16,
                                                                                              ),
                                                                                            ),
                                                                                          ),
                                                                                          Text(
                                                                                            Constant.amountShow(amount: orderModel.deliveryCharge),
                                                                                            textAlign: TextAlign.start,
                                                                                            style: TextStyle(
                                                                                              fontFamily: AppThemeData.semiBold,
                                                                                              color: themeChange.getThem() ? AppThemeData.grey50 : AppThemeData.grey900,
                                                                                              fontSize: 16,
                                                                                            ),
                                                                                          ),
                                                                                        ],
                                                                                      ),
                                                                                    ],
                                                                                  ),
                                                                                ),
                                                                                const SizedBox(
                                                                                  height: 5,
                                                                                ),
                                                                                orderModel.tipAmount == null || orderModel.tipAmount!.isEmpty || double.parse(orderModel.tipAmount.toString()) <= 0
                                                                                    ? const SizedBox()
                                                                                    : Row(
                                                                                        crossAxisAlignment: CrossAxisAlignment.start,
                                                                                        children: [
                                                                                          Expanded(
                                                                                            child: Text(
                                                                                              "Tips".tr,
                                                                                              textAlign: TextAlign.start,
                                                                                              style: TextStyle(
                                                                                                fontFamily: AppThemeData.regular,
                                                                                                color: themeChange.getThem() ? AppThemeData.grey300 : AppThemeData.grey600,
                                                                                                fontSize: 16,
                                                                                              ),
                                                                                            ),
                                                                                          ),
                                                                                          Text(
                                                                                            Constant.amountShow(amount: orderModel.tipAmount),
                                                                                            textAlign: TextAlign.start,
                                                                                            style: TextStyle(
                                                                                              fontFamily: AppThemeData.semiBold,
                                                                                              color: themeChange.getThem() ? AppThemeData.grey50 : AppThemeData.grey900,
                                                                                              fontSize: 16,
                                                                                            ),
                                                                                          ),
                                                                                        ],
                                                                                      ),
                                                                                const SizedBox(
                                                                                  height: 10,
                                                                                ),
                                                                                Row(
                                                                                  children: [
                                                                                    Expanded(
                                                                                      child: RoundedButtonFill(
                                                                                        title: "Reject".tr,
                                                                                        width: 24,
                                                                                        height: 5.5,
                                                                                        borderRadius: 10,
                                                                                        color: AppThemeData.danger300,
                                                                                        textColor: AppThemeData.grey50,
                                                                                        onPress: () {
                                                                                          controller.rejectOrder(orderModel);
                                                                                        },
                                                                                      ),
                                                                                    ),
                                                                                    const SizedBox(
                                                                                      width: 10,
                                                                                    ),
                                                                                    Expanded(
                                                                                      child: RoundedButtonFill(
                                                                                        title: "Accept".tr,
                                                                                        width: 24,
                                                                                        height: 5.5,
                                                                                        borderRadius: 10,
                                                                                        color: AppThemeData.success400,
                                                                                        textColor: AppThemeData.grey50,
                                                                                        onPress: () {
                                                                                          controller.acceptOrder(orderModel);
                                                                                        },
                                                                                      ),
                                                                                    )
                                                                                  ],
                                                                                ),
                                                                                const SizedBox(
                                                                                  height: 10,
                                                                                ),
                                                                              ],
                                                                            ),
                                                                          );
                                                                        }
                                                                      }
                                                                    }),
                                                          ),
                                                        ),
                                                      );
                                                    },
                                                  ),
                                          controller.activeOrder.isEmpty
                                              ? Constant.showEmptyView(
                                                  message:
                                                      "Active order not found."
                                                          .tr)
                                              : ListView.builder(
                                                  itemCount: controller
                                                      .activeOrder.length,
                                                  shrinkWrap: true,
                                                  padding: EdgeInsets.zero,
                                                  itemBuilder:
                                                      (context, index) {
                                                    return Padding(
                                                      padding: const EdgeInsets
                                                          .symmetric(
                                                          vertical: 5),
                                                      child: Container(
                                                        decoration:
                                                            ShapeDecoration(
                                                          color: themeChange
                                                                  .getThem()
                                                              ? AppThemeData
                                                                  .grey900
                                                              : AppThemeData
                                                                  .grey50,
                                                          shape:
                                                              RoundedRectangleBorder(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        16),
                                                          ),
                                                        ),
                                                        child: Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                  .all(8.0),
                                                          child: FutureBuilder(
                                                              future: FireStoreUtils
                                                                  .getOrderById(
                                                                      controller
                                                                              .activeOrder[
                                                                          index]),
                                                              builder: (context,
                                                                  snapshot) {
                                                                if (snapshot
                                                                        .connectionState ==
                                                                    ConnectionState
                                                                        .waiting) {
                                                                  return const SizedBox();
                                                                } else {
                                                                  if (snapshot
                                                                      .hasError) {
                                                                    return Center(
                                                                        child: Text(
                                                                            'Error: ${snapshot.error}'));
                                                                  } else if (snapshot
                                                                          .data ==
                                                                      null) {
                                                                    return const SizedBox();
                                                                  } else {
                                                                    OrderModel
                                                                        orderModel =
                                                                        snapshot
                                                                            .data!;
                                                                    double distanceInMeters = Geolocator.distanceBetween(
                                                                        orderModel.vendor!.latitude ??
                                                                            0.0,
                                                                        orderModel.vendor!.longitude ??
                                                                            0.0,
                                                                        orderModel.address!.location!.latitude ??
                                                                            0.0,
                                                                        orderModel.address!.location!.longitude ??
                                                                            0.0);
                                                                    double
                                                                        kilometer =
                                                                        distanceInMeters /
                                                                            1000;
                                                                    return InkWell(
                                                                      onTap:
                                                                          () {
                                                                        Get.to(
                                                                            const HomeScreen(
                                                                              isAppBarShow: true,
                                                                            ),
                                                                            arguments: {
                                                                              "orderModel": orderModel
                                                                            });
                                                                      },
                                                                      child:
                                                                          Column(
                                                                        children: [
                                                                          Timeline
                                                                              .tileBuilder(
                                                                            shrinkWrap:
                                                                                true,
                                                                            padding:
                                                                                EdgeInsets.zero,
                                                                            physics:
                                                                                const NeverScrollableScrollPhysics(),
                                                                            theme:
                                                                                TimelineThemeData(
                                                                              nodePosition: 0,
                                                                              // indicatorPosition: 0,
                                                                            ),
                                                                            builder:
                                                                                TimelineTileBuilder.connected(
                                                                              contentsAlign: ContentsAlign.basic,
                                                                              indicatorBuilder: (context, index) {
                                                                                return index == 0
                                                                                    ? Container(
                                                                                        decoration: ShapeDecoration(
                                                                                          color: AppThemeData.primary50,
                                                                                          shape: RoundedRectangleBorder(
                                                                                            borderRadius: BorderRadius.circular(120),
                                                                                          ),
                                                                                        ),
                                                                                        child: Padding(
                                                                                          padding: const EdgeInsets.all(10),
                                                                                          child: SvgPicture.asset(
                                                                                            "assets/icons/ic_building.svg",
                                                                                            colorFilter: const ColorFilter.mode(AppThemeData.primary300, BlendMode.srcIn),
                                                                                          ),
                                                                                        ),
                                                                                      )
                                                                                    : Container(
                                                                                        decoration: ShapeDecoration(
                                                                                          color: AppThemeData.driverApp50,
                                                                                          shape: RoundedRectangleBorder(
                                                                                            borderRadius: BorderRadius.circular(120),
                                                                                          ),
                                                                                        ),
                                                                                        child: Padding(
                                                                                          padding: const EdgeInsets.all(10),
                                                                                          child: SvgPicture.asset(
                                                                                            "assets/icons/ic_location.svg",
                                                                                            colorFilter: ColorFilter.mode(AppThemeData.driverApp300, BlendMode.srcIn),
                                                                                          ),
                                                                                        ),
                                                                                      );
                                                                              },
                                                                              connectorBuilder: (context, index, connectorType) {
                                                                                return const DashedLineConnector(
                                                                                  color: AppThemeData.grey300,
                                                                                  gap: 3,
                                                                                );
                                                                              },
                                                                              contentsBuilder: (context, index) {
                                                                                return Padding(
                                                                                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                                                                                  child: index == 0
                                                                                      ? Column(
                                                                                          crossAxisAlignment: CrossAxisAlignment.start,
                                                                                          children: [
                                                                                            Text(
                                                                                              "${orderModel.vendor!.title}",
                                                                                              textAlign: TextAlign.start,
                                                                                              style: TextStyle(
                                                                                                fontFamily: AppThemeData.semiBold,
                                                                                                fontSize: 16,
                                                                                                color: themeChange.getThem() ? AppThemeData.grey50 : AppThemeData.grey900,
                                                                                              ),
                                                                                            ),
                                                                                            Text(
                                                                                              "${orderModel.vendor!.location}",
                                                                                              textAlign: TextAlign.start,
                                                                                              style: TextStyle(
                                                                                                fontFamily: AppThemeData.medium,
                                                                                                fontSize: 14,
                                                                                                color: themeChange.getThem() ? AppThemeData.grey300 : AppThemeData.grey600,
                                                                                              ),
                                                                                            ),
                                                                                          ],
                                                                                        )
                                                                                      : Column(
                                                                                          crossAxisAlignment: CrossAxisAlignment.start,
                                                                                          children: [
                                                                                            Text(
                                                                                              "Deliver to the".tr,
                                                                                              textAlign: TextAlign.start,
                                                                                              style: TextStyle(
                                                                                                fontFamily: AppThemeData.semiBold,
                                                                                                fontSize: 16,
                                                                                                color: themeChange.getThem() ? AppThemeData.grey50 : AppThemeData.grey900,
                                                                                              ),
                                                                                            ),
                                                                                            Text(
                                                                                              orderModel.address!.getFullAddress(),
                                                                                              textAlign: TextAlign.start,
                                                                                              style: TextStyle(
                                                                                                fontFamily: AppThemeData.medium,
                                                                                                fontSize: 14,
                                                                                                color: themeChange.getThem() ? AppThemeData.grey300 : AppThemeData.grey600,
                                                                                              ),
                                                                                            ),
                                                                                          ],
                                                                                        ),
                                                                                );
                                                                              },
                                                                              itemCount: 2,
                                                                            ),
                                                                          ),
                                                                          Padding(
                                                                            padding:
                                                                                const EdgeInsets.symmetric(vertical: 5),
                                                                            child:
                                                                                MySeparator(color: themeChange.getThem() ? AppThemeData.grey700 : AppThemeData.grey200),
                                                                          ),
                                                                          Row(
                                                                            crossAxisAlignment:
                                                                                CrossAxisAlignment.start,
                                                                            children: [
                                                                              Expanded(
                                                                                child: Text(
                                                                                  "Trip Distance".tr,
                                                                                  textAlign: TextAlign.start,
                                                                                  style: TextStyle(
                                                                                    fontFamily: AppThemeData.regular,
                                                                                    color: themeChange.getThem() ? AppThemeData.grey300 : AppThemeData.grey600,
                                                                                    fontSize: 16,
                                                                                  ),
                                                                                ),
                                                                              ),
                                                                              Text(
                                                                                "${double.parse(kilometer.toString()).toStringAsFixed(2)} ${Constant.distanceType}",
                                                                                textAlign: TextAlign.start,
                                                                                style: TextStyle(
                                                                                  fontFamily: AppThemeData.semiBold,
                                                                                  color: themeChange.getThem() ? AppThemeData.grey50 : AppThemeData.grey900,
                                                                                  fontSize: 16,
                                                                                ),
                                                                              ),
                                                                            ],
                                                                          ),
                                                                          Visibility(
                                                                            visible:
                                                                                (controller.driverModel.value.vendorID?.isEmpty == true),
                                                                            child:
                                                                                Column(children: [
                                                                              const SizedBox(
                                                                                height: 5,
                                                                              ),
                                                                              Row(
                                                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                                                children: [
                                                                                  Expanded(
                                                                                    child: Text(
                                                                                      "Delivery Charge".tr,
                                                                                      textAlign: TextAlign.start,
                                                                                      style: TextStyle(
                                                                                        fontFamily: AppThemeData.regular,
                                                                                        color: themeChange.getThem() ? AppThemeData.grey300 : AppThemeData.grey600,
                                                                                        fontSize: 16,
                                                                                      ),
                                                                                    ),
                                                                                  ),
                                                                                  Text(
                                                                                    Constant.amountShow(amount: orderModel.deliveryCharge),
                                                                                    textAlign: TextAlign.start,
                                                                                    style: TextStyle(
                                                                                      fontFamily: AppThemeData.semiBold,
                                                                                      color: themeChange.getThem() ? AppThemeData.grey50 : AppThemeData.grey900,
                                                                                      fontSize: 16,
                                                                                    ),
                                                                                  ),
                                                                                ],
                                                                              ),
                                                                            ]),
                                                                          ),
                                                                          const SizedBox(
                                                                            height:
                                                                                5,
                                                                          ),
                                                                          orderModel.tipAmount == null || orderModel.tipAmount!.isEmpty || double.parse(orderModel.tipAmount.toString()) <= 0
                                                                              ? const SizedBox()
                                                                              : Row(
                                                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                                                  children: [
                                                                                    Expanded(
                                                                                      child: Text(
                                                                                        "Tips".tr,
                                                                                        textAlign: TextAlign.start,
                                                                                        style: TextStyle(
                                                                                          fontFamily: AppThemeData.regular,
                                                                                          color: themeChange.getThem() ? AppThemeData.grey300 : AppThemeData.grey600,
                                                                                          fontSize: 16,
                                                                                        ),
                                                                                      ),
                                                                                    ),
                                                                                    Text(
                                                                                      Constant.amountShow(amount: orderModel.tipAmount),
                                                                                      textAlign: TextAlign.start,
                                                                                      style: TextStyle(
                                                                                        fontFamily: AppThemeData.semiBold,
                                                                                        color: themeChange.getThem() ? AppThemeData.grey50 : AppThemeData.grey900,
                                                                                        fontSize: 16,
                                                                                      ),
                                                                                    ),
                                                                                  ],
                                                                                ),
                                                                          const SizedBox(
                                                                            height:
                                                                                10,
                                                                          ),
                                                                        ],
                                                                      ),
                                                                    );
                                                                  }
                                                                }
                                                              }),
                                                        ),
                                                      ),
                                                    );
                                                  },
                                                ),
                                        ],
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            ),
                          )
                        ],
                      ),
          );
        });
  }
}
