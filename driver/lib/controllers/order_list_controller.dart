import 'dart:developer';

import 'package:driver/constant/collection_name.dart';
import 'package:driver/constant/constant.dart';
import 'package:driver/models/order_model.dart';
import 'package:driver/utils/fire_store_utils.dart';
import 'package:get/get.dart';

class OrderListController extends GetxController{

  RxBool isLoading  = true.obs;
  @override
  void onInit() {
    // TODO: implement onInit
    getOrder();
    super.onInit();
  }

  RxList<OrderModel> orderList = <OrderModel>[].obs;


  getOrder() async {
    await FireStoreUtils.fireStore
        .collection(CollectionName.restaurantOrders)
        .where('driverID', isEqualTo: Constant.userModel!.id.toString())
        .orderBy('createdAt', descending: true)
        .get()
        .then((value) {
      for (var element in value.docs) {
        OrderModel dailyEarningModel = OrderModel.fromJson(element.data());
        orderList.add(dailyEarningModel);
      }
    }).catchError((error) {
      log(error.toString());
    });

    isLoading.value = false;
  }

}