import 'package:driver/constant/constant.dart';
import 'package:driver/controllers/order_details_controller.dart';
import 'package:driver/models/cart_product_model.dart';
import 'package:driver/models/tax_model.dart';
import 'package:driver/themes/app_them_data.dart';
import 'package:driver/themes/responsive.dart';
import 'package:driver/themes/round_button_fill.dart';
import 'package:driver/utils/dark_theme_provider.dart';
import 'package:driver/utils/network_image_widget.dart';
import 'package:driver/widget/my_separator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:timelines_plus/timelines_plus.dart';

class OrderDetailsScreen extends StatelessWidget {
  const OrderDetailsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final themeChange = Provider.of<DarkThemeProvider>(context);
    return GetX(
        init: OrderDetailsController(),
        builder: (controller) {
          return Scaffold(
            backgroundColor: themeChange.getThem()
                ? AppThemeData.surfaceDark
                : AppThemeData.surface,
            appBar: AppBar(
              backgroundColor: themeChange.getThem()
                  ? AppThemeData.surfaceDark
                  : AppThemeData.surface,
              centerTitle: false,
              titleSpacing: 0,
              title: Text(
                "Order Details".tr,
                textAlign: TextAlign.start,
                style: TextStyle(
                  fontFamily: AppThemeData.medium,
                  fontSize: 16,
                  color: themeChange.getThem()
                      ? AppThemeData.grey50
                      : AppThemeData.grey900,
                ),
              ),
            ),
            body: controller.isLoading.value
                ? Constant.loader()
                : Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "${'Order'.tr} ${Constant.orderId(orderId: controller.orderModel.value.id.toString())}"
                                          .tr,
                                      textAlign: TextAlign.start,
                                      style: TextStyle(
                                        fontFamily: AppThemeData.semiBold,
                                        fontSize: 18,
                                        color: themeChange.getThem()
                                            ? AppThemeData.grey50
                                            : AppThemeData.grey900,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              RoundedButtonFill(
                                title: controller.orderModel.value.status
                                    .toString()
                                    .tr,
                                color: Constant.statusColor(
                                    status: controller.orderModel.value.status
                                        .toString()),
                                width: 32,
                                height: 4.5,
                                textColor: Constant.statusText(
                                    status: controller.orderModel.value.status
                                        .toString()),
                                onPress: () async {},
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: 14,
                          ),
                          Container(
                            decoration: ShapeDecoration(
                              color: themeChange.getThem()
                                  ? AppThemeData.grey900
                                  : AppThemeData.grey50,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            child: Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 16),
                              child: Column(
                                children: [
                                  Timeline.tileBuilder(
                                    shrinkWrap: true,
                                    padding: EdgeInsets.zero,
                                    physics:
                                        const NeverScrollableScrollPhysics(),
                                    theme: TimelineThemeData(
                                      nodePosition: 0,
                                      // indicatorPosition: 0,
                                    ),
                                    builder: TimelineTileBuilder.connected(
                                      contentsAlign: ContentsAlign.basic,
                                      indicatorBuilder: (context, index) {
                                        return SvgPicture.asset(
                                            "assets/icons/ic_location.svg");
                                      },
                                      connectorBuilder:
                                          (context, index, connectorType) {
                                        return const DashedLineConnector(
                                          color: AppThemeData.grey300,
                                          gap: 3,
                                        );
                                      },
                                      contentsBuilder: (context, index) {
                                        return Padding(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 10, vertical: 10),
                                          child: index == 0
                                              ? Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                      "${controller.orderModel.value.vendor!.title}",
                                                      textAlign:
                                                          TextAlign.start,
                                                      style: TextStyle(
                                                        fontFamily: AppThemeData
                                                            .semiBold,
                                                        fontSize: 16,
                                                        color: themeChange
                                                                .getThem()
                                                            ? AppThemeData
                                                                .primary300
                                                            : AppThemeData
                                                                .primary300,
                                                      ),
                                                    ),
                                                    Text(
                                                      "${controller.orderModel.value.vendor!.location}",
                                                      textAlign:
                                                          TextAlign.start,
                                                      style: TextStyle(
                                                        fontFamily:
                                                            AppThemeData.medium,
                                                        fontSize: 14,
                                                        color: themeChange
                                                                .getThem()
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
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                      "${controller.orderModel.value.address!.addressAs}",
                                                      textAlign:
                                                          TextAlign.start,
                                                      style: TextStyle(
                                                        fontFamily: AppThemeData
                                                            .semiBold,
                                                        fontSize: 16,
                                                        color: themeChange
                                                                .getThem()
                                                            ? AppThemeData
                                                                .primary300
                                                            : AppThemeData
                                                                .primary300,
                                                      ),
                                                    ),
                                                    Text(
                                                      controller.orderModel
                                                          .value.address!
                                                          .getFullAddress(),
                                                      textAlign:
                                                          TextAlign.start,
                                                      style: TextStyle(
                                                        fontFamily:
                                                            AppThemeData.medium,
                                                        fontSize: 14,
                                                        color: themeChange
                                                                .getThem()
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
                                  const SizedBox(
                                    height: 10,
                                  ),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 14,
                          ),
                          Text(
                            "Order Details".tr,
                            textAlign: TextAlign.start,
                            style: TextStyle(
                              fontFamily: AppThemeData.semiBold,
                              fontSize: 16,
                              color: themeChange.getThem()
                                  ? AppThemeData.grey50
                                  : AppThemeData.grey900,
                            ),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          Container(
                            decoration: ShapeDecoration(
                              color: themeChange.getThem()
                                  ? AppThemeData.grey900
                                  : AppThemeData.grey50,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 16, vertical: 10),
                              child: ListView.separated(
                                shrinkWrap: true,
                                padding: EdgeInsets.zero,
                                itemCount: controller
                                    .orderModel.value.products!.length,
                                physics: const NeverScrollableScrollPhysics(),
                                itemBuilder: (context, index) {
                                  CartProductModel cartProductModel = controller
                                      .orderModel.value.products![index];
                                  return Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          ClipRRect(
                                            borderRadius:
                                                const BorderRadius.all(
                                                    Radius.circular(14)),
                                            child: Stack(
                                              children: [
                                                NetworkImageWidget(
                                                  imageUrl: cartProductModel
                                                      .photo
                                                      .toString(),
                                                  height: Responsive.height(
                                                      8, context),
                                                  width: Responsive.width(
                                                      16, context),
                                                  fit: BoxFit.cover,
                                                ),
                                                Container(
                                                  height: Responsive.height(
                                                      8, context),
                                                  width: Responsive.width(
                                                      16, context),
                                                  decoration: BoxDecoration(
                                                    gradient: LinearGradient(
                                                      begin: const Alignment(
                                                          -0.00, -1.00),
                                                      end:
                                                          const Alignment(0, 1),
                                                      colors: [
                                                        Colors.black
                                                            .withOpacity(0),
                                                        const Color(0xFF111827)
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
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Row(
                                                  children: [
                                                    Expanded(
                                                      child: Text(
                                                        "${cartProductModel.name}",
                                                        textAlign:
                                                            TextAlign.start,
                                                        style: TextStyle(
                                                          fontFamily:
                                                              AppThemeData
                                                                  .regular,
                                                          color: themeChange
                                                                  .getThem()
                                                              ? AppThemeData
                                                                  .grey50
                                                              : AppThemeData
                                                                  .grey900,
                                                          fontSize: 16,
                                                        ),
                                                      ),
                                                    ),
                                                    Text(
                                                      "x ${cartProductModel.quantity}",
                                                      textAlign:
                                                          TextAlign.start,
                                                      style: TextStyle(
                                                        fontFamily: AppThemeData
                                                            .regular,
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
                                                double.parse(cartProductModel
                                                                        .discountPrice ==
                                                                    null ||
                                                                cartProductModel
                                                                    .discountPrice!
                                                                    .isEmpty
                                                            ? "0.0"
                                                            : cartProductModel
                                                                .discountPrice
                                                                .toString()) <=
                                                        0
                                                    ? Text(
                                                        Constant.amountShow(
                                                            amount:
                                                                cartProductModel
                                                                    .price),
                                                        style: TextStyle(
                                                          fontSize: 16,
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
                                                      )
                                                    : Row(
                                                        children: [
                                                          Text(
                                                            Constant.amountShow(
                                                                amount: cartProductModel
                                                                    .discountPrice
                                                                    .toString()),
                                                            style: TextStyle(
                                                              fontSize: 16,
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
                                                                  FontWeight
                                                                      .w600,
                                                            ),
                                                          ),
                                                          const SizedBox(
                                                            width: 5,
                                                          ),
                                                          Text(
                                                            Constant.amountShow(
                                                                amount:
                                                                    cartProductModel
                                                                        .price),
                                                            style: TextStyle(
                                                              fontSize: 14,
                                                              decoration:
                                                                  TextDecoration
                                                                      .lineThrough,
                                                              decorationColor: themeChange
                                                                      .getThem()
                                                                  ? AppThemeData
                                                                      .grey500
                                                                  : AppThemeData
                                                                      .grey400,
                                                              color: themeChange
                                                                      .getThem()
                                                                  ? AppThemeData
                                                                      .grey500
                                                                  : AppThemeData
                                                                      .grey400,
                                                              fontFamily:
                                                                  AppThemeData
                                                                      .semiBold,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w600,
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                      cartProductModel.variantInfo == null ||
                                              cartProductModel.variantInfo!
                                                  .variantOptions!.isEmpty
                                          ? Container()
                                          : Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 5,
                                                      vertical: 10),
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    "Variants".tr,
                                                    textAlign: TextAlign.start,
                                                    style: TextStyle(
                                                      fontFamily:
                                                          AppThemeData.semiBold,
                                                      color: themeChange
                                                              .getThem()
                                                          ? AppThemeData.grey300
                                                          : AppThemeData
                                                              .grey600,
                                                      fontSize: 16,
                                                    ),
                                                  ),
                                                  const SizedBox(
                                                    height: 5,
                                                  ),
                                                  Wrap(
                                                    spacing: 6.0,
                                                    runSpacing: 6.0,
                                                    children: List.generate(
                                                      cartProductModel
                                                          .variantInfo!
                                                          .variantOptions!
                                                          .length,
                                                      (i) {
                                                        return Container(
                                                          decoration:
                                                              ShapeDecoration(
                                                            color: themeChange
                                                                    .getThem()
                                                                ? AppThemeData
                                                                    .grey800
                                                                : AppThemeData
                                                                    .grey100,
                                                            shape: RoundedRectangleBorder(
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            8)),
                                                          ),
                                                          child: Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                    .symmetric(
                                                                    horizontal:
                                                                        16,
                                                                    vertical:
                                                                        5),
                                                            child: Text(
                                                              "${cartProductModel.variantInfo!.variantOptions!.keys.elementAt(i)} : ${cartProductModel.variantInfo!.variantOptions![cartProductModel.variantInfo!.variantOptions!.keys.elementAt(i)]}",
                                                              textAlign:
                                                                  TextAlign
                                                                      .start,
                                                              style: TextStyle(
                                                                fontFamily:
                                                                    AppThemeData
                                                                        .medium,
                                                                color: themeChange.getThem()
                                                                    ? AppThemeData
                                                                        .grey500
                                                                    : AppThemeData
                                                                        .grey400,
                                                              ),
                                                            ),
                                                          ),
                                                        );
                                                      },
                                                    ).toList(),
                                                  ),
                                                ],
                                              ),
                                            ),
                                      cartProductModel.extras == null ||
                                              cartProductModel.extras!.isEmpty
                                          ? const SizedBox()
                                          : Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Row(
                                                  children: [
                                                    Expanded(
                                                      child: Text(
                                                        "Addons".tr,
                                                        textAlign:
                                                            TextAlign.start,
                                                        style: TextStyle(
                                                          fontFamily:
                                                              AppThemeData
                                                                  .semiBold,
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
                                                          amount: (double.parse(
                                                                      cartProductModel
                                                                          .extrasPrice
                                                                          .toString()) *
                                                                  double.parse(
                                                                      cartProductModel
                                                                          .quantity
                                                                          .toString()))
                                                              .toString()),
                                                      textAlign:
                                                          TextAlign.start,
                                                      style: TextStyle(
                                                        fontFamily: AppThemeData
                                                            .semiBold,
                                                        color: themeChange
                                                                .getThem()
                                                            ? AppThemeData
                                                                .primary300
                                                            : AppThemeData
                                                                .primary300,
                                                        fontSize: 16,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                Wrap(
                                                  spacing: 6.0,
                                                  runSpacing: 6.0,
                                                  children: List.generate(
                                                    cartProductModel
                                                        .extras!.length,
                                                    (i) {
                                                      return Container(
                                                        decoration:
                                                            ShapeDecoration(
                                                          color: themeChange
                                                                  .getThem()
                                                              ? AppThemeData
                                                                  .grey800
                                                              : AppThemeData
                                                                  .grey100,
                                                          shape: RoundedRectangleBorder(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          8)),
                                                        ),
                                                        child: Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                  .symmetric(
                                                                  horizontal:
                                                                      16,
                                                                  vertical: 5),
                                                          child: Text(
                                                            cartProductModel
                                                                .extras![i]
                                                                .toString(),
                                                            textAlign:
                                                                TextAlign.start,
                                                            style: TextStyle(
                                                              fontFamily:
                                                                  AppThemeData
                                                                      .medium,
                                                              color: themeChange
                                                                      .getThem()
                                                                  ? AppThemeData
                                                                      .grey500
                                                                  : AppThemeData
                                                                      .grey400,
                                                            ),
                                                          ),
                                                        ),
                                                      );
                                                    },
                                                  ).toList(),
                                                ),
                                              ],
                                            ),
                                    ],
                                  );
                                },
                                separatorBuilder: (context, index) {
                                  return Padding(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 10),
                                    child: MySeparator(
                                        color: themeChange.getThem()
                                            ? AppThemeData.grey700
                                            : AppThemeData.grey200),
                                  );
                                },
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 14,
                          ),
                          Text(
                            "Bill Details".tr,
                            textAlign: TextAlign.start,
                            style: TextStyle(
                              fontFamily: AppThemeData.semiBold,
                              fontSize: 16,
                              color: themeChange.getThem()
                                  ? AppThemeData.grey50
                                  : AppThemeData.grey900,
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
                                  horizontal: 10, vertical: 14),
                              child: Column(
                                children: [
                                  Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Expanded(
                                        child: Text(
                                          "Item totals".tr,
                                          textAlign: TextAlign.start,
                                          style: TextStyle(
                                            fontFamily: AppThemeData.regular,
                                            color: themeChange.getThem()
                                                ? AppThemeData.grey300
                                                : AppThemeData.grey600,
                                            fontSize: 16,
                                          ),
                                        ),
                                      ),
                                      Text(
                                        Constant.amountShow(
                                            amount: controller.subTotal.value
                                                .toString()),
                                        textAlign: TextAlign.start,
                                        style: TextStyle(
                                          fontFamily: AppThemeData.regular,
                                          color: themeChange.getThem()
                                              ? AppThemeData.grey50
                                              : AppThemeData.grey900,
                                          fontSize: 16,
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  controller.orderModel.value.takeAway ==
                                              true ||
                                          Constant.userModel?.vendorID
                                                  ?.isNotEmpty ==
                                              true
                                      ? const SizedBox()
                                      : Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Expanded(
                                              child: Text(
                                                "Delivery Fee".tr,
                                                textAlign: TextAlign.start,
                                                style: TextStyle(
                                                  fontFamily:
                                                      AppThemeData.regular,
                                                  color: themeChange.getThem()
                                                      ? AppThemeData.grey300
                                                      : AppThemeData.grey600,
                                                  fontSize: 16,
                                                ),
                                              ),
                                            ),
                                            Text(
                                              Constant.amountShow(
                                                  amount: controller
                                                                  .orderModel
                                                                  .value
                                                                  .deliveryCharge ==
                                                              null ||
                                                          controller
                                                              .orderModel
                                                              .value
                                                              .deliveryCharge!
                                                              .isEmpty
                                                      ? "0.0"
                                                      : controller.orderModel
                                                          .value.deliveryCharge
                                                          .toString()),
                                              textAlign: TextAlign.start,
                                              style: TextStyle(
                                                fontFamily:
                                                    AppThemeData.regular,
                                                color: themeChange.getThem()
                                                    ? AppThemeData.grey50
                                                    : AppThemeData.grey900,
                                                fontSize: 16,
                                              ),
                                            ),
                                          ],
                                        ),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  MySeparator(
                                      color: themeChange.getThem()
                                          ? AppThemeData.grey700
                                          : AppThemeData.grey200),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Expanded(
                                        child: Text(
                                          "Coupon Discount".tr,
                                          textAlign: TextAlign.start,
                                          style: TextStyle(
                                            fontFamily: AppThemeData.regular,
                                            color: themeChange.getThem()
                                                ? AppThemeData.grey300
                                                : AppThemeData.grey600,
                                            fontSize: 16,
                                          ),
                                        ),
                                      ),
                                      Text(
                                        "- (${Constant.amountShow(amount: controller.orderModel.value.discount.toString())})",
                                        textAlign: TextAlign.start,
                                        style: TextStyle(
                                          fontFamily: AppThemeData.regular,
                                          color: themeChange.getThem()
                                              ? AppThemeData.danger300
                                              : AppThemeData.danger300,
                                          fontSize: 16,
                                        ),
                                      ),
                                    ],
                                  ),
                                  controller.orderModel.value.specialDiscount !=
                                              null &&
                                          controller.orderModel.value
                                                      .specialDiscount![
                                                  'special_discount'] !=
                                              null
                                      ? Column(
                                          children: [
                                            const SizedBox(
                                              height: 10,
                                            ),
                                            Row(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Expanded(
                                                  child: Text(
                                                    "Special Discount".tr,
                                                    textAlign: TextAlign.start,
                                                    style: TextStyle(
                                                      fontFamily:
                                                          AppThemeData.regular,
                                                      color: themeChange
                                                              .getThem()
                                                          ? AppThemeData.grey300
                                                          : AppThemeData
                                                              .grey600,
                                                      fontSize: 16,
                                                    ),
                                                  ),
                                                ),
                                                Text(
                                                  "- (${Constant.amountShow(amount: controller.specialDiscountAmount.value.toString())})",
                                                  textAlign: TextAlign.start,
                                                  style: TextStyle(
                                                    fontFamily:
                                                        AppThemeData.regular,
                                                    color: themeChange.getThem()
                                                        ? AppThemeData.danger300
                                                        : AppThemeData
                                                            .danger300,
                                                    fontSize: 16,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ],
                                        )
                                      : const SizedBox(),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  controller.orderModel.value.takeAway ==
                                              true ||
                                          Constant.userModel?.vendorID
                                                  ?.isNotEmpty ==
                                              true
                                      ? const SizedBox()
                                      : Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Expanded(
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    "Delivery Tips".tr,
                                                    textAlign: TextAlign.start,
                                                    style: TextStyle(
                                                      fontFamily:
                                                          AppThemeData.regular,
                                                      color: themeChange
                                                              .getThem()
                                                          ? AppThemeData.grey300
                                                          : AppThemeData
                                                              .grey600,
                                                      fontSize: 16,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            Text(
                                              Constant.amountShow(
                                                  amount: controller.orderModel
                                                      .value.tipAmount
                                                      .toString()),
                                              textAlign: TextAlign.start,
                                              style: TextStyle(
                                                fontFamily:
                                                    AppThemeData.regular,
                                                color: themeChange.getThem()
                                                    ? AppThemeData.grey50
                                                    : AppThemeData.grey900,
                                                fontSize: 16,
                                              ),
                                            ),
                                          ],
                                        ),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  MySeparator(
                                      color: themeChange.getThem()
                                          ? AppThemeData.grey700
                                          : AppThemeData.grey200),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  ListView.builder(
                                    itemCount: controller
                                        .orderModel.value.taxSetting!.length,
                                    shrinkWrap: true,
                                    padding: EdgeInsets.zero,
                                    physics:
                                        const NeverScrollableScrollPhysics(),
                                    itemBuilder: (context, index) {
                                      TaxModel taxModel = controller
                                          .orderModel.value.taxSetting![index];
                                      return Padding(
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 5),
                                        child: Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Expanded(
                                              child: Text(
                                                "${taxModel.title.toString()} (${taxModel.type == "fix" ? Constant.amountShow(amount: taxModel.tax) : "${taxModel.tax}%"})",
                                                textAlign: TextAlign.start,
                                                style: TextStyle(
                                                  fontFamily:
                                                      AppThemeData.regular,
                                                  color: themeChange.getThem()
                                                      ? AppThemeData.grey300
                                                      : AppThemeData.grey600,
                                                  fontSize: 16,
                                                ),
                                              ),
                                            ),
                                            Text(
                                              Constant.amountShow(
                                                  amount: Constant.calculateTax(
                                                          amount: (controller
                                                                      .subTotal
                                                                      .value -
                                                                  double.parse(controller
                                                                      .orderModel
                                                                      .value
                                                                      .discount
                                                                      .toString()) -
                                                                  controller
                                                                      .specialDiscountAmount
                                                                      .value)
                                                              .toString(),
                                                          taxModel: taxModel)
                                                      .toString()),
                                              textAlign: TextAlign.start,
                                              style: TextStyle(
                                                fontFamily:
                                                    AppThemeData.regular,
                                                color: themeChange.getThem()
                                                    ? AppThemeData.grey50
                                                    : AppThemeData.grey900,
                                                fontSize: 16,
                                              ),
                                            ),
                                          ],
                                        ),
                                      );
                                    },
                                  ),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Expanded(
                                        child: Text(
                                          "To Pay".tr,
                                          textAlign: TextAlign.start,
                                          style: TextStyle(
                                            fontFamily: AppThemeData.regular,
                                            color: themeChange.getThem()
                                                ? AppThemeData.grey300
                                                : AppThemeData.grey600,
                                            fontSize: 16,
                                          ),
                                        ),
                                      ),
                                      Text(
                                        Constant.amountShow(
                                            amount: controller.totalAmount.value
                                                .toString()),
                                        textAlign: TextAlign.start,
                                        style: TextStyle(
                                          fontFamily: AppThemeData.regular,
                                          color: themeChange.getThem()
                                              ? AppThemeData.grey50
                                              : AppThemeData.grey900,
                                          fontSize: 16,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 14,
                          ),
                        ],
                      ),
                    ),
                  ),
          );
        });
  }
}
