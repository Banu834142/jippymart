import 'dart:developer';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:restaurant/constant/constant.dart';
import 'package:restaurant/constant/show_toast_dialog.dart';
import 'package:restaurant/models/advertisement_model.dart';
import 'package:restaurant/utils/fire_store_utils.dart';

class AddAdvertisementController extends GetxController {
  RxBool isLoading = false.obs;
  Rx<TextEditingController> advertisementTitleController =
      TextEditingController().obs;
  Rx<TextEditingController> descriptionController = TextEditingController().obs;
  Rx<TextEditingController> validityController = TextEditingController().obs;
  RxBool isReviewSelected = true.obs;
  RxBool isRatingsSelected = false.obs;
  RxString selectedAdvertisementType = ''.obs;
  RxList<String> advertisementType =
      ['Restaurant Promotion', 'Video Promotion'].obs;

  @override
  void onInit() {
    getArgument();
    super.onInit();
  }

  Rx<AdvertisementModel> advertisementModel = AdvertisementModel().obs;
  RxBool isCopy = false.obs;
  getArgument() {
    dynamic argumentData = Get.arguments;
    if (argumentData != null) {
      advertisementModel.value = argumentData['advsModel'];
      isCopy.value = argumentData['isCopy'] ?? false;
      if (advertisementModel.value.id != null) {
        advertisementTitleController.value.text =
            advertisementModel.value.title ?? '';
        descriptionController.value.text =
            advertisementModel.value.description ?? '';
        validityController.value.text =
            '${DateFormat('MMM d, yyyy').format(advertisementModel.value.startDate!.toDate())} - ${DateFormat('MMM d, yyyy').format(advertisementModel.value.endDate!.toDate())}';
        isReviewSelected.value = advertisementModel.value.showReview ?? false;
        isRatingsSelected.value = advertisementModel.value.showRating ?? false;
        selectedAdvertisementType.value =
            advertisementModel.value.type == 'restaurant_promotion'
                ? 'Restaurant Promotion'
                : 'Video Promotion';
        profileImageString.value = advertisementModel.value.profileImage ?? '';
        coverImageString.value = advertisementModel.value.coverImage ?? '';
        thumbnailFileString.value = advertisementModel.value.video ?? '';
        startValidityDate.value = advertisementModel.value.startDate!.toDate();
        endValidityDate.value = advertisementModel.value.endDate!.toDate();
      }
    }
  }

  final ImagePicker _imageProfilePicker = ImagePicker();
  Rx<XFile> profileImage = XFile('').obs;
  Rx<String> profileImageString = ''.obs;
  Future profilePickFile({required ImageSource source}) async {
    try {
      XFile? image = await _imageProfilePicker.pickImage(source: source);
      if (image == null) return;
      profileImage.value = image;
      Get.back();
    } on PlatformException catch (e) {
      ShowToastDialog.showToast("${"Failed to Pick :".tr} \n $e");
    }
  }

  final ImagePicker _imageCoverPicker = ImagePicker();
  Rx<XFile> coverImage = XFile('').obs;
  Rx<String> coverImageString = ''.obs;
  Future coverPickFile({required ImageSource source}) async {
    try {
      XFile? image = await _imageCoverPicker.pickImage(source: source);
      if (image == null) return;
      coverImage.value = image;
      Get.back();
    } on PlatformException catch (e) {
      ShowToastDialog.showToast("${"Failed to Pick :".tr} \n $e");
    }
  }

  Rx<DateTime> startValidityDate = DateTime.now().obs;
  Rx<DateTime> endValidityDate = DateTime.now().obs;
  void selectValidityDate() {
    validityController.value.text =
        '${DateFormat('MMM d, yyyy').format(startValidityDate.value)} - ${DateFormat('MMM d, yyyy').format(endValidityDate.value)}';
    update(); // Notify GetX listeners
  }

  Rx<XFile> thumbnailFile = XFile('').obs;
  Rx<String> thumbnailFileString = ''.obs;

