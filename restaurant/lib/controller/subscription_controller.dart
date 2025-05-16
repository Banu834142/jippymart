import 'package:get/get.dart';
import 'package:restaurant/app/dash_board_screens/app_not_access_screen.dart';
import 'package:restaurant/app/dash_board_screens/dash_board_screen.dart';
import 'package:restaurant/constant/collection_name.dart';
import 'package:restaurant/controller/dash_board_controller.dart';
import 'package:restaurant/models/subscription_plan_model.dart';
import 'package:restaurant/models/user_model.dart';
import 'package:restaurant/models/vendor_model.dart';
import 'package:restaurant/utils/fire_store_utils.dart';
import 'dart:convert';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
import 'package:restaurant/constant/constant.dart';
import 'package:restaurant/constant/show_toast_dialog.dart';
import 'package:restaurant/controller/stripe_failed_model.dart';
import 'package:restaurant/models/payment_model/flutter_wave_model.dart';
import 'package:restaurant/models/payment_model/getPaytmTxtToken.dart';
import 'package:restaurant/models/payment_model/mercado_pago_model.dart';
import 'package:restaurant/models/payment_model/mid_trans.dart';
import 'package:restaurant/models/payment_model/orange_money.dart';
import 'package:restaurant/models/payment_model/pay_fast_model.dart';
import 'package:restaurant/models/payment_model/pay_stack_model.dart';
import 'package:restaurant/models/payment_model/paypal_model.dart';
import 'package:restaurant/models/payment_model/paytm_model.dart';
import 'package:restaurant/models/payment_model/razorpay_model.dart';
import 'package:restaurant/models/payment_model/stripe_model.dart';
import 'package:restaurant/models/payment_model/wallet_setting_model.dart';
import 'package:restaurant/models/payment_model/xendit.dart';
import 'package:restaurant/models/subscription_history.dart';
import 'package:restaurant/models/wallet_transaction_model.dart';
import 'package:restaurant/payment/MercadoPagoScreen.dart';
import 'package:restaurant/payment/PayFastScreen.dart';
import 'package:restaurant/payment/midtrans_screen.dart';
import 'package:restaurant/payment/orangePayScreen.dart';
import 'package:restaurant/payment/paystack/pay_stack_screen.dart';
import 'package:restaurant/payment/paystack/pay_stack_url_model.dart';
import 'package:restaurant/payment/paystack/paystack_url_genrater.dart';
import 'package:restaurant/payment/xenditModel.dart';
import 'package:restaurant/payment/xenditScreen.dart';
import 'package:restaurant/themes/app_them_data.dart';
import 'package:restaurant/utils/preferences.dart';
import 'package:flutter_paypal/flutter_paypal.dart';
import 'dart:math' as maths;
import 'package:http/http.dart' as http;

class SubscriptionController extends GetxController {
  RxList<SubscriptionPlanModel> subscriptionPlanList =
      <SubscriptionPlanModel>[].obs;
  Rx<SubscriptionPlanModel> selectedSubscriptionPlan =
      SubscriptionPlanModel().obs;
  RxBool isLoading = true.obs;

  @override
  void onInit() {
    getInitPlanSettings();
    super.onInit();
  }

  getInitPlanSettings() async {
    userModel.value =
        await FireStoreUtils.getUserProfile(FireStoreUtils.getCurrentUid()) ??
            UserModel();

    await FirebaseFirestore.instance
        .collection(CollectionName.settings)
        .doc('restaurant')
        .get()
        .then((value) {
      Constant.autoApproveRestaurant = value.data()!['auto_approve_restaurant'];
      Constant.isSubscriptionModelApplied = value.data()!['subscription_model'];
    });

    await getSubscriptionPlanList();
    getPaymentSettings();
  }

  Future<void> getSubscriptionPlanList() async {
    isLoading.value = true;
    if (Constant.adminCommission?.isEnabled == true) {
      await FireStoreUtils.getSubscriptionPlanById(
              planId: Constant.commissionSubscriptionID)
          .then(
        (value) {
          if (value != null) {
            subscriptionPlanList.add(value);
          }
        },
      );
    }

    if (Constant.isSubscriptionModelApplied) {
      await FireStoreUtils.getAllSubscriptionPlans().then(
        (value) {
          value.forEach(
            (element) {
              subscriptionPlanList.add(element);
            },
          );
        },
      );
    }
    if (userModel.value.subscriptionPlanId == null) {
      selectedSubscriptionPlan.value = subscriptionPlanList.first;
    }
    isLoading.value = false;
  }

