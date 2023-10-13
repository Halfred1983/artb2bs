import 'dart:async';
import 'dart:convert';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:http/http.dart' as http;
import 'package:copy_with_extension/copy_with_extension.dart';

part 'payment_event.dart';
part 'payment_state.dart';

class PaymentBloc extends Bloc<PaymentEvent, PaymentState> {
  PaymentBloc() : super(const PaymentState()) {
    on<PaymentStart>(_onPaymentStart);
    on<PaymentCreateIntent>(_onPaymentCreateIntent);
    on<PaymentConfirmIntent>(_onPaymentConfirmIntent);
  }

  void _onPaymentStart(
      PaymentStart event,
      Emitter<PaymentState> emit) {
    emit(state.copyWith(status: PaymentStatus.initial, paymentIntentId: ''));
  }

  void _onPaymentCreateIntent(
      PaymentCreateIntent event,
      Emitter<PaymentState> emit) async {
    emit(state.copyWith(status: PaymentStatus.loading, paymentIntentId: ''));

    final paymentMethod = await Stripe.instance.createPaymentMethod(
        params: PaymentMethodParams.card(paymentMethodData:
        PaymentMethodData(billingDetails: event.billingDetails))
    );

    final paymentIntentResult = await _callPayEndpointMethodId(
        useStripeSdk: true,
        paymentMethodId: paymentMethod.id,
        currency: 'gbp',
        grandTotal: event.grandTotal
    );

    if(paymentIntentResult['error'] != null) {
      emit(state.copyWith(status: PaymentStatus.failure, paymentIntentId: ''));
    }

    if(paymentIntentResult['clientSecret'] != null &&
        paymentIntentResult['requiresAction'] == null) {

      PaymentState newState = state.copyWith(status: PaymentStatus.success,
          paymentIntentId: paymentIntentResult['paymentIntentId']);
      emit(newState);
    }

    if(paymentIntentResult['clientSecret'] != null &&
        paymentIntentResult['requiresAction'] != null) {

      final String clientSecret = paymentIntentResult['clientSecret'];
      add(PaymentConfirmIntent(clientSecret: clientSecret));
    }
  }

  void _onPaymentConfirmIntent(
      PaymentConfirmIntent event,
      Emitter<PaymentState> emit) async {
    try{
      final paymentIntent = await Stripe.instance.handleNextAction(event.clientSecret);

      if(paymentIntent.status == PaymentIntentsStatus.RequiresConfirmation) {
        Map<String, dynamic> results = await _callPayEndpointIntentId(
          paymentIntentId: paymentIntent.id,
        );

        if(results['error'] != null) {
          emit(state.copyWith(status: PaymentStatus.failure, paymentIntentId: ''));
        }
        else {
          emit(state.copyWith(status: PaymentStatus.success, paymentIntentId: paymentIntent.id));
        }
      }
    }
    catch(e) {
      print(e);
      emit(state.copyWith(status: PaymentStatus.failure, paymentIntentId: ''));
    }
  }


  Future <Map<String, dynamic>> _callPayEndpointIntentId({
    required String paymentIntentId,
  }) async {

    final url = Uri.parse('https://us-central1-artb2b-34af2.cloudfunctions.net/StripePayEndpointIntentId');

    final response = await http.post(
        url,
        headers: {
          'Content-Type':'application/json'
        },
        body: json.encode({
          'paymentIntentId':paymentIntentId,
        })
    );

    return json.decode(response.body);
  }

  Future <Map<String, dynamic>> _callPayEndpointMethodId({
    required bool useStripeSdk,
    required String paymentMethodId,
    required String currency,
    String? grandTotal}) async {

    final url = Uri.parse('https://us-central1-artb2b-34af2.cloudfunctions.net/StripePayEndpointMethodId');

    final response = await http.post(
        url,
        headers: {
          'Content-Type':'application/json'
        },
        body: json.encode({
          'useStripeSdk':useStripeSdk,
          'paymentMethodId': paymentMethodId,
          'currency': currency,
          'grandTotal': grandTotal,
        })
    );

    return json.decode(response.body);
  }
}
