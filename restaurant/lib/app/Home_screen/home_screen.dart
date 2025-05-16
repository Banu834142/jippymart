import 'package:bottom_picker/resources/extensions.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:flutter_multi_formatter/flutter_multi_formatter.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:restaurant/app/Home_screen/order_details_screen.dart';
import 'package:restaurant/app/add_restaurant_screen/add_restaurant_screen.dart';
import 'package:restaurant/app/chat_screens/chat_screen.dart';
import 'package:restaurant/app/chat_screens/restaurant_inbox_screen.dart';
import 'package:restaurant/app/driver_screens/add_driver_screen.dart';
import 'package:restaurant/app/product_rating_view_screen/product_rating_view_screen.dart';
import 'package:restaurant/app/verification_screen/verification_screen.dart';
import 'package:restaurant/constant/collection_name.dart';
import 'package:restaurant/constant/constant.dart';
import 'package:restaurant/constant/send_notification.dart';
import 'package:restaurant/constant/show_toast_dialog.dart';
import 'package:restaurant/controller/dash_board_controller.dart';
import 'package:restaurant/controller/home_controller.dart';
import 'package:restaurant/models/cart_product_model.dart';
import 'package:restaurant/models/order_model.dart';
import 'package:restaurant/models/user_model.dart';
import 'package:restaurant/models/vendor_model.dart';
import 'package:restaurant/models/wallet_transaction_model.dart';
import 'package:restaurant/service/audio_player_service.dart';
import 'package:restaurant/themes/app_them_data.dart';
import 'package:restaurant/themes/text_field_widget.dart';
import 'package:restaurant/utils/dark_theme_provider.dart';
import 'package:restaurant/utils/fire_store_utils.dart';
import 'package:restaurant/utils/network_image_widget.dart';
import 'package:restaurant/widget/my_separator.dart';
import 'package:uuid/uuid.dart';

