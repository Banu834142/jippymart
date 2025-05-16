import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:restaurant/app/subscription_plan_screen/select_payment_screen.dart';
import 'package:restaurant/constant/constant.dart';
import 'package:restaurant/controller/subscription_controller.dart';
import 'package:restaurant/models/subscription_plan_model.dart';
import 'package:restaurant/themes/app_them_data.dart';
import 'package:restaurant/themes/responsive.dart';
import 'package:restaurant/themes/round_button_fill.dart';
import 'package:restaurant/utils/dark_theme_provider.dart';
import 'package:restaurant/utils/network_image_widget.dart';

class SubscriptionPlanScreen extends StatelessWidget {
  const SubscriptionPlanScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final themeChange = Provider.of<DarkThemeProvider>(context);
    return GetX(
        init: SubscriptionController(),
        builder: (controller) {
          return Scaffold(
            appBar: AppBar(
              backgroundColor: AppThemeData.secondary300,
              centerTitle: false,
              titleSpacing: 0,
              iconTheme:
                  const IconThemeData(color: AppThemeData.grey50, size: 20),
            ),
            body: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    const SizedBox(
                      height: 40,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "Choose Your Business Plan".tr,
                            style: TextStyle(
                              color: themeChange.getThem()
                                  ? AppThemeData.grey50
                                  : AppThemeData.grey900,
                              fontSize: 24,
                              fontFamily: AppThemeData.semiBold,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            "Select the most suitable business plan for your restaurant to maximize your potential and access exclusive features."
                                .tr,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: themeChange.getThem()
                                  ? AppThemeData.grey400
                                  : AppThemeData.grey500,
                              fontSize: 16,
                              fontFamily: AppThemeData.regular,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 24,
                    ),
                    controller.isLoading.value
                        ? Constant.loader()
                        : controller.subscriptionPlanList.isEmpty
                            ? SizedBox(
                                width: Responsive.width(100, context),
                                height: Responsive.height(50, context),
                                child: Constant.showEmptyView(
                                    message: "Subscription plan not found.".tr))
                            : ListView.builder(
                                physics: const NeverScrollableScrollPhysics(),
                                shrinkWrap: true,
                                primary: false,
                                itemCount:
                                    controller.subscriptionPlanList.length,
                                itemBuilder: (context, index) {
                                  final subscriptionPlanModel =
                                      controller.subscriptionPlanList[index];
                                  return SubscriptionPlanWidget(
                                    onContainClick: () {
                                      controller.selectedSubscriptionPlan
                                          .value = subscriptionPlanModel;
                                      controller.totalAmount.value =
                                          double.parse(
                                              subscriptionPlanModel.price ??
                                                  '0.0');
                                      controller.update();
                                    },
                                    onClick: () {
                                      if (controller.selectedSubscriptionPlan
                                              .value.id ==
                                          subscriptionPlanModel.id) {
                                        if (controller.selectedSubscriptionPlan
                                                    .value.type ==
                                                'free' ||
                                            controller.selectedSubscriptionPlan
                                                    .value.id ==
                                                Constant
                                                    .commissionSubscriptionID) {
                                          controller.selectedPaymentMethod
                                              .value = 'free';
                                          controller.placeOrder();
                                        } else {
                                          Get.to(const SelectPaymentScreen());
                                        }
                                      }
                                    },
                                    type: 'Plan',
                                    subscriptionPlanModel:
                                        subscriptionPlanModel,
                                  );
                                }),
                    const SizedBox(
                      height: 10,
                    ),
                  ],
                ),
              ),
            ),
          );
        });
  }
}

class FeatureItem extends StatelessWidget {
  final String title;
  final bool isActive;
  final bool selectedPlan;

  const FeatureItem(
      {super.key,
      required this.title,
      required this.isActive,
      required this.selectedPlan});

