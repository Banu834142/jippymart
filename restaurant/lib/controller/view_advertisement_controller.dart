import 'package:get/get.dart';
import 'package:restaurant/models/advertisement_model.dart';

class ViewAdvertisementController extends GetxController {
  @override
  void onInit() {
    getArgument();
    // TODO: implement onInit
    super.onInit();
  }

  Rx<AdvertisementModel> advertisementModel = AdvertisementModel().obs;
  getArgument() {
    dynamic argumentData = Get.arguments;
    if (argumentData != null) {
      advertisementModel.value = argumentData['advsModel'];
    }
  }
}
