
import 'package:driver/models/on_boarding_model.dart';
import 'package:driver/utils/fire_store_utils.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class OnBoardingController extends GetxController {
  var selectedPageIndex = 0.obs;

  bool get isLastPage => selectedPageIndex.value == onBoardingList.length - 1;
  var pageController = PageController();

  @override
  void onInit() {
    getOnBoardingData();
    super.onInit();
  }

  RxBool isLoading = true.obs;
  RxList<OnBoardingModel> onBoardingList = <OnBoardingModel>[].obs;

  getOnBoardingData() async {
    await FireStoreUtils.getOnBoardingList().then((value) {
      onBoardingList.value = value;
    });
    // onBoardingList.add(OnBoardingModel(id: "",title: "Welcome to Foodie Driver App",description: "Join our community of drivers and start earning by delivering delicious meals.",image: "assets/images/image_1.png"));
    // onBoardingList.add(OnBoardingModel(id: "",title: "Manage Your Deliveries",description: "Stay on top of your deliveries with real-time updates and easy navigation.",image: "assets/images/image_2.png"));
    // onBoardingList.add(OnBoardingModel(id: "",title: "Earn More with Incentives",description: "Boost your earnings with our driver incentives and rewards program.",image: "assets/images/image_3.png"));

    isLoading.value = false;
    update();
  }
}
