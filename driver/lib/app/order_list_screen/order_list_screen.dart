import 'package:driver/app/order_list_screen/order_details_screen.dart';
import 'package:driver/constant/constant.dart';
import 'package:driver/controllers/dash_board_controller.dart';
import 'package:driver/controllers/order_list_controller.dart';
import 'package:driver/models/order_model.dart';
import 'package:driver/themes/app_them_data.dart';
import 'package:driver/themes/round_button_fill.dart';
import 'package:driver/utils/dark_theme_provider.dart';
import 'package:driver/widget/my_separator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:timelines_plus/timelines_plus.dart';

class OrderListScreen extends StatelessWidget {
  const OrderListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final themeChange = Provider.of<DarkThemeProvider>(context);
    return GetX(
        init: OrderListController(),
        builder: (controller) {
          return Scaffold(
            body: controller.isLoading.value
                ? Constant.loader()
                : Constant.isDriverVerification == true &&
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
                    : Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 10),
                        child: controller.orderList.isEmpty
                            ? Constant.showEmptyView(
                                message: "Order Not found".tr)
                            : ListView.builder(
                                shrinkWrap: true,
                                itemCount: controller.orderList.length,
                                itemBuilder: (context, index) {
                                  OrderModel orderModel =
                                      controller.orderList[index];
                                  return Padding(
                                    padding:
                                        const EdgeInsets.symmetric(vertical: 5),
                                    child: InkWell(
                                      onTap: () {
                                        Get.to(const OrderDetailsScreen(),
                                            arguments: {
                                              "orderModel": orderModel
                                            });
                                      },
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
                                          child: Column(
                                            children: [
                                              Row(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Expanded(
                                                    child: Text(
                                                      "Order ID".tr,
                                                      textAlign:
                                                          TextAlign.start,
                                                      style: TextStyle(
                                                        fontFamily: AppThemeData
                                                            .regular,
                                                        color: themeChange
                                                                .getThem()
                                                            ? AppThemeData
                                                                .grey300
                                                            : AppThemeData
                                                                .grey600,
                                                      ),
                                                    ),
                                                  ),
                                                  Text(
                                                    Constant.orderId(
                                                        orderId: orderModel.id
                                                            .toString()),
                                                    textAlign: TextAlign.start,
                                                    style: TextStyle(
                                                      fontFamily:
                                                          AppThemeData.semiBold,
                                                      color: themeChange
                                                              .getThem()
                                                          ? AppThemeData.grey50
                                                          : AppThemeData
                                                              .grey900,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              const SizedBox(
                                                height: 5,
                                              ),
                                              Row(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Expanded(
                                                    child: Text(
                                                      "Status".tr,
                                                      textAlign:
                                                          TextAlign.start,
                                                      style: TextStyle(
                                                        fontFamily: AppThemeData
                                                            .regular,
                                                        color: themeChange
                                                                .getThem()
                                                            ? AppThemeData
                                                                .grey300
                                                            : AppThemeData
                                                                .grey600,
                                                      ),
                                                    ),
                                                  ),
                                                  Text(
                                                    orderModel.status
                                                        .toString(),
                                                    textAlign: TextAlign.start,
                                                    style: TextStyle(
                                                      fontFamily:
                                                          AppThemeData.semiBold,
                                                      color:
                                                          Constant.statusColor(
                                                              status: orderModel
                                                                  .status),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              const SizedBox(
                                                height: 5,
                                              ),
                                              Row(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Expanded(
                                                    child: Text(
                                                      "Date".tr,
                                                      textAlign:
                                                          TextAlign.start,
                                                      style: TextStyle(
                                                        fontFamily: AppThemeData
                                                            .regular,
                                                        color: themeChange
                                                                .getThem()
                                                            ? AppThemeData
                                                                .grey300
                                                            : AppThemeData
                                                                .grey600,
                                                      ),
                                                    ),
                                                  ),
                                                  Text(
                                                    Constant
                                                        .timestampToDateTime(
                                                            orderModel
                                                                .createdAt!),
                                                    textAlign: TextAlign.start,
                                                    style: TextStyle(
                                                      fontFamily:
                                                          AppThemeData.semiBold,
                                                      color: themeChange
                                                              .getThem()
                                                          ? AppThemeData.grey50
                                                          : AppThemeData
                                                              .grey900,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              Padding(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        vertical: 10),
                                                child: MySeparator(
                                                    color: themeChange.getThem()
                                                        ? AppThemeData.grey700
                                                        : AppThemeData.grey200),
                                              ),
                                              Timeline.tileBuilder(
                                                shrinkWrap: true,
                                                padding: EdgeInsets.zero,
                                                physics:
                                                    const NeverScrollableScrollPhysics(),
                                                theme: TimelineThemeData(
                                                  nodePosition: 0,
                                                  // indicatorPosition: 0,
                                                ),
                                                builder: TimelineTileBuilder
                                                    .connected(
                                                  contentsAlign:
                                                      ContentsAlign.basic,
                                                  indicatorBuilder:
                                                      (context, index) {
                                                    return index == 0
                                                        ? Container(
                                                            decoration:
                                                                ShapeDecoration(
                                                              color: AppThemeData
                                                                  .primary50,
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
                                                              child: SvgPicture
                                                                  .asset(
                                                                "assets/icons/ic_building.svg",
                                                                colorFilter: const ColorFilter
                                                                    .mode(
                                                                    AppThemeData
                                                                        .primary300,
                                                                    BlendMode
                                                                        .srcIn),
                                                              ),
                                                            ),
                                                          )
                                                        : Container(
                                                            decoration:
                                                                ShapeDecoration(
                                                              color: AppThemeData
                                                                  .driverApp50,
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
                                                              child: SvgPicture
                                                                  .asset(
                                                                "assets/icons/ic_location.svg",
                                                                colorFilter: ColorFilter.mode(
                                                                    AppThemeData
                                                                        .driverApp300,
                                                                    BlendMode
                                                                        .srcIn),
                                                              ),
                                                            ),
                                                          );
                                                  },
                                                  connectorBuilder: (context,
                                                      index, connectorType) {
                                                    return const DashedLineConnector(
                                                      color:
                                                          AppThemeData.grey300,
                                                      gap: 3,
                                                    );
                                                  },
                                                  contentsBuilder:
                                                      (context, index) {
                                                    return Padding(
                                                      padding: const EdgeInsets
                                                          .symmetric(
                                                          horizontal: 10,
                                                          vertical: 10),
                                                      child: index == 0
                                                          ? Column(
                                                              crossAxisAlignment:
                                                                  CrossAxisAlignment
                                                                      .start,
                                                              children: [
                                                                Text(
                                                                  "${orderModel.vendor!.title}",
                                                                  textAlign:
                                                                      TextAlign
                                                                          .start,
                                                                  style:
                                                                      TextStyle(
                                                                    fontFamily:
                                                                        AppThemeData
                                                                            .semiBold,
                                                                    fontSize:
                                                                        16,
                                                                    color: themeChange.getThem()
                                                                        ? AppThemeData
                                                                            .grey50
                                                                        : AppThemeData
                                                                            .grey900,
                                                                  ),
                                                                ),
                                                                Text(
                                                                  "${orderModel.vendor!.location}",
                                                                  textAlign:
                                                                      TextAlign
                                                                          .start,
                                                                  style:
                                                                      TextStyle(
                                                                    fontFamily:
                                                                        AppThemeData
                                                                            .medium,
                                                                    fontSize:
                                                                        12,
                                                                    color: themeChange.getThem()
                                                                        ? AppThemeData
                                                                            .grey300
                                                                        : AppThemeData
                                                                            .grey600,
                                                                  ),
                                                                ),
                                                              ],
                                                            )
                                                          : Column(
                                                              crossAxisAlignment:
                                                                  CrossAxisAlignment
                                                                      .start,
                                                              children: [
                                                                Text(
                                                                  "Deliver to the"
                                                                      .tr,
                                                                  textAlign:
                                                                      TextAlign
                                                                          .start,
                                                                  style:
                                                                      TextStyle(
                                                                    fontFamily:
                                                                        AppThemeData
                                                                            .semiBold,
                                                                    fontSize:
                                                                        16,
                                                                    color: themeChange.getThem()
                                                                        ? AppThemeData
                                                                            .grey50
                                                                        : AppThemeData
                                                                            .grey900,
                                                                  ),
                                                                ),
                                                                Text(
                                                                  orderModel
                                                                      .address!
                                                                      .getFullAddress(),
                                                                  textAlign:
                                                                      TextAlign
                                                                          .start,
                                                                  style:
                                                                      TextStyle(
                                                                    fontFamily:
                                                                        AppThemeData
                                                                            .medium,
                                                                    fontSize:
                                                                        12,
                                                                    color: themeChange.getThem()
                                                                        ? AppThemeData
                                                                            .grey300
                                                                        : AppThemeData
                                                                            .grey600,
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                    );
                                                  },
                                                  itemCount: 2,
                                                ),
                                              ),
                                              Visibility(
                                                visible: (Constant.userModel
                                                        ?.vendorID?.isEmpty ==
                                                    true),
                                                child: Column(children: [
                                                  Padding(
                                                    padding: const EdgeInsets
                                                        .symmetric(vertical: 5),
                                                    child: MySeparator(
                                                        color: themeChange
                                                                .getThem()
                                                            ? AppThemeData
                                                                .grey700
                                                            : AppThemeData
                                                                .grey200),
                                                  ),
                                                  const SizedBox(
                                                    height: 10,
                                                  ),
                                                  Row(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Expanded(
                                                        child: Text(
                                                          "Delivery Charge".tr,
                                                          textAlign:
                                                              TextAlign.start,
                                                          style: TextStyle(
                                                            fontFamily:
                                                                AppThemeData
                                                                    .regular,
                                                            color: themeChange
                                                                    .getThem()
                                                                ? AppThemeData
                                                                    .grey300
                                                                : AppThemeData
                                                                    .grey600,
                                                            fontSize: 16,
                                                          ),
                                                        ),
                                                      ),
                                                      Text(
                                                        Constant.amountShow(
                                                            amount: orderModel
                                                                .deliveryCharge),
                                                        textAlign:
                                                            TextAlign.start,
                                                        style: TextStyle(
                                                          fontFamily:
                                                              AppThemeData
                                                                  .semiBold,
                                                          color: themeChange
                                                                  .getThem()
                                                              ? AppThemeData
                                                                  .grey50
                                                              : AppThemeData
                                                                  .grey900,
                                                          fontSize: 16,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ]),
                                              ),
                                              const SizedBox(
                                                height: 5,
                                              ),
                                              orderModel.tipAmount == null ||
                                                      orderModel
                                                          .tipAmount!.isEmpty ||
                                                      double.parse(orderModel
                                                              .tipAmount
                                                              .toString()) <=
                                                          0
                                                  ? const SizedBox()
                                                  : Row(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        Expanded(
                                                          child: Text(
                                                            "Tips".tr,
                                                            textAlign:
                                                                TextAlign.start,
                                                            style: TextStyle(
                                                              fontFamily:
                                                                  AppThemeData
                                                                      .regular,
                                                              color: themeChange
                                                                      .getThem()
                                                                  ? AppThemeData
                                                                      .grey300
                                                                  : AppThemeData
                                                                      .grey600,
                                                              fontSize: 16,
                                                            ),
                                                          ),
                                                        ),
                                                        Text(
                                                          Constant.amountShow(
                                                              amount: orderModel
                                                                  .tipAmount),
                                                          textAlign:
                                                              TextAlign.start,
                                                          style: TextStyle(
                                                            fontFamily:
                                                                AppThemeData
                                                                    .semiBold,
                                                            color: themeChange
                                                                    .getThem()
                                                                ? AppThemeData
                                                                    .grey50
                                                                : AppThemeData
                                                                    .grey900,
                                                            fontSize: 16,
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                              const SizedBox(
                                                height: 10,
                                              ),
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
