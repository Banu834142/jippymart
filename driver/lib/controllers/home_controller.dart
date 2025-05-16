import 'dart:async';
import 'dart:convert';
import 'package:driver/constant/collection_name.dart';
import 'package:driver/constant/constant.dart';
import 'package:driver/constant/send_notification.dart';
import 'package:driver/constant/show_toast_dialog.dart';
import 'package:driver/models/user_model.dart';
import 'package:driver/services/audio_player_service.dart';
import 'package:driver/themes/app_them_data.dart';
import 'package:driver/utils/fire_store_utils.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_map/flutter_map.dart' as flutterMap;
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:latlong2/latlong.dart' as location;
import '../models/order_model.dart';
import 'package:http/http.dart' as http;

class HomeController extends GetxController {
  RxBool isLoading = true.obs;
  flutterMap.MapController osmMapController = flutterMap.MapController();
  RxList<flutterMap.Marker> osmMarkers = <flutterMap.Marker>[].obs;

  @override
  void onInit() {
    getArgument();
    setIcons();
    getDriver();
    super.onInit();
  }

  Rx<OrderModel> orderModel = OrderModel().obs;
  Rx<OrderModel> currentOrder = OrderModel().obs;
  Rx<UserModel> driverModel = UserModel().obs;

  getArgument() {
    dynamic argumentData = Get.arguments;
    if (argumentData != null) {
      orderModel.value = argumentData['orderModel'];
    }
  }

  acceptOrder() async {
    await AudioPlayerService.playSound(false);
    ShowToastDialog.showLoader("Please wait".tr);
    driverModel.value.inProgressOrderID ?? [];
    driverModel.value.orderRequestData!.remove(currentOrder.value.id);
    driverModel.value.inProgressOrderID!.add(currentOrder.value.id);

    await FireStoreUtils.updateUser(driverModel.value);

    currentOrder.value.status = Constant.driverAccepted;
    currentOrder.value.driverID = driverModel.value.id;
    currentOrder.value.driver = driverModel.value;

    await FireStoreUtils.setOrder(currentOrder.value);
    ShowToastDialog.closeLoader();
    await SendNotification.sendFcmMessage(Constant.driverAcceptedNotification,
        currentOrder.value.author!.fcmToken.toString(), {});
    await SendNotification.sendFcmMessage(Constant.driverAcceptedNotification,
        currentOrder.value.vendor!.fcmToken.toString(), {});
  }

  rejectOrder() async {
    await AudioPlayerService.playSound(false);
    currentOrder.value.rejectedByDrivers ??= [];

    currentOrder.value.rejectedByDrivers!.add(driverModel.value.id);
    currentOrder.value.status = Constant.driverRejected;
    await FireStoreUtils.setOrder(currentOrder.value);
    driverModel.value.orderRequestData!.remove(currentOrder.value.id);
    await FireStoreUtils.updateUser(driverModel.value);
    currentOrder.value = OrderModel();
    clearMap();
    if (Constant.singleOrderReceive == false) {
      Get.back();
    }
  }

  clearMap() async {
    await AudioPlayerService.playSound(false);
    if (Constant.selectedMapType != 'osm') {
      markers.clear();
      polyLines.clear();
    } else {
      osmMarkers.clear();
      routePoints.clear();
      // osmMapController = flutterMap.MapController();
    }
    update();
  }

  getCurrentOrder() async {
    if (currentOrder.value.id != null &&
        !driverModel.value.orderRequestData!.contains(currentOrder.value.id) &&
        !driverModel.value.inProgressOrderID!.contains(currentOrder.value.id)) {
      currentOrder.value = OrderModel();
      await clearMap();
      await AudioPlayerService.playSound(false);
    } else if (Constant.singleOrderReceive == true) {
      if (driverModel.value.inProgressOrderID != null &&
          driverModel.value.inProgressOrderID!.isNotEmpty) {
        FireStoreUtils.fireStore
            .collection(CollectionName.restaurantOrders)
            .where('status',
                whereNotIn: [Constant.orderCancelled, Constant.driverRejected])
            .where('id',
                isEqualTo:
                    driverModel.value.inProgressOrderID!.first.toString())
            .snapshots()
            .listen(
              (event) async {
                if (event.docs.isNotEmpty) {
                  currentOrder.value =
                      OrderModel.fromJson(event.docs.first.data());
                  changeData();
                } else {
                  currentOrder.value = OrderModel();
                  await AudioPlayerService.playSound(false);
                }
              },
            );
      } else if (driverModel.value.orderRequestData != null &&
          driverModel.value.orderRequestData!.isNotEmpty) {
        FireStoreUtils.fireStore
            .collection(CollectionName.restaurantOrders)
            .where('status',
                whereNotIn: [Constant.orderCancelled, Constant.driverRejected])
            .where('id',
                isEqualTo: driverModel.value.orderRequestData!.first.toString())
            .snapshots()
            .listen(
              (event) async {
                if (event.docs.isNotEmpty) {
                  currentOrder.value =
                      OrderModel.fromJson(event.docs.first.data());
                  if (driverModel.value.orderRequestData
                          ?.contains(currentOrder.value.id) ==
                      true) {
                    changeData();
                  } else {
                    currentOrder.value = OrderModel();
                    update();
                  }
                } else {
                  currentOrder.value = OrderModel();
                  await AudioPlayerService.playSound(false);
                }
              },
            );
      }
    } else if (orderModel.value.id != null) {
      FireStoreUtils.fireStore
          .collection(CollectionName.restaurantOrders)
          .where('status',
              whereNotIn: [Constant.orderCancelled, Constant.driverRejected])
          .where('id', isEqualTo: orderModel.value.id.toString())
          .snapshots()
          .listen(
            (event) async {
              if (event.docs.isNotEmpty) {
                currentOrder.value =
                    OrderModel.fromJson(event.docs.first.data());
                changeData();
              } else {
                currentOrder.value = OrderModel();
                await AudioPlayerService.playSound(false);
              }
            },
          );
    }
  }

