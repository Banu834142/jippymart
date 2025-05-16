import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:restaurant/constant/show_toast_dialog.dart';
import 'package:restaurant/controller/qr_code_controller.dart';
import 'package:restaurant/themes/app_them_data.dart';
import 'package:restaurant/themes/round_button_fill.dart';
import 'package:restaurant/utils/dark_theme_provider.dart';
import 'dart:ui' as ui;

import 'package:restaurant/widget/image_saver.dart';

class QrCodeScreen extends StatelessWidget {
  const QrCodeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final themeChange = Provider.of<DarkThemeProvider>(context);
    return GetX(
        init: QrCodeController(),
        builder: (controller) {
          return Scaffold(
            appBar: AppBar(
              backgroundColor: AppThemeData.secondary300,
              centerTitle: false,
              titleSpacing: 0,
              iconTheme:
                  const IconThemeData(color: AppThemeData.grey50, size: 20),
            ),
            body: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    "Restaurant QR Code".tr,
                    style: TextStyle(
                        color: themeChange.getThem()
                            ? AppThemeData.grey50
                            : AppThemeData.grey900,
                        fontSize: 22,
                        fontFamily: AppThemeData.semiBold),
                  ),
                  Text(
                    "Your unique QR code for seamless customers  interactions.."
                        .tr,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        color: themeChange.getThem()
                            ? AppThemeData.grey50
                            : AppThemeData.grey500,
                        fontSize: 16,
                        fontFamily: AppThemeData.bold),
                  ),
                  const SizedBox(
                    height: 50,
                  ),
                  RepaintBoundary(
                    key: controller.globalKey,
                    child: QrImageView(
                      data: '${controller.vendorModel.value.id}',
                      version: QrVersions.auto,
                      size: 200.0,
                      foregroundColor: themeChange.getThem()
                          ? AppThemeData.grey50
                          : AppThemeData.grey900,
                      backgroundColor: themeChange.getThem()
                          ? AppThemeData.grey900
                          : AppThemeData.grey50, // White background for QR code
                    ),
                  ),
                  const SizedBox(
                    height: 50,
                  ),
                ],
              ),
            ),
            bottomNavigationBar: Container(
              color: themeChange.getThem()
                  ? AppThemeData.grey900
                  : AppThemeData.grey50,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              child: Padding(
                padding: const EdgeInsets.only(bottom: 20),
                child: RoundedButtonFill(
                  title: "Save".tr,
                  height: 5.5,
                  color: themeChange.getThem()
                      ? AppThemeData.secondary300
                      : AppThemeData.secondary300,
                  textColor: themeChange.getThem()
                      ? AppThemeData.grey900
                      : AppThemeData.grey50,
                  fontSizes: 16,
                  onPress: () async {
                    try {
                      RenderRepaintBoundary boundary = controller
                          .globalKey.currentContext!
                          .findRenderObject() as RenderRepaintBoundary;
                      ui.Image image = await boundary.toImage(
                          pixelRatio: 3.0); // High resolution
                      ByteData? byteData = await image.toByteData(
                          format: ui.ImageByteFormat.png);
                      if (byteData != null) {
                        await ImageSaver.saveImage(
                            byteData.buffer.asUint8List(),
                            "qrcode${DateTime.now().toIso8601String()}.png");
                        ShowToastDialog.showToast("Image Saved!".tr);
                      } else {
                        debugPrint("Byte data is null");
                      }
                    } catch (e) {
                      debugPrint("Error saving image: $e");
                    }
                  },
                ),
              ),
            ),
          );
        });
  }
}
