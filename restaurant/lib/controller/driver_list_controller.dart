import 'package:get/get.dart';
import 'package:restaurant/models/user_model.dart';
import 'package:restaurant/utils/fire_store_utils.dart';

class DriverListController extends GetxController {
  @override
  void onInit() {
    // TODO: implement onInit
    getAllDriverList();
    super.onInit();
  }

  RxBool isLoading = true.obs;
  RxList<UserModel> driverUserList = <UserModel>[].obs;

  getAllDriverList() async {
    await FireStoreUtils.getAllDrivers().then(
      (value) {
        if (value.isNotEmpty == true) {
          driverUserList.value = value;
        }
      },
    );
    isLoading.value = false;
  }

  updateDriver(UserModel user) async {
    await FireStoreUtils.updateDriverUser(user);
  }
}
