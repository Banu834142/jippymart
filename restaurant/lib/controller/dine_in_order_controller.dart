import 'package:get/get.dart';
import 'package:restaurant/constant/constant.dart';
import 'package:restaurant/models/dine_in_booking_model.dart';
import 'package:restaurant/models/user_model.dart';
import 'package:restaurant/models/vendor_model.dart';
import 'package:restaurant/utils/fire_store_utils.dart';

class DineInOrderController extends GetxController {
  RxBool isLoading = true.obs;
  RxInt selectedTabIndex = 0.obs;

  @override
  void onInit() {
    // TODO: implement onInit
    getUserProfile();
    super.onInit();
  }

  Rx<UserModel> userModel = UserModel().obs;
  Rx<VendorModel> vendorModel = VendorModel().obs;

  RxList<DineInBookingModel> featureList = <DineInBookingModel>[].obs;
  RxList<DineInBookingModel> historyList = <DineInBookingModel>[].obs;

  getUserProfile() async {
    await FireStoreUtils.getUserProfile(FireStoreUtils.getCurrentUid()).then(
      (value) {
        if (value != null) {
          userModel.value = value;
        }
      },
    );

    if (Constant.userModel!.vendorID != null &&
        Constant.userModel!.vendorID!.isNotEmpty) {
      await FireStoreUtils.getVendorById(
              Constant.userModel!.vendorID.toString())
          .then(
        (value) {
          if (value != null) {
            vendorModel.value = value;
          }
        },
      );

      await getDineBooking();
    }

    isLoading.value = false;
  }

  getDineBooking() async {
    await FireStoreUtils.getDineInBooking(true).then(
      (value) {
        featureList.value = value;
      },
    );
    await FireStoreUtils.getDineInBooking(false).then(
      (value) {
        historyList.value = value;
      },
    );
  }
}
