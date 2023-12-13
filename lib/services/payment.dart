import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:stripe_payment/stripe_payment.dart';

class StripeTransactionResponse {
  String message;
  bool success;
  StripeTransactionResponse({
    required this.message,
    required this.success,
  });
}

class StripeServices {
  static String apiBase = 'https://api.stripe.com/v1';
  static String paymentApiUrl = '${StripeServices.apiBase}/payment_intents';
  static Uri paymentApiUri = Uri.parse(paymentApiUrl);
  static String secret =
      'sk_test_51JDZiMBpOuUb6HqhobRyLRA12lSqPtePRSM3qrviNPQSw7SbL7yoJGnd4jxu1gVPgBTvfo4lOQmnc2NDcaVleLvA00vbPjjXGJ';

  static Map<String, String> headers = {
    'Authorization': 'Bearer ${StripeServices.secret}',
    'Content-Type': 'application/x-www-form-urlencoded'
  };

  static init() {
    StripePayment.setOptions(StripeOptions(
        publishableKey:
            'pk_test_51JDZiMBpOuUb6HqhhK5zuUO1bd74XAnXFxQcllfVYxJcVZLIiLDLLe4P3mHSZC8VfB239QvZsT6UZWtXm4ulhZKl00OOCG2VRU',
        androidPayMode: 'test',
        merchantId: 'test'));
  }

  static Future<Map<String, dynamic>> createPaymentIntent(
      String amount, String currency) async {
    try {
      Map<String, dynamic> body = {
        'amount': amount,
        'currency': currency,
      };

      var response =
          await http.post(paymentApiUri, headers: headers, body: body);
      return jsonDecode(response.body);
    } catch (error) {
      print('error Happened');
      throw error;
    }
  }

  static Future<StripeTransactionResponse> payNowHandler(
      {required String amount, required String currency}) async {
    try {
      var paymentMethod = await StripePayment.paymentRequestWithCardForm(
          CardFormPaymentRequest());
      var paymentIntent =
          await StripeServices.createPaymentIntent(amount, currency);
      var response = await StripePayment.confirmPaymentIntent(PaymentIntent(
          clientSecret: paymentIntent['client_secret'],
          paymentMethodId: paymentMethod.id));

      if (response.status == 'succeeded') {
        return StripeTransactionResponse(
            message: 'Transaction successful ', success: true);
      } else {
        return StripeTransactionResponse(
            message: 'Transaction failed: ${response.status}', success: false);
      }
    } on PlatformException catch (error) {
      return StripeServices.getErrorAndAnalyze(error);
    } catch (error) {
      return StripeTransactionResponse(
          message: 'Transaction failed in the catch block ', success: false);
    }
  }

  static Future<StripeTransactionResponse> choseExistingCard(
      {String amount, String currency, CreditCard card}) async {
    try {
      var stripePaymentMethod = await StripePayment.createPaymentMethod(
          PaymentMethodRequest(card: card));
      var stripePaymentIntent =
          await StripeServices.createPaymentIntent(amount, currency);
      var response = await StripePayment.confirmPaymentIntent(PaymentIntent(
          clientSecret: stripePaymentIntent['client_secret'],
          paymentMethodId: stripePaymentMethod.id));

      if (response.status == 'succeeded') {
        //if the payment process success
        return new StripeTransactionResponse(
            message: 'Transaction successful', success: true);
      } else {
        //payment process fail
        return new StripeTransactionResponse(
            message: 'Transaction failed', success: false);
      }
    } on PlatformException catch (error) {
      return StripeServices.getErrorAndAnalyze(error);
    } catch (error) {
      return new StripeTransactionResponse(
          //convert the error to string and assign to message variable for json resposne
          message: 'Transaction failed: ${error.toString()}',
          success: false);
    }
  }

  static getErrorAndAnalyze(err) {
    String message = 'Something went wrong';
    if (err.code == 'cancelled') {
      message = 'Transaction canceled';
    }
    return StripeTransactionResponse(message: message, success: false);
  }
}