  @override
  Widget build(BuildContext context) {
    final themeChange = Provider.of<DarkThemeProvider>(context);
    return Padding(
      padding: const EdgeInsets.only(right: 16),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          isActive == true
              ? SvgPicture.asset(
                  'assets/icons/ic_check.svg',
                )
              : SvgPicture.asset(
                  'assets/icons/ic_close.svg',
                  colorFilter: const ColorFilter.mode(
                    AppThemeData.danger200,
                    BlendMode.srcIn,
                  ),
                ),
          const SizedBox(width: 4),
          Text(
            title == 'chat'
                ? 'Chat'.tr
                : title == 'dineIn'
                    ? "DineIn".tr
                    : title == 'qrCodeGenerate'
                        ? 'QR Code Generate'.tr
                        : title == 'restaurantMobileApp'
                            ? 'Restaurant Mobile App'.tr
                            : '',
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontSize: 14,
              fontFamily: AppThemeData.medium,
              color: themeChange.getThem()
                  ? selectedPlan == true
                      ? AppThemeData.grey900
                      : AppThemeData.grey50
                  : selectedPlan == true
                      ? AppThemeData.grey50
                      : AppThemeData.grey900,
            ),
          ),
        ],
      ),
    );
  }
}

class SubscriptionPlanWidget extends StatelessWidget {
  final VoidCallback onClick;
  final VoidCallback onContainClick;
  final String type;
  final SubscriptionPlanModel subscriptionPlanModel;

  const SubscriptionPlanWidget(
      {super.key,
      required this.onClick,
      required this.type,
      required this.subscriptionPlanModel,
      required this.onContainClick});

