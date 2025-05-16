import 'package:driver/app/chat_screens/chat_screen.dart';
import 'package:driver/app/home_screen/deliver_order_screen.dart';
import 'package:driver/app/home_screen/pickup_order_screen.dart';
import 'package:driver/constant/constant.dart';
import 'package:driver/constant/show_toast_dialog.dart';
import 'package:driver/controllers/dash_board_controller.dart';
import 'package:driver/controllers/home_controller.dart';
import 'package:driver/models/order_model.dart';
import 'package:driver/models/user_model.dart';
import 'package:driver/services/audio_player_service.dart';
import 'package:driver/themes/app_them_data.dart';
import 'package:driver/themes/responsive.dart';
import 'package:driver/themes/round_button_fill.dart';
import 'package:driver/utils/dark_theme_provider.dart';
import 'package:driver/utils/fire_store_utils.dart';
import 'package:driver/utils/utils.dart';
import 'package:driver/widget/my_separator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart' as flutterMap;
import 'package:flutter_svg/flutter_svg.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'package:timelines_plus/timelines_plus.dart';
import 'package:latlong2/latlong.dart' as location;

class HomeScreen extends StatelessWidget {
  final bool? isAppBarShow;

  const HomeScreen({super.key, this.isAppBarShow});

  @override
  Widget build(BuildContext context) {
    final themeChange = Provider.of<DarkThemeProvider>(context);
    return GetX(
      init: HomeController(),
      builder: (controller) {
        return Scaffold(
          appBar: isAppBarShow == true
              ? AppBar(
                  backgroundColor: themeChange.getThem()
                      ? AppThemeData.grey900
                      : AppThemeData.grey50,
                  centerTitle: false,
                  iconTheme: const IconThemeData(
                      color: AppThemeData.grey900, size: 20),
                  title: Text(
                    "Order".tr,
                    style: TextStyle(
                        color: themeChange.getThem()
                            ? AppThemeData.grey50
                            : AppThemeData.grey900,
                        fontSize: 18,
                        fontFamily: AppThemeData.medium),
                  ),
                )
              : null,
          body: controller.isLoading.value
              ? Constant.loader()
              : Constant.userModel?.vendorID?.isEmpty == true &&
                      Constant.isDriverVerification == true &&
                      Constant.userModel!.isDocumentVerify == false
                  ? Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Container(
                            decoration: ShapeDecoration(
                              color: themeChange.getThem()
                                  ? AppThemeData.grey700
                                  : AppThemeData.grey200,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(120),
                              ),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(20),
                              child: SvgPicture.asset(
                                  "assets/icons/ic_document.svg"),
                            ),
                          ),
                          const SizedBox(
                            height: 12,
                          ),
                          Text(
                            "Document Verification in Pending".tr,
                            style: TextStyle(
                                color: themeChange.getThem()
                                    ? AppThemeData.grey100
                                    : AppThemeData.grey800,
                                fontSize: 22,
                                fontFamily: AppThemeData.semiBold),
                          ),
                          const SizedBox(
                            height: 5,
                          ),
                          Text(
                            "Your documents are being reviewed. We will notify you once the verification is complete."
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
                            height: 20,
                          ),
                          RoundedButtonFill(
                            title: "View Status".tr,
                            width: 55,
                            height: 5.5,
                            color: AppThemeData.secondary300,
                            textColor: AppThemeData.grey50,
                            onPress: () async {
                              DashBoardController dashBoardController =
                                  Get.put(DashBoardController());
                              dashBoardController.drawerIndex.value = 4;
                            },
                          ),
                        ],
                      ),
                    )
                  : Column(
                      children: [
                        Constant.userModel?.vendorID?.isEmpty == true &&
                                double.parse(
                                        Constant.userModel!.walletAmount == null
                                            ? "0.0"
                                            : Constant.userModel!.walletAmount
                                                .toString()) <
                                    double.parse(
                                        Constant.minimumDepositToRideAccept)
                            ? Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  "${'You have to minimum'.tr} ${Constant.amountShow(amount: Constant.minimumDepositToRideAccept.toString())} ${'wallet amount to receiving Order'.tr}",
                                  style: TextStyle(
                                      color: themeChange.getThem()
                                          ? AppThemeData.grey50
                                          : AppThemeData.grey900,
                                      fontSize: 14,
                                      fontFamily: AppThemeData.semiBold),
                                ),
                              )
                            : const SizedBox(),
                        Expanded(
                          child: Constant.mapType == "inappmap"
                              ? Constant.selectedMapType == "osm"
                                  ? Obx(() => flutterMap.FlutterMap(
                                        mapController:
                                            controller.osmMapController,
                                        options: flutterMap.MapOptions(
                                          initialCenter: location.LatLng(
                                              // Constant.locationDataFinal
                                              //         ?.latitude ??
                                              //     0.0,
                                              // Constant.locationDataFinal
                                              //         ?.longitude ??
                                              //     0.0
                                              controller.driverModel.value
                                                      .location?.latitude ??
                                                  0.0,
                                              controller.driverModel.value
                                                      .location?.longitude ??
                                                  0.0),
                                          initialZoom: 12,
                                        ),
                                        children: [
                                          flutterMap.TileLayer(
                                            urlTemplate:
                                                'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                                            userAgentPackageName:
                                                'com.example.app',
                                          ),
                                          flutterMap.MarkerLayer(
                                              markers: controller.currentOrder
                                                          .value.id ==
                                                      null
                                                  ? []
                                                  : controller.osmMarkers),
                                          if (controller
                                                  .routePoints.isNotEmpty &&
                                              controller
                                                      .currentOrder.value.id !=
                                                  null)
                                            flutterMap.PolylineLayer(
                                              polylines: [
                                                flutterMap.Polyline(
                                                  points:
                                                      controller.routePoints,
                                                  strokeWidth: 7.0,
                                                  color:
                                                      AppThemeData.secondary300,
                                                ),
                                              ],
                                            ),
                                        ],
                                      ))
                                  : GoogleMap(
                                      onMapCreated: (mapController) {
                                        controller.mapController =
                                            mapController;
                                        controller.mapController!.animateCamera(
                                          CameraUpdate.newCameraPosition(
                                            CameraPosition(
                                                target: LatLng(
                                                    Constant.locationDataFinal
                                                            ?.latitude ??
                                                        0.0,
                                                    Constant.locationDataFinal
                                                            ?.longitude ??
                                                        0.0),
                                                zoom: 15,
                                                bearing: double.parse(
                                                    '${controller.driverModel.value.rotation ?? '0.0'}')),
                                          ),
                                        );
                                      },
                                      myLocationEnabled:
                                          controller.currentOrder.value.id !=
                                                      null &&
                                                  controller.currentOrder.value
                                                          .status ==
                                                      Constant.driverPending
                                              ? false
                                              : true,
                                      myLocationButtonEnabled: true,
                                      mapType: MapType.normal,
                                      zoomControlsEnabled: true,
                                      polylines: Set<Polyline>.of(
                                          controller.polyLines.values),
                                      markers:
                                          controller.markers.values.toSet(),
                                      initialCameraPosition: CameraPosition(
                                        zoom: 15,
                                        target: LatLng(
                                            controller.driverModel.value
                                                    .location?.latitude ??
                                                0.0,
                                            controller.driverModel.value
                                                    .location?.longitude ??
                                                0.0),
                                      ),
                                    )
                              : Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 16),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      SvgPicture.asset(
                                          "assets/images/ic_location_map.svg"),
                                      const SizedBox(
                                        height: 10,
                                      ),
                                      Text(
                                        "${'Navigate with'.tr} ${Constant.mapType == "google" ? "Google Map" : Constant.mapType == "googleGo" ? "Google Go" : Constant.mapType == "waze" ? "Waze Map" : Constant.mapType == "mapswithme" ? "MapsWithMe Map" : Constant.mapType == "yandexNavi" ? "VandexNavi Map" : Constant.mapType == "yandexMaps" ? "Vandex Map" : ""}",
                                        style: TextStyle(
                                            color: themeChange.getThem()
                                                ? AppThemeData.grey50
                                                : AppThemeData.grey900,
                                            fontSize: 22,
                                            fontFamily: AppThemeData.semiBold),
                                      ),
                                      Text(
                                        "${'Easily find your destination with a single tap redirect to'.tr}  ${Constant.mapType == "google" ? "Google Map" : Constant.mapType == "googleGo" ? "Google Go" : Constant.mapType == "waze" ? "Waze Map" : Constant.mapType == "mapswithme" ? "MapsWithMe Map" : Constant.mapType == "yandexNavi" ? "VandexNavi Map" : Constant.mapType == "yandexMaps" ? "Vandex Map" : ""} ${'for seamless navigation.'.tr}",
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                            color: themeChange.getThem()
                                                ? AppThemeData.grey50
                                                : AppThemeData.grey900,
                                            fontSize: 16,
                                            fontFamily: AppThemeData.regular),
                                      ),
                                      const SizedBox(
                                        height: 30,
                                      ),
                                      RoundedButtonFill(
                                        title:
                                            "${'Redirect'} ${Constant.mapType == "google" ? "Google Map" : Constant.mapType == "googleGo" ? "Google Go" : Constant.mapType == "waze" ? "Waze Map" : Constant.mapType == "mapswithme" ? "MapsWithMe Map" : Constant.mapType == "yandexNavi" ? "VandexNavi Map" : Constant.mapType == "yandexMaps" ? "Vandex Map" : ""}"
                                                .tr,
                                        width: 55,
                                        height: 5.5,
                                        color: AppThemeData.driverApp300,
                                        textColor: AppThemeData.grey50,
                                        onPress: () async {
                                          if (controller
                                                  .currentOrder.value.id !=
                                              null) {
                                            if (controller.currentOrder.value
                                                    .status !=
                                                Constant.driverPending) {
                                              if (controller.currentOrder.value
                                                      .status ==
                                                  Constant.orderShipped) {
                                                Utils.redirectMap(
                                                    name: controller
                                                        .currentOrder
                                                        .value
                                                        .vendor!
                                                        .title
                                                        .toString(),
                                                    latitude: controller
                                                            .currentOrder
                                                            .value
                                                            .vendor!
                                                            .latitude ??
                                                        0.0,
                                                    longLatitude: controller
                                                            .currentOrder
                                                            .value
                                                            .vendor!
                                                            .longitude ??
                                                        0.0);
                                              } else if (controller.currentOrder
                                                      .value.status ==
                                                  Constant.orderInTransit) {
                                                Utils.redirectMap(
                                                    name: controller
                                                        .currentOrder
                                                        .value
                                                        .author!
                                                        .firstName
                                                        .toString(),
                                                    latitude: controller
                                                            .currentOrder
                                                            .value
                                                            .address!
                                                            .location!
                                                            .latitude ??
                                                        0.0,
                                                    longLatitude: controller
                                                            .currentOrder
                                                            .value
                                                            .address!
                                                            .location!
                                                            .longitude ??
                                                        0.0);
                                              }
                                            } else {
                                              Utils.redirectMap(
                                                  name: controller.currentOrder
                                                      .value.author!.firstName
                                                      .toString(),
                                                  latitude: controller
                                                          .currentOrder
                                                          .value
                                                          .vendor!
                                                          .latitude ??
                                                      0.0,
                                                  longLatitude: controller
                                                          .currentOrder
                                                          .value
                                                          .vendor!
                                                          .longitude ??
                                                      0.0);
                                            }
                                          }
                                        },
                                      ),
                                    ],
                                  ),
                                ),
                        ),
                        controller.currentOrder.value.id != null &&
                                controller.currentOrder.value.status ==
                                    Constant.driverPending
                            ? showDriverBottomSheet(themeChange, controller)
                            : Container(),
                        controller.currentOrder.value.id != null &&
                                controller.currentOrder.value.status !=
                                    Constant.driverPending
                            ? buildOrderActionsCard(themeChange, controller)
                            : Container(),
                      ],
                    ),
        );
      },
    );
  }

  showDriverBottomSheet(themeChange, HomeController controller) {
    double distanceInMeters = Geolocator.distanceBetween(
        controller.currentOrder.value.vendor!.latitude ?? 0.0,
        controller.currentOrder.value.vendor!.longitude ?? 0.0,
        controller.currentOrder.value.address!.location!.latitude ?? 0.0,
        controller.currentOrder.value.address!.location!.longitude ?? 0.0);
    double kilometer = distanceInMeters / 1000;
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        decoration: ShapeDecoration(
          color: themeChange.getThem()
              ? AppThemeData.grey900
              : AppThemeData.grey50,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Timeline.tileBuilder(
                shrinkWrap: true,
                padding: EdgeInsets.zero,
                physics: const NeverScrollableScrollPhysics(),
                theme: TimelineThemeData(
                  nodePosition: 0,
                  // indicatorPosition: 0,
                ),
                builder: TimelineTileBuilder.connected(
                  contentsAlign: ContentsAlign.basic,
                  indicatorBuilder: (context, index) {
                    return index == 0
                        ? Container(
                            decoration: ShapeDecoration(
                              color: AppThemeData.primary50,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(120),
                              ),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(10),
                              child: SvgPicture.asset(
                                "assets/icons/ic_building.svg",
                                colorFilter: const ColorFilter.mode(
                                    AppThemeData.primary300, BlendMode.srcIn),
                              ),
                            ),
                          )
                        : Container(
                            decoration: ShapeDecoration(
                              color: AppThemeData.driverApp50,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(120),
                              ),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(10),
                              child: SvgPicture.asset(
                                "assets/icons/ic_location.svg",
                                colorFilter: ColorFilter.mode(
                                    AppThemeData.driverApp300, BlendMode.srcIn),
                              ),
                            ),
                          );
                  },
                  connectorBuilder: (context, index, connectorType) {
                    return const DashedLineConnector(
                      color: AppThemeData.grey300,
                      gap: 3,
                    );
                  },
                  contentsBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 10),
                      child: index == 0
                          ? Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "${controller.currentOrder.value.vendor!.title}",
                                  textAlign: TextAlign.start,
                                  style: TextStyle(
                                    fontFamily: AppThemeData.semiBold,
                                    fontSize: 16,
                                    color: themeChange.getThem()
                                        ? AppThemeData.grey50
                                        : AppThemeData.grey900,
                                  ),
                                ),
                                Text(
                                  "${controller.currentOrder.value.vendor!.location}",
                                  textAlign: TextAlign.start,
                                  style: TextStyle(
                                    fontFamily: AppThemeData.medium,
                                    fontSize: 14,
                                    color: themeChange.getThem()
                                        ? AppThemeData.grey300
                                        : AppThemeData.grey600,
                                  ),
                                ),
                              ],
                            )
                          : Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Deliver to the".tr,
                                  textAlign: TextAlign.start,
                                  style: TextStyle(
                                    fontFamily: AppThemeData.semiBold,
                                    fontSize: 16,
                                    color: themeChange.getThem()
                                        ? AppThemeData.grey50
                                        : AppThemeData.grey900,
                                  ),
                                ),
                                Text(
                                  controller.currentOrder.value.address!
                                      .getFullAddress(),
                                  textAlign: TextAlign.start,
                                  style: TextStyle(
                                    fontFamily: AppThemeData.medium,
                                    fontSize: 14,
                                    color: themeChange.getThem()
                                        ? AppThemeData.grey300
                                        : AppThemeData.grey600,
                                  ),
                                ),
                              ],
                            ),
                    );
                  },
                  itemCount: 2,
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 5),
                child: MySeparator(
                    color: themeChange.getThem()
                        ? AppThemeData.grey700
                        : AppThemeData.grey200),
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Text(
                      "Trip Distance".tr,
                      textAlign: TextAlign.start,
                      style: TextStyle(
                        fontFamily: AppThemeData.regular,
                        color: themeChange.getThem()
                            ? AppThemeData.grey300
                            : AppThemeData.grey600,
                        fontSize: 16,
                      ),
                    ),
                  ),
                  Text(
                    "${double.parse(kilometer.toString()).toStringAsFixed(2)} ${Constant.distanceType}",
                    textAlign: TextAlign.start,
                    style: TextStyle(
                      fontFamily: AppThemeData.semiBold,
                      color: themeChange.getThem()
                          ? AppThemeData.grey50
                          : AppThemeData.grey900,
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
              Visibility(
                visible:
                    (controller.driverModel.value.vendorID?.isEmpty == true),
                child: Column(children: [
                  const SizedBox(
                    height: 5,
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Text(
                          "Delivery Charge".tr,
                          textAlign: TextAlign.start,
                          style: TextStyle(
                            fontFamily: AppThemeData.regular,
                            color: themeChange.getThem()
                                ? AppThemeData.grey300
                                : AppThemeData.grey600,
                            fontSize: 16,
                          ),
                        ),
                      ),
                      Text(
                        Constant.amountShow(
                            amount:
                                controller.currentOrder.value.deliveryCharge),
                        textAlign: TextAlign.start,
                        style: TextStyle(
                          fontFamily: AppThemeData.semiBold,
                          color: themeChange.getThem()
                              ? AppThemeData.grey50
                              : AppThemeData.grey900,
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                ]),
              ),
              const SizedBox(
                height: 5,
              ),
              controller.currentOrder.value.tipAmount == null ||
                      controller.currentOrder.value.tipAmount!.isEmpty ||
                      double.parse(controller.currentOrder.value.tipAmount
                              .toString()) <=
                          0
                  ? const SizedBox()
                  : Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Text(
                            "Tips".tr,
                            textAlign: TextAlign.start,
                            style: TextStyle(
                              fontFamily: AppThemeData.regular,
                              color: themeChange.getThem()
                                  ? AppThemeData.grey300
                                  : AppThemeData.grey600,
                              fontSize: 16,
                            ),
                          ),
                        ),
                        Text(
                          Constant.amountShow(
                              amount: controller.currentOrder.value.tipAmount),
                          textAlign: TextAlign.start,
                          style: TextStyle(
                            fontFamily: AppThemeData.semiBold,
                            color: themeChange.getThem()
                                ? AppThemeData.grey50
                                : AppThemeData.grey900,
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
              const SizedBox(
                height: 10,
              ),
              Row(
                children: [
                  Expanded(
                    child: RoundedButtonFill(
                      title: "Reject".tr,
                      width: 24,
                      height: 5.5,
                      borderRadius: 10,
                      color: AppThemeData.danger300,
                      textColor: AppThemeData.grey50,
                      onPress: () {
                        controller.rejectOrder();
                      },
                    ),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  Expanded(
                    child: RoundedButtonFill(
                      title: "Accept".tr,
                      width: 24,
                      height: 5.5,
                      borderRadius: 10,
                      color: AppThemeData.success400,
                      textColor: AppThemeData.grey50,
                      onPress: () {
                        controller.acceptOrder();
                      },
                    ),
                  )
                ],
              ),
              const SizedBox(
                height: 10,
              ),
            ],
          ),
        ),
      ),
    );
  }

  buildOrderActionsCard(themeChange, HomeController controller) {
    double totalAmount = 0.0;
    double subTotal = 0.0;
    double taxAmount = 0.0;
    double specialDiscount = 0.0;

    for (var element in controller.currentOrder.value.products!) {
      if (double.parse(element.discountPrice.toString()) <= 0) {
        subTotal = subTotal +
            double.parse(element.price.toString()) *
                double.parse(element.quantity.toString()) +
            (double.parse(element.extrasPrice.toString()) *
                double.parse(element.quantity.toString()));
      } else {
        subTotal = subTotal +
            double.parse(element.discountPrice.toString()) *
                double.parse(element.quantity.toString()) +
            (double.parse(element.extrasPrice.toString()) *
                double.parse(element.quantity.toString()));
      }
    }

    if (controller.currentOrder.value.taxSetting != null) {
      for (var element in controller.currentOrder.value.taxSetting!) {
        taxAmount = taxAmount +
            Constant.calculateTax(
                amount: (subTotal -
                        double.parse(
                            controller.currentOrder.value.discount.toString()))
                    .toString(),
                taxModel: element);
      }
    }

    if (controller.currentOrder.value.specialDiscount != null &&
        controller.currentOrder.value.specialDiscount!['special_discount'] !=
            null) {
      specialDiscount = double.parse(controller
          .currentOrder.value.specialDiscount!['special_discount']
          .toString());
    }

    totalAmount = subTotal -
        double.parse(controller.currentOrder.value.discount.toString()) -
        specialDiscount +
        taxAmount +
        double.parse(controller.currentOrder.value.deliveryCharge.toString()) +
        double.parse(controller.currentOrder.value.tipAmount.toString());

    return Container(
      color: themeChange.getThem() ? AppThemeData.grey900 : AppThemeData.grey50,
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                controller.currentOrder.value.status == Constant.orderShipped ||
                        controller.currentOrder.value.status ==
                            Constant.driverAccepted
                    ? Row(
                        children: [
                          Container(
                            decoration: ShapeDecoration(
                              color: AppThemeData.primary50,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(120),
                              ),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(10),
                              child: SvgPicture.asset(
                                "assets/icons/ic_building.svg",
                                colorFilter: const ColorFilter.mode(
                                    AppThemeData.primary300, BlendMode.srcIn),
                              ),
                            ),
                          ),
                          const SizedBox(
                            width: 10,
                          ),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "${controller.currentOrder.value.vendor!.title}",
                                  textAlign: TextAlign.start,
                                  style: TextStyle(
                                    fontFamily: AppThemeData.semiBold,
                                    fontSize: 16,
                                    color: themeChange.getThem()
                                        ? AppThemeData.grey50
                                        : AppThemeData.grey900,
                                  ),
                                ),
                                Text(
                                  "${controller.currentOrder.value.vendor!.location}",
                                  textAlign: TextAlign.start,
                                  style: TextStyle(
                                    fontFamily: AppThemeData.medium,
                                    fontSize: 14,
                                    color: themeChange.getThem()
                                        ? AppThemeData.grey300
                                        : AppThemeData.grey600,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(
                            width: 10,
                          ),
                          InkWell(
                            onTap: () {
                              Constant.makePhoneCall(controller
                                  .currentOrder.value.vendor!.phonenumber
                                  .toString());
                            },
                            child: Container(
                              width: 38,
                              height: 38,
                              decoration: ShapeDecoration(
                                shape: RoundedRectangleBorder(
                                  side: BorderSide(
                                      width: 1,
                                      color: themeChange.getThem()
                                          ? AppThemeData.grey700
                                          : AppThemeData.grey200),
                                  borderRadius: BorderRadius.circular(120),
                                ),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: SvgPicture.asset(
                                    "assets/icons/ic_phone_call.svg"),
                              ),
                            ),
                          ),
                        ],
                      )
                    : Timeline.tileBuilder(
                        shrinkWrap: true,
                        padding: EdgeInsets.zero,
                        physics: const NeverScrollableScrollPhysics(),
                        theme: TimelineThemeData(
                          nodePosition: 0,
                          // indicatorPosition: 0,
                        ),
                        builder: TimelineTileBuilder.connected(
                          contentsAlign: ContentsAlign.basic,
                          indicatorBuilder: (context, index) {
                            return index == 0
                                ? Container(
                                    decoration: ShapeDecoration(
                                      color: AppThemeData.primary50,
                                      shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(120),
                                      ),
                                    ),
                                    child: Padding(
                                      padding: const EdgeInsets.all(10),
                                      child: SvgPicture.asset(
                                        "assets/icons/ic_building.svg",
                                        colorFilter: const ColorFilter.mode(
                                            AppThemeData.primary300,
                                            BlendMode.srcIn),
                                      ),
                                    ),
                                  )
                                : Container(
                                    decoration: ShapeDecoration(
                                      color: AppThemeData.driverApp50,
                                      shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(120),
                                      ),
                                    ),
                                    child: Padding(
                                      padding: const EdgeInsets.all(10),
                                      child: SvgPicture.asset(
                                        "assets/icons/ic_location.svg",
                                        colorFilter: ColorFilter.mode(
                                            AppThemeData.driverApp300,
                                            BlendMode.srcIn),
                                      ),
                                    ),
                                  );
                          },
                          connectorBuilder: (context, index, connectorType) {
                            return const DashedLineConnector(
                              color: AppThemeData.grey300,
                              gap: 3,
                            );
                          },
                          contentsBuilder: (context, index) {
                            return Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 10),
                              child: index == 0
                                  ? Row(
                                      children: [
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                "${controller.currentOrder.value.vendor!.title}",
                                                textAlign: TextAlign.start,
                                                style: TextStyle(
                                                  fontFamily:
                                                      AppThemeData.semiBold,
                                                  fontSize: 16,
                                                  color: themeChange.getThem()
                                                      ? AppThemeData.grey50
                                                      : AppThemeData.grey900,
                                                ),
                                              ),
                                              Text(
                                                "${controller.currentOrder.value.vendor!.location}",
                                                textAlign: TextAlign.start,
                                                style: TextStyle(
                                                  fontFamily:
                                                      AppThemeData.medium,
                                                  fontSize: 14,
                                                  color: themeChange.getThem()
                                                      ? AppThemeData.grey300
                                                      : AppThemeData.grey600,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        const SizedBox(
                                          width: 5,
                                        ),
                                        InkWell(
                                          onTap: () {
                                            Constant.makePhoneCall(controller
                                                .currentOrder
                                                .value
                                                .vendor!
                                                .phonenumber
                                                .toString());
                                          },
                                          child: Container(
                                            width: 42,
                                            height: 42,
                                            decoration: ShapeDecoration(
                                              shape: RoundedRectangleBorder(
                                                side: BorderSide(
                                                    width: 1,
                                                    color: themeChange.getThem()
                                                        ? AppThemeData.grey700
                                                        : AppThemeData.grey200),
                                                borderRadius:
                                                    BorderRadius.circular(120),
                                              ),
                                            ),
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: SvgPicture.asset(
                                                  "assets/icons/ic_phone_call.svg"),
                                            ),
                                          ),
                                        ),
                                      ],
                                    )
                                  : Row(
                                      children: [
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                "Deliver to the".tr,
                                                textAlign: TextAlign.start,
                                                style: TextStyle(
                                                  fontFamily:
                                                      AppThemeData.semiBold,
                                                  fontSize: 16,
                                                  color: themeChange.getThem()
                                                      ? AppThemeData.grey50
                                                      : AppThemeData.grey900,
                                                ),
                                              ),
                                              Text(
                                                controller
                                                    .currentOrder.value.address!
                                                    .getFullAddress(),
                                                textAlign: TextAlign.start,
                                                style: TextStyle(
                                                  fontFamily:
                                                      AppThemeData.medium,
                                                  fontSize: 14,
                                                  color: themeChange.getThem()
                                                      ? AppThemeData.grey300
                                                      : AppThemeData.grey600,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        const SizedBox(
                                          width: 5,
                                        ),
                                        InkWell(
                                          onTap: () async {
                                            ShowToastDialog.showLoader(
                                                "Please wait".tr);

                                            UserModel? customer =
                                                await FireStoreUtils
                                                    .getUserProfile(controller
                                                        .currentOrder
                                                        .value
                                                        .authorID
                                                        .toString());
                                            UserModel? driver =
                                                await FireStoreUtils
                                                    .getUserProfile(controller
                                                        .currentOrder
                                                        .value
                                                        .driverID
                                                        .toString());

                                            ShowToastDialog.closeLoader();

                                            Get.to(const ChatScreen(),
                                                arguments: {
                                                  "customerName":
                                                      '${customer!.fullName()}',
                                                  "restaurantName":
                                                      driver!.fullName(),
                                                  "orderId": controller
                                                      .currentOrder.value.id,
                                                  "restaurantId": driver.id,
                                                  "customerId": customer.id,
                                                  "customerProfileImage": customer
                                                          .profilePictureURL ??
                                                      "",
                                                  "restaurantProfileImage":
                                                      driver.profilePictureURL ??
                                                          "",
                                                  "token": customer.fcmToken,
                                                  "chatType": "Driver",
                                                });
                                          },
                                          child: Container(
                                            width: 42,
                                            height: 42,
                                            decoration: ShapeDecoration(
                                              shape: RoundedRectangleBorder(
                                                side: BorderSide(
                                                    width: 1,
                                                    color: themeChange.getThem()
                                                        ? AppThemeData.grey700
                                                        : AppThemeData.grey200),
                                                borderRadius:
                                                    BorderRadius.circular(120),
                                              ),
                                            ),
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: SvgPicture.asset(
                                                  "assets/icons/ic_wechat.svg"),
                                            ),
                                          ),
                                        )
                                      ],
                                    ),
                            );
                          },
                          itemCount: 2,
                        ),
                      ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 20),
                  child: MySeparator(
                      color: themeChange.getThem()
                          ? AppThemeData.grey700
                          : AppThemeData.grey200),
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Text(
                        "Payment Type".tr,
                        textAlign: TextAlign.start,
                        style: TextStyle(
                          fontFamily: AppThemeData.regular,
                          color: themeChange.getThem()
                              ? AppThemeData.grey300
                              : AppThemeData.grey600,
                          fontSize: 16,
                        ),
                      ),
                    ),
                    Text(
                      controller.currentOrder.value.paymentMethod!
                                  .toLowerCase() ==
                              "cod"
                          ? "Cash on delivery"
                          : "Online",
                      textAlign: TextAlign.start,
                      style: TextStyle(
                        fontFamily: AppThemeData.semiBold,
                        color: themeChange.getThem()
                            ? AppThemeData.grey50
                            : AppThemeData.grey900,
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 5,
                ),
                controller.currentOrder.value.paymentMethod!.toLowerCase() ==
                        "cod"
                    ? Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Text(
                              "Collect Payment from customer".tr,
                              textAlign: TextAlign.start,
                              style: TextStyle(
                                fontFamily: AppThemeData.regular,
                                color: themeChange.getThem()
                                    ? AppThemeData.grey300
                                    : AppThemeData.grey600,
                                fontSize: 16,
                              ),
                            ),
                          ),
                          Text(
                            Constant.amountShow(amount: totalAmount.toString()),
                            textAlign: TextAlign.start,
                            style: TextStyle(
                              fontFamily: AppThemeData.semiBold,
                              color: themeChange.getThem()
                                  ? AppThemeData.grey50
                                  : AppThemeData.grey900,
                              fontSize: 16,
                            ),
                          ),
                        ],
                      )
                    : const SizedBox(),
                const SizedBox(
                  height: 5,
                ),
                controller.currentOrder.value.tipAmount == null ||
                        controller.currentOrder.value.tipAmount!.isEmpty ||
                        double.parse(controller.currentOrder.value.tipAmount
                                .toString()) <=
                            0
                    ? const SizedBox()
                    : Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Text(
                              "Tips".tr,
                              textAlign: TextAlign.start,
                              style: TextStyle(
                                fontFamily: AppThemeData.regular,
                                color: themeChange.getThem()
                                    ? AppThemeData.grey300
                                    : AppThemeData.grey600,
                                fontSize: 16,
                              ),
                            ),
                          ),
                          Text(
                            Constant.amountShow(
                                amount:
                                    controller.currentOrder.value.tipAmount),
                            textAlign: TextAlign.start,
                            style: TextStyle(
                              fontFamily: AppThemeData.semiBold,
                              color: themeChange.getThem()
                                  ? AppThemeData.grey50
                                  : AppThemeData.grey900,
                              fontSize: 16,
                            ),
                          ),
                        ],
                      ),
                const SizedBox(
                  height: 10,
                ),
              ],
            ),
          ),
          InkWell(
            onTap: () async {
              if (controller.currentOrder.value.status ==
                      Constant.orderShipped ||
                  controller.currentOrder.value.status ==
                      Constant.driverAccepted) {
                Get.to(const PickupOrderScreen(), arguments: {
                  "orderModel": controller.currentOrder.value
                })?.then((v) async {
                  if (v == true) {
                    OrderModel? ordermodel = await FireStoreUtils.getOrderById(
                        controller.currentOrder.value.id!);
                    if (ordermodel?.id != null) {
                      controller.currentOrder.value = ordermodel!;
                    }
                    controller.update();
                  }
                });
              } else {
                Get.to(const DeliverOrderScreen(), arguments: {
                  "orderModel": controller.currentOrder.value
                })!
                    .then(
                  (value) async {
                    if (value == true) {
                      await AudioPlayerService.playSound(false);
                      controller.driverModel.value.inProgressOrderID!
                          .remove(controller.currentOrder.value.id);
                      await FireStoreUtils.updateUser(
                          controller.driverModel.value);
                      controller.currentOrder.value = OrderModel();
                      controller.clearMap();
                      if (Constant.singleOrderReceive == false) {
                        Get.back();
                      }
                    }
                  },
                );
              }
            },
            child: Container(
              color: AppThemeData.driverApp300,
              width: Responsive.width(100, Get.context!),
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 16),
                child: Text(
                  controller.currentOrder.value.status ==
                              Constant.orderShipped ||
                          controller.currentOrder.value.status ==
                              Constant.driverAccepted
                      ? "Reached restaurant for Pickup".tr
                      : controller.driverModel.value.vendorID?.isEmpty == true
                          ? "Reached the Customers Door Steps".tr
                          : "Order Delivered".tr,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: themeChange.getThem()
                        ? AppThemeData.grey900
                        : AppThemeData.grey900,
                    fontSize: 16,
                    fontFamily: AppThemeData.semiBold,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