  RxBool isChange = false.obs;

  changeData() async {
    print(
        "currentOrder.value.status :: ${currentOrder.value.id} :: ${currentOrder.value.status} :: ( ${orderModel.value.driver?.vendorID != null} :: ${orderModel.value.status})");

    if (Constant.mapType == "inappmap") {
      if (Constant.selectedMapType == "osm") {
        getOSMPolyline();
      } else {
        getDirections();
      }
    }
    if (currentOrder.value.status == Constant.driverPending) {
      await AudioPlayerService.playSound(true);
    } else {
      await AudioPlayerService.playSound(false);
    }
  }

  getDriver() {
    FireStoreUtils.fireStore
        .collection(CollectionName.users)
        .doc(FireStoreUtils.getCurrentUid())
        .snapshots()
        .listen(
      (event) async {
        if (event.exists) {
          driverModel.value = UserModel.fromJson(event.data()!);
          if (driverModel.value.id != null) {
            isLoading.value = false;
            update();
            changeData();
            getCurrentOrder();
          }
        }
      },
    );
  }

  GoogleMapController? mapController;

  Rx<PolylinePoints> polylinePoints = PolylinePoints().obs;
  RxMap<PolylineId, Polyline> polyLines = <PolylineId, Polyline>{}.obs;
  RxMap<String, Marker> markers = <String, Marker>{}.obs;

  BitmapDescriptor? departureIcon;
  BitmapDescriptor? destinationIcon;
  BitmapDescriptor? taxiIcon;

  setIcons() async {
    if (Constant.selectedMapType == 'google') {
      final Uint8List departure = await Constant()
          .getBytesFromAsset('assets/images/location_black3x.png', 100);
      final Uint8List destination = await Constant()
          .getBytesFromAsset('assets/images/location_orange3x.png', 100);
      final Uint8List driver = await Constant()
          .getBytesFromAsset('assets/images/food_delivery.png', 120);

      departureIcon = BitmapDescriptor.fromBytes(departure);
      destinationIcon = BitmapDescriptor.fromBytes(destination);
      taxiIcon = BitmapDescriptor.fromBytes(driver);
    }
  }

