import 'package:driver/constant/collection_name.dart';
import 'package:driver/constant/constant.dart';
import 'package:driver/constant/send_notification.dart';
import 'package:driver/constant/show_toast_dialog.dart';
import 'package:driver/models/order_model.dart';
import 'package:driver/models/user_model.dart';
import 'package:driver/services/audio_player_service.dart';
import 'package:driver/utils/fire_store_utils.dart';
import 'package:get/get.dart';

class HomeScreenMultipleOrderController extends GetxController {
  Rx<UserModel> driverModel = Constant.userModel!.obs;
  RxBool isLoading = true.obs;
  RxInt selectedTabIndex = 0.obs;

  RxList<dynamic> newOrder = [].obs;
  RxList<dynamic> activeOrder = [].obs;

  @override
  void onInit() {
    // TODO: implement onInt
    getDriver();
    super.onInit();
  }

  getDriver() async {
    FireStoreUtils.fireStore
        .collection(CollectionName.users)
        .doc(FireStoreUtils.getCurrentUid())
        .snapshots()
        .listen(
      (event) async {
        if (event.exists) {
          driverModel.value = UserModel.fromJson(event.data()!);
          Constant.userModel = driverModel.value;
          newOrder.clear();
          activeOrder.clear();
          if (driverModel.value.orderRequestData != null) {
            for (var element in driverModel.value.orderRequestData!) {
              newOrder.add(element);
            }
          }

          if (driverModel.value.inProgressOrderID != null) {
            for (var element in driverModel.value.inProgressOrderID!) {
              activeOrder.add(element);
            }
          }

          if (newOrder.isEmpty == true) {
            await AudioPlayerService.playSound(false);
          }

          if (newOrder.isNotEmpty) {
            if (driverModel.value.vendorID?.isEmpty == true) {
              await AudioPlayerService.playSound(true);
            }
          }
        }
      },
    );
    isLoading.value = false;
  }

  acceptOrder(OrderModel currentOrder) async {
    await AudioPlayerService.playSound(false);
    ShowToastDialog.showLoader("Please wait".tr);
    driverModel.value.inProgressOrderID ?? [];
    driverModel.value.orderRequestData!.remove(currentOrder.id);
    driverModel.value.inProgressOrderID!.add(currentOrder.id);

    await FireStoreUtils.updateUser(driverModel.value);

    currentOrder.status = Constant.driverAccepted;
    currentOrder.driverID = driverModel.value.id;
    currentOrder.driver = driverModel.value;

    await FireStoreUtils.setOrder(currentOrder);
    ShowToastDialog.closeLoader();
    await SendNotification.sendFcmMessage(Constant.driverAcceptedNotification,
        currentOrder.author!.fcmToken.toString(), {});
    await SendNotification.sendFcmMessage(Constant.driverAcceptedNotification,
        currentOrder.vendor!.fcmToken.toString(), {});
  }

  rejectOrder(OrderModel currentOrder) async {
    await AudioPlayerService.playSound(false);
    currentOrder.rejectedByDrivers ??= [];

    currentOrder.rejectedByDrivers!.add(driverModel.value.id);
    currentOrder.status = Constant.driverRejected;
    await FireStoreUtils.setOrder(currentOrder);

    driverModel.value.orderRequestData!.remove(currentOrder.id);
    await FireStoreUtils.updateUser(driverModel.value);
  }
}
