part of 'payment_bloc.dart';

abstract class PaymentEvent extends Equatable {
  const PaymentEvent();

  @override
  List<Object> get props => [];
}

class PaymentStart extends PaymentEvent {}
class PaymentCreateIntent extends PaymentEvent {
  final BillingDetails billingDetails;
  final String grandTotal;

  const PaymentCreateIntent({required this.billingDetails, required this.grandTotal});

  @override
  List<Object> get props => [billingDetails, grandTotal];

}
class PaymentConfirmIntent extends PaymentEvent {
  final String clientSecret;

  const PaymentConfirmIntent({required this.clientSecret});

  @override
  List<Object> get props => [clientSecret];
}