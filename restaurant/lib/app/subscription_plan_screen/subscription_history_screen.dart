import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:restaurant/constant/constant.dart';
import 'package:restaurant/controller/subscription_history_controller.dart';
import 'package:restaurant/themes/app_them_data.dart';
import 'package:restaurant/utils/dark_theme_provider.dart';
import 'package:restaurant/utils/network_image_widget.dart';

class SubscriptionHistoryScreen extends StatelessWidget {
  const SubscriptionHistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final themeChange = Provider.of<DarkThemeProvider>(context);
    return GetX(
        init: SubscriptionHistoryController(),
        builder: (controller) {
          return Scaffold(
              appBar: AppBar(
                title: Text(
                  "Purchase History".tr,
                  style: TextStyle(
                      color: themeChange.getThem()
                          ? AppThemeData.grey900
                          : AppThemeData.grey50,
                      fontSize: 18,
                      fontFamily: AppThemeData.medium),
                ),
                backgroundColor: AppThemeData.secondary300,
                centerTitle: false,
                titleSpacing: 0,
                iconTheme: IconThemeData(
                    color: themeChange.getThem()
                        ? AppThemeData.grey900
                        : AppThemeData.grey50,
                    size: 20),
              ),
              body: controller.isLoading.value
                  ? Constant.loader()
                  : controller.subscriptionHistoryList.isEmpty
                      ? Constant.showEmptyView(
                          message: "Purchase History Not found".tr)
                      : ListView.builder(
                          shrinkWrap: true,
                          itemCount: controller.subscriptionHistoryList.length,
                          itemBuilder: (context, index) {
                            final subscriptionHistoryModel =
                                controller.subscriptionHistoryList[index];
                            return Container(
                              margin: const EdgeInsets.only(
                                  left: 16, right: 16, top: 20),
                              decoration: ShapeDecoration(
                                color: themeChange.getThem()
                                    ? AppThemeData.grey900
                                    : AppThemeData.grey50,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(16),
                                ),
                                shadows: const [
                                  BoxShadow(
                                    color: Color(0x07000000),
                                    blurRadius: 20,
                                    offset: Offset(0, 0),
                                    spreadRadius: 0,
                                  )
                                ],
                              ),
                              child: Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 16),
                                child: Column(
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 16),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            children: [
                                              NetworkImageWidget(
                                                imageUrl:
                                                    subscriptionHistoryModel
                                                            .subscriptionPlan
                                                            ?.image ??
                                                        '',
                                                fit: BoxFit.cover,
                                                width: 45,
                                                height: 45,
                                              ),
                                              const SizedBox(width: 10),
                                              Text(
                                                subscriptionHistoryModel
                                                        .subscriptionPlan
                                                        ?.name ??
                                                    '',
                                                textAlign: TextAlign.start,
                                                style: TextStyle(
                                                  fontFamily:
                                                      AppThemeData.medium,
                                                  fontSize: 16,
                                                  color: themeChange.getThem()
                                                      ? AppThemeData.grey50
                                                      : AppThemeData.grey900,
                                                ),
                                              ),
                                            ],
                                          ),
                                          if (index == 0)
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              children: [
                                                Icon(
                                                  Icons.check_circle_outlined,
                                                  color:
                                                      AppThemeData.success400,
                                                ),
                                                SizedBox(width: 5),
                                                Text(
                                                  'Active'.tr,
                                                  textAlign: TextAlign.start,
                                                  style: TextStyle(
                                                    fontFamily:
                                                        AppThemeData.medium,
                                                    fontSize: 16,
                                                    color:
                                                        AppThemeData.success400,
                                                  ),
                                                ),
                                              ],
                                            ),
                                        ],
                                      ),
                                    ),
                                    const SizedBox(height: 5),
                                    Divider(
                                        color: themeChange.getThem()
                                            ? AppThemeData.grey800
                                            : AppThemeData.grey100),
                                    const SizedBox(height: 5),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 16),
                                      child: Column(
                                        children: [
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text('Validity'.tr,
                                                  textAlign: TextAlign.end,
                                                  maxLines: 2,
                                                  style: TextStyle(
                                                    fontSize: 14,
                                                    fontFamily:
                                                        AppThemeData.regular,
                                                    color: themeChange.getThem()
                                                        ? AppThemeData.grey200
                                                        : AppThemeData.grey900,
                                                  )),
                                              Text(
                                                  subscriptionHistoryModel
                                                              .subscriptionPlan
                                                              ?.expiryDay ==
                                                          '-1'
                                                      ? "Unlimited".tr
                                                      : '${subscriptionHistoryModel.subscriptionPlan?.expiryDay ?? '0'}  Days',
                                                  textAlign: TextAlign.end,
                                                  maxLines: 2,
                                                  style: TextStyle(
                                                    fontSize: 14,
                                                    fontFamily:
                                                        AppThemeData.medium,
                                                    color: themeChange.getThem()
                                                        ? AppThemeData.grey50
                                                        : AppThemeData.grey800,
                                                  )),
                                            ],
                                          ),
                                          const SizedBox(height: 10),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text('Price'.tr,
                                                  textAlign: TextAlign.end,
                                                  maxLines: 2,
                                                  style: TextStyle(
                                                    fontSize: 14,
                                                    fontFamily:
                                                        AppThemeData.regular,
                                                    color: themeChange.getThem()
                                                        ? AppThemeData.grey200
                                                        : AppThemeData.grey900,
                                                  )),
                                              Text(
                                                  Constant.amountShow(
                                                      amount:
                                                          subscriptionHistoryModel
                                                                  .subscriptionPlan
                                                                  ?.price ??
                                                              '0'),
                                                  textAlign: TextAlign.end,
                                                  maxLines: 2,
                                                  style: TextStyle(
                                                    fontSize: 14,
                                                    fontFamily:
                                                        AppThemeData.medium,
                                                    color: themeChange.getThem()
                                                        ? AppThemeData.grey50
                                                        : AppThemeData.grey800,
                                                  )),
                                            ],
                                          ),
                                          const SizedBox(height: 10),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text('Payment Type'.tr,
                                                  textAlign: TextAlign.end,
                                                  maxLines: 2,
                                                  style: TextStyle(
                                                    fontSize: 14,
                                                    fontFamily:
                                                        AppThemeData.regular,
                                                    color: themeChange.getThem()
                                                        ? AppThemeData.grey200
                                                        : AppThemeData.grey900,
                                                  )),
                                              Text(
                                                  (subscriptionHistoryModel
                                                              .paymentType ??
                                                          '')
                                                      .capitalizeString(),
                                                  textAlign: TextAlign.end,
                                                  maxLines: 2,
                                                  style: TextStyle(
                                                    fontSize: 14,
                                                    fontFamily:
                                                        AppThemeData.medium,
                                                    color: themeChange.getThem()
                                                        ? AppThemeData.grey50
                                                        : AppThemeData.grey800,
                                                  )),
                                            ],
                                          ),
                                          const SizedBox(height: 10),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text('Purchase Date'.tr,
                                                  textAlign: TextAlign.end,
                                                  maxLines: 2,
                                                  style: TextStyle(
                                                    fontSize: 14,
                                                    fontFamily:
                                                        AppThemeData.regular,
                                                    color: themeChange.getThem()
                                                        ? AppThemeData.grey200
                                                        : AppThemeData.grey900,
                                                  )),
                                              Text(
                                                  Constant.timestampToDateTime(
                                                      subscriptionHistoryModel
                                                          .subscriptionPlan!
                                                          .createdAt!),
                                                  textAlign: TextAlign.end,
                                                  maxLines: 2,
                                                  style: TextStyle(
                                                    fontSize: 14,
                                                    fontFamily:
                                                        AppThemeData.medium,
                                                    color: themeChange.getThem()
                                                        ? AppThemeData.grey50
                                                        : AppThemeData.grey800,
                                                  )),
                                            ],
                                          ),
                                          const SizedBox(height: 10),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text('Expiry Date'.tr,
                                                  textAlign: TextAlign.end,
                                                  maxLines: 2,
                                                  style: TextStyle(
                                                    fontSize: 14,
                                                    fontFamily:
                                                        AppThemeData.regular,
                                                    color: themeChange.getThem()
                                                        ? AppThemeData.grey200
                                                        : AppThemeData.grey900,
                                                  )),
                                              Text(
                                                  subscriptionHistoryModel
                                                              .expiryDate ==
                                                          null
                                                      ? "Unlimited".tr
                                                      : Constant
                                                          .timestampToDateTime(
                                                              subscriptionHistoryModel
                                                                  .expiryDate!),
                                                  textAlign: TextAlign.end,
                                                  maxLines: 2,
                                                  style: TextStyle(
                                                    fontSize: 14,
                                                    fontFamily:
                                                        AppThemeData.medium,
                                                    color: themeChange.getThem()
                                                        ? AppThemeData.grey50
                                                        : AppThemeData.grey800,
                                                  )),
                                            ],
                                          ),
                                        ],
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            );
                          }));
        });
  }
}
