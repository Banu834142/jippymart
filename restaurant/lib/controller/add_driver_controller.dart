import 'dart:developer';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:restaurant/constant/constant.dart';
import 'package:restaurant/constant/show_toast_dialog.dart';
import 'package:restaurant/models/user_model.dart';
import 'package:restaurant/models/zone_model.dart';
import 'package:restaurant/utils/fire_store_utils.dart';

class AddDriverController extends GetxController {
  RxBool isLoading = true.obs;
  Rx<TextEditingController> firstNameEditingController =
      TextEditingController().obs;
  Rx<TextEditingController> lastNameEditingController =
      TextEditingController().obs;
  Rx<TextEditingController> emailEditingController =
      TextEditingController().obs;
  Rx<TextEditingController> phoneNUmberEditingController =
      TextEditingController().obs;
  Rx<TextEditingController> countryCodeEditingController =
      TextEditingController().obs;
  Rx<TextEditingController> passwordEditingController =
      TextEditingController().obs;
  RxBool passwordVisible = true.obs;
  Rx<TextEditingController> conformPasswordEditingController =
      TextEditingController().obs;
  RxBool conformPasswordVisible = true.obs;
  Rx<ZoneModel> selectedZone = ZoneModel().obs;
  RxList<ZoneModel> zoneList = <ZoneModel>[].obs;
  //

  @override
  void onInit() {
    // TODO: implement onInit
    getArgument();
    super.onInit();
  }

  getArgument() async {
    await FireStoreUtils.getZone().then((value) {
      if (value != null) {
        zoneList.value = value;
      }
    });
    dynamic argumentData = Get.arguments;
    if (argumentData != null) {
      driverModel.value = argumentData['driverModel'];
      if (driverModel.value.id != null) {
        firstNameEditingController.value.text =
            driverModel.value.firstName ?? '';
        lastNameEditingController.value.text = driverModel.value.lastName ?? '';
        emailEditingController.value.text = driverModel.value.email ?? '';
        phoneNUmberEditingController.value.text =
            driverModel.value.phoneNumber ?? '';
        countryCodeEditingController.value.text =
            driverModel.value.countryCode ?? '';

        if (driverModel.value.zoneId != null) {
          selectedZone.value = zoneList.firstWhere(
            (zone) => driverModel.value.zoneId == zone.id,
            orElse: () => ZoneModel(),
          );
        }
      }
    }
    isLoading.value = false;
  }

  signUpWithEmailAndPassword() async {
    signUp();
  }

  Rx<UserModel> driverModel = UserModel().obs;
  signUp() async {
    ShowToastDialog.showLoader("Please wait".tr);

    try {
      if (driverModel.value.id != null && driverModel.value.id != '') {
        log(":::::111:::::::");
        driverModel.value.firstName =
            firstNameEditingController.value.text.trim();
        driverModel.value.lastName =
            lastNameEditingController.value.text.trim();
        driverModel.value.email = emailEditingController.value.text.trim();
        driverModel.value.phoneNumber =
            phoneNUmberEditingController.value.text.trim();
        driverModel.value.countryCode =
            countryCodeEditingController.value.text.trim();
        driverModel.value.zoneId = selectedZone.value.id;
      } else {
        FirebaseApp secondaryApp = await Firebase.initializeApp(
          name: 'SecondaryApp',
          options: Firebase.app().options,
        );

        FirebaseAuth secondaryAuth =
            FirebaseAuth.instanceFor(app: secondaryApp);

        final credential = await secondaryAuth.createUserWithEmailAndPassword(
          email: emailEditingController.value.text.trim(),
          password: passwordEditingController.value.text.trim(),
        );

        if (credential.user != null) {
          driverModel.value.firstName =
              firstNameEditingController.value.text.trim();
          driverModel.value.lastName =
              lastNameEditingController.value.text.trim();
          driverModel.value.email =
              emailEditingController.value.text.trim().toLowerCase();
          driverModel.value.phoneNumber =
              phoneNUmberEditingController.value.text.trim();
          driverModel.value.role = Constant.userRoleDriver;
          driverModel.value.fcmToken = '';
          driverModel.value.active = true;
          driverModel.value.isDocumentVerify = true;
          driverModel.value.countryCode =
              countryCodeEditingController.value.text.trim();
          driverModel.value.createdAt = Timestamp.now();
          driverModel.value.zoneId = selectedZone.value.id;
          driverModel.value.appIdentifier =
              Platform.isAndroid ? 'android' : 'ios';
          driverModel.value.provider = 'email';
          driverModel.value.vendorID = Constant.userModel?.vendorID;
          driverModel.value.id = credential.user!.uid;
        } else {
          ShowToastDialog.showToast("Something went to wrong".tr);
          return null;
        }
        await secondaryApp.delete();
      }
      await FireStoreUtils.updateUser(driverModel.value).then(
        (value) async {
          if (value == true) {
            Get.back(result: true);
            ShowToastDialog.showToast(
                "Delivery man details saved successfully!".tr);
          } else {
            ShowToastDialog.showToast("Something went to wrong".tr);
          }
        },
      );
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        ShowToastDialog.showToast("The password provided is too weak.".tr);
      } else if (e.code == 'email-already-in-use') {
        ShowToastDialog.showToast(
            "The account already exists for that email.".tr);
      } else if (e.code == 'invalid-email') {
        ShowToastDialog.showToast("Enter email is Invalid".tr);
      }
    } catch (e) {
      ShowToastDialog.showToast(e.toString());
    }

    ShowToastDialog.closeLoader();
  }
}
