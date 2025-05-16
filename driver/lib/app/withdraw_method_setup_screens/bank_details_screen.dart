import 'package:driver/constant/show_toast_dialog.dart';
import 'package:driver/controllers/bank_details_controller.dart';
import 'package:driver/themes/responsive.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:driver/themes/app_them_data.dart';
import 'package:driver/themes/text_field_widget.dart';
import 'package:driver/utils/dark_theme_provider.dart';

class BankDetailsScreen extends StatelessWidget {
  const BankDetailsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final themeChange = Provider.of<DarkThemeProvider>(context);
    return GetX(
        init: BankDetailsController(),
        builder: (controller) {
          return Scaffold(
            backgroundColor: themeChange.getThem()
                ? AppThemeData.surfaceDark
                : AppThemeData.surface,
            appBar: AppBar(
              backgroundColor: themeChange.getThem()
                  ? AppThemeData.surfaceDark
                  : AppThemeData.surface,
              centerTitle: false,
              title: Text(
                "Bank Setup".tr,
                style: TextStyle(
                    color: themeChange.getThem()
                        ? AppThemeData.grey50
                        : AppThemeData.grey900,
                    fontSize: 18,
                    fontFamily: AppThemeData.medium),
              ),
            ),
            body: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    TextFieldWidget(
                      title: 'Bank Name'.tr,
                      controller: controller.bankNameController.value,
                      hintText: 'Enter Bank Name'.tr,
                    ),
                    TextFieldWidget(
                      title: 'Branch Name'.tr,
                      controller: controller.branchNameController.value,
                      hintText: 'Enter Branch Name'.tr,
                    ),
                    TextFieldWidget(
                      title: 'Holder Name'.tr,
                      controller: controller.holderNameController.value,
                      hintText: 'Enter Holder Name'.tr,
                    ),
                    TextFieldWidget(
                      title: 'Account Number'.tr,
                      controller: controller.accountNoController.value,
                      hintText: 'Enter Account Number'.tr,
                    ),
                    TextFieldWidget(
                      title: 'Other Information'.tr,
                      controller: controller.otherInfoController.value,
                      hintText: 'Enter Other Information'.tr,
                    ),
                  ],
                ),
              ),
            ),
            bottomNavigationBar: InkWell(
              onTap: () {
                if (controller.bankNameController.value.text.isEmpty) {
                  ShowToastDialog.showToast("Please enter bank name".tr);
                } else if (controller.branchNameController.value.text.isEmpty) {
                  ShowToastDialog.showToast("Please enter branch name".tr);
                } else if (controller.holderNameController.value.text.isEmpty) {
                  ShowToastDialog.showToast("Please enter holder name".tr);
                } else if (controller.accountNoController.value.text.isEmpty) {
                  ShowToastDialog.showToast("Please enter account number".tr);
                } else {
                  controller.saveBank();
                }
              },
              child: Container(
                color: AppThemeData.driverApp300,
                width: Responsive.width(100, context),
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  child: Text(
                    "Save Details".tr,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: themeChange.getThem()
                          ? AppThemeData.grey50
                          : AppThemeData.grey50,
                      fontSize: 16,
                      fontFamily: AppThemeData.medium,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ),
              ),
            ),
          );
        });
  }
}
