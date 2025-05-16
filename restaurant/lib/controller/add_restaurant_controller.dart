import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:restaurant/constant/constant.dart';
import 'package:restaurant/constant/show_toast_dialog.dart';
import 'package:restaurant/models/user_model.dart';
import 'package:restaurant/models/vendor_category_model.dart';
import 'package:restaurant/models/vendor_model.dart';
import 'package:restaurant/models/zone_model.dart';
import 'package:restaurant/utils/fire_store_utils.dart';
import 'package:restaurant/widget/geoflutterfire/src/geoflutterfire.dart';

class AddRestaurantController extends GetxController {
  RxBool isLoading = true.obs;
  RxBool isAddressEnable = false.obs;
  RxBool isEnableDeliverySettings = true.obs;
  final myKey1 = GlobalKey<DropdownSearchState<VendorCategoryModel>>();

  Rx<TextEditingController> restaurantNameController =
      TextEditingController().obs;
  Rx<TextEditingController> restaurantDescriptionController =
      TextEditingController().obs;
  Rx<TextEditingController> mobileNumberController =
      TextEditingController().obs;
  Rx<TextEditingController> countryCodeEditingController =
      TextEditingController().obs;
  Rx<TextEditingController> addressController = TextEditingController().obs;

  Rx<TextEditingController> chargePerKmController = TextEditingController().obs;
  Rx<TextEditingController> minDeliveryChargesController =
      TextEditingController().obs;
  Rx<TextEditingController> minDeliveryChargesWithinKMController =
      TextEditingController().obs;

  LatLng? selectedLocation;

  RxList images = <dynamic>[].obs;

  RxList<VendorCategoryModel> vendorCategoryList = <VendorCategoryModel>[].obs;
  RxList<ZoneModel> zoneList = <ZoneModel>[].obs;
  Rx<ZoneModel> selectedZone = ZoneModel().obs;

  // Rx<VendorCategoryModel> selectedCategory = VendorCategoryModel().obs;
  RxList selectedService = [].obs;

  RxList<VendorCategoryModel> selectedCategories = <VendorCategoryModel>[].obs;

  @override
  void onInit() {
    // TODO: implement onInit
    getRestaurant();
    super.onInit();
  }

  Rx<UserModel> userModel = UserModel().obs;
  Rx<VendorModel> vendorModel = VendorModel().obs;
  Rx<DeliveryCharge> deliveryChargeModel = DeliveryCharge().obs;
  RxBool isSelfDelivery = false.obs;

  getRestaurant() async {
    try {
      await FireStoreUtils.getUserProfile(FireStoreUtils.getCurrentUid())
          .then((model) {
        if (model != null) {
          userModel.value = model;
        }
      });

      await FireStoreUtils.getVendorCategoryById().then((value) {
        if (value != null) {
          vendorCategoryList.value = value;
        }
      });

      await FireStoreUtils.getZone().then((value) {
        if (value != null) {
          zoneList.value = value;
        }
      });
      if (Constant.userModel?.vendorID != null &&
          Constant.userModel?.vendorID?.isNotEmpty == true) {
        await FireStoreUtils.getVendorById(
                Constant.userModel!.vendorID.toString())
            .then(
          (value) {
            if (value != null) {
              vendorModel.value = value;

              restaurantNameController.value.text =
                  vendorModel.value.title.toString();
              restaurantDescriptionController.value.text =
                  vendorModel.value.description.toString();
              mobileNumberController.value.text =
                  vendorModel.value.phonenumber.toString();
              addressController.value.text =
                  vendorModel.value.location.toString();
              isSelfDelivery.value = vendorModel.value.isSelfDelivery ?? false;
              if (addressController.value.text.isNotEmpty) {
                isAddressEnable.value = true;
              }
              selectedLocation = LatLng(
                  vendorModel.value.latitude!, vendorModel.value.longitude!);
              for (var element in vendorModel.value.photos!) {
                images.add(element);
              }

              for (var element in zoneList) {
                if (element.id == vendorModel.value.zoneId) {
                  selectedZone.value = element;
                }
              }

              if (vendorModel.value.categoryID!.isNotEmpty) {
                selectedCategories.value = vendorCategoryList
                    .where((category) =>
                        vendorModel.value.categoryID!.contains(category.id))
                    .toList();
              }

              vendorModel.value.filters!.toJson().forEach((key, value) {
                if (value.contains("Yes")) {
                  selectedService.add(key);
                }
              });
            }
          },
        );
      }

      await FireStoreUtils.getDelivery().then((value) {
        if (value != null) {
          deliveryChargeModel.value = value;
          isEnableDeliverySettings.value =
              deliveryChargeModel.value.vendorCanModify ?? false;
          if (value.vendorCanModify == true) {
            if (vendorModel.value.deliveryCharge != null) {
              chargePerKmController.value.text = vendorModel
                  .value.deliveryCharge!.deliveryChargesPerKm
                  .toString();
              minDeliveryChargesController.value.text = vendorModel
                  .value.deliveryCharge!.minimumDeliveryCharges
                  .toString();
              minDeliveryChargesWithinKMController.value.text = vendorModel
                  .value.deliveryCharge!.minimumDeliveryChargesWithinKm
                  .toString();
            }
          } else {
            chargePerKmController.value.text =
                deliveryChargeModel.value.deliveryChargesPerKm.toString();
            minDeliveryChargesController.value.text =
                deliveryChargeModel.value.minimumDeliveryCharges.toString();
            minDeliveryChargesWithinKMController.value.text =
                deliveryChargeModel.value.minimumDeliveryChargesWithinKm
                    .toString();
          }
        }
      });
    } catch (e) {
      print(e);
    }

    isLoading.value = false;
  }