import '../../themes/round_button_fill.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final themeChange = Provider.of<DarkThemeProvider>(context);
    return GetX(
        init: HomeController(),
        builder: (controller) {
          return controller.isLoading.value
              ? Constant.loader()
              : DefaultTabController(
                  length: 5,
                  child: Scaffold(
                    appBar: AppBar(
                      backgroundColor: AppThemeData.secondary300,
                      centerTitle: false,
                      title: Row(
                        children: [
                          InkWell(
                            onTap: () {
                              DashBoardController dashBoardController =
                                  Get.find<DashBoardController>();
                              if (Constant.isDineInEnable &&
                                  Constant.userModel!.subscriptionPlan?.features
                                          ?.dineIn !=
                                      false) {
                                dashBoardController.selectedIndex.value = 4;
                              } else {
                                dashBoardController.selectedIndex.value = 3;
                              }
                            },
                            child: ClipOval(
                              child: NetworkImageWidget(
                                imageUrl: controller
                                    .userModel.value.profilePictureURL
                                    .toString(),
                                height: 42,
                                width: 42,
                                fit: BoxFit.cover,
                              ),
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
                        tabAlignment: TabAlignment.start,
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
                        isScrollable: true,
                        padding: const EdgeInsets.symmetric(horizontal: 18),
                        labelPadding:
                            const EdgeInsets.symmetric(horizontal: 20),
                        dividerColor: Colors.transparent,
                        tabs: [
                          Tab(
                            text: "New".tr,
                          ),
                          Tab(
                            text: "Accepted".tr,
                          ),
                          Tab(
                            text: "Completed".tr,
                          ),
                          Tab(
                            text: "Rejected".tr,
                          ),
                          Tab(
                            text: "Cancelled".tr,
                          ),
                        ],
                      ),
                      actions: [
                        Visibility(
                          visible: controller.userModel.value.subscriptionPlan
                                  ?.features?.chat !=
                              false,
                          child: InkWell(
                            onTap: () async {
                              Get.to(const RestaurantInboxScreen());
                            },
                            child: Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 20),
                              child: SvgPicture.asset(
                                "assets/icons/ic_chat.svg",
                                color: themeChange.getThem()
                                    ? AppThemeData.grey900
                                    : AppThemeData.grey50,
                              ),
                            ),
                          ),
                        )
                      ],
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
                                        Get.to(const AddRestaurantScreen())
                                            ?.then((v) {
                                          controller.getUserProfile();
                                        });
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
                                    controller.newOrderList.isEmpty
                                        ? Constant.showEmptyView(
                                            message: "New Orders Not found".tr)
                                        : ListView.builder(
                                            shrinkWrap: true,
                                            itemCount:
                                                controller.newOrderList.length,
                                            itemBuilder: (context, index) {
                                              OrderModel orderModel = controller
                                                  .newOrderList[index];
                                              return newOrderWidget(
                                                  themeChange,
                                                  context,
                                                  orderModel,
                                                  controller);
                                            },
                                          ),
                                    controller.acceptedOrderList.isEmpty
                                        ? Constant.showEmptyView(
                                            message:
                                                "Accepted Orders Not found".tr)
                                        : ListView.builder(
                                            shrinkWrap: true,
                                            itemCount: controller
                                                .acceptedOrderList.length,
                                            itemBuilder: (context, index) {
                                              OrderModel orderModel = controller
                                                  .acceptedOrderList[index];
                                              return acceptedWidget(
                                                  themeChange,
                                                  context,
                                                  orderModel,
                                                  controller);
                                            },
                                          ),
                                    controller.completedOrderList.isEmpty
                                        ? Constant.showEmptyView(
                                            message:
                                                "Completed Orders Not found".tr)
                                        : ListView.builder(
                                            shrinkWrap: true,
                                            itemCount: controller
                                                .completedOrderList.length,
                                            itemBuilder: (context, index) {
                                              OrderModel orderModel = controller
                                                  .completedOrderList[index];
                                              return completedAndRejectedWidget(
                                                  themeChange,
                                                  context,
                                                  orderModel,
                                                  controller);
                                            },
                                          ),
                                    controller.rejectedOrderList.isEmpty
                                        ? Constant.showEmptyView(
                                            message:
                                                "Rejected Orders Not found".tr)
                                        : ListView.builder(
                                            shrinkWrap: true,
                                            itemCount: controller
                                                .rejectedOrderList.length,
                                            itemBuilder: (context, index) {
                                              OrderModel orderModel = controller
                                                  .rejectedOrderList[index];
                                              return completedAndRejectedWidget(
                                                  themeChange,
                                                  context,
                                                  orderModel,
                                                  controller);
                                            },
                                          ),
                                    controller.cancelledOrderList.isEmpty
                                        ? Constant.showEmptyView(
                                            message:
                                                "Cancelled Orders Not found".tr)
                                        : ListView.builder(
                                            shrinkWrap: true,
                                            itemCount: controller
                                                .cancelledOrderList.length,
                                            itemBuilder: (context, index) {
                                              OrderModel orderModel = controller
                                                  .cancelledOrderList[index];
                                              return completedAndRejectedWidget(
                                                  themeChange,
                                                  context,
                                                  orderModel,
                                                  controller);
                                            },
                                          ),
                                  ],
                                ),
                              ),
                  ),
                );
        });
  }

  newOrderWidget(themeChange, BuildContext context, OrderModel orderModel,
      HomeController controller) {
    double totalAmount = 0.0;
    double subTotal = 0.0;
    double taxAmount = 0.0;
    double specialDiscount = 0.0;
    double adminCommission = 0.0;

    for (var element in orderModel.products!) {
      if (double.parse(element.discountPrice.toString()) <= 0) {
        subTotal = subTotal +
            double.parse(element.price.toString()) *
                double.parse(element.quantity.toString()) +
            (double.parse(element.extrasPrice.toString()) *
                double.parse(element.quantity.toString()));
      } else {
        subTotal = subTotal +
            double.parse(element.discountPrice.toString()) *
                double.parse(element.quantity.toString()) +
            (double.parse(element.extrasPrice.toString()) *
                double.parse(element.quantity.toString()));
      }
    }

    if (orderModel.specialDiscount != null &&
        orderModel.specialDiscount!['special_discount'] != null) {
      specialDiscount = double.parse(
          orderModel.specialDiscount!['special_discount'].toString());
    }

    if (orderModel.taxSetting != null) {
      for (var element in orderModel.taxSetting!) {
        taxAmount = taxAmount +
            Constant.calculateTax(
                amount: (subTotal -
                        double.parse(orderModel.discount.toString()) -
                        specialDiscount)
                    .toString(),
                taxModel: element);
      }
    }

    totalAmount = subTotal -
        double.parse(orderModel.discount.toString()) -
        specialDiscount +
        taxAmount;

    if (orderModel.adminCommissionType == 'Percent') {
      double basePrice =
          subTotal / (1 + (double.parse(orderModel.adminCommission!) / 100));
      adminCommission = subTotal - basePrice;
    } else {
      adminCommission = double.parse(orderModel.adminCommission!);
    }

    return InkWell(
      onTap: () async {
        Get.to(const OrderDetailsScreen(),
            arguments: {"orderModel": orderModel});
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 5),
        child: Container(
          decoration: ShapeDecoration(
            color: themeChange.getThem()
                ? AppThemeData.grey900
                : AppThemeData.grey50,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    ClipOval(
                      child: NetworkImageWidget(
                        imageUrl:
                            orderModel.author!.profilePictureURL.toString(),
                        width: 40,
                        height: 40,
                        fit: BoxFit.cover,
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
                            orderModel.author!.fullName().toString().tr,
                            style: TextStyle(
                              color: themeChange.getThem()
                                  ? AppThemeData.grey50
                                  : AppThemeData.grey900,
                              fontSize: 14,
                              fontFamily: AppThemeData.semiBold,
                            ),
                          ),
                          orderModel.takeAway == true
                              ? Text(
                                  "Take Away".tr,
                                  style: TextStyle(
                                    color: themeChange.getThem()
                                        ? AppThemeData.grey400
                                        : AppThemeData.grey500,
                                    fontSize: 12,
                                    fontFamily: AppThemeData.medium,
                                  ),
                                )
                              : Text(
                                  orderModel.address!.getFullAddress().tr,
                                  style: TextStyle(
                                    color: themeChange.getThem()
                                        ? AppThemeData.grey400
                                        : AppThemeData.grey500,
                                    fontSize: 12,
                                    fontFamily: AppThemeData.medium,
                                  ),
                                ),
                        ],
                      ),
                    ),
                    const Icon(Icons.chevron_right)
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  child: MySeparator(
                      color: themeChange.getThem()
                          ? AppThemeData.grey700
                          : AppThemeData.grey200),
                ),
                ListView.separated(
                  shrinkWrap: true,
                  itemCount: orderModel.products!.length,
                  physics: const NeverScrollableScrollPhysics(),
                  itemBuilder: (context, index) {
                    CartProductModel product = orderModel.products![index];
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                "${product.quantity}x ${product.name}".tr,
                                style: TextStyle(
                                  color: themeChange.getThem()
                                      ? AppThemeData.grey100
                                      : AppThemeData.grey800,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                  fontFamily: AppThemeData.semiBold,
                                ),
                              ),
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Text(
                                  double.parse(product.discountPrice ?? "0.0") <= 0
                                      ? Constant.amountShow(
                                          amount:
                                              (double.parse(product.price.toString()) *
                                                      double.parse(product
                                                          .quantity
                                                          .toString()))
                                                  .toString())
                                      : Constant.amountShow(
                                              amount: (double.parse(product
                                                          .discountPrice
                                                          .toString()) *
                                                      double.parse(product
                                                          .quantity
                                                          .toString()))
                                                  .toString())
                                          .tr,
                                  style: TextStyle(
                                    color: themeChange.getThem()
                                        ? AppThemeData.grey100
                                        : AppThemeData.grey800,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500,
                                    fontFamily: AppThemeData.semiBold,
                                  ),
                                ),
                                InkWell(
                                  onTap: () {
                                    Get.to(const ProductRatingViewScreen(),
                                        arguments: {
                                          "orderModel": orderModel,
                                          "productId": product.id
                                        });
                                  },
                                  child: Text(
                                    "View Ratings".tr,
                                    style: TextStyle(
                                      color: themeChange.getThem()
                                          ? AppThemeData.secondary300
                                          : AppThemeData.secondary300,
                                      fontWeight: FontWeight.w500,
                                      decoration: TextDecoration.underline,
                                      fontFamily: AppThemeData.semiBold,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                        product.variantInfo == null ||
                                product.variantInfo!.variantOptions!.isEmpty
                            ? Container()
                            : Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 5, vertical: 10),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "Variants".tr,
                                      textAlign: TextAlign.start,
                                      style: TextStyle(
                                        fontFamily: AppThemeData.semiBold,
                                        color: themeChange.getThem()
                                            ? AppThemeData.grey300
                                            : AppThemeData.grey600,
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
                                        product.variantInfo!.variantOptions!
                                            .length,
                                        (i) {
                                          return Container(
                                            decoration: ShapeDecoration(
                                              color: themeChange.getThem()
                                                  ? AppThemeData.grey800
                                                  : AppThemeData.grey100,
                                              shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(8)),
                                            ),
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 16,
                                                      vertical: 5),
                                              child: Text(
                                                "${product.variantInfo!.variantOptions!.keys.elementAt(i)} : ${product.variantInfo!.variantOptions![product.variantInfo!.variantOptions!.keys.elementAt(i)]}",
                                                textAlign: TextAlign.start,
                                                style: TextStyle(
                                                  fontFamily:
                                                      AppThemeData.medium,
                                                  color: themeChange.getThem()
                                                      ? AppThemeData.grey500
                                                      : AppThemeData.grey400,
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
                        product.extras == null || product.extras!.isEmpty
                            ? const SizedBox()
                            : Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  Row(
                                    children: [
                                      Expanded(
                                        child: Text(
                                          "Addons".tr,
                                          textAlign: TextAlign.start,
                                          style: TextStyle(
                                            fontFamily: AppThemeData.semiBold,
                                            color: themeChange.getThem()
                                                ? AppThemeData.grey300
                                                : AppThemeData.grey600,
                                            fontSize: 16,
                                          ),
                                        ),
                                      ),
                                      Text(
                                        Constant.amountShow(
                                            amount: (double.parse(product
                                                        .extrasPrice
                                                        .toString()) *
                                                    double.parse(product
                                                        .quantity
                                                        .toString()))
                                                .toString()),
                                        textAlign: TextAlign.start,
                                        style: TextStyle(
                                          fontFamily: AppThemeData.semiBold,
                                          color: themeChange.getThem()
                                              ? AppThemeData.secondary300
                                              : AppThemeData.secondary300,
                                          fontSize: 16,
                                        ),
                                      ),
                                    ],
                                  ),
                                  Wrap(
                                    spacing: 6.0,
                                    runSpacing: 6.0,
                                    children: List.generate(
                                      product.extras!.length,
                                      (i) {
                                        return Container(
                                          decoration: ShapeDecoration(
                                            color: themeChange.getThem()
                                                ? AppThemeData.grey800
                                                : AppThemeData.grey100,
                                            shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(8)),
                                          ),
                                          child: Padding(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 16, vertical: 5),
                                            child: Text(
                                              product.extras![i].toString(),
                                              textAlign: TextAlign.start,
                                              style: TextStyle(
                                                fontFamily: AppThemeData.medium,
                                                color: themeChange.getThem()
                                                    ? AppThemeData.grey500
                                                    : AppThemeData.grey400,
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
                  separatorBuilder: (BuildContext context, int index) {
                    return Padding(
                      padding: const EdgeInsets.only(top: 20, bottom: 10),
                      child: MySeparator(
                          color: themeChange.getThem()
                              ? AppThemeData.grey700
                              : AppThemeData.grey200),
                    );
                  },
                ),
                const SizedBox(
                  height: 10,
                ),
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        "Order Date".tr,
                        style: TextStyle(
                          color: themeChange.getThem()
                              ? AppThemeData.grey300
                              : AppThemeData.grey600,
                          fontSize: 16,
                          fontWeight: FontWeight.w400,
                          fontFamily: AppThemeData.regular,
                        ),
                      ),
                    ),
                    Text(
                      Constant.timestampToDateTime(orderModel.createdAt!),
                      style: TextStyle(
                        color: themeChange.getThem()
                            ? AppThemeData.grey100
                            : AppThemeData.grey800,
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        fontFamily: AppThemeData.semiBold,
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 5,
                ),
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        "Total Amount".tr,
                        style: TextStyle(
                          color: themeChange.getThem()
                              ? AppThemeData.grey300
                              : AppThemeData.grey600,
                          fontSize: 16,
                          fontWeight: FontWeight.w400,
                          fontFamily: AppThemeData.regular,
                        ),
                      ),
                    ),
                    Text(
                      Constant.amountShow(amount: totalAmount.toString()).tr,
                      style: TextStyle(
                        color: themeChange.getThem()
                            ? AppThemeData.grey100
                            : AppThemeData.grey800,
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        fontFamily: AppThemeData.semiBold,
                      ),
                    ),
                  ],
                ),
                Visibility(
                  visible: Constant.adminCommission?.isEnabled == true,
                  child: Column(
                    children: [
                      const SizedBox(
                        height: 5,
                      ),
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              "Admin Commissions".tr,
                              style: TextStyle(
                                color: themeChange.getThem()
                                    ? AppThemeData.grey300
                                    : AppThemeData.grey600,
                                fontSize: 16,
                                fontWeight: FontWeight.w400,
                                fontFamily: AppThemeData.regular,
                              ),
                            ),
                          ),
                          Text(
                            "-${Constant.amountShow(amount: adminCommission.toString())}"
                                .tr,
                            style: TextStyle(
                              color: themeChange.getThem()
                                  ? AppThemeData.danger300
                                  : AppThemeData.danger300,
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                              fontFamily: AppThemeData.semiBold,
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
                orderModel.scheduleTime == null
                    ? const SizedBox()
                    : Row(
                        children: [
                          Expanded(
                            child: Text(
                              "Schedule Time".tr,
                              style: TextStyle(
                                color: themeChange.getThem()
                                    ? AppThemeData.grey300
                                    : AppThemeData.grey600,
                                fontSize: 16,
                                fontWeight: FontWeight.w400,
                                fontFamily: AppThemeData.regular,
                              ),
                            ),
                          ),
                          Text(
                            Constant.timestampToDateTime(
                                    orderModel.scheduleTime!)
                                .tr,
                            style: TextStyle(
                              color: themeChange.getThem()
                                  ? AppThemeData.secondary300
                                  : AppThemeData.secondary300,
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                              fontFamily: AppThemeData.semiBold,
                            ),
                          ),
                        ],
                      ),
                const SizedBox(
                  height: 5,
                ),
                orderModel.notes == null || orderModel.notes!.isEmpty
                    ? const SizedBox()
                    : InkWell(
                        onTap: () {
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return viewRemarkDialog(
                                  controller, themeChange, orderModel);
                            },
                          );
                        },
                        child: Text(
                          "View Remarks".tr,
                          textAlign: TextAlign.start,
                          style: TextStyle(
                            fontFamily: AppThemeData.regular,
                            decoration: TextDecoration.underline,
                            color: themeChange.getThem()
                                ? AppThemeData.secondary300
                                : AppThemeData.secondary300,
                            fontSize: 16,
                          ),
                        ),
                      ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  child: Row(
                    children: [
                      Expanded(
                        child: RoundedButtonFill(
                          title: "Reject".tr,
                          color: AppThemeData.danger300,
                          textColor: AppThemeData.grey50,
                          height: 5,
                          onPress: () async {
                            ShowToastDialog.showLoader('Please wait...'.tr);
                            await AudioPlayerService.playSound(false);
                            orderModel.status = Constant.orderRejected;
                            await FireStoreUtils.updateOrder(orderModel);

                            SendNotification.sendFcmMessage(
                                Constant.restaurantRejected,
                                orderModel.author!.fcmToken.toString(), {});

                            if (orderModel.paymentMethod!.toLowerCase() !=
                                'cod') {
                              double finalAmount = (subTotal +
                                      double.parse(
                                          orderModel.discount.toString()) +
                                      specialDiscount +
                                      double.parse(taxAmount.toString())) +
                                  double.parse(
                                      orderModel.deliveryCharge.toString()) +
                                  double.parse(orderModel.tipAmount.toString());

                              WalletTransactionModel historyModel =
                                  WalletTransactionModel(
                                      amount: finalAmount,
                                      id: const Uuid().v4(),
                                      orderId: orderModel.id,
                                      userId: orderModel.author!.id,
                                      date: Timestamp.now(),
                                      isTopup: true,
                                      paymentMethod: "Wallet",
                                      paymentStatus: "success",
                                      note: "Order Refund success",
                                      transactionUser: "user");

                              await FireStoreUtils.fireStore
                                  .collection(CollectionName.wallet)
                                  .doc(historyModel.id)
                                  .set(historyModel.toJson());
                              await FireStoreUtils.updateUserWallet(
                                  amount: finalAmount.toString(),
                                  userId: orderModel.author!.id.toString());
                            }

                            ShowToastDialog.closeLoader();
                            controller.getOrder();
                            Get.back();
                          },
                        ),
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      Expanded(
                          child: Constant.isSelfDeliveryFeature == true &&
                                  controller.vendermodel.value.isSelfDelivery ==
                                      true &&
                                  orderModel.takeAway == false
                              ? RoundedButtonFill(
                                  title: "Self Delivery".tr,
                                  height: 5,
                                  color: AppThemeData.success400,
                                  textColor: AppThemeData.grey50,
                                  onPress: () async {
                                    if ((Constant.isSubscriptionModelApplied ==
                                                true ||
                                            Constant.adminCommission
                                                    ?.isEnabled ==
                                                true) &&
                                        controller.vendermodel.value
                                                .subscriptionPlan !=
                                            null) {
                                      if (controller.vendermodel.value
                                                  .subscriptionTotalOrders ==
                                              '0' ||
                                          controller.vendermodel.value
                                                  .subscriptionTotalOrders ==
                                              null) {
                                        ShowToastDialog.closeLoader();
                                        ShowToastDialog.showToast(
                                            "You have reached the maximum order capacity for your current plan. Upgrade your subscription to continue accepting orders seamlessly!."
                                                .tr);
                                        return;
                                      }
                                    }

                                    if (orderModel.scheduleTime != null) {
                                      if (DateTime.now().isAtSameMomentOrAfter(
                                          Constant.checkScheduleTime(
                                              scheduleDate: orderModel
                                                  .scheduleTime!
                                                  .toDate()))) {
                                        showDialog(
                                          context: context,
                                          builder: (BuildContext context) {
                                            return estimatedTimeDialog(
                                                controller,
                                                themeChange,
                                                orderModel,
                                                context);
                                          },
                                        );
                                      } else {
                                        ShowToastDialog.showToast(
                                            "${"You can accept order on".tr} ${Constant.timestampToDateTime(Timestamp.fromDate(Constant.checkScheduleTime(scheduleDate: orderModel.scheduleTime!.toDate())))}.");
                                      }
                                    } else {
                                      controller.driverUserList.clear();
                                      controller.selectDriverUser.value =
                                          UserModel();

                                      showDialog(
                                        context: context,
                                        builder: (BuildContext context) {
                                          return estimatedTimeDialog(controller,
                                              themeChange, orderModel, context);
                                        },
                                      );
                                    }
                                  },
                                )
                              : RoundedButtonFill(
                                  title: "Accept".tr,
                                  height: 5,
                                  color: AppThemeData.success400,
                                  textColor: AppThemeData.grey50,
                                  onPress: () async {
                                    // if ((Constant.isSubscriptionModelApplied == true || Constant.adminCommission?.isEnabled == true) &&
                                    //     Constant.userModel?.subscriptionPlan?.type != 'free' &&
                                    //     Constant.userModel?.subscriptionPlan?.orderLimit != '-1' &&
                                    //     int.parse(Constant.userModel?.subscriptionPlan?.orderLimit ?? '0') <= controller.totalOrderList.length) {
                                    //   ShowToastDialog.showToast("Your current subscription plan has reached its maximum order limit. Upgrade now to accept more order.".tr);
                                    //   return;
                                    // }

                                    if ((Constant.isSubscriptionModelApplied ==
                                                true ||
                                            Constant.adminCommission
                                                    ?.isEnabled ==
                                                true) &&
                                        controller.vendermodel.value
                                                .subscriptionPlan !=
                                            null) {
                                      if (controller.vendermodel.value
                                                  .subscriptionTotalOrders ==
                                              '0' ||
                                          controller.vendermodel.value
                                                  .subscriptionTotalOrders ==
                                              null) {
                                        ShowToastDialog.closeLoader();
                                        ShowToastDialog.showToast(
                                            "You have reached the maximum order capacity for your current plan. Upgrade your subscription to continue accepting orders seamlessly!."
                                                .tr);
                                        return;
                                      }
                                    }
                                    if (orderModel.scheduleTime != null) {
                                      if (DateTime.now().isAtSameMomentOrAfter(
                                          Constant.checkScheduleTime(
                                              scheduleDate: orderModel
                                                  .scheduleTime!
                                                  .toDate()))) {
                                        showDialog(
                                          context: context,
                                          builder: (BuildContext context) {
                                            return estimatedTimeDialog(
                                                controller,
                                                themeChange,
                                                orderModel,
                                                context);
                                          },
                                        );
                                      } else {
                                        ShowToastDialog.showToast(
                                            "${"You can accept order on".tr} ${Constant.timestampToDateTime(Timestamp.fromDate(Constant.checkScheduleTime(scheduleDate: orderModel.scheduleTime!.toDate())))}.");
                                      }
                                    } else {
                                      showDialog(
                                        context: context,
                                        builder: (BuildContext context) {
                                          return estimatedTimeDialog(controller,
                                              themeChange, orderModel, context);
                                        },
                                      );
                                    }
                                  },
                                ))
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  acceptedWidget(themeChange, BuildContext context, OrderModel orderModel,
      HomeController controller) {
    double totalAmount = 0.0;
    double subTotal = 0.0;
    double taxAmount = 0.0;
    double specialDiscount = 0.0;
    double adminCommission = 0.0;

    for (var element in orderModel.products!) {
      if (double.parse(element.discountPrice.toString()) <= 0) {
        subTotal = subTotal +
            double.parse(element.price.toString()) *
                double.parse(element.quantity.toString()) +
            (double.parse(element.extrasPrice.toString()) *
                double.parse(element.quantity.toString()));
      } else {
        subTotal = subTotal +
            double.parse(element.discountPrice.toString()) *
                double.parse(element.quantity.toString()) +
            (double.parse(element.extrasPrice.toString()) *
                double.parse(element.quantity.toString()));
      }
    }

    if (orderModel.specialDiscount != null &&
        orderModel.specialDiscount!['special_discount'] != null) {
      specialDiscount = double.parse(
          orderModel.specialDiscount!['special_discount'].toString());
    }

    if (orderModel.taxSetting != null) {
      for (var element in orderModel.taxSetting!) {
        taxAmount = taxAmount +
            Constant.calculateTax(
                amount: (subTotal -
                        double.parse(orderModel.discount.toString()) -
                        specialDiscount)
                    .toString(),
                taxModel: element);
      }
    }

    totalAmount = subTotal -
        double.parse(orderModel.discount.toString()) -
        specialDiscount +
        taxAmount;

    if (orderModel.adminCommissionType == 'Percent') {
      double basePrice =
          subTotal / (1 + (double.parse(orderModel.adminCommission!) / 100));
      adminCommission = subTotal - basePrice;
    } else {
      adminCommission = double.parse(orderModel.adminCommission!);
    }

    return InkWell(
      onTap: () async {
        Get.to(const OrderDetailsScreen(),
            arguments: {"orderModel": orderModel});
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 5),
        child: Container(
          decoration: ShapeDecoration(
            color: themeChange.getThem()
                ? AppThemeData.grey900
                : AppThemeData.grey50,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                Row(
                  children: [
                    ClipOval(
                      child: NetworkImageWidget(
                        imageUrl:
                            orderModel.author!.profilePictureURL.toString(),
                        width: 40,
                        height: 40,
                        fit: BoxFit.cover,
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
                            orderModel.author!.fullName().toString().tr,
                            style: TextStyle(
                              color: themeChange.getThem()
                                  ? AppThemeData.grey50
                                  : AppThemeData.grey900,
                              fontSize: 14,
                              fontFamily: AppThemeData.semiBold,
                            ),
                          ),
                          orderModel.takeAway == true
                              ? Text(
                                  "Take Away".tr,
                                  style: TextStyle(
                                    color: themeChange.getThem()
                                        ? AppThemeData.grey400
                                        : AppThemeData.grey500,
                                    fontSize: 12,
                                    fontFamily: AppThemeData.medium,
                                  ),
                                )
                              : Text(
                                  orderModel.address!.getFullAddress().tr,
                                  style: TextStyle(
                                    color: themeChange.getThem()
                                        ? AppThemeData.grey400
                                        : AppThemeData.grey500,
                                    fontSize: 12,
                                    fontFamily: AppThemeData.medium,
                                  ),
                                ),
                        ],
                      ),
                    ),
                    const Icon(Icons.chevron_right)
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  child: MySeparator(
                      color: themeChange.getThem()
                          ? AppThemeData.grey700
                          : AppThemeData.grey200),
                ),
                ListView.builder(
                  shrinkWrap: true,
                  itemCount: orderModel.products!.length,
                  physics: const NeverScrollableScrollPhysics(),
                  itemBuilder: (context, index) {
                    CartProductModel product = orderModel.products![index];
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                "${product.quantity}x ${product.name}".tr,
                                style: TextStyle(
                                  color: themeChange.getThem()
                                      ? AppThemeData.grey100
                                      : AppThemeData.grey800,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                  fontFamily: AppThemeData.semiBold,
                                ),
                              ),
                            ),
                            Text(
                              double.parse(product.discountPrice ?? "0.0") <= 0
                                  ? Constant.amountShow(
                                      amount: (double.parse(
                                                  product.price.toString()) *
                                              double.parse(
                                                  product.quantity.toString()))
                                          .toString())
                                  : Constant.amountShow(
                                          amount: (double.parse(product
                                                      .discountPrice
                                                      .toString()) *
                                                  double.parse(product.quantity
                                                      .toString()))
                                              .toString())
                                      .tr,
                              style: TextStyle(
                                color: themeChange.getThem()
                                    ? AppThemeData.grey100
                                    : AppThemeData.grey800,
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                                fontFamily: AppThemeData.semiBold,
                              ),
                            ),
                          ],
                        ),
                        product.variantInfo == null ||
                                product.variantInfo!.variantOptions!.isEmpty
                            ? Container()
                            : Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 5, vertical: 10),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "Variants".tr,
                                      textAlign: TextAlign.start,
                                      style: TextStyle(
                                        fontFamily: AppThemeData.semiBold,
                                        color: themeChange.getThem()
                                            ? AppThemeData.grey300
                                            : AppThemeData.grey600,
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
                                        product.variantInfo!.variantOptions!
                                            .length,
                                        (i) {
                                          return Container(
                                            decoration: ShapeDecoration(
                                              color: themeChange.getThem()
                                                  ? AppThemeData.grey800
                                                  : AppThemeData.grey100,
                                              shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(8)),
                                            ),
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 16,
                                                      vertical: 5),
                                              child: Text(
                                                "${product.variantInfo!.variantOptions!.keys.elementAt(i)} : ${product.variantInfo!.variantOptions![product.variantInfo!.variantOptions!.keys.elementAt(i)]}",
                                                textAlign: TextAlign.start,
                                                style: TextStyle(
                                                  fontFamily:
                                                      AppThemeData.medium,
                                                  color: themeChange.getThem()
                                                      ? AppThemeData.grey500
                                                      : AppThemeData.grey400,
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
                        product.extras == null || product.extras!.isEmpty
                            ? const SizedBox()
                            : Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  Row(
                                    children: [
                                      Expanded(
                                        child: Text(
                                          "Addons".tr,
                                          textAlign: TextAlign.start,
                                          style: TextStyle(
                                            fontFamily: AppThemeData.semiBold,
                                            color: themeChange.getThem()
                                                ? AppThemeData.grey300
                                                : AppThemeData.grey600,
                                            fontSize: 16,
                                          ),
                                        ),
                                      ),
                                      Text(
                                        Constant.amountShow(
                                            amount: (double.parse(product
                                                        .extrasPrice
                                                        .toString()) *
                                                    double.parse(product
                                                        .quantity
                                                        .toString()))
                                                .toString()),
                                        textAlign: TextAlign.start,
                                        style: TextStyle(
                                          fontFamily: AppThemeData.semiBold,
                                          color: themeChange.getThem()
                                              ? AppThemeData.secondary300
                                              : AppThemeData.secondary300,
                                          fontSize: 16,
                                        ),
                                      ),
                                    ],
                                  ),
                                  Wrap(
                                    spacing: 6.0,
                                    runSpacing: 6.0,
                                    children: List.generate(
                                      product.extras!.length,
                                      (i) {
                                        return Container(
                                          decoration: ShapeDecoration(
                                            color: themeChange.getThem()
                                                ? AppThemeData.grey800
                                                : AppThemeData.grey100,
                                            shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(8)),
                                          ),
                                          child: Padding(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 16, vertical: 5),
                                            child: Text(
                                              product.extras![i].toString(),
                                              textAlign: TextAlign.start,
                                              style: TextStyle(
                                                fontFamily: AppThemeData.medium,
                                                color: themeChange.getThem()
                                                    ? AppThemeData.grey500
                                                    : AppThemeData.grey400,
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
                ),
                const SizedBox(
                  height: 10,
                ),
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        "Order Date".tr,
                        style: TextStyle(
                          color: themeChange.getThem()
                              ? AppThemeData.grey300
                              : AppThemeData.grey600,
                          fontSize: 16,
                          fontWeight: FontWeight.w400,
                          fontFamily: AppThemeData.regular,
                        ),
                      ),
                    ),
                    Text(
                      Constant.timestampToDateTime(orderModel.createdAt!),
                      style: TextStyle(
                        color: themeChange.getThem()
                            ? AppThemeData.grey100
                            : AppThemeData.grey800,
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        fontFamily: AppThemeData.semiBold,
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 5,
                ),
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        "Total Amount".tr,
                        style: TextStyle(
                          color: themeChange.getThem()
                              ? AppThemeData.grey300
                              : AppThemeData.grey600,
                          fontSize: 16,
                          fontWeight: FontWeight.w400,
                          fontFamily: AppThemeData.regular,
                        ),
                      ),
                    ),
                    Text(
                      Constant.amountShow(amount: totalAmount.toString()).tr,
                      style: TextStyle(
                        color: themeChange.getThem()
                            ? AppThemeData.grey100
                            : AppThemeData.grey800,
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        fontFamily: AppThemeData.semiBold,
                      ),
                    ),
                  ],
                ),
                Visibility(
                  visible: Constant.adminCommission?.isEnabled == true,
                  child: Column(
                    children: [
                      const SizedBox(
                        height: 5,
                      ),
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              "Admin Commissions".tr,
                              style: TextStyle(
                                color: themeChange.getThem()
                                    ? AppThemeData.grey300
                                    : AppThemeData.grey600,
                                fontSize: 16,
                                fontWeight: FontWeight.w400,
                                fontFamily: AppThemeData.regular,
                              ),
                            ),
                          ),
                          Text(
                            "-${Constant.amountShow(amount: adminCommission.toString())}"
                                .tr,
                            style: TextStyle(
                              color: themeChange.getThem()
                                  ? AppThemeData.danger300
                                  : AppThemeData.danger300,
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                              fontFamily: AppThemeData.semiBold,
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
                orderModel.scheduleTime == null
                    ? const SizedBox()
                    : Row(
                        children: [
                          Expanded(
                            child: Text(
                              "Schedule Time".tr,
                              style: TextStyle(
                                color: themeChange.getThem()
                                    ? AppThemeData.grey300
                                    : AppThemeData.grey600,
                                fontSize: 16,
                                fontWeight: FontWeight.w400,
                                fontFamily: AppThemeData.regular,
                              ),
                            ),
                          ),
                          Text(
                            Constant.timestampToDateTime(
                                    orderModel.scheduleTime!)
                                .tr,
                            style: TextStyle(
                              color: themeChange.getThem()
                                  ? AppThemeData.secondary300
                                  : AppThemeData.secondary300,
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                              fontFamily: AppThemeData.semiBold,
                            ),
                          ),
                        ],
                      ),
                const SizedBox(
                  height: 5,
                ),
                orderModel.notes == null || orderModel.notes!.isEmpty
                    ? const SizedBox()
                    : InkWell(
                        onTap: () {
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return viewRemarkDialog(
                                  controller, themeChange, orderModel);
                            },
                          );
                        },
                        child: Text(
                          "View Remarks".tr,
                          textAlign: TextAlign.start,
                          style: TextStyle(
                            fontFamily: AppThemeData.regular,
                            decoration: TextDecoration.underline,
                            color: themeChange.getThem()
                                ? AppThemeData.secondary300
                                : AppThemeData.secondary300,
                            fontSize: 16,
                          ),
                        ),
                      ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  child: Row(
                    children: [
                      Expanded(
                        child: RoundedButtonFill(
                          title: "Cancel Order".tr,
                          color: AppThemeData.danger300,
                          textColor: AppThemeData.grey50,
                          height: 5,
                          onPress: () async {
                            ShowToastDialog.showLoader('Please wait...'.tr);
                            await AudioPlayerService.playSound(false);
                            orderModel.status = Constant.orderCancelled;
                            if (orderModel.driverID != null) {
                              UserModel? driverModel =
                                  await FireStoreUtils.getUserById(
                                      orderModel.driverID ?? '');
                              driverModel?.orderRequestData
                                  ?.remove(orderModel.id);
                              driverModel?.inProgressOrderID
                                  ?.remove(orderModel.id);
                              await FireStoreUtils.updateDriverUser(
                                  driverModel!);
                              SendNotification.sendFcmMessage(
                                  Constant.driverCancelled,
                                  driverModel.fcmToken.toString(),
                                  {'title': 'Cancelled Order'});
                            }
                            await FireStoreUtils.updateOrder(orderModel);
                            SendNotification.sendFcmMessage(
                                Constant.restaurantCancelled,
                                orderModel.author!.fcmToken.toString(), {});

                            if (orderModel.paymentMethod!.toLowerCase() !=
                                'cod') {
                              double finalAmount = (subTotal +
                                      double.parse(
                                          orderModel.discount.toString()) +
                                      specialDiscount +
                                      double.parse(taxAmount.toString())) +
                                  double.parse(
                                      orderModel.deliveryCharge.toString()) +
                                  double.parse(orderModel.tipAmount.toString());

                              WalletTransactionModel historyModel =
                                  WalletTransactionModel(
                                      amount: finalAmount,
                                      id: const Uuid().v4(),
                                      orderId: orderModel.id,
                                      userId: orderModel.author!.id,
                                      date: Timestamp.now(),
                                      isTopup: true,
                                      paymentMethod: "Wallet",
                                      paymentStatus: "success",
                                      note: "Order Refund success",
                                      transactionUser: "user");

                              await FireStoreUtils.fireStore
                                  .collection(CollectionName.wallet)
                                  .doc(historyModel.id)
                                  .set(historyModel.toJson());
                              await FireStoreUtils.updateUserWallet(
                                  amount: finalAmount.toString(),
                                  userId: orderModel.author!.id.toString());
                            }

                            double taxAmountData =
                                double.parse(taxAmount.toString());

                            double finalAmount = 0;
                            if (orderModel.adminCommission != '0' &&
                                orderModel.adminCommission != '' &&
                                orderModel.adminCommission != null) {
                              finalAmount = (subTotal /
                                      (1 +
                                          (double.parse(
                                                  orderModel.adminCommission!) /
                                              100))) -
                                  double.parse(orderModel.discount.toString()) -
                                  specialDiscount;
                            } else {
                              finalAmount = subTotal -
                                  double.parse(orderModel.discount.toString()) -
                                  specialDiscount;
                            }
                            WalletTransactionModel historyTaxModel =
                                WalletTransactionModel(
                                    amount: taxAmountData,
                                    id: const Uuid().v4(),
                                    orderId: orderModel.id,
                                    userId: FireStoreUtils.getCurrentUid(),
                                    date: Timestamp.now(),
                                    isTopup: false,
                                    paymentMethod: "tax",
                                    paymentStatus: "success",
                                    note: "Tax Amount Refund",
                                    transactionUser: "vendor");

                            WalletTransactionModel historyModel =
                                WalletTransactionModel(
                                    amount: finalAmount,
                                    id: const Uuid().v4(),
                                    orderId: orderModel.id,
                                    userId: FireStoreUtils.getCurrentUid(),
                                    date: Timestamp.now(),
                                    isTopup: false,
                                    paymentMethod: "Wallet",
                                    paymentStatus: "success",
                                    note: "Order Amount Refund",
                                    transactionUser: "vendor");

                            await FireStoreUtils.fireStore
                                .collection(CollectionName.wallet)
                                .doc(historyTaxModel.id)
                                .set(historyTaxModel.toJson());
                            await FireStoreUtils.fireStore
                                .collection(CollectionName.wallet)
                                .doc(historyModel.id)
                                .set(historyModel.toJson());
                            double finalAmountdata = finalAmount + taxAmount;
                            await FireStoreUtils.updateUserWallet(
                                amount: (-finalAmountdata).toString(),
                                userId:
                                    FireStoreUtils.getCurrentUid().toString());
                            await controller.getOrder();
                            Get.back();
                            ShowToastDialog.closeLoader();
                          },
                        ),
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      Expanded(
                        child: orderModel.takeAway == true
                            ? RoundedButtonFill(
                                title: "Delivered".tr,
                                color: AppThemeData.primary300,
                                textColor: AppThemeData.grey50,
                                height: 5,
                                onPress: () async {
                                  ShowToastDialog.showLoader(
                                      'Please wait...'.tr);
                                  await AudioPlayerService.playSound(false);
                                  orderModel.status = Constant.orderCompleted;
                                  await FireStoreUtils.updateOrder(orderModel);
                                  await FireStoreUtils
                                      .restaurantVendorWalletSet(orderModel);
                                  SendNotification.sendFcmMessage(
                                      Constant.takeawayCompleted,
                                      orderModel.author!.fcmToken.toString(),
                                      {});

                                  ShowToastDialog.closeLoader();
                                },
                              )
                            : RoundedButtonFill(
                                title: orderModel.status.toString(),
                                color: AppThemeData.secondary300,
                                textColor: AppThemeData.grey50,
                                height: 5,
                                onPress: () async {},
                              ),
                      ),
                      Visibility(
                        visible: controller.userModel.value.subscriptionPlan
                                ?.features?.chat !=
                            false,
                        child: Row(
                          children: [
                            const SizedBox(
                              width: 10,
                            ),
                            InkWell(
                              onTap: () async {
                                ShowToastDialog.showLoader("Please wait".tr);

                                UserModel? customer =
                                    await FireStoreUtils.getUserById(
                                        orderModel.authorID.toString());
                                UserModel? restaurantUser =
                                    await FireStoreUtils.getUserProfile(
                                        orderModel.vendor!.author.toString());
                                VendorModel? vendorModel =
                                    await FireStoreUtils.getVendorById(
                                        orderModel.vendorID.toString());
                                ShowToastDialog.closeLoader();

                                Get.to(const ChatScreen(), arguments: {
                                  "customerName": '${customer!.fullName()}',
                                  "restaurantName": vendorModel!.title,
                                  "orderId": orderModel.id,
                                  "restaurantId": restaurantUser!.id,
                                  "customerId": customer.id,
                                  "customerProfileImage":
                                      customer.profilePictureURL,
                                  "restaurantProfileImage": vendorModel.photo,
                                  "token": restaurantUser.fcmToken,
                                  "chatType": "customer",
                                });
                              },
                              child: Container(
                                  decoration: ShapeDecoration(
                                    color: AppThemeData.secondary50,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: SvgPicture.asset(
                                        "assets/icons/ic_message.svg"),
                                  )),
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  completedAndRejectedWidget(themeChange, BuildContext context,
      OrderModel orderModel, HomeController controller) {
    double totalAmount = 0.0;
    double subTotal = 0.0;
    double taxAmount = 0.0;
    double specialDiscount = 0.0;
    double adminCommission = 0.0;

    for (var element in orderModel.products!) {
      if (double.parse(element.discountPrice.toString()) <= 0) {
        subTotal = subTotal +
            double.parse(element.price.toString()) *
                double.parse(element.quantity.toString()) +
            (double.parse(element.extrasPrice.toString()) *
                double.parse(element.quantity.toString()));
      } else {
        subTotal = subTotal +
            double.parse(element.discountPrice.toString()) *
                double.parse(element.quantity.toString()) +
            (double.parse(element.extrasPrice.toString()) *
                double.parse(element.quantity.toString()));
      }
    }

    if (orderModel.specialDiscount != null &&
        orderModel.specialDiscount!['special_discount'] != null) {
      specialDiscount = double.parse(
          orderModel.specialDiscount!['special_discount'].toString());
    }

    if (orderModel.taxSetting != null) {
      for (var element in orderModel.taxSetting!) {
        taxAmount = taxAmount +
            Constant.calculateTax(
                amount: (subTotal -
                        double.parse(orderModel.discount.toString()) -
                        specialDiscount)
                    .toString(),
                taxModel: element);
      }
    }

    totalAmount = subTotal -
        double.parse(orderModel.discount.toString()) -
        specialDiscount +
        taxAmount;

    if (orderModel.adminCommissionType == 'Percent') {
      double basePrice =
          subTotal / (1 + (double.parse(orderModel.adminCommission!) / 100));
      adminCommission = subTotal - basePrice;
    } else {
      adminCommission = double.parse(orderModel.adminCommission!);
    }

    return InkWell(
      onTap: () async {
        Get.to(const OrderDetailsScreen(),
            arguments: {"orderModel": orderModel});
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 5),
        child: Container(
          decoration: ShapeDecoration(
            color: themeChange.getThem()
                ? AppThemeData.grey900
                : AppThemeData.grey50,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                Row(
                  children: [
                    ClipOval(
                      child: NetworkImageWidget(
                        imageUrl:
                            orderModel.author!.profilePictureURL.toString(),
                        width: 40,
                        height: 40,
                        fit: BoxFit.cover,
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
                            orderModel.author!.fullName().toString().tr,
                            style: TextStyle(
                              color: themeChange.getThem()
                                  ? AppThemeData.grey50
                                  : AppThemeData.grey900,
                              fontSize: 14,
                              fontFamily: AppThemeData.semiBold,
                            ),
                          ),
                          orderModel.takeAway == true
                              ? Text(
                                  "Take Away".tr,
                                  style: TextStyle(
                                    color: themeChange.getThem()
                                        ? AppThemeData.grey400
                                        : AppThemeData.grey500,
                                    fontSize: 12,
                                    fontFamily: AppThemeData.medium,
                                  ),
                                )
                              : Text(
                                  orderModel.address!.getFullAddress().tr,
                                  style: TextStyle(
                                    color: themeChange.getThem()
                                        ? AppThemeData.grey400
                                        : AppThemeData.grey500,
                                    fontSize: 12,
                                    fontFamily: AppThemeData.medium,
                                  ),
                                ),
                        ],
                      ),
                    ),
                    const Icon(Icons.chevron_right)
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  child: MySeparator(
                      color: themeChange.getThem()
                          ? AppThemeData.grey700
                          : AppThemeData.grey200),
                ),
                ListView.builder(
                  shrinkWrap: true,
                  itemCount: orderModel.products!.length,
                  physics: const NeverScrollableScrollPhysics(),
                  itemBuilder: (context, index) {
                    CartProductModel product = orderModel.products![index];
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                "${product.quantity}x ${product.name}".tr,
                                style: TextStyle(
                                  color: themeChange.getThem()
                                      ? AppThemeData.grey100
                                      : AppThemeData.grey800,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                  fontFamily: AppThemeData.semiBold,
                                ),
                              ),
                            ),
                            Text(
                              double.parse(product.discountPrice ?? "0.0") <= 0
                                  ? Constant.amountShow(
                                      amount: (double.parse(
                                                  product.price.toString()) *
                                              double.parse(
                                                  product.quantity.toString()))
                                          .toString())
                                  : Constant.amountShow(
                                          amount: (double.parse(product
                                                      .discountPrice
                                                      .toString()) *
                                                  double.parse(product.quantity
                                                      .toString()))
                                              .toString())
                                      .tr,
                              style: TextStyle(
                                color: themeChange.getThem()
                                    ? AppThemeData.grey100
                                    : AppThemeData.grey800,
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                                fontFamily: AppThemeData.semiBold,
                              ),
                            ),
                          ],
                        ),
                        product.variantInfo == null ||
                                product.variantInfo!.variantOptions!.isEmpty
                            ? Container()
                            : Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 5, vertical: 10),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "Variants".tr,
                                      textAlign: TextAlign.start,
                                      style: TextStyle(
                                        fontFamily: AppThemeData.semiBold,
                                        color: themeChange.getThem()
                                            ? AppThemeData.grey300
                                            : AppThemeData.grey600,
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
                                        product.variantInfo!.variantOptions!
                                            .length,
                                        (i) {
                                          return Container(
                                            decoration: ShapeDecoration(
                                              color: themeChange.getThem()
                                                  ? AppThemeData.grey800
                                                  : AppThemeData.grey100,
                                              shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(8)),
                                            ),
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 16,
                                                      vertical: 5),
                                              child: Text(
                                                "${product.variantInfo!.variantOptions!.keys.elementAt(i)} : ${product.variantInfo!.variantOptions![product.variantInfo!.variantOptions!.keys.elementAt(i)]}",
                                                textAlign: TextAlign.start,
                                                style: TextStyle(
                                                  fontFamily:
                                                      AppThemeData.medium,
                                                  color: themeChange.getThem()
                                                      ? AppThemeData.grey500
                                                      : AppThemeData.grey400,
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
                        product.extras == null || product.extras!.isEmpty
                            ? const SizedBox()
                            : Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  Row(
                                    children: [
                                      Expanded(
                                        child: Text(
                                          "Addons".tr,
                                          textAlign: TextAlign.start,
                                          style: TextStyle(
                                            fontFamily: AppThemeData.semiBold,
                                            color: themeChange.getThem()
                                                ? AppThemeData.grey300
                                                : AppThemeData.grey600,
                                            fontSize: 16,
                                          ),
                                        ),
                                      ),
                                      Text(
                                        Constant.amountShow(
                                            amount: (double.parse(product
                                                        .extrasPrice
                                                        .toString()) *
                                                    double.parse(product
                                                        .quantity
                                                        .toString()))
                                                .toString()),
                                        textAlign: TextAlign.start,
                                        style: TextStyle(
                                          fontFamily: AppThemeData.semiBold,
                                          color: themeChange.getThem()
                                              ? AppThemeData.secondary300
                                              : AppThemeData.secondary300,
                                          fontSize: 16,
                                        ),
                                      ),
                                    ],
                                  ),
                                  Wrap(
                                    spacing: 6.0,
                                    runSpacing: 6.0,
                                    children: List.generate(
                                      product.extras!.length,
                                      (i) {
                                        return Container(
                                          decoration: ShapeDecoration(
                                            color: themeChange.getThem()
                                                ? AppThemeData.grey800
                                                : AppThemeData.grey100,
                                            shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(8)),
                                          ),
                                          child: Padding(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 16, vertical: 5),
                                            child: Text(
                                              product.extras![i].toString(),
                                              textAlign: TextAlign.start,
                                              style: TextStyle(
                                                fontFamily: AppThemeData.medium,
                                                color: themeChange.getThem()
                                                    ? AppThemeData.grey500
                                                    : AppThemeData.grey400,
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
                ),
                const SizedBox(
                  height: 10,
                ),
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        "Order Date".tr,
                        style: TextStyle(
                          color: themeChange.getThem()
                              ? AppThemeData.grey300
                              : AppThemeData.grey600,
                          fontSize: 16,
                          fontWeight: FontWeight.w400,
                          fontFamily: AppThemeData.regular,
                        ),
                      ),
                    ),
                    Text(
                      Constant.timestampToDateTime(orderModel.createdAt!),
                      style: TextStyle(
                        color: themeChange.getThem()
                            ? AppThemeData.grey100
                            : AppThemeData.grey800,
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        fontFamily: AppThemeData.semiBold,
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 5,
                ),
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        "Total Amount".tr,
                        style: TextStyle(
                          color: themeChange.getThem()
                              ? AppThemeData.grey300
                              : AppThemeData.grey600,
                          fontSize: 16,
                          fontWeight: FontWeight.w400,
                          fontFamily: AppThemeData.regular,
                        ),
                      ),
                    ),
                    Text(
                      Constant.amountShow(amount: totalAmount.toString()).tr,
                      style: TextStyle(
                        color: themeChange.getThem()
                            ? AppThemeData.grey100
                            : AppThemeData.grey800,
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        fontFamily: AppThemeData.semiBold,
                      ),
                    ),
                  ],
                ),
                Visibility(
                  visible: Constant.adminCommission?.isEnabled == true,
                  child: Column(
                    children: [
                      const SizedBox(
                        height: 5,
                      ),
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              "Admin Commissions".tr,
                              style: TextStyle(
                                color: themeChange.getThem()
                                    ? AppThemeData.grey300
                                    : AppThemeData.grey600,
                                fontSize: 16,
                                fontWeight: FontWeight.w400,
                                fontFamily: AppThemeData.regular,
                              ),
                            ),
                          ),
                          Text(
                            "-${Constant.amountShow(amount: adminCommission.toString())}"
                                .tr,
                            style: TextStyle(
                              color: themeChange.getThem()
                                  ? AppThemeData.danger300
                                  : AppThemeData.danger300,
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                              fontFamily: AppThemeData.semiBold,
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
                orderModel.scheduleTime == null
                    ? const SizedBox()
                    : Row(
                        children: [
                          Expanded(
                            child: Text(
                              "Schedule Time".tr,
                              style: TextStyle(
                                color: themeChange.getThem()
                                    ? AppThemeData.grey300
                                    : AppThemeData.grey600,
                                fontSize: 16,
                                fontWeight: FontWeight.w400,
                                fontFamily: AppThemeData.regular,
                              ),
                            ),
                          ),
                          Text(
                            Constant.timestampToDateTime(
                                    orderModel.scheduleTime!)
                                .tr,
                            style: TextStyle(
                              color: themeChange.getThem()
                                  ? AppThemeData.secondary300
                                  : AppThemeData.secondary300,
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                              fontFamily: AppThemeData.semiBold,
                            ),
                          ),
                        ],
                      ),
                const SizedBox(
                  height: 5,
                ),
                orderModel.notes == null || orderModel.notes!.isEmpty
                    ? const SizedBox()
                    : InkWell(
                        onTap: () {
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return viewRemarkDialog(
                                  controller, themeChange, orderModel);
                            },
                          );
                        },
                        child: Text(
                          "View Remarks".tr,
                          textAlign: TextAlign.start,
                          style: TextStyle(
                            fontFamily: AppThemeData.regular,
                            decoration: TextDecoration.underline,
                            color: themeChange.getThem()
                                ? AppThemeData.secondary300
                                : AppThemeData.secondary300,
                            fontSize: 16,
                          ),
                        ),
                      ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  child: RoundedButtonFill(
                    title: orderModel.status.toString(),
                    color: orderModel.status == Constant.orderRejected
                        ? AppThemeData.danger300
                        : AppThemeData.secondary300,
                    textColor: AppThemeData.grey50,
                    height: 5,
                    onPress: () async {},
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  showListOfDeliverymenDialog(
      HomeController controller, themeChange, OrderModel orderModel) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      insetPadding: const EdgeInsets.all(10),
      clipBehavior: Clip.antiAliasWithSaveLayer,
      backgroundColor: themeChange.getThem()
          ? AppThemeData.surfaceDark
          : AppThemeData.surface,
      child: SizedBox(
        width: 500,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    child: Text(
                      "Select the delivery man".tr,
                      textAlign: TextAlign.start,
                      style: TextStyle(
                        fontFamily: AppThemeData.semiBold,
                        color: themeChange.getThem()
                            ? AppThemeData.grey100
                            : AppThemeData.grey800,
                        fontSize: 18,
                      ),
                    ),
                  ),
                  TextButton(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      child: Text(
                        'Add Delivery Man'.tr,
                        style: TextStyle(
                            color: AppThemeData.secondary300,
                            fontFamily: AppThemeData.medium),
                      ),
                    ),
                    onPressed: () {
                      Get.to(AddDriverScreen())?.then((value) async {
                        if (value == true) {
                          Get.back();
                          ShowToastDialog.showToastDuration(
                              "Please ensure that the deliveryman is signed in and has an active status to assign the delivery."
                                  .tr,
                              duration: Duration(seconds: 4));
                        }
                      });
                    },
                  ),
                ],
              ),
            ),
            SizedBox(height: 10),
            Obx(() => Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: DropdownSearch<UserModel>(
                    popupProps: PopupProps.menu(
                        showSearchBox: true,
                        searchFieldProps: TextFieldProps(
                          decoration: InputDecoration(
                            labelStyle: TextStyle(
                                fontFamily: AppThemeData.medium, fontSize: 15),
                            labelText: "Search Delivery Man".tr,
                            border: OutlineInputBorder(),
                            prefixIcon: Icon(Icons.search),
                            contentPadding: EdgeInsets.symmetric(
                                vertical: 12, horizontal: 16),
                          ),
                        ),
                        itemBuilder:
                            (context, UserModel driver, bool isSelected) {
                          return Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 12, vertical: 12),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                  flex: 5,
                                  child: Text(
                                    "${driver.firstName} ${driver.lastName}",
                                    style: TextStyle(
                                      fontFamily: AppThemeData.medium,
                                      fontSize: 14,
                                      // Change this to match your theme
                                    ),
                                  ),
                                ),
                                if (Constant.singleOrderReceive == true)
                                  Expanded(
                                    flex: 1,
                                    child: driver.inProgressOrderID?.isEmpty ==
                                            true
                                        ? Text(
                                            'Assign'.tr,
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                              fontFamily: AppThemeData.medium,
                                              fontSize: 12,
                                              color: AppThemeData.secondary300,
                                              // Change this to match your theme
                                            ),
                                          )
                                        : Text(
                                            'Occupied'.tr,
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                              fontFamily: AppThemeData.medium,
                                              fontSize: 12,
                                              color: AppThemeData.danger300,
                                              // Change this to match your theme
                                            ),
                                          ),
                                  ),
                              ],
                            ),
                          );
                        }),
                    items: controller.driverUserList,
                    dropdownDecoratorProps: DropDownDecoratorProps(
                      baseStyle: TextStyle(
                        fontFamily: AppThemeData.medium,
                        fontSize: 16,
                      ),
                      dropdownSearchDecoration: InputDecoration(
                        labelText: "Select Delivery Man".tr,
                        labelStyle: TextStyle(
                          fontFamily: AppThemeData.medium,
                          fontSize: 15, // Light grey label text
                        ),
                        border: OutlineInputBorder(),
                        contentPadding:
                            EdgeInsets.symmetric(vertical: 14, horizontal: 16),
                      ),
                    ),
                    itemAsString: (UserModel? user) => user?.id != null
                        ? "${user?.firstName} ${user?.lastName}"
                        : "Select Delivery Man".tr,
                    onChanged: (value) {
                      if (Constant.singleOrderReceive == true) {
                        if (value?.inProgressOrderID?.isEmpty == true) {
                          controller.selectDriverUser.value = value!;
                        } else {
                          ShowToastDialog.showToast(
                              "This delivery man is already assigned. Kindly select a different one."
                                  .tr);
                          controller.selectDriverUser.value = UserModel();
                        }
                      } else {
                        controller.selectDriverUser.value = value!;
                      }
                    },
                    selectedItem: controller.selectDriverUser.value,
                  ),
                )),
            SizedBox(height: 20),
            PreferredSize(
              preferredSize: const Size.fromHeight(4.0),
              child: Container(
                color: themeChange.getThem()
                    ? AppThemeData.grey700
                    : AppThemeData.grey200,
                height: 3.0,
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                children: [
                  SizedBox(height: 10),
                  Row(
                    children: [
                      Expanded(
                        child: RoundedButtonFill(
                          title: "Cancel".tr,
                          color: themeChange.getThem()
                              ? AppThemeData.grey700
                              : AppThemeData.grey200,
                          textColor: themeChange.getThem()
                              ? AppThemeData.grey100
                              : AppThemeData.grey800,
                          onPress: () async {
                            Get.back();
                          },
                        ),
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      Expanded(
                        child: RoundedButtonFill(
                          title: "Order Assign".tr,
                          color: AppThemeData.secondary300,
                          textColor: AppThemeData.grey50,
                          onPress: () async {
                            if (controller.selectDriverUser.value.id != null &&
                                controller.selectDriverUser.value.id != '') {
                              Get.back();
                              ShowToastDialog.showLoader('Please wait...'.tr);
                              await AudioPlayerService.playSound(false);
                              if ((Constant.isSubscriptionModelApplied ==
                                          true ||
                                      Constant.adminCommission?.isEnabled ==
                                          true) &&
                                  controller
                                          .vendermodel.value.subscriptionPlan !=
                                      null) {
                                if (controller.vendermodel.value
                                            .subscriptionTotalOrders !=
                                        '-1' &&
                                    controller.vendermodel.value
                                            .subscriptionTotalOrders !=
                                        null) {
                                  controller.vendermodel.value
                                      .subscriptionTotalOrders = (int.parse(
                                              controller.vendermodel.value
                                                  .subscriptionTotalOrders!) -
                                          1)
                                      .toString();
                                  await FireStoreUtils.updateVendor(
                                      controller.vendermodel.value);
                                }
                              }
                              orderModel.notes = "";
                              orderModel.driverID =
                                  controller.selectDriverUser.value.id;
                              orderModel.driver =
                                  controller.selectDriverUser.value;
                              orderModel.status = Constant.orderInTransit;
                              controller
                                  .selectDriverUser.value.inProgressOrderID!
                                  .add(orderModel.id);

                              await FireStoreUtils.updateOrder(orderModel);
                              await FireStoreUtils.updateDriverUser(
                                  controller.selectDriverUser.value);
                              await FireStoreUtils.restaurantVendorWalletSet(
                                  orderModel);
                              SendNotification.sendFcmMessage(
                                  Constant.restaurantAccepted,
                                  orderModel.author!.fcmToken.toString(), {});
                              SendNotification.sendFcmMessage(
                                  Constant.newDeliveryOrder,
                                  orderModel.driver?.fcmToken ?? '', {});
                              ShowToastDialog.closeLoader();
                            } else {
                              ShowToastDialog.showToast(
                                  "Please select the delivery man".tr);
                            }
                          },
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  estimatedTimeDialog(HomeController controller, themeChange,
      OrderModel orderModel, BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      insetPadding: const EdgeInsets.all(10),
      clipBehavior: Clip.antiAliasWithSaveLayer,
      backgroundColor: themeChange.getThem()
          ? AppThemeData.surfaceDark
          : AppThemeData.surface,
      child: SizedBox(
        width: 500,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              child: Text(
                "Estimate time to prepare".tr,
                textAlign: TextAlign.start,
                style: TextStyle(
                  fontFamily: AppThemeData.semiBold,
                  color: themeChange.getThem()
                      ? AppThemeData.grey100
                      : AppThemeData.grey800,
                  fontSize: 18,
                ),
              ),
            ),
            PreferredSize(
              preferredSize: const Size.fromHeight(4.0),
              child: Container(
                color: themeChange.getThem()
                    ? AppThemeData.grey700
                    : AppThemeData.grey200,
                height: 3.0,
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                children: [
                  const SizedBox(
                    height: 20,
                  ),
                  TextFieldWidget(
                    title: 'Estimated time to Prepare'.tr,
                    inputFormatters: [MaskedInputFormatter('##:##')],
                    controller: controller.estimatedTimeController.value,
                    hintText: '00:00'.tr,
                    textInputType: TextInputType.number,
                    prefix: const Icon(Icons.alarm),
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: RoundedButtonFill(
                          title: "Cancel".tr,
                          color: themeChange.getThem()
                              ? AppThemeData.grey700
                              : AppThemeData.grey200,
                          textColor: themeChange.getThem()
                              ? AppThemeData.grey100
                              : AppThemeData.grey800,
                          onPress: () async {
                            Get.back();
                          },
                        ),
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      Expanded(
                        child: RoundedButtonFill(
                          title: "Shipped order".tr,
                          color: AppThemeData.secondary300,
                          textColor: AppThemeData.grey50,
                          onPress: () async {
                            if (controller.estimatedTimeController.value.text
                                .isNotEmpty) {
                              if ((Constant.isSubscriptionModelApplied ==
                                          true ||
                                      Constant.adminCommission?.isEnabled ==
                                          true) &&
                                  controller
                                          .vendermodel.value.subscriptionPlan !=
                                      null) {
                                if (controller.vendermodel.value
                                            .subscriptionTotalOrders !=
                                        '-1' &&
                                    controller.vendermodel.value
                                            .subscriptionTotalOrders !=
                                        null) {
                                  controller.vendermodel.value
                                      .subscriptionTotalOrders = (int.parse(
                                              controller.vendermodel.value
                                                  .subscriptionTotalOrders!) -
                                          1)
                                      .toString();
                                  await FireStoreUtils.updateVendor(
                                      controller.vendermodel.value);
                                }
                              }
                              if (Constant.isSelfDeliveryFeature == true &&
                                  controller.vendermodel.value.isSelfDelivery ==
                                      true &&
                                  orderModel.takeAway == false) {
                                ShowToastDialog.showLoader('Please wait...'.tr);
                                await controller.getAllDriverList();
                                ShowToastDialog.closeLoader();
                                orderModel.estimatedTimeToPrepare = controller
                                    .estimatedTimeController.value.text;
                                Get.back();
                                showDialog(
                                  // ignore: use_build_context_synchronously
                                  context: context,
                                  builder: (BuildContext context) {
                                    return showListOfDeliverymenDialog(
                                        controller, themeChange, orderModel);
                                  },
                                );
                              } else {
                                ShowToastDialog.showLoader('Please wait...'.tr);
                                orderModel.estimatedTimeToPrepare = controller
                                    .estimatedTimeController.value.text;
                                orderModel.status = Constant.orderAccepted;
                                await AudioPlayerService.playSound(false);
                                await FireStoreUtils.updateOrder(orderModel);
                                await FireStoreUtils.restaurantVendorWalletSet(
                                    orderModel);
                                SendNotification.sendFcmMessage(
                                    Constant.restaurantAccepted,
                                    orderModel.author!.fcmToken.toString(), {});

                                ShowToastDialog.closeLoader();
                                Get.back();
                              }
                            } else {
                              ShowToastDialog.showToast(
                                  "Please enter estimated time".tr);
                            }
                          },
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  viewRemarkDialog(
      HomeController controller, themeChange, OrderModel orderModel) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      insetPadding: const EdgeInsets.all(10),
      clipBehavior: Clip.antiAliasWithSaveLayer,
      backgroundColor: themeChange.getThem()
          ? AppThemeData.surfaceDark
          : AppThemeData.surface,
      child: SizedBox(
        width: 500,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                child: Text(
                  orderModel.notes.toString(),
                  textAlign: TextAlign.start,
                  style: TextStyle(
                    fontFamily: AppThemeData.semiBold,
                    color: themeChange.getThem()
                        ? AppThemeData.grey100
                        : AppThemeData.grey800,
                    fontSize: 18,
                  ),
                ),
              ),
              RoundedButtonFill(
                title: "Cancel".tr,
                color: themeChange.getThem()
                    ? AppThemeData.grey700
                    : AppThemeData.grey200,
                textColor: themeChange.getThem()
                    ? AppThemeData.grey100
                    : AppThemeData.grey800,
                onPress: () async {
                  Get.back();
                },
              ),
              const SizedBox(
                height: 20,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