  getDirections() async {
    if (currentOrder.value.id != null) {
      if (currentOrder.value.status != Constant.driverPending) {
        if (currentOrder.value.status == Constant.orderShipped) {
          List<LatLng> polylineCoordinates = [];

          PolylineResult result = await polylinePoints.value
              .getRouteBetweenCoordinates(
                  googleApiKey: Constant.mapAPIKey,
                  request: PolylineRequest(
                      origin: PointLatLng(
                          driverModel.value.location!.latitude ?? 0.0,
                          driverModel.value.location!.longitude ?? 0.0),
                      destination: PointLatLng(
                          currentOrder.value.vendor!.latitude ?? 0.0,
                          currentOrder.value.vendor!.longitude ?? 0.0),
                      mode: TravelMode.driving));
          if (result.points.isNotEmpty) {
            for (var point in result.points) {
              polylineCoordinates.add(LatLng(point.latitude, point.longitude));
            }
          }

          markers.remove("Departure");
          markers['Departure'] = Marker(
              markerId: const MarkerId('Departure'),
              infoWindow: const InfoWindow(title: "Departure"),
              position: LatLng(currentOrder.value.vendor!.latitude ?? 0.0,
                  currentOrder.value.vendor!.longitude ?? 0.0),
              icon: departureIcon!);
          // ignore: invalid_use_of_protected_member
          if (markers.value.containsKey("Destination")) {
            markers.remove("Destination");
          }
          // markers['Destination'] = Marker(
          //     markerId: const MarkerId('Destination'),
          //     infoWindow: const InfoWindow(title: "Destination"),
          //     position: LatLng(currentOrder.value.address!.location!.latitude ?? 0.0, currentOrder.value.address!.location!.longitude ?? 0.0),
          //     icon: destinationIcon!);

          markers.remove("Driver");
          markers['Driver'] = Marker(
              markerId: const MarkerId('Driver'),
              infoWindow: const InfoWindow(title: "Driver"),
              position: LatLng(driverModel.value.location!.latitude ?? 0.0,
                  driverModel.value.location!.longitude ?? 0.0),
              icon: taxiIcon!,
              rotation: double.parse(driverModel.value.rotation.toString()));

          addPolyLine(polylineCoordinates);
        } else if (currentOrder.value.status == Constant.orderInTransit) {
          List<LatLng> polylineCoordinates = [];

          PolylineResult result = await polylinePoints.value
              .getRouteBetweenCoordinates(
                  googleApiKey: Constant.mapAPIKey,
                  request: PolylineRequest(
                      origin: PointLatLng(
                          driverModel.value.location!.latitude ?? 0.0,
                          driverModel.value.location!.longitude ?? 0.0),
                      destination: PointLatLng(
                          currentOrder.value.address!.location!.latitude ?? 0.0,
                          currentOrder.value.address!.location!.longitude ??
                              0.0),
                      mode: TravelMode.driving));

          if (result.points.isNotEmpty) {
            for (var point in result.points) {
              polylineCoordinates.add(LatLng(point.latitude, point.longitude));
            }
          }
          // ignore: invalid_use_of_protected_member
          if (markers.value.containsKey("Departure")) {
            markers.remove("Departure");
          }
          // markers['Departure'] = Marker(
          //     markerId: const MarkerId('Departure'),
          //     infoWindow: const InfoWindow(title: "Departure"),
          //     position: LatLng(currentOrder.value.vendor!.latitude ?? 0.0, currentOrder.value.vendor!.longitude ?? 0.0),
          //     icon: departureIcon!);

          markers.remove("Destination");
          markers['Destination'] = Marker(
              markerId: const MarkerId('Destination'),
              infoWindow: const InfoWindow(title: "Destination"),
              position: LatLng(
                  currentOrder.value.address!.location!.latitude ?? 0.0,
                  currentOrder.value.address!.location!.longitude ?? 0.0),
              icon: destinationIcon!);

          markers.remove("Driver");
          markers['Driver'] = Marker(
              markerId: const MarkerId('Driver'),
              infoWindow: const InfoWindow(title: "Driver"),
              position: LatLng(driverModel.value.location!.latitude ?? 0.0,
                  driverModel.value.location!.longitude ?? 0.0),
              icon: taxiIcon!,
              rotation: double.parse(driverModel.value.rotation.toString()));
          addPolyLine(polylineCoordinates);
        }
      } else {
        List<LatLng> polylineCoordinates = [];

        PolylineResult result = await polylinePoints.value
            .getRouteBetweenCoordinates(
                googleApiKey: Constant.mapAPIKey,
                request: PolylineRequest(
                    origin: PointLatLng(
                        currentOrder.value.author!.location!.latitude ?? 0.0,
                        currentOrder.value.author!.location!.longitude ?? 0.0),
                    destination: PointLatLng(
                        currentOrder.value.vendor!.latitude ?? 0.0,
                        currentOrder.value.vendor!.longitude ?? 0.0),
                    mode: TravelMode.driving));

        if (result.points.isNotEmpty) {
          for (var point in result.points) {
            polylineCoordinates.add(LatLng(point.latitude, point.longitude));
          }
        }

        markers.remove("Departure");
        markers['Departure'] = Marker(
            markerId: const MarkerId('Departure'),
            infoWindow: const InfoWindow(title: "Departure"),
            position: LatLng(currentOrder.value.vendor!.latitude ?? 0.0,
                currentOrder.value.vendor!.longitude ?? 0.0),
            icon: departureIcon!);

        markers.remove("Destination");
        markers['Destination'] = Marker(
            markerId: const MarkerId('Destination'),
            infoWindow: const InfoWindow(title: "Destination"),
            position: LatLng(
                currentOrder.value.address!.location!.latitude ?? 0.0,
                currentOrder.value.address!.location!.longitude ?? 0.0),
            icon: destinationIcon!);

        markers.remove("Driver");
        markers['Driver'] = Marker(
            markerId: const MarkerId('Driver'),
            infoWindow: const InfoWindow(title: "Driver"),
            position: LatLng(driverModel.value.location!.latitude ?? 0.0,
                driverModel.value.location!.longitude ?? 0.0),
            icon: taxiIcon!,
            rotation: double.parse(driverModel.value.rotation.toString()));
        addPolyLine(polylineCoordinates);
      }
    }
  }

