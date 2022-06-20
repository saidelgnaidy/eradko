// ignore_for_file: avoid_print

import 'dart:convert';
import 'package:eradko/orders/successful_order.dart';
import 'package:eradko/payment/cant_pay_dialog.dart';
import 'package:eradko/payment/payment_method_model.dart';
import 'package:eradko/provider/app_url.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:myfatoorah_flutter/myfatoorah_flutter.dart';
import 'package:myfatoorah_flutter/utils/MFCountry.dart';
import 'package:myfatoorah_flutter/utils/MFEnvironment.dart';

class PaymentProvider extends ChangeNotifier {
  static String mAPIKey =
      "rLtt6JWvbUHDDhsZnfpAhpYk4dxYDQkbcPTyGaKp2TYqQgG7FGZ5Th_WD53Oq8Ebz6A53njUoo1w3pjU1D4vs_ZMqFiz_j0urb_BH9Oq9VZoKFoJEDAbRZepGcQanImyYrry7Kt6MnMdgfG5jn4HngWoRdKduNNyP4kzcp3mRv7x00ahkm9LAK7ZRieg7k1PDAnBIOG3EyVSJ5kK4WLMvYr7sCwHbHcu4A5WwelxYK0GMJy37bNAarSJDFQsJ2ZvJjvMDmfWwDVFEVe_5tOomfVNt6bOg9mexbGjMrnHBnKnZR1vQbBtQieDlQepzTZMuQrSuKn-t5XZM7V6fCW7oP-uXGX-sMOajeX65JOf6XVpk29DP6ro8WTAflCDANC193yof8-f5_EYY-3hXhJj7RBXmizDpneEQDSaSz5sFk0sV5qPcARJ9zGG73vuGFyenjPPmtDtXtpx35A-BVcOSBYVIWe9kndG3nclfefjKEuZ3m4jL9Gg1h2JBvmXSMYiZtp9MR5I6pvbvylU_PP5xJFSjVTIz7IQSjcVGO41npnwIxRXNRxFOdIUHn0tjQ-7LwvEcTXyPsHXcMD8WtgBh-wxR8aKX7WPSsT1O8d8reb2aR7K3rkV3K82K_0OgawImEpwSvp9MNKynEAJQS6ZHe_J_l77652xwPNxMRTMASk1ZsJL";

  PaymentMethodsList _paymentList = PaymentMethodsList(data: []);
  PaymentMethodsList get paymentList => _paymentList;
  PaymentResMap get paymentResMap => _paymentResMap;
  int? _selectedAddress;
  int? get selectedAddress => _selectedAddress;
  PaymentResMap _paymentResMap = PaymentResMap(paymentMethodsList: PaymentMethodsList(data: []), message: 'Failed', status: false);
  String paymentErrorMag = '';

  setDeliveryAddress(int addressId) {
    _selectedAddress = addressId;
    notifyListeners();
  }

  resetErrorMsg() {
    paymentErrorMag = '';
    notifyListeners();
  }