  Future<AdvertisementModel?> saveAdvDetails() async {
    if (advertisementTitleController.value.text.isEmpty) {
      ShowToastDialog.showToast("Please enter advertisement title".tr);
    } else if (descriptionController.value.text.isEmpty) {
      ShowToastDialog.showToast("Please enter description".tr);
    } else if (selectedAdvertisementType.value.isEmpty) {
      ShowToastDialog.showToast("Please select advertisement type".tr);
    } else if (validityController.value.text.isEmpty) {
      ShowToastDialog.showToast("Please select the validity durations".tr);
    } else if ((profileImage.value.path.isEmpty == true &&
            profileImageString.value.isEmpty == true) &&
        selectedAdvertisementType.value == 'Restaurant Promotion') {
      ShowToastDialog.showToast("Please select the profile image".tr);
    } else if ((coverImage.value.path.isEmpty == true &&
            coverImageString.value.isEmpty == true) &&
        selectedAdvertisementType.value == 'Restaurant Promotion') {
      ShowToastDialog.showToast(
          "Please select the advertisement cover image".tr);
    } else if ((thumbnailFile.value.path.isEmpty == true &&
            thumbnailFileString.value.isEmpty == true) &&
        selectedAdvertisementType.value == 'Video Promotion') {
      ShowToastDialog.showToast("Please select the advertisement video".tr);
    } else {
      ShowToastDialog.showLoader("Please wait...".tr);
      if (thumbnailFile.value.path.isNotEmpty &&
          selectedAdvertisementType.value == 'Video Promotion') {
        bool iswide = await Constant()
            .isVideoLandscape(videoPath: thumbnailFile.value.path);
        if (iswide == false) {
          ShowToastDialog.closeLoader();
          ShowToastDialog.showToast(
              "Please choose a 2:1 ratio for the cover video.".tr);
          return null;
        }
      }

      var uuId = advertisementModel.value.id != null && isCopy.value == false
          ? advertisementModel.value.id
          : Constant.getUuid();
      String urlProfile = '';
      if (selectedAdvertisementType.value == 'Restaurant Promotion') {
        if (profileImage.value.runtimeType == XFile &&
            profileImage.value.path.isNotEmpty) {
          urlProfile = await Constant.uploadUserImageToFireStorage(
            File(profileImage.value.path),
            "advProfileImage/$uuId",
            File(profileImage.value.path).path.split('/').last,
          );
        } else {
          urlProfile = advertisementModel.value.profileImage ?? '';
        }
      }

      String urlCover = '';
      if (selectedAdvertisementType.value == 'Restaurant Promotion') {
        if (coverImage.value.runtimeType == XFile &&
            coverImage.value.path.isNotEmpty) {
          log("Advertisement :: profileImage.value.path :: ${coverImage.value.path}");
          urlCover = await Constant.uploadUserImageToFireStorage(
            File(coverImage.value.path),
            "advCoverImage/$uuId",
            File(coverImage.value.path).path.split('/').last,
          );
        } else {
          urlCover = advertisementModel.value.coverImage ?? '';
        }
      }

      String urlVideo = '';
      if (selectedAdvertisementType.value == 'Video Promotion') {
        if (thumbnailFile.value.runtimeType == XFile &&
            thumbnailFile.value.path.isNotEmpty) {
          urlVideo = await Constant.uploadUserImageToFireStorage(
            File(thumbnailFile.value.path),
            "advVideo/$uuId",
            File(thumbnailFile.value.path).path.split('/').last,
          );
        } else {
          urlVideo = advertisementModel.value.video ?? '';
        }
      }
      AdvertisementModel model = AdvertisementModel();
      model.id = uuId;
      model.vendorId = Constant.userModel?.vendorID;
      model.title = advertisementTitleController.value.text.trim();
      model.description = descriptionController.value.text.trim();
      model.startDate = Timestamp.fromDate(DateTime(
          startValidityDate.value.year,
          startValidityDate.value.month,
          startValidityDate.value.day,
          0,
          0,
          0));
      model.endDate = Timestamp.fromDate(DateTime(
        endValidityDate.value.year,
        endValidityDate.value.month,
        endValidityDate.value.day,
        23,
        59,
        59,
      ));
      model.showRating = isRatingsSelected.value;
      model.showReview = isReviewSelected.value;
      model.type = selectedAdvertisementType.value == 'Video Promotion'
          ? 'video_promotion'
          : 'restaurant_promotion';
      if (model.type == 'restaurant_promotion') {
        model.profileImage = urlProfile;
        model.coverImage = urlCover;
      } else {
        model.video = urlVideo;
      }
      model.status = Constant.adsPending;
      if (advertisementModel.value.id != null && isCopy.value == false) {
        model.isPaused = advertisementModel.value.isPaused;
        model.priority = advertisementModel.value.priority ?? 'N/A';
        model.createdAt = advertisementModel.value.createdAt;
        model.paymentStatus = advertisementModel.value.paymentStatus ?? false;
        model.pauseNote = advertisementModel.value.pauseNote ?? '';
        model.canceledNote = advertisementModel.value.canceledNote ?? '';
      } else {
        model.pauseNote = '';
        model.canceledNote = '';
        model.isPaused = null;
        model.priority = 'N/A';
        model.createdAt = Timestamp.now();
        model.paymentStatus = false;
      }
      model.updatedAt = Timestamp.now();

      AdvertisementModel modeldata =
          await FireStoreUtils.firebaseCreateAdvertisement(model);
      if (modeldata.id != null) {
        profileImage.value = XFile('');
        coverImage.value = XFile('');
        thumbnailFile.value = XFile('');
        ShowToastDialog.closeLoader();
        ShowToastDialog.showToast(
            "Advertisement details saved successfully.".tr);
        return modeldata;
      } else {
        ShowToastDialog.closeLoader();
        return null;
      }
    }
    return null;
  }

  reset() {
    advertisementTitleController.value = TextEditingController();
    descriptionController.value = TextEditingController();
    validityController.value = TextEditingController();
    isReviewSelected.value = true;
    isRatingsSelected.value = false;
    selectedAdvertisementType.value = '';
    profileImage.value = XFile('');
    profileImageString.value = '';
    coverImage.value = XFile('');
    coverImageString.value = '';
    thumbnailFile.value = XFile('');
    thumbnailFileString.value = '';
    startValidityDate.value = DateTime.now();
    endValidityDate.value = DateTime.now();
  }
}
