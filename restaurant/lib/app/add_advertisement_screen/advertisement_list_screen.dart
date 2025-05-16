import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:restaurant/app/add_advertisement_screen/add_advertisement_screen.dart';
import 'package:restaurant/app/add_advertisement_screen/view_advertisement_screen.dart';
import 'package:restaurant/app/chat_screens/admin_inbox_screen.dart';
import 'package:restaurant/constant/constant.dart';
import 'package:restaurant/controller/advertisement_list_controller.dart';
import 'package:restaurant/models/advertisement_model.dart';
import 'package:restaurant/themes/app_them_data.dart';
import 'package:restaurant/themes/round_button_fill.dart';
import 'package:restaurant/utils/dark_theme_provider.dart';
import 'package:restaurant/utils/network_image_widget.dart';
import 'package:restaurant/widget/video_widget.dart';

class AdvertisementListScreen extends StatelessWidget {
  const AdvertisementListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final themeChange = Provider.of<DarkThemeProvider>(context);
    return GetX(
        init: AdvertisementListController(),
        builder: (controller) {
          return DefaultTabController(
            length: 7,
            child: Scaffold(
              appBar: AppBar(
                backgroundColor: AppThemeData.secondary300,
                centerTitle: false,
                titleSpacing: 0,
                iconTheme: IconThemeData(
                    color: themeChange.getThem()
                        ? AppThemeData.grey900
                        : AppThemeData.grey100,
                    size: 20),
                title: Text(
                  "Your Advertisement".tr,
                  style: TextStyle(
                      color: themeChange.getThem()
                          ? AppThemeData.grey900
                          : AppThemeData.grey100,
                      fontSize: 18,
                      fontFamily: AppThemeData.medium),
                ),
                bottom: TabBar(
                  padding: const EdgeInsets.all(0),
                  tabAlignment: TabAlignment.start,
                  isScrollable: true,
                  indicatorSize: TabBarIndicatorSize.tab,
                  onTap: (value) {
                    controller.selectedTabIndex.value = value;
                  },
                  labelStyle: TextStyle(
                      fontFamily: AppThemeData.semiBold,
                      color: themeChange.getThem()
                          ? AppThemeData.grey900
                          : AppThemeData.grey50),
                  labelColor: themeChange.getThem()
                      ? AppThemeData.grey900
                      : AppThemeData.grey50,
                  unselectedLabelStyle: TextStyle(
                      fontFamily: AppThemeData.medium,
                      color: themeChange.getThem()
                          ? AppThemeData.grey900
                          : AppThemeData.grey50),
                  unselectedLabelColor: themeChange.getThem()
                      ? AppThemeData.grey900
                      : AppThemeData.grey50,
                  indicatorColor: themeChange.getThem()
                      ? AppThemeData.grey900
                      : AppThemeData.grey50,
                  dividerColor: Colors.transparent,
                  tabs: [
                    Tab(
                      text: "All".tr,
                    ),
                    Tab(
                      text: "Pending".tr,
                    ),
                    Tab(
                      text: "Approved".tr,
                    ),
                    Tab(
                      text: "Running".tr,
                    ),
                    Tab(
                      text: "Paused".tr,
                    ),
                    Tab(
                      text: "Expired".tr,
                    ),
                    Tab(
                      text: "Cancelled".tr,
                    ),
                  ],
                ),
                actions: [
                  Visibility(
                    visible:
                        Constant.userModel?.subscriptionPlan?.features?.chat !=
                            false,
                    child: InkWell(
                      onTap: () async {
                        Get.to(const AdminInboxScreen());
                      },
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
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
              body: controller.isLoading.value
                  ? Constant.loader()
                  : Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 10),
                      child: TabBarView(children: [
                        controller.allAdvertisementList.isEmpty
                            ? Constant.showEmptyView(
                                message: "Advertisement not found.".tr)
                            : RefreshIndicator(
                                onRefresh: () => controller.getAdvertisement(),
                                child: ListView.builder(
                                  itemCount:
                                      controller.allAdvertisementList.length,
                                  shrinkWrap: true,
                                  padding: EdgeInsets.zero,
                                  itemBuilder: (context, index) {
                                    return AdvertisementCard(
                                        index: index,
                                        controller: controller,
                                        model: controller
                                            .allAdvertisementList[index]);
                                  },
                                ),
                              ),
                        controller.pendingAdvertisementList.isEmpty
                            ? Constant.showEmptyView(
                                message: "Advertisement not found.".tr)
                            : RefreshIndicator(
                                onRefresh: () => controller.getAdvertisement(),
                                child: ListView.builder(
                                  itemCount: controller
                                      .pendingAdvertisementList.length,
                                  shrinkWrap: true,
                                  padding: EdgeInsets.zero,
                                  itemBuilder: (context, index) {
                                    return AdvertisementCard(
                                        index: index,
                                        controller: controller,
                                        model: controller
                                            .pendingAdvertisementList[index]);
                                  },
                                ),
                              ),
                        controller.appovedAdvertisementList.isEmpty
                            ? Constant.showEmptyView(
                                message: "Advertisement not found.".tr)
                            : RefreshIndicator(
                                onRefresh: () => controller.getAdvertisement(),
                                child: ListView.builder(
                                  itemCount: controller
                                      .appovedAdvertisementList.length,
                                  shrinkWrap: true,
                                  padding: EdgeInsets.zero,
                                  itemBuilder: (context, index) {
                                    return AdvertisementCard(
                                        index: index,
                                        controller: controller,
                                        model: controller
                                            .appovedAdvertisementList[index]);
                                  },
                                ),
                              ),
                        controller.runningAdvertisementList.isEmpty
                            ? Constant.showEmptyView(
                                message: "Advertisement not found.".tr)
                            : RefreshIndicator(
                                onRefresh: () => controller.getAdvertisement(),
                                child: ListView.builder(
                                  itemCount: controller
                                      .runningAdvertisementList.length,
                                  shrinkWrap: true,
                                  padding: EdgeInsets.zero,
                                  itemBuilder: (context, index) {
                                    return AdvertisementCard(
                                        index: index,
                                        controller: controller,
                                        model: controller
                                            .runningAdvertisementList[index]);
                                  },
                                ),
                              ),
                        controller.pausedAdvertisementList.isEmpty
                            ? Constant.showEmptyView(
                                message: "Advertisement not found.".tr)
                            : RefreshIndicator(
                                onRefresh: () => controller.getAdvertisement(),
                                child: ListView.builder(
                                  itemCount:
                                      controller.pausedAdvertisementList.length,
                                  shrinkWrap: true,
                                  padding: EdgeInsets.zero,
                                  itemBuilder: (context, index) {
                                    return AdvertisementCard(
                                        index: index,
                                        controller: controller,
                                        model: controller
                                            .pausedAdvertisementList[index]);
                                  },
                                ),
                              ),
                        controller.expiredAdvertisementList.isEmpty
                            ? Constant.showEmptyView(
                                message: "Advertisement not found.".tr)
                            : RefreshIndicator(
                                onRefresh: () => controller.getAdvertisement(),
                                child: ListView.builder(
                                  itemCount: controller
                                      .expiredAdvertisementList.length,
                                  shrinkWrap: true,
                                  padding: EdgeInsets.zero,
                                  itemBuilder: (context, index) {
                                    return AdvertisementCard(
                                        index: index,
                                        controller: controller,
                                        model: controller
                                            .expiredAdvertisementList[index]);
                                  },
                                ),
                              ),
                        controller.cancelAdvertisementList.isEmpty
                            ? Constant.showEmptyView(
                                message: "Advertisement not found.".tr)
                            : RefreshIndicator(
                                onRefresh: () => controller.getAdvertisement(),
                                child: ListView.builder(
                                  itemCount:
                                      controller.cancelAdvertisementList.length,
                                  shrinkWrap: true,
                                  padding: EdgeInsets.zero,
                                  itemBuilder: (context, index) {
                                    return AdvertisementCard(
                                        index: index,
                                        controller: controller,
                                        model: controller
                                            .cancelAdvertisementList[index]);
                                  },
                                ),
                              )
                      ])),
              bottomNavigationBar: Container(
                color: Colors.transparent,
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
                child: RoundedButtonFill(
                  radius: 12,
                  isRight: false,
                  icon: Icon(
                    Icons.add,
                    color: themeChange.getThem()
                        ? AppThemeData.grey900
                        : AppThemeData.grey50,
                  ),
                  title: "New Advertisement".tr,
                  height: 5.5,
                  color: themeChange.getThem()
                      ? AppThemeData.secondary300
                      : AppThemeData.secondary300,
                  textColor: themeChange.getThem()
                      ? AppThemeData.grey900
                      : AppThemeData.grey50,
                  fontSizes: 16,
                  onPress: () {
                    Get.to(AddAdvertisementScreen())?.then((value) async {
                      if (value != null) {
                        await controller.getAdvertisement();
                        if (value == 'Save') {
                          showAdSuccessBottomSheet(context);
                        }
                      }
                    });
                  },
                ),
              ),
            ),
          );
        });
  }
}

void showAdSuccessBottomSheet(BuildContext context) {
  showModalBottomSheet(
    context: context,
    isDismissible: false,
    isScrollControlled: true,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
    ),
    builder: (_) {
      final themeChange = Provider.of<DarkThemeProvider>(context);
      return Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(height: 16),
            Image.asset(
              'assets/images/ads_image.png',
              height: 100,
            ),
            SizedBox(height: 16),
            Text('Ad Created Successfully!'.tr,
                style: TextStyle(
                    color: themeChange.getThem()
                        ? AppThemeData.grey50
                        : AppThemeData.grey900,
                    fontFamily: AppThemeData.semiBold,
                    fontSize: 16)),
            SizedBox(height: 12),
            Text(
              '${"Congratulations on creating your ad! It\'s now awaiting approval.To finalize the process & make payment arrangements, please contact our Admin.".tr}\n${Constant.adminEmail}',
              textAlign: TextAlign.center,
              style: TextStyle(
                  color: themeChange.getThem()
                      ? AppThemeData.grey50
                      : AppThemeData.grey900,
                  fontFamily: AppThemeData.medium,
                  fontSize: 14),
            ),
            SizedBox(height: 24),
            RoundedButtonFill(
              radius: 6,
              height: MediaQuery.of(context).size.width * 0.012,
              width: MediaQuery.of(context).size.width * 0.07,
              title: "Okay".tr,
              color: AppThemeData.primary300,
              textColor: AppThemeData.grey50,
              onPress: () {
                Get.back();
              },
            )
          ],
        ),
      );
    },
  );
}

class AdvertisementCard extends StatelessWidget {
  final int index;
  final AdvertisementModel model;
  final AdvertisementListController controller;

  const AdvertisementCard(
      {super.key,
      required this.index,
      required this.model,
      required this.controller});

  @override
  Widget build(BuildContext context) {
    final themeChange = Provider.of<DarkThemeProvider>(context);
    return InkWell(
      onTap: () {
        Get.to(ViewAdvertisementScreen(), arguments: {'advsModel': model})
            ?.then((value) async {
          if (value == true) {
            await controller.getAdvertisement();
            controller.update();
          }
        });
      },
      child: Card(
        color:
            themeChange.getThem() ? AppThemeData.info600 : AppThemeData.surface,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        elevation: themeChange.getThem() ? 6 : 2,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                model.type == 'restaurant_promotion'
                    ? ClipRRect(
                        borderRadius:
                            BorderRadius.vertical(top: Radius.circular(16)),
                        child: NetworkImageWidget(
                          imageUrl: model.coverImage ?? '',
                          height: 150,
                          width: double.infinity,
                          fit: BoxFit.cover,
                        ),
                      )
                    : VideoAdvWidget(
                        url: model.video ?? '',
                        height: 150,
                        width: double.infinity,
                      ),
                Positioned(
                  top: 8,
                  right: 8,
                  child: PopupMenuButton<String>(
                    icon: Icon(Icons.more_vert, color: AppThemeData.grey50),
                    color: themeChange.getThem()
                        ? AppThemeData.grey900
                        : AppThemeData.grey50,
                    onSelected: (value) {
                      // Handle menu selection
                    },
                    itemBuilder: (context) => [
                      if ((model.status == Constant.adsApproved ||
                              model.status != Constant.adsUpdated) &&
                          !model.endDate!.toDate().isBefore(DateTime.now()))
                        model.isPaused == true
                            ? PopupMenuItem(
                                onTap: () {
                                  controller.resumeAdvertisement(model, index,
                                      context, themeChange.getThem());
                                },
                                value: 'resume',
                                child: Row(
                                  children: [
                                    Icon(Icons.play_circle, size: 20),
                                    SizedBox(width: 8),
                                    Text(
                                      'Resume Ads'.tr,
                                      style: TextStyle(
                                          fontFamily: AppThemeData.medium),
                                    )
                                  ],
                                ),
                              )
                            : PopupMenuItem(
                                onTap: () {
                                  controller.pauseNote.value.text = '';
                                  controller.pauseAdvertisement(model, index,
                                      context, themeChange.getThem());
                                },
                                value: 'pause',
                                child: Row(
                                  children: [
                                    Icon(Icons.pause_circle, size: 20),
                                    SizedBox(width: 8),
                                    Text(
                                      'Pause Ads'.tr,
                                      style: TextStyle(
                                          fontFamily: AppThemeData.medium),
                                    )
                                  ],
                                ),
                              ),
                      PopupMenuItem(
                        onTap: () {
                          Get.to(AddAdvertisementScreen(), arguments: {
                            'advsModel': model,
                            'isCopy': true
                          })?.then((v) {
                            if (v == true) {
                              controller.getAdvertisement();
                            }
                          });
                        },
                        value: 'copy',
                        child: Row(
                          children: [
                            Icon(Icons.file_copy_rounded, size: 20),
                            SizedBox(width: 8),
                            Text(
                              'Copy Ads'.tr,
                              style: TextStyle(fontFamily: AppThemeData.medium),
                            )
                          ],
                        ),
                      ),
                      PopupMenuItem(
                        onTap: () async {
                          controller.deleteAdvertisement(
                              model, index, context, themeChange.getThem());
                        },
                        value: 'delete',
                        child: Row(
                          children: [
                            Icon(Icons.delete, size: 20),
                            SizedBox(width: 8),
                            Text(
                              'Delete Ads'.tr,
                              style: TextStyle(fontFamily: AppThemeData.medium),
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                if (model.type != 'video_promotion')
                  Positioned(
                    bottom: 8,
                    right: 8,
                    child: Container(
                      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 6),
                      decoration: BoxDecoration(
                        color: AppThemeData.primary50,
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: Row(
                        children: [
                          model.showRating == true
                              ? Icon(Icons.star,
                                  color: AppThemeData.outrageous300, size: 16)
                              : SizedBox(),
                          SizedBox(width: 4),
                          Text(
                            '${model.showRating == true ? Constant.calculateReview(reviewCount: controller.venderModel.value.reviewsCount?.toStringAsFixed(0), reviewSum: controller.venderModel.value.reviewsSum.toString()) : ""}${model.showRating == true && model.showReview == true ? ' ' : ''}${model.showReview == true ? '(${controller.venderModel.value.reviewsCount?.toStringAsFixed(0)})' : ''}',
                            style: TextStyle(
                                color: AppThemeData.outrageous300,
                                fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ),
                  ),
              ],
            ),
            Padding(
              padding: EdgeInsets.all(12),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (model.type == 'restaurant_promotion')
                    ClipRRect(
                      borderRadius: BorderRadius.circular(30),
                      child: NetworkImageWidget(
                        imageUrl: model.profileImage ?? '',
                        height: 50,
                        width: 50,
                        fit: BoxFit.cover,
                      ),
                    ),
                  SizedBox(width: 8),
                  Expanded(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                model.title ?? '',
                                style: TextStyle(
                                  color: themeChange.getThem()
                                      ? AppThemeData.grey50
                                      : AppThemeData.grey900,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                              Text(
                                model.description ?? '',
                                style: TextStyle(
                                    fontSize: 14,
                                    fontFamily: AppThemeData.medium,
                                    color: themeChange.getThem()
                                        ? AppThemeData.grey400
                                        : AppThemeData.grey600),
                                overflow: TextOverflow.ellipsis,
                                maxLines: 2,
                              ),
                            ],
                          ),
                        ),
                        model.type == 'restaurant_promotion'
                            ? SvgPicture.asset(
                                "assets/icons/ic_like.svg",
                                colorFilter: ColorFilter.mode(
                                    themeChange.getThem()
                                        ? AppThemeData.grey400
                                        : AppThemeData.grey600,
                                    BlendMode.srcIn),
                              )
                            : Container(
                                decoration: ShapeDecoration(
                                  color: themeChange.getThem()
                                      ? AppThemeData.primary600
                                      : AppThemeData.primary50,
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(5)),
                                ),
                                child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 10, vertical: 4),
                                    child: Icon(Icons.arrow_forward,
                                        size: 20,
                                        color: AppThemeData.primary300))),
                      ],
                    ),
                  ),
                  // IconButton(
                  //   icon: Icon(Icons.favorite_border,
                  //       color: themeChange.getThem()
                  //           ? AppThemeData.grey300
                  //           : AppThemeData.grey400),
                  //   onPressed: () {},
                  // ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