  Rx<UserModel> userModel = UserModel().obs;

  RxString selectedPaymentMethod = ''.obs;

  Rx<WalletSettingModel> walletSettingModel = WalletSettingModel().obs;
  Rx<PayFastModel> payFastModel = PayFastModel().obs;
  Rx<MercadoPagoModel> mercadoPagoModel = MercadoPagoModel().obs;
  Rx<PayPalModel> payPalModel = PayPalModel().obs;
  Rx<StripeModel> stripeModel = StripeModel().obs;
  Rx<FlutterWaveModel> flutterWaveModel = FlutterWaveModel().obs;
  Rx<PayStackModel> payStackModel = PayStackModel().obs;
  Rx<PaytmModel> paytmModel = PaytmModel().obs;
  Rx<RazorPayModel> razorPayModel = RazorPayModel().obs;
  Rx<MidTrans> midTransModel = MidTrans().obs;
  Rx<OrangeMoney> orangeMoneyModel = OrangeMoney().obs;
  Rx<Xendit> xenditModel = Xendit().obs;

  final Razorpay razorPay = Razorpay();

  getPaymentSettings() async {
    await FireStoreUtils.getPaymentSettingsData().then(
      (value) {
        stripeModel.value = StripeModel.fromJson(
            jsonDecode(Preferences.getString(Preferences.stripeSettings)));
        payPalModel.value = PayPalModel.fromJson(
            jsonDecode(Preferences.getString(Preferences.paypalSettings)));
        payStackModel.value = PayStackModel.fromJson(
            jsonDecode(Preferences.getString(Preferences.payStack)));
        mercadoPagoModel.value = MercadoPagoModel.fromJson(
            jsonDecode(Preferences.getString(Preferences.mercadoPago)));
        flutterWaveModel.value = FlutterWaveModel.fromJson(
            jsonDecode(Preferences.getString(Preferences.flutterWave)));
        paytmModel.value = PaytmModel.fromJson(
            jsonDecode(Preferences.getString(Preferences.paytmSettings)));
        payFastModel.value = PayFastModel.fromJson(
            jsonDecode(Preferences.getString(Preferences.payFastSettings)));
        razorPayModel.value = RazorPayModel.fromJson(
            jsonDecode(Preferences.getString(Preferences.razorpaySettings)));
        midTransModel.value = MidTrans.fromJson(
            jsonDecode(Preferences.getString(Preferences.midTransSettings)));
        orangeMoneyModel.value = OrangeMoney.fromJson(
            jsonDecode(Preferences.getString(Preferences.orangeMoneySettings)));
        xenditModel.value = Xendit.fromJson(
            jsonDecode(Preferences.getString(Preferences.xenditSettings)));
        walletSettingModel.value = WalletSettingModel.fromJson(
            jsonDecode(Preferences.getString(Preferences.walletSettings)));
        if (stripeModel.value.isEnabled == true) {
          Stripe.publishableKey =
              stripeModel.value.clientpublishableKey.toString();
          Stripe.merchantIdentifier = 'Foodie Restaurant'.tr;
          Stripe.instance.applySettings();
        }
        setRef();

        razorPay.on(Razorpay.EVENT_PAYMENT_SUCCESS, handlePaymentSuccess);
        razorPay.on(Razorpay.EVENT_EXTERNAL_WALLET, handleExternalWaller);
        razorPay.on(Razorpay.EVENT_PAYMENT_ERROR, handlePaymentError);
      },
    );
    if (walletSettingModel.value.isEnabled == true) {
      selectedPaymentMethod.value = PaymentGateway.wallet.name;
    }
    isLoading.value = false;
  }

  void handlePaymentSuccess(PaymentSuccessResponse response) {
    Get.back();
    ShowToastDialog.showToast("Payment Successful!!".tr);
    placeOrder();
  }

  void handleExternalWaller(ExternalWalletResponse response) {
    Get.back();
    ShowToastDialog.showToast("Payment Processing!! via");
  }

