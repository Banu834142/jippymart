import 'package:flutter_easyloading/flutter_easyloading.dart';

class ShowToastDialog {
  static showToast(String? message,
      {EasyLoadingToastPosition position = EasyLoadingToastPosition.top}) {
    EasyLoading.showToast(message!, toastPosition: position);
  }

  static showToastDuration(String? message,
      {EasyLoadingToastPosition position = EasyLoadingToastPosition.top,
      required Duration duration}) {
    EasyLoading.showToast(message!,
        toastPosition: position, duration: duration);
  }

  static showLoader(String message) {
    EasyLoading.show(status: message);
  }

  static closeLoader() {
    EasyLoading.dismiss();
  }
}