  Future<String> get bearerToken async {
    var bearer = await getToken().then((value) {
      return 'Bearer ${value!}';
    });
    return bearer;
  }

  Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('token');
  }

  Future<PaymentResMap> getPaymentMethods({required String locale}) async {
    try {
      http.Response response = await http.get(
        Uri.parse(AppUrl.paymentMethods),
        headers: {
          'accept': 'application/json',
          'locale': locale,
          'Authorization': await bearerToken,
        },
      );
      if (response.statusCode == 200) {
        _paymentList = paymentMethodsFromJson(response.body);
        _paymentResMap = PaymentResMap(paymentMethodsList: _paymentList, message: 'Success', status: true);
      } else if (response.statusCode == 401) {
        _paymentResMap = PaymentResMap(paymentMethodsList: _paymentList, message: 'UnAuthorized', status: false);
      } else {
        _paymentResMap = PaymentResMap(paymentMethodsList: _paymentList, message: jsonDecode(response.body).toString(), status: false);
      }
    } catch (e) {
      _paymentResMap = PaymentResMap(paymentMethodsList: _paymentList, message: 'SocketException', status: false);
      if (kDebugMode) {
        print(e);
      }
    }

    return _paymentResMap;
  }

  Future<OrderResponse> addNewOrder({required String methodId, required String addressId, required String locale}) async {
    OrderResponse orderResponse = OrderResponse(
      message: '',
      status: false,
    );
    try {
      http.Response response = await http.post(
        Uri.parse(AppUrl.orders),
        headers: {
          'accept': 'application/json',
          'locale': locale,
          'Authorization': await bearerToken,
        },
        body: {
          'address_id': addressId,
          'payment_method_id': '2',
        },
      );
      var decoded = jsonDecode(response.body);
      print(decoded);
      if (response.statusCode == 200) {
        orderResponse = OrderResponse(message: decoded['message'], status: true, receipt: decoded['order']['receipt']);
      } else {
        orderResponse = OrderResponse(message: decoded['message'], status: false);
      }
    } catch (e) {
      orderResponse = OrderResponse(message: locale == 'ar' ? 'تأكد من اتصالك و حاول مجددا' : 'Check your Connection', status: false);
    }

    return orderResponse;
  }

  void initiatePayment({required String amount}) {
    MFSDK.init(PaymentProvider.mAPIKey, MFCountry.SAUDI_ARABIA, MFEnvironment.TEST);

    var request = MFInitiatePaymentRequest(double.parse(amount), MFCurrencyISO.SAUDI_ARABIA_SAR);
    MFSDK.initiatePayment(request, MFAPILanguage.EN, (MFResult<MFInitiatePaymentResponse> result) {
      if (kDebugMode) {
        print(result.response!.toJson());
      }
    });
  }

  Future executeRegularPayment(
      {required BuildContext context, required double amount, required int methodId, required String locale, required int addressId}) async {
    resetErrorMsg();
    var request = MFExecutePaymentRequest(methodId, amount);
    MFSDK.executePayment(context, request, MFAPILanguage.AR, onPaymentResponse: (String invoiceId, MFResult<MFPaymentStatusResponse> result) async {
      if (result.isSuccess()) {
        await addNewOrder(methodId: '$methodId', addressId: '$addressId', locale: locale).then((value) {
          print(value.receipt);
          Navigator.push(context, MaterialPageRoute(builder: (_) => SuccessfulOrder(orderNumber: value.receipt ?? '', step: 1)));
        });
        print('********************* successfully paid ********************* InvoiceId : ${result.response!.invoiceId}');
      } else {
        print('********************* Failed to Pay *********************');
        print(result.error!.toJson());
        if (result.error!.message! != 'User clicked back button') {
          showCantPayDialog(context: context, message: result.error!.message!);
        }
      }
    });
  }

  Future executeDirectPayment(
      {required int paymentMethodId,
      required MFCardInfo mfCardInfo,
      required BuildContext context,
      required double amount,
      required String locale,
      required int addressId}) async {
    resetErrorMsg();
    var request = MFExecutePaymentRequest(paymentMethodId, amount);

    MFSDK.executeDirectPayment(context, request, mfCardInfo, MFAPILanguage.AR, (String invoiceId, MFResult<MFDirectPaymentResponse> result) async {
      if (result.isSuccess()) {
        await addNewOrder(methodId: '$paymentMethodId', addressId: '$addressId', locale: locale).then((value) {
          print(value.receipt);
          Navigator.push(context, MaterialPageRoute(builder: (_) => SuccessfulOrder(orderNumber: value.receipt ?? '', step: 1)));
        });
        print('********************* successfully paid ********************* InvoiceId : $invoiceId');
      } else {
        print('********************* Failed to Pay *********************');
        print(result.error!.toJson());
        if (result.error!.message! != 'User clicked back button') {
          showCantPayDialog(context: context, message: result.error!.message!);
        }
      }
    });
  }
}

class PaymentResMap {
  final PaymentMethodsList paymentMethodsList;
  final String message;
  final bool status;

  PaymentResMap({required this.paymentMethodsList, required this.message, required this.status});
}

class OrderResponse {
  final bool status;
  final String message;
  final String? receipt;

  OrderResponse({this.receipt, required this.status, required this.message});
}