  void handlePaymentError(PaymentFailureResponse response) {
    Get.back();
    ShowToastDialog.showToast("Payment Failed!!".tr);
  }

  String? _ref;

  setRef() {
    maths.Random numRef = maths.Random();
    int year = DateTime.now().year;
    int refNumber = numRef.nextInt(20000);
    if (Platform.isAndroid) {
      _ref = "AndroidRef$year$refNumber";
    } else if (Platform.isIOS) {
      _ref = "IOSRef$year$refNumber";
    }
  }

  // Strip
  Future<void> stripeMakePayment({required String amount}) async {
    try {
      Map<String, dynamic>? paymentIntentData =
          await createStripeIntent(amount: amount);

      if (paymentIntentData!.containsKey("error")) {
        Get.back();
        ShowToastDialog.showToast(
            "Something went wrong, please contact admin.".tr);
      } else {
        await Stripe.instance.initPaymentSheet(
            paymentSheetParameters: SetupPaymentSheetParameters(
                paymentIntentClientSecret: paymentIntentData['client_secret'],
                allowsDelayedPaymentMethods: false,
                googlePay: const PaymentSheetGooglePay(
                  merchantCountryCode: 'US',
                  testEnv: true,
                  currencyCode: "USD",
                ),
                customFlow: true,
                style: ThemeMode.system,
                appearance: const PaymentSheetAppearance(
                  colors: PaymentSheetAppearanceColors(
                    primary: AppThemeData.primary300,
                  ),
                ),
                merchantDisplayName: 'GoRide'));
        displayStripePaymentSheet(amount: amount);
      }
    } catch (e, s) {
      ShowToastDialog.showToast("exception:$e \n$s");
    }
  }

  displayStripePaymentSheet({required String amount}) async {
    try {
      await Stripe.instance.presentPaymentSheet().then((value) {
        ShowToastDialog.showToast("Payment successfully".tr);
        Get.back(result: true);
        placeOrder();
      });
    } on StripeException catch (e) {
      var lo1 = jsonEncode(e);
      var lo2 = jsonDecode(lo1);
      StripePayFailedModel lom = StripePayFailedModel.fromJson(lo2);
      ShowToastDialog.showToast(lom.error.message);
    } catch (e) {
      ShowToastDialog.showToast(e.toString());
    }
  }

  createStripeIntent({required String amount}) async {
    try {
      Map<String, dynamic> body = {
        'amount': ((double.parse(amount) * 100).round()).toString(),
        'currency': "USD",
        'payment_method_types[]': 'card',
        "description": "Strip Payment",
        "shipping[name]": userModel.value.fullName(),
        "shipping[address][line1]": "510 Townsend St",
        "shipping[address][postal_code]": "98140",
        "shipping[address][city]": "San Francisco",
        "shipping[address][state]": "CA",
        "shipping[address][country]": "US",
      };
      var stripeSecret = stripeModel.value.stripeSecret;
      var response = await http.post(
          Uri.parse('https://api.stripe.com/v1/payment_intents'),
          body: body,
          headers: {
            'Authorization': 'Bearer $stripeSecret',
            'Content-Type': 'application/x-www-form-urlencoded'
          });

      return jsonDecode(response.body);
    } catch (e) {
      print(e.toString());
    }
  }