  saveDetails() async {
    if (restaurantNameController.value.text.isEmpty) {
      ShowToastDialog.showToast("Please enter restaurant name".tr);
    } else if (restaurantDescriptionController.value.text.isEmpty) {
      ShowToastDialog.showToast("Please enter Description".tr);
    } else if (mobileNumberController.value.text.isEmpty) {
      ShowToastDialog.showToast("Please enter phone number".tr);
    } else if (addressController.value.text.isEmpty) {
      ShowToastDialog.showToast("Please enter address".tr);
    } else if (selectedZone.value.id == null) {
      ShowToastDialog.showToast("Please select zone".tr);
    } else if (selectedCategories.isEmpty) {
      ShowToastDialog.showToast("Please select category".tr);
    } else {
      if (Constant.isPointInPolygon(
          selectedLocation!, selectedZone.value.area!)) {
        ShowToastDialog.showLoader("Please wait".tr);
        filter();
        DeliveryCharge deliveryChargeModel = DeliveryCharge(
            vendorCanModify: true,
            deliveryChargesPerKm: num.parse(chargePerKmController.value.text),
            minimumDeliveryCharges:
                num.parse(minDeliveryChargesController.value.text),
            minimumDeliveryChargesWithinKm:
                num.parse(minDeliveryChargesWithinKMController.value.text));

        if (vendorModel.value.id == null) {
          vendorModel.value = VendorModel();
          vendorModel.value.createdAt = Timestamp.now();
        }
        for (int i = 0; i < images.length; i++) {
          if (images[i].runtimeType == XFile) {
            String url = await Constant.uploadUserImageToFireStorage(
              File(images[i].path),
              "profileImage/${FireStoreUtils.getCurrentUid()}",
              File(images[i].path).path.split('/').last,
            );
            images.removeAt(i);
            images.insert(i, url);
          }
        }

        vendorModel.value.id = Constant.userModel?.vendorID;
        vendorModel.value.author = Constant.userModel!.id;
        vendorModel.value.authorName = Constant.userModel!.firstName;
        vendorModel.value.authorProfilePic =
            Constant.userModel!.profilePictureURL;

        vendorModel.value.categoryID =
            selectedCategories.map((e) => e.id ?? '').toList();
        vendorModel.value.categoryTitle =
            selectedCategories.map((e) => e.title ?? '').toList();
        vendorModel.value.g = G(
            geohash: Geoflutterfire()
                .point(
                    latitude: selectedLocation!.latitude,
                    longitude: selectedLocation!.longitude)
                .hash,
            geopoint: GeoPoint(
                selectedLocation!.latitude, selectedLocation!.longitude));
        vendorModel.value.description =
            restaurantDescriptionController.value.text;
        vendorModel.value.phonenumber = mobileNumberController.value.text;
        vendorModel.value.filters = Filters.fromJson(filters);
        vendorModel.value.location = addressController.value.text;
        vendorModel.value.latitude = selectedLocation!.latitude;
        vendorModel.value.longitude = selectedLocation!.longitude;
        vendorModel.value.photos = images;
        if (images.isNotEmpty) {
          vendorModel.value.photo = images.first;
        } else {
          vendorModel.value.photo = null;
        }

        vendorModel.value.deliveryCharge = deliveryChargeModel;
        vendorModel.value.title = restaurantNameController.value.text;
        vendorModel.value.zoneId = selectedZone.value.id;
        vendorModel.value.isSelfDelivery = isSelfDelivery.value;

        if (Constant.adminCommission!.isEnabled == true ||
            Constant.isSubscriptionModelApplied == true) {
          vendorModel.value.subscriptionPlanId =
              userModel.value.subscriptionPlanId;
          vendorModel.value.subscriptionPlan = userModel.value.subscriptionPlan;
          vendorModel.value.subscriptionExpiryDate =
              userModel.value.subscriptionExpiryDate;
          vendorModel.value.subscriptionTotalOrders =
              userModel.value.subscriptionPlan?.orderLimit;
        }

        if (Constant.userModel!.vendorID!.isNotEmpty) {
          await FireStoreUtils.updateVendor(vendorModel.value).then((value) {
            ShowToastDialog.closeLoader();
            ShowToastDialog.showToast(
                "Restaurant details save successfully".tr);
          });
        } else {
          vendorModel.value.adminCommission = Constant.adminCommission;
          vendorModel.value.workingHours = [
            WorkingHours(
                day: 'Monday'.tr,
                timeslot: [Timeslot(from: '00:00', to: '23:59')]),
            WorkingHours(
                day: 'Tuesday'.tr,
                timeslot: [Timeslot(from: '00:00', to: '23:59')]),
            WorkingHours(
                day: 'Wednesday'.tr,
                timeslot: [Timeslot(from: '00:00', to: '23:59')]),
            WorkingHours(
                day: 'Thursday'.tr,
                timeslot: [Timeslot(from: '00:00', to: '23:59')]),
            WorkingHours(
                day: 'Friday'.tr,
                timeslot: [Timeslot(from: '00:00', to: '23:59')]),
            WorkingHours(
                day: 'Saturday'.tr,
                timeslot: [Timeslot(from: '00:00', to: '23:59')]),
            WorkingHours(
                day: 'Sunday'.tr,
                timeslot: [Timeslot(from: '00:00', to: '23:59')])
          ];

          await FireStoreUtils.firebaseCreateNewVendor(vendorModel.value)
              .then((value) {
            ShowToastDialog.closeLoader();
            ShowToastDialog.showToast(
                "Restaurant details save successfully".tr);
          });
        }
      } else {
        ShowToastDialog.showToast(
            "The chosen area is outside the selected zone.".tr);
      }
    }
  }