  addPolyLine(List<LatLng> polylineCoordinates) {
    // mapOsmController.clearAllRoads();
    PolylineId id = const PolylineId("poly");
    Polyline polyline = Polyline(
      polylineId: id,
      color: AppThemeData.secondary300,
      points: polylineCoordinates,
      width: 8,
      geodesic: true,
    );
    polyLines[id] = polyline;
    update();
    updateCameraLocation(polylineCoordinates.first, mapController);
  }

  Future<void> updateCameraLocation(
    LatLng source,
    GoogleMapController? mapController,
  ) async {
    mapController!.animateCamera(
      CameraUpdate.newCameraPosition(
        CameraPosition(
          target: source,
          zoom: currentOrder.value.id == null ||
                  currentOrder.value.status == Constant.driverPending
              ? 16
              : 20,
          bearing: double.parse(driverModel.value.rotation.toString()),
        ),
      ),
    );
  }

  void animateToSource() {
    osmMapController.move(
        location.LatLng(driverModel.value.location!.latitude ?? 0.0,
            driverModel.value.location!.longitude ?? 0.0),
        16);
  }

  Rx<location.LatLng> source =
      location.LatLng(21.1702, 72.8311).obs; // Start (e.g., Surat)
  Rx<location.LatLng> current =
      location.LatLng(21.1800, 72.8400).obs; // Moving marker
  Rx<location.LatLng> destination =
      location.LatLng(21.2000, 72.8600).obs; // Destination

  setOsmMapMarker() {
    osmMarkers.value = [
      flutterMap.Marker(
        point: current.value,
        width: 45,
        height: 45,
        rotate: true,
        child: Image.asset('assets/images/food_delivery.png'),
      ),
      flutterMap.Marker(
        point: source.value,
        width: 40,
        height: 40,
        child: Image.asset('assets/images/location_black3x.png'),
      ),
      flutterMap.Marker(
        point: destination.value,
        width: 40,
        height: 40,
        child: Image.asset('assets/images/location_orange3x.png'),
      )
    ];
  }

  void getOSMPolyline() async {
    try {
      if (currentOrder.value.id != null) {
        if (currentOrder.value.status != Constant.driverPending) {
          print(
              "Order Status :: ${currentOrder.value.status} :: OrderId :: ${currentOrder.value.id}} ::");
          if (currentOrder.value.status == Constant.orderShipped) {
            current.value = location.LatLng(
                driverModel.value.location!.latitude ?? 0.0,
                driverModel.value.location!.longitude ?? 0.0);
            destination.value = location.LatLng(
              currentOrder.value.vendor!.latitude ?? 0.0,
              currentOrder.value.vendor!.longitude ?? 0.0,
            );
            animateToSource();
            fetchRoute(current.value, destination.value).then((value) {
              setOsmMapMarker();
            });
          } else if (currentOrder.value.status == Constant.orderInTransit) {
            print(
                ":::::::::::::${currentOrder.value.status}::::::::::::::::::44");
            current.value = location.LatLng(
                driverModel.value.location!.latitude ?? 0.0,
                driverModel.value.location!.longitude ?? 0.0);
            destination.value = location.LatLng(
              currentOrder.value.address!.location!.latitude ?? 0.0,
              currentOrder.value.address!.location!.longitude ?? 0.0,
            );
            setOsmMapMarker();
            fetchRoute(current.value, destination.value).then((value) {
              setOsmMapMarker();
            });
            animateToSource();
          }
        } else {
          print("====>5");
          current.value = location.LatLng(
              currentOrder.value.author!.location!.latitude ?? 0.0,
              currentOrder.value.author!.location!.longitude ?? 0.0);

          destination.value = location.LatLng(
              currentOrder.value.vendor!.latitude ?? 0.0,
              currentOrder.value.vendor!.longitude ?? 0.0);
          animateToSource();
          fetchRoute(current.value, destination.value).then((value) {
            setOsmMapMarker();
          });
          animateToSource();
        }
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  RxList<location.LatLng> routePoints = <location.LatLng>[].obs;
  Future<void> fetchRoute(
      location.LatLng source, location.LatLng destination) async {
    final url = Uri.parse(
      'https://router.project-osrm.org/route/v1/driving/${source.longitude},${source.latitude};${destination.longitude},${destination.latitude}?overview=full&geometries=geojson',
    );

    final response = await http.get(url);

    if (response.statusCode == 200) {
      final decoded = json.decode(response.body);
      final geometry = decoded['routes'][0]['geometry']['coordinates'];

      routePoints.clear();
      for (var coord in geometry) {
        final lon = coord[0];
        final lat = coord[1];
        routePoints.add(location.LatLng(lat, lon));
      }
    } else {
      print("Failed to get route: ${response.body}");
    }
  }
}