  //mercadoo
  mercadoPagoMakePayment(
      {required BuildContext context, required String amount}) async {
    final headers = {
      'Authorization': 'Bearer ${mercadoPagoModel.value.accessToken}',
      'Content-Type': 'application/json',
    };

    final body = jsonEncode({
      "items": [
        {
          "title": "Test",
          "description": "Test Payment",
          "quantity": 1,
          "currency_id": "BRL", // or your preferred currency
          "unit_price": double.parse(amount),
        }
      ],
      "payer": {"email": userModel.value.email},
      "back_urls": {
        "failure": "${Constant.globalUrl}payment/failure",
        "pending": "${Constant.globalUrl}payment/pending",
        "success": "${Constant.globalUrl}payment/success",
      },
      "auto_return":
          "approved" // Automatically return after payment is approved
    });

    final response = await http.post(
      Uri.parse("https://api.mercadopago.com/checkout/preferences"),
      headers: headers,
      body: body,
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      final data = jsonDecode(response.body);
      Get.to(MercadoPagoScreen(initialURl: data['init_point']))!.then((value) {
        if (value) {
          ShowToastDialog.showToast("Payment Successful!!".tr);
          placeOrder();
        } else {
          ShowToastDialog.showToast("Payment UnSuccessful!!".tr);
        }
      });
    } else {
      print('Error creating preference: ${response.body}');
      return null;
    }
  }

//Paypal
  paypalPaymentSheet(String amount, context) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (BuildContext context) => UsePaypal(
            sandboxMode: payPalModel.value.isLive == true ? false : true,
            clientId: payPalModel.value.paypalClient ?? '',
            secretKey: payPalModel.value.paypalSecret ?? '',
            returnURL: "com.parkme://paypalpay",
            cancelURL: "com.parkme://paypalpay",
            transactions: [
              {
                "amount": {
                  "total": amount,
                  "currency": "USD",
                  "details": {"subtotal": amount}
                },
              }
            ],
            note: "Contact us for any questions on your order.",
            onSuccess: (Map params) async {
              placeOrder();
              ShowToastDialog.showToast("Payment Successful!!".tr);
            },
            onError: (error) {
              Get.back();
              ShowToastDialog.showToast("Payment UnSuccessful!!".tr);
            },
            onCancel: (params) {
              Get.back();
              ShowToastDialog.showToast("Payment UnSuccessful!!".tr);
            }),
      ),
    );
  }

  ///PayStack Payment Method
  payStackPayment(String totalAmount) async {
    await PayStackURLGen.payStackURLGen(
            amount: (double.parse(totalAmount) * 100).toString(),
            currency: "ZAR",
            secretKey: payStackModel.value.secretKey.toString(),
            userModel: userModel.value)
        .then((value) async {
      if (value != null) {
        PayStackUrlModel payStackModel0 = value;
        Get.to(PayStackScreen(
          secretKey: payStackModel.value.secretKey.toString(),
          callBackUrl: payStackModel.value.callbackURL.toString(),
          initialURl: payStackModel0.data.authorizationUrl,
          amount: totalAmount,
          reference: payStackModel0.data.reference,
        ))!
            .then((value) {
          if (value) {
            ShowToastDialog.showToast("Payment Successful!!".tr);
            placeOrder();
          } else {
            ShowToastDialog.showToast("Payment UnSuccessful!!".tr);
          }
        });
      } else {
        ShowToastDialog.showToast(
            "Something went wrong, please contact admin.".tr);
      }
    });
  }

  //flutter wave Payment Method
  flutterWaveInitiatePayment(
      {required BuildContext context, required String amount}) async {
    final url = Uri.parse('https://api.flutterwave.com/v3/payments');
    final headers = {
      'Authorization': 'Bearer ${flutterWaveModel.value.secretKey}',
      'Content-Type': 'application/json',
    };

    final body = jsonEncode({
      "tx_ref": _ref,
      "amount": amount,
      "currency": "NGN",
      "redirect_url": "${Constant.globalUrl}payment/success",
      "payment_options": "ussd, card, barter, payattitude",
      "customer": {
        "email": userModel.value.email.toString(),
        "phonenumber": userModel.value.phoneNumber, // Add a real phone number
        "name": userModel.value.fullName(), // Add a real customer name
      },
      "customizations": {
        "title": "Payment for Services",
        "description": "Payment for XYZ services",
      }
    });

    final response = await http.post(url, headers: headers, body: body);

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      Get.to(MercadoPagoScreen(initialURl: data['data']['link']))!
          .then((value) {
        if (value) {
          ShowToastDialog.showToast("Payment Successful!!".tr);
          placeOrder();
        } else {
          ShowToastDialog.showToast("Payment UnSuccessful!!".tr);
        }
      });
    } else {
      print('Payment initialization failed: ${response.body}');
      return null;
    }
  }

  // payFast
  payFastPayment({required BuildContext context, required String amount}) {
    PayStackURLGen.getPayHTML(
            payFastSettingData: payFastModel.value,
            amount: amount.toString(),
            userModel: userModel.value)
        .then((String? value) async {
      bool isDone = await Get.to(PayFastScreen(
          htmlData: value!, payFastSettingData: payFastModel.value));
      if (isDone) {
        Get.back();
        ShowToastDialog.showToast("Payment successfully".tr);
        placeOrder();
      } else {
        Get.back();
        ShowToastDialog.showToast("Payment Failed".tr);
      }
    });
  }

  ///Paytm payment function
  getPaytmCheckSum(context, {required double amount}) async {
    final String orderId = DateTime.now().millisecondsSinceEpoch.toString();
    String getChecksum = "${Constant.globalUrl}payments/getpaytmchecksum";

    final response = await http.post(
        Uri.parse(
          getChecksum,
        ),
        headers: {},
        body: {
          "mid": paytmModel.value.paytmMID.toString(),
          "order_id": orderId,
          "key_secret": paytmModel.value.pAYTMMERCHANTKEY.toString(),
        });

    final data = jsonDecode(response.body);
    await verifyCheckSum(
            checkSum: data["code"], amount: amount, orderId: orderId)
        .then((value) {
      initiatePayment(amount: amount, orderId: orderId).then((value) {
        String callback = "";
        if (paytmModel.value.isSandboxEnabled == true) {
          callback =
              "${callback}https://securegw-stage.paytm.in/theia/paytmCallback?ORDER_ID=$orderId";
        } else {
          callback =
              "${callback}https://securegw.paytm.in/theia/paytmCallback?ORDER_ID=$orderId";
        }

        GetPaymentTxtTokenModel result = value;
        startTransaction(context,
            txnTokenBy: result.body.txnToken,
            orderId: orderId,
            amount: amount,
            callBackURL: callback,
            isStaging: paytmModel.value.isSandboxEnabled);
      });
    });
  }

  Future<void> startTransaction(context,
      {required String txnTokenBy,
      required orderId,
      required double amount,
      required callBackURL,
      required isStaging}) async {
    // try {
    //   var response = AllInOneSdk.startTransaction(
    //     paytmModel.value.paytmMID.toString(),
    //     orderId,
    //     amount.toString(),
    //     txnTokenBy,
    //     callBackURL,
    //     isStaging,
    //     true,
    //     true,
    //   );
    //
    //   response.then((value) {
    //     if (value!["RESPMSG"] == "Txn Success") {
    //       print("txt done!!");
    //       ShowToastDialog.showToast("Payment Successful!!");
    //       placeOrder();
    //     }
    //   }).catchError((onError) {
    //     if (onError is PlatformException) {
    //       Get.back();
    //
    //       ShowToastDialog.showToast(onError.message.toString());
    //     } else {
    //       log("======>>2");
    //       Get.back();
    //       ShowToastDialog.showToast(onError.message.toString());
    //     }
    //   });
    // } catch (err) {
    //   Get.back();
    //   ShowToastDialog.showToast(err.toString());
    // }
  }

  Future verifyCheckSum(
      {required String checkSum,
      required double amount,
      required orderId}) async {
    String getChecksum = "${Constant.globalUrl}payments/validatechecksum";
    final response = await http.post(
        Uri.parse(
          getChecksum,
        ),
        headers: {},
        body: {
          "mid": paytmModel.value.paytmMID.toString(),
          "order_id": orderId,
          "key_secret": paytmModel.value.pAYTMMERCHANTKEY.toString(),
          "checksum_value": checkSum,
        });
    final data = jsonDecode(response.body);
    return data['status'];
  }

  Future<GetPaymentTxtTokenModel> initiatePayment(
      {required double amount, required orderId}) async {
    String initiateURL = "${Constant.globalUrl}payments/initiatepaytmpayment";
    String callback = "";
    if (paytmModel.value.isSandboxEnabled == true) {
      callback =
          "${callback}https://securegw-stage.paytm.in/theia/paytmCallback?ORDER_ID=$orderId";
    } else {
      callback =
          "${callback}https://securegw.paytm.in/theia/paytmCallback?ORDER_ID=$orderId";
    }
    final response =
        await http.post(Uri.parse(initiateURL), headers: {}, body: {
      "mid": paytmModel.value.paytmMID,
      "order_id": orderId,
      "key_secret": paytmModel.value.pAYTMMERCHANTKEY,
      "amount": amount.toString(),
      "currency": "INR",
      "callback_url": callback,
      "custId": FireStoreUtils.getCurrentUid(),
      "issandbox": paytmModel.value.isSandboxEnabled == true ? "1" : "2",
    });

    final data = jsonDecode(response.body);
    if (data["body"]["txnToken"] == null ||
        data["body"]["txnToken"].toString().isEmpty) {
      Get.back();
      ShowToastDialog.showToast(
          "something went wrong, please contact admin.".tr);
    }
    return GetPaymentTxtTokenModel.fromJson(data);
  }

  void openCheckout({required amount, required orderId}) async {
    var options = {
      'key': razorPayModel.value.razorpayKey,
      'amount': amount * 100,
      'name': 'GoRide',
      'order_id': orderId,
      "currency": "INR",
      'description': 'wallet Topup',
      'retry': {'enabled': true, 'max_count': 1},
      'send_sms_hash': true,
      'prefill': {
        'contact': userModel.value.phoneNumber,
        'email': userModel.value.email,
      },
      'external': {
        'wallets': ['paytm']
      }
    };

    try {
      razorPay.open(options);
    } catch (e) {
      debugPrint('Error: $e');
    }
  }

  RxDouble totalAmount = 0.0.obs;

  placeOrder() async {
    setOrder();
  }

  setOrder() async {
    ShowToastDialog.showLoader("Please wait".tr);
    userModel.value.subscriptionPlanId = selectedSubscriptionPlan.value.id;
    userModel.value.subscriptionPlan = selectedSubscriptionPlan.value;
    userModel.value.subscriptionPlan?.createdAt = Timestamp.now();
    userModel.value.subscriptionExpiryDate =
        selectedSubscriptionPlan.value.expiryDay == '-1'
            ? null
            : Constant().addDayInTimestamp(
                days: selectedSubscriptionPlan.value.expiryDay,
                date: Timestamp.now());

    print("====>${userModel.value.vendorID}");
    if (userModel.value.vendorID != null &&
        userModel.value.vendorID!.isNotEmpty) {
      print("====>");
      VendorModel? vendorModel = await FireStoreUtils.getVendorById(
          userModel.value.vendorID.toString());
      if (vendorModel != null) {
        vendorModel.subscriptionPlanId = selectedSubscriptionPlan.value.id;
        vendorModel.subscriptionPlan = selectedSubscriptionPlan.value;
        vendorModel.subscriptionPlan?.createdAt = Timestamp.now();
        vendorModel.subscriptionExpiryDate =
            selectedSubscriptionPlan.value.expiryDay == '-1'
                ? null
                : Constant().addDayInTimestamp(
                    days: selectedSubscriptionPlan.value.expiryDay,
                    date: Timestamp.now());
        vendorModel.subscriptionTotalOrders =
            selectedSubscriptionPlan.value.orderLimit;
      }

      DashBoardController dashBoardController = Get.put(DashBoardController());
      dashBoardController.setPage();

      if (Constant.isDineInEnable &&
          Constant.userModel!.subscriptionPlan?.features?.dineIn != false) {
        dashBoardController.selectedIndex.value = 4;
      } else {
        dashBoardController.selectedIndex.value = 3;
      }
      dashBoardController.update();

      await FireStoreUtils.updateVendor(vendorModel!);
    }

    SubscriptionHistoryModel subscriptionHistoryData = SubscriptionHistoryModel(
        id: Constant.getUuid(),
        createdAt: Timestamp.now(),
        expiryDate: userModel.value.subscriptionExpiryDate,
        subscriptionPlan: userModel.value.subscriptionPlan,
        paymentType: selectedPaymentMethod.value,
        userId: userModel.value.id);

    await FireStoreUtils.setSubscriptionTransaction(subscriptionHistoryData);

    if (selectedPaymentMethod.value == PaymentGateway.wallet.name) {
      WalletTransactionModel transactionModel = WalletTransactionModel(
          id: Constant.getUuid(),
          amount: double.parse(totalAmount.value.toString()),
          date: Timestamp.now(),
          paymentMethod: PaymentGateway.wallet.name,
          transactionUser: "user",
          userId: FireStoreUtils.getCurrentUid(),
          isTopup: false,
          subscriptionId: subscriptionHistoryData.id,
          note: "Subscription Amount debited".tr,
          paymentStatus: "success".tr);

      await FireStoreUtils.setWalletTransaction(transactionModel);
      userModel.value.walletAmount =
          userModel.value.walletAmount! - totalAmount.value;
    }

    await FireStoreUtils.updateUser(userModel.value).then(
      (value) async {
        ShowToastDialog.closeLoader();
        if (userModel.value.subscriptionPlan!.features?.restaurantMobileApp ==
            true) {
          dynamic argumentData = Get.arguments;
          if (argumentData == null) {
            Get.offAll(const DashBoardScreen());
          } else {
            Get.back(result: true);
          }
          ShowToastDialog.showToast(
              "Success! You’ve unlocked your subscription benefits starting today."
                  .tr);
        } else {
          Get.offAll(const AppNotAccessScreen());
        }
      },
    );
  }

  //Midtrans payment
  midtransMakePayment(
      {required String amount, required BuildContext context}) async {
    await createPaymentLink(amount: amount).then((url) {
      ShowToastDialog.closeLoader();
      if (url != '') {
        Get.to(() => MidtransScreen(
                  initialURl: url,
                ))!
            .then((value) {
          if (value == true) {
            ShowToastDialog.showToast("Payment Successful!!".tr);
            placeOrder();
          } else {
            ShowToastDialog.showToast("Payment Unsuccessful!!".tr);
          }
        });
      }
    });
  }

  Future<String> createPaymentLink({required var amount}) async {
    var ordersId = Constant.getUuid();
    final url = Uri.parse(midTransModel.value.isSandbox!
        ? 'https://api.sandbox.midtrans.com/v1/payment-links'
        : 'https://api.midtrans.com/v1/payment-links');

    final response = await http.post(
      url,
      headers: {
        'Accept': 'application/json',
        'Content-Type': 'application/json',
        'Authorization':
            generateBasicAuthHeader(midTransModel.value.serverKey!),
      },
      body: jsonEncode({
        'transaction_details': {
          'order_id': ordersId,
          'gross_amount': double.parse(amount.toString()).toInt(),
        },
        'usage_limit': 2,
        "callbacks": {
          "finish": "https://www.google.com?merchant_order_id=$ordersId"
        },
      }),
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      final responseData = jsonDecode(response.body);
      return responseData['payment_url'];
    } else {
      ShowToastDialog.showToast(
          "something went wrong, please contact admin.".tr);
      return '';
    }
  }

  String generateBasicAuthHeader(String apiKey) {
    String credentials = '$apiKey:';
    String base64Encoded = base64Encode(utf8.encode(credentials));
    return 'Basic $base64Encoded';
  }

  //Orangepay payment
  static String accessToken = '';
  static String payToken = '';
  static String orderId = '';
  static String amount = '';

  orangeMakePayment(
      {required String amount, required BuildContext context}) async {
    reset();
    var id = Constant.getUuid();
    var paymentURL = await fetchToken(
        context: context, orderId: id, amount: amount, currency: 'USD');
    ShowToastDialog.closeLoader();
    if (paymentURL.toString() != '') {
      Get.to(() => OrangeMoneyScreen(
                initialURl: paymentURL,
                accessToken: accessToken,
                amount: amount,
                orangePay: orangeMoneyModel.value,
                orderId: orderId,
                payToken: payToken,
              ))!
          .then((value) {
        if (value == true) {
          ShowToastDialog.showToast("Payment Successful!!".tr);
          placeOrder();
          ();
        }
      });
    } else {
      ShowToastDialog.showToast("Payment Unsuccessful!!".tr);
    }
  }

  Future fetchToken(
      {required String orderId,
      required String currency,
      required BuildContext context,
      required String amount}) async {
    String apiUrl = 'https://api.orange.com/oauth/v3/token';
    Map<String, String> requestBody = {
      'grant_type': 'client_credentials',
    };

    var response = await http.post(Uri.parse(apiUrl),
        headers: <String, String>{
          'Authorization': "Basic ${orangeMoneyModel.value.auth!}",
          'Content-Type': 'application/x-www-form-urlencoded',
          'Accept': 'application/json',
        },
        body: requestBody);

    // Handle the response

    if (response.statusCode == 200) {
      Map<String, dynamic> responseData = jsonDecode(response.body);

      accessToken = responseData['access_token'];
      // ignore: use_build_context_synchronously
      return await webpayment(
          context: context,
          amountData: amount,
          currency: currency,
          orderIdData: orderId);
    } else {
      ShowToastDialog.showToast(
          "Something went wrong, please contact admin.".tr);
      return '';
    }
  }

  Future webpayment(
      {required String orderIdData,
      required BuildContext context,
      required String currency,
      required String amountData}) async {
    orderId = orderIdData;
    amount = amountData;
    String apiUrl = orangeMoneyModel.value.isSandbox! == true
        ? 'https://api.orange.com/orange-money-webpay/dev/v1/webpayment'
        : 'https://api.orange.com/orange-money-webpay/cm/v1/webpayment';
    Map<String, String> requestBody = {
      "merchant_key": orangeMoneyModel.value.merchantKey ?? '',
      "currency": orangeMoneyModel.value.isSandbox == true ? "OUV" : currency,
      "order_id": orderId,
      "amount": amount,
      "reference": 'Y-Note Test',
      "lang": "en",
      "return_url": orangeMoneyModel.value.returnUrl!.toString(),
      "cancel_url": orangeMoneyModel.value.cancelUrl!.toString(),
      "notif_url": orangeMoneyModel.value.notifUrl!.toString(),
    };

    var response = await http.post(
      Uri.parse(apiUrl),
      headers: <String, String>{
        'Authorization': 'Bearer $accessToken',
        'Content-Type': 'application/json',
        'Accept': 'application/json'
      },
      body: json.encode(requestBody),
    );

    // Handle the response
    if (response.statusCode == 201) {
      Map<String, dynamic> responseData = jsonDecode(response.body);
      if (responseData['message'] == 'OK') {
        payToken = responseData['pay_token'];
        return responseData['payment_url'];
      } else {
        return '';
      }
    } else {
      ShowToastDialog.showToast(
          "Something went wrong, please contact admin.".tr);
      return '';
    }
  }

  static reset() {
    accessToken = '';
    payToken = '';
    orderId = '';
    amount = '';
  }

  //XenditPayment
  xenditPayment(context, amount) async {
    await createXenditInvoice(amount: amount).then((model) {
      ShowToastDialog.closeLoader();
      if (model.id != null) {
        Get.to(() => XenditScreen(
                  initialURl: model.invoiceUrl ?? '',
                  transId: model.id ?? '',
                  apiKey: xenditModel.value.apiKey!.toString(),
                ))!
            .then((value) {
          if (value == true) {
            ShowToastDialog.showToast("Payment Successful!!".tr);
            placeOrder();
            ();
          } else {
            ShowToastDialog.showToast("Payment Unsuccessful!!".tr);
          }
        });
      }
    });
  }

  Future<XenditModel> createXenditInvoice({required var amount}) async {
    const url = 'https://api.xendit.co/v2/invoices';
    var headers = {
      'Content-Type': 'application/json',
      'Authorization':
          generateBasicAuthHeader(xenditModel.value.apiKey!.toString()),
      // 'Cookie': '__cf_bm=yERkrx3xDITyFGiou0bbKY1bi7xEwovHNwxV1vCNbVc-1724155511-1.0.1.1-jekyYQmPCwY6vIJ524K0V6_CEw6O.dAwOmQnHtwmaXO_MfTrdnmZMka0KZvjukQgXu5B.K_6FJm47SGOPeWviQ',
    };

    final body = jsonEncode({
      'external_id': Constant.getUuid(),
      'amount': amount,
      'payer_email': 'customer@domain.com',
      'description': 'Test - VA Successful invoice payment',
      'currency': 'IDR', //IDR, PHP, THB, VND, MYR
    });

    try {
      final response =
          await http.post(Uri.parse(url), headers: headers, body: body);

      if (response.statusCode == 200 || response.statusCode == 201) {
        XenditModel model = XenditModel.fromJson(jsonDecode(response.body));
        return model;
      } else {
        return XenditModel();
      }
    } catch (e) {
      return XenditModel();
    }
  }
}

enum PaymentGateway {
  payFast,
  mercadoPago,
  paypal,
  stripe,
  flutterWave,
  payStack,
  paytm,
  razorpay,
  cod,
  wallet,
  midTrans,
  orangeMoney,
  xendit
}