  Map<String, dynamic> filters = {};

  filter() {
    if (selectedService.contains('Good for Breakfast')) {
      filters['Good for Breakfast'] = 'Yes';
    } else {
      filters['Good for Breakfast'] = 'No';
    }
    if (selectedService.contains('Good for Lunch')) {
      filters['Good for Lunch'] = 'Yes';
    } else {
      filters['Good for Lunch'] = 'No';
    }

    if (selectedService.contains('Good for Dinner')) {
      filters['Good for Dinner'] = 'Yes';
    } else {
      filters['Good for Dinner'] = 'No';
    }

    if (selectedService.contains('Takes Reservations')) {
      filters['Takes Reservations'] = 'Yes';
    } else {
      filters['Takes Reservations'] = 'No';
    }

    if (selectedService.contains('Vegetarian Friendly')) {
      filters['Vegetarian Friendly'] = 'Yes';
    } else {
      filters['Vegetarian Friendly'] = 'No';
    }

    if (selectedService.contains('Live Music')) {
      filters['Live Music'] = 'Yes';
    } else {
      filters['Live Music'] = 'No';
    }

    if (selectedService.contains('Outdoor Seating')) {
      filters['Outdoor Seating'] = 'Yes';
    } else {
      filters['Outdoor Seating'] = 'No';
    }

    if (selectedService.contains('Free Wi-Fi')) {
      filters['Free Wi-Fi'] = 'Yes';
    } else {
      filters['Free Wi-Fi'] = 'No';
    }
  }

  final ImagePicker _imagePicker = ImagePicker();

  Future pickFile({required ImageSource source}) async {
    try {
      XFile? image = await _imagePicker.pickImage(source: source);
      if (image == null) return;
      images.add(image);
      Get.back();
    } on PlatformException catch (e) {
      ShowToastDialog.showToast("${"Failed to Pick :".tr} \n $e");
    }
  }
}
