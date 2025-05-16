import 'package:driver/constant/constant.dart';
import 'package:driver/constant/send_notification.dart';
import 'package:driver/constant/show_toast_dialog.dart';
import 'package:driver/models/order_model.dart';
import 'package:driver/services/audio_player_service.dart';
import 'package:driver/utils/fire_store_utils.dart';
import 'package:get/get.dart';

class DeliverOrderController extends GetxController {
  RxBool isLoading = true.obs;
  RxBool conformPickup = false.obs;

  @override
  void onInit() {
    // TODO: implement onInit
    getArgument();
    super.onInit();
  }

  Rx<OrderModel> orderModel = OrderModel().obs;

  RxInt totalQuantity = 0.obs;

  getArgument() {
    dynamic argumentData = Get.arguments;
    if (argumentData != null) {
      orderModel.value = argumentData['orderModel'];
      for (var element in orderModel.value.products!) {
        totalQuantity.value += (element.quantity ?? 0);
      }
    }
    isLoading.value = false;
  }

  completedOrder() async {
    ShowToastDialog.showLoader("Please wait".tr);
    await AudioPlayerService.playSound(false);
    orderModel.value.status = Constant.orderCompleted;
    await FireStoreUtils.updateWallateAmount(orderModel.value);
    await FireStoreUtils.setOrder(orderModel.value);
    if (Constant.userModel?.vendorID?.isNotEmpty == true) {
      Constant.userModel?.orderRequestData?.remove(orderModel.value.id);
      Constant.userModel?.inProgressOrderID?.remove(orderModel.value.id);
      await FireStoreUtils.updateUser(Constant.userModel!);
    }
    await FireStoreUtils.getFirestOrderOrNOt(orderModel.value)
        .then((value) async {
      if (value == true) {
        await FireStoreUtils.updateReferralAmount(orderModel.value);
      }
    });

    await SendNotification.sendFcmMessage(Constant.driverCompleted,
        orderModel.value.author!.fcmToken.toString(), {});
    ShowToastDialog.closeLoader();
    Get.back(result: true);
  }
}
