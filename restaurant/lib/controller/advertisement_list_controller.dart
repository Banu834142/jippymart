import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:restaurant/constant/constant.dart';
import 'package:restaurant/constant/show_toast_dialog.dart';
import 'package:restaurant/models/advertisement_model.dart';
import 'package:restaurant/models/vendor_model.dart';
import 'package:restaurant/themes/app_them_data.dart';
import 'package:restaurant/themes/custom_dialog_box.dart';
import 'package:restaurant/themes/text_field_widget.dart';
import 'package:restaurant/utils/fire_store_utils.dart';

class AdvertisementListController extends GetxController {
  @override
  void onInit() {
    // TODO: implement onInit
    initCall();
    super.onInit();
  }

  initCall() async {
    await getVendor();
    getAdvertisement();
  }

  RxBool isLoading = true.obs;
  RxList<AdvertisementModel> advertisementList = <AdvertisementModel>[].obs;
  RxList<AdvertisementModel> allAdvertisementList = <AdvertisementModel>[].obs;
  RxList<AdvertisementModel> pendingAdvertisementList =
      <AdvertisementModel>[].obs;
  RxList<AdvertisementModel> runningAdvertisementList =
      <AdvertisementModel>[].obs;
  RxList<AdvertisementModel> appovedAdvertisementList =
      <AdvertisementModel>[].obs;
  RxList<AdvertisementModel> pausedAdvertisementList =
      <AdvertisementModel>[].obs;
  RxList<AdvertisementModel> expiredAdvertisementList =
      <AdvertisementModel>[].obs;
  RxList<AdvertisementModel> cancelAdvertisementList =
      <AdvertisementModel>[].obs;
  RxInt selectedTabIndex = 0.obs;

  RxInt contr = 0.obs;
  getAdvertisement() async {
    await FireStoreUtils.getAdvertisement().then(
      (value) {
        if (value != null) {
          advertisementList.value = value;
          allAdvertisementList.value = value.toList();
          pendingAdvertisementList.value = advertisementList
              .where((item) =>
                  (item.status == Constant.adsPending ||
                      item.status == Constant.adsUpdated) &&
                  item.isPaused != true &&
                  item.endDate!.toDate().isAfter(DateTime.now()))
              .toList();
          runningAdvertisementList.value = advertisementList
              .where((item) =>
                  (item.status == Constant.adsApproved) &&
                  item.isPaused != true &&
                  item.paymentStatus == true &&
                  item.endDate!.toDate().isAfter(DateTime.now()) &&
                  item.startDate!.toDate().isBefore(DateTime.now()))
              .toList();
          appovedAdvertisementList.value = advertisementList
              .where((item) =>
                  (item.status == Constant.adsApproved) &&
                  item.isPaused != true &&
                  (item.paymentStatus == false ||
                      (item.paymentStatus == true &&
                          item.startDate!.toDate().isAfter(DateTime.now()))) &&
                  !item.endDate!.toDate().isBefore(DateTime.now()))
              .toList();
          pausedAdvertisementList.value = advertisementList
              .where((item) =>
                  (item.isPaused == true &&
                      item.status != Constant.adsCancel) &&
                  !item.endDate!.toDate().isBefore(DateTime.now()))
              .toList();
          expiredAdvertisementList.value = advertisementList
              .where((item) =>
                  item.endDate != null &&
                  item.endDate!.toDate().isBefore(DateTime.now()))
              .toList();
          cancelAdvertisementList.value = advertisementList
              .where((item) => item.status == Constant.adsCancel)
              .toList();
        }
      },
    );
    isLoading.value = false;
  }

  Rx<VendorModel> venderModel = VendorModel().obs;
  getVendor() async {
    await FireStoreUtils.getVendorById(Constant.userModel?.vendorID ?? '')
        .then((value) {
      if (value?.id?.isNotEmpty == true) {
        venderModel.value = value!;
      }
    });
  }

  void removeAdvertisement(AdvertisementModel model) async {
    ShowToastDialog.showLoader("Please wait".tr);
    await FireStoreUtils.removeAdvertisement(model);
    if (model.status == 'pending' || model.status == 'updated') {
      pendingAdvertisementList.remove(model);
    } else if (model.status == 'approved') {
      runningAdvertisementList.remove(model);
    } else if (model.endDate!.toDate().isBefore(DateTime.now())) {
      expiredAdvertisementList.remove(model);
    }
    update();
    ShowToastDialog.closeLoader();
  }

  Rx<TextEditingController> pauseNote = TextEditingController().obs;
  void pauseAdvertisement(AdvertisementModel model, int index,
      BuildContext context, bool isDarkModel) async {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return CustomDialogBox(
            title: "Are you sure you want to Pause the request?".tr,
            descriptions:
                "This ad will be pause and not show in the app or web".tr,
            positiveString: "Yes".tr,
            negativeString: "Not Now".tr,
            widget: Column(
              children: [
                TextFieldWidget(
                  controller: pauseNote.value,
                  hintText: 'Pause Note..'.tr,
                  maxLine: 3,
                ),
              ],
            ),
            positiveClick: () async {
              if (pauseNote.value.text.isEmpty) {
                ShowToastDialog.showLoader("Please enter pause note".tr);
              } else {
                Get.back();
                ShowToastDialog.showLoader("Please wait".tr);
                model.isPaused = true;
                model.pauseNote = pauseNote.value.text;
                await FireStoreUtils.pauseAndResumeAdvertisement(model);
                await getAdvertisement();
                update();
                ShowToastDialog.closeLoader();
              }
            },
            negativeClick: () {
              Get.back();
            },
            img: SvgPicture.asset(
              'assets/icons/ic_alert.svg',
              width: 40,
              height: 40,
              color: isDarkModel ? AppThemeData.grey100 : AppThemeData.grey800,
            ),
          );
        });
  }

  void resumeAdvertisement(AdvertisementModel model, int index,
      BuildContext context, bool isDarkModel) async {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return CustomDialogBox(
            title: "Are you sure you want to resume the request?".tr,
            descriptions:
                "This ad will be run again and will show in the app or web".tr,
            positiveString: "Yes".tr,
            negativeString: "Not Now".tr,
            positiveClick: () async {
              Get.back();
              ShowToastDialog.showLoader("Please wait".tr);
              model.isPaused = false;
              model.pauseNote = '';
              await FireStoreUtils.pauseAndResumeAdvertisement(model);
              await getAdvertisement();
              update();
              ShowToastDialog.closeLoader();
            },
            negativeClick: () {
              Get.back();
            },
            img: SvgPicture.asset(
              'assets/icons/ic_alert.svg',
              width: 40,
              height: 40,
              color: isDarkModel ? AppThemeData.grey100 : AppThemeData.grey800,
            ),
          );
        });
  }

  void deleteAdvertisement(AdvertisementModel model, int index,
      BuildContext context, bool isDarkModel) async {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return CustomDialogBox(
            title: "Confirm ad deletion".tr,
            descriptions:
                "Deleting this ad will remove it permanently. Are you sure you want to proceed?"
                    .tr,
            positiveString: "Yes".tr,
            negativeString: "Not Now".tr,
            positiveClick: () async {
              Get.back();
              ShowToastDialog.showLoader("Please wait".tr);
              removeAdvertisement(model);
              await getAdvertisement();
              update();
              ShowToastDialog.closeLoader();
            },
            negativeClick: () {
              Get.back();
            },
            img: SvgPicture.asset(
              'assets/icons/ic_delete.svg',
              width: 40,
              height: 40,
              color: isDarkModel ? AppThemeData.grey100 : AppThemeData.grey800,
            ),
          );
        });
  }
}