  @override
  Widget build(BuildContext context) {
    final themeChange = Provider.of<DarkThemeProvider>(context);

    return GetX(
        init: SubscriptionController(),
        builder: (controller) {
          return InkWell(
            splashColor: Colors.transparent,
            onTap: onContainClick,
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 2, vertical: 4),
              decoration: BoxDecoration(
                border: Border.all(
                    color: themeChange.getThem()
                        ? AppThemeData.grey800
                        : AppThemeData.grey200),
                color: controller.selectedSubscriptionPlan.value.id ==
                        subscriptionPlanModel.id
                    ? themeChange.getThem()
                        ? AppThemeData.grey50
                        : AppThemeData.grey800
                    : themeChange.getThem()
                        ? AppThemeData.grey900
                        : AppThemeData.grey50,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        NetworkImageWidget(
                          imageUrl: subscriptionPlanModel.image ?? '',
                          fit: BoxFit.cover,
                          width: 50,
                          height: 50,
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                subscriptionPlanModel.name ?? '',
                                style: TextStyle(
                                  color: controller.selectedSubscriptionPlan
                                              .value.id ==
                                          subscriptionPlanModel.id
                                      ? themeChange.getThem()
                                          ? AppThemeData.grey900
                                          : AppThemeData.grey50
                                      : themeChange.getThem()
                                          ? AppThemeData.grey50
                                          : AppThemeData.grey900,
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  fontFamily: AppThemeData.semiBold,
                                ),
                              ),
                              Text(
                                "${subscriptionPlanModel.description}",
                                maxLines: 2,
                                softWrap: true,
                                style: const TextStyle(
                                  fontFamily: AppThemeData.regular,
                                  fontSize: 14,
                                  color: AppThemeData.grey400,
                                ),
                              ),
                            ],
                          ),
                        ),
                        controller.userModel.value.subscriptionPlanId ==
                                subscriptionPlanModel.id
                            ? RoundedButtonFill(
                                title: "Active".tr,
                                width: 18,
                                height: 4,
                                color: AppThemeData.success500,
                                textColor: AppThemeData.grey50,
                                onPress: () async {},
                              )
                            : SizedBox(),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          subscriptionPlanModel.type == "free"
                              ? "Free".tr
                              : Constant.amountShow(
                                  amount: double.parse(
                                          subscriptionPlanModel.price ?? '0.0')
                                      .toString()),
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color:
                                controller.selectedSubscriptionPlan.value.id ==
                                        subscriptionPlanModel.id
                                    ? themeChange.getThem()
                                        ? AppThemeData.grey800
                                        : AppThemeData.grey200
                                    : themeChange.getThem()
                                        ? AppThemeData.grey200
                                        : AppThemeData.grey800,
                            fontFamily: AppThemeData.semiBold,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          subscriptionPlanModel.expiryDay == "-1"
                              ? "Lifetime".tr
                              : "${subscriptionPlanModel.expiryDay} ${"Days".tr}",
                          style: TextStyle(
                            fontFamily: AppThemeData.medium,
                            fontSize: 14,
                            color:
                                controller.selectedSubscriptionPlan.value.id ==
                                        subscriptionPlanModel.id
                                    ? themeChange.getThem()
                                        ? AppThemeData.grey500
                                        : AppThemeData.grey500
                                    : themeChange.getThem()
                                        ? AppThemeData.grey500
                                        : AppThemeData.grey500,
                          ),
                        ),
                        const SizedBox(height: 10),
                      ],
                    ),
                    Divider(
                        color: controller.selectedSubscriptionPlan.value.id ==
                                subscriptionPlanModel.id
                            ? themeChange.getThem()
                                ? AppThemeData.grey200
                                : AppThemeData.grey700
                            : themeChange.getThem()
                                ? AppThemeData.grey700
                                : AppThemeData.grey200),
                    const SizedBox(height: 10),
                    Wrap(
                      spacing: 0,
                      runSpacing: 12,
                      children: subscriptionPlanModel.features
                              ?.toJson()
                              .entries
                              .map((entry) {
                            return FeatureItem(
                                title: entry.key,
                                isActive: entry.value,
                                selectedPlan: controller
                                        .selectedSubscriptionPlan.value.id ==
                                    subscriptionPlanModel.id);
                          }).toList() ??
                          [],
                    ),
                    SizedBox(height: 10),
                    if (subscriptionPlanModel.id ==
                        Constant.commissionSubscriptionID)
                      Padding(
                          padding: const EdgeInsets.only(bottom: 4),
                          child: Row(
                            children: [
                              Text('•  ',
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontFamily: AppThemeData.medium,
                                    color: themeChange.getThem()
                                        ? controller.selectedSubscriptionPlan
                                                    .value.id ==
                                                subscriptionPlanModel.id
                                            ? AppThemeData.grey800
                                            : AppThemeData.grey200
                                        : controller.selectedSubscriptionPlan
                                                    .value.id ==
                                                subscriptionPlanModel.id
                                            ? AppThemeData.grey200
                                            : AppThemeData.grey800,
                                  )),
                              Expanded(
                                child: Text(
                                    // Constant.userModel!.vendorID != null && Constant.userModel!.vendorID!.isNotEmpty
                                    //     ? "Pay a commission of ${Constant.vendorAdminCommission?.commissionType == 'Percent' ? "${Constant.vendorAdminCommission?.amount} %" : "${Constant.amountShow(amount: Constant.vendorAdminCommission?.amount)} Flat"} on each order"
                                    //         .tr
                                    //     :
                                    "${"Pay a commission of".tr} ${Constant.adminCommission?.commissionType == 'Percent' ? "${Constant.adminCommission?.amount} %" : "${Constant.amountShow(amount: Constant.adminCommission?.amount)} ${'Flat'.tr}"} ${"on each order".tr}"
                                        .tr,
                                    maxLines: 2,
                                    style: TextStyle(
                                      fontSize: 14,
                                      fontFamily: AppThemeData.regular,
                                      color: themeChange.getThem()
                                          ? controller.selectedSubscriptionPlan
                                                      .value.id ==
                                                  subscriptionPlanModel.id
                                              ? AppThemeData.grey800
                                              : AppThemeData.grey200
                                          : controller.selectedSubscriptionPlan
                                                      .value.id ==
                                                  subscriptionPlanModel.id
                                              ? AppThemeData.grey200
                                              : AppThemeData.grey800,
                                    )),
                              ),
                            ],
                          )),
                    ListView.builder(
                      shrinkWrap: true,
                      itemCount: subscriptionPlanModel.planPoints?.length,
                      itemBuilder: (BuildContext? context, int index) {
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 4),
                          child: Row(
                            children: [
                              Text('•  ',
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontFamily: AppThemeData.medium,
                                    color: themeChange.getThem()
                                        ? controller.selectedSubscriptionPlan
                                                    .value.id ==
                                                subscriptionPlanModel.id
                                            ? AppThemeData.grey800
                                            : AppThemeData.grey200
                                        : controller.selectedSubscriptionPlan
                                                    .value.id ==
                                                subscriptionPlanModel.id
                                            ? AppThemeData.grey200
                                            : AppThemeData.grey800,
                                  )),
                              Expanded(
                                child: Text(
                                    subscriptionPlanModel.planPoints?[index] ??
                                        '',
                                    maxLines: 2,
                                    style: TextStyle(
                                      fontSize: 14,
                                      fontFamily: AppThemeData.regular,
                                      color: themeChange.getThem()
                                          ? controller.selectedSubscriptionPlan
                                                      .value.id ==
                                                  subscriptionPlanModel.id
                                              ? AppThemeData.grey800
                                              : AppThemeData.grey200
                                          : controller.selectedSubscriptionPlan
                                                      .value.id ==
                                                  subscriptionPlanModel.id
                                              ? AppThemeData.grey200
                                              : AppThemeData.grey800,
                                    )),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                    const SizedBox(height: 10),
                    Divider(
                        color: controller.selectedSubscriptionPlan.value.id ==
                                subscriptionPlanModel.id
                            ? themeChange.getThem()
                                ? AppThemeData.grey200
                                : AppThemeData.grey700
                            : themeChange.getThem()
                                ? AppThemeData.grey700
                                : AppThemeData.grey200),
                    const SizedBox(height: 10),
                    Text(
                        '${"Add item limits :".tr} ${subscriptionPlanModel.itemLimit == '-1' ? 'Unlimited'.tr : subscriptionPlanModel.itemLimit ?? '0'}',
                        maxLines: 2,
                        textAlign: TextAlign.start,
                        style: TextStyle(
                            fontSize: 14,
                            fontFamily: AppThemeData.regular,
                            color: themeChange.getThem()
                                ? controller.selectedSubscriptionPlan.value
                                            .id ==
                                        subscriptionPlanModel.id
                                    ? AppThemeData.grey900
                                    : AppThemeData.grey50
                                : controller.selectedSubscriptionPlan.value
                                            .id ==
                                        subscriptionPlanModel.id
                                    ? AppThemeData.grey50
                                    : AppThemeData.grey900)),
                    const SizedBox(height: 10),
                    Text(
                        '${'Accept order limits :'.tr} ${subscriptionPlanModel.orderLimit == '-1' ? 'Unlimited'.tr : subscriptionPlanModel.orderLimit ?? '0'}',
                        textAlign: TextAlign.end,
                        maxLines: 2,
                        style: TextStyle(
                            fontSize: 14,
                            fontFamily: AppThemeData.regular,
                            color: themeChange.getThem()
                                ? controller.selectedSubscriptionPlan.value
                                            .id ==
                                        subscriptionPlanModel.id
                                    ? AppThemeData.grey900
                                    : AppThemeData.grey50
                                : controller.selectedSubscriptionPlan.value
                                            .id ==
                                        subscriptionPlanModel.id
                                    ? AppThemeData.grey50
                                    : AppThemeData.grey900)),
                    const SizedBox(height: 20),
                    RoundedButtonFill(
                      radius: 14,
                      textColor: controller.selectedSubscriptionPlan.value.id ==
                              subscriptionPlanModel.id
                          ? AppThemeData.grey200
                          : themeChange.getThem()
                              ? AppThemeData.grey500
                              : AppThemeData.grey500,
                      title: controller.userModel.value.subscriptionPlanId ==
                              subscriptionPlanModel.id
                          ? "Renew".tr
                          : controller.selectedSubscriptionPlan.value.id ==
                                  subscriptionPlanModel.id
                              ? "Active".tr
                              : "Select Plan".tr,
                      color: controller.selectedSubscriptionPlan.value.id ==
                              subscriptionPlanModel.id
                          ? AppThemeData.secondary300
                          : themeChange.getThem()
                              ? AppThemeData.grey800
                              : AppThemeData.grey200,
                      width: 80,
                      height: 5,
                      onPress: onClick,
                    ),
                  ],
                ),
              ),
            ),
          );
        });
  }
}
