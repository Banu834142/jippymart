import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:restaurant/app/chat_screens/chat_screen.dart';
import 'package:restaurant/constant/constant.dart';
import 'package:restaurant/constant/show_toast_dialog.dart';
import 'package:restaurant/models/inbox_model.dart';
import 'package:restaurant/models/user_model.dart';
import 'package:restaurant/models/vendor_model.dart';
import 'package:restaurant/themes/app_them_data.dart';
import 'package:restaurant/themes/responsive.dart';
import 'package:restaurant/utils/dark_theme_provider.dart';
import 'package:restaurant/utils/fire_store_utils.dart';
import 'package:restaurant/utils/network_image_widget.dart';
import 'package:restaurant/widget/firebase_pagination/src/firestore_pagination.dart';
import 'package:restaurant/widget/firebase_pagination/src/models/view_type.dart';

class RestaurantInboxScreen extends StatelessWidget {
  const RestaurantInboxScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final themeChange = Provider.of<DarkThemeProvider>(context);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: themeChange.getThem()
            ? AppThemeData.surfaceDark
            : AppThemeData.surface,
        centerTitle: false,
        titleSpacing: 0,
        title: Text(
          "Inbox".tr,
          textAlign: TextAlign.start,
          style: TextStyle(
            fontFamily: AppThemeData.medium,
            fontSize: 16,
            color: themeChange.getThem()
                ? AppThemeData.grey50
                : AppThemeData.grey900,
          ),
        ),
      ),
      body: FirestorePagination(
        //item builder type is compulsory.
        physics: const BouncingScrollPhysics(),
        itemBuilder: (context, documentSnapshots, index) {
          final data = documentSnapshots[index].data() as Map<String, dynamic>?;
          InboxModel inboxModel = InboxModel.fromJson(data!);
          return InkWell(
            onTap: () async {
              ShowToastDialog.showLoader("Please wait".tr);

              UserModel? customer = await FireStoreUtils.getUserById(
                  inboxModel.customerId.toString());
              UserModel? restaurantUser = await FireStoreUtils.getUserProfile(
                  inboxModel.restaurantId.toString());
              VendorModel? vendorModel = await FireStoreUtils.getVendorById(
                  restaurantUser!.vendorID.toString());
              ShowToastDialog.closeLoader();

              Get.to(const ChatScreen(), arguments: {
                "customerName": '${customer!.fullName()}',
                "restaurantName": vendorModel!.title,
                "orderId": inboxModel.orderId,
                "restaurantId": restaurantUser.id,
                "customerId": customer.id,
                "customerProfileImage": customer.profilePictureURL,
                "restaurantProfileImage": vendorModel.photo,
                "token": restaurantUser.fcmToken,
                "chatType": inboxModel.chatType,
              });
            },
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 5),
              child: Container(
                decoration: ShapeDecoration(
                  color: themeChange.getThem()
                      ? AppThemeData.grey900
                      : AppThemeData.grey50,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8)),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    children: [
                      ClipRRect(
                        borderRadius:
                            const BorderRadius.all(Radius.circular(10)),
                        child: NetworkImageWidget(
                          imageUrl: inboxModel.customerProfileImage.toString(),
                          fit: BoxFit.cover,
                          height: Responsive.height(6, context),
                          width: Responsive.width(12, context),
                        ),
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Expanded(
                                  child: Text(
                                    "${inboxModel.customerName}",
                                    textAlign: TextAlign.start,
                                    style: TextStyle(
                                      fontFamily: AppThemeData.semiBold,
                                      fontSize: 16,
                                      color: themeChange.getThem()
                                          ? AppThemeData.grey100
                                          : AppThemeData.grey800,
                                    ),
                                  ),
                                ),
                                Text(
                                  Constant.timestampToDate(
                                      inboxModel.createdAt!),
                                  textAlign: TextAlign.start,
                                  style: TextStyle(
                                    fontFamily: AppThemeData.regular,
                                    fontSize: 16,
                                    color: themeChange.getThem()
                                        ? AppThemeData.grey400
                                        : AppThemeData.grey500,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(
                              height: 5,
                            ),
                            Text(
                              "${inboxModel.lastMessage}",
                              textAlign: TextAlign.start,
                              style: TextStyle(
                                fontFamily: AppThemeData.medium,
                                fontSize: 14,
                                color: themeChange.getThem()
                                    ? AppThemeData.grey200
                                    : AppThemeData.grey700,
                              ),
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
        shrinkWrap: true,
        onEmpty: Constant.showEmptyView(message: "No Conversion found".tr),
        // orderBy is compulsory to enable pagination
        query: FirebaseFirestore.instance
            .collection('chat_restaurant')
            .where("restaurantId", isEqualTo: FireStoreUtils.getCurrentUid())
            .orderBy('createdAt', descending: true),
        //Change types customerId
        initialLoader: Constant.loader(),
        // to fetch real-time data
        isLive: true,
        viewType: ViewType.list,
      ),
    );
  }
}
