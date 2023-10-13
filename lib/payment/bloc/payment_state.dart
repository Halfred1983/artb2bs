part of 'payment_bloc.dart';


enum PaymentStatus {initial, loading, success, failure }

class PaymentState extends Equatable {
  final PaymentStatus status;
  final CardFieldInputDetails cardFieldInputDetails;
  final String? paymentIntentId;

  const PaymentState({
    this.status = PaymentStatus.initial,
    this.cardFieldInputDetails = const CardFieldInputDetails(complete: false),
    this.paymentIntentId = ''
  });

  @override
  List<Object> get props => [status, cardFieldInputDetails];

  PaymentState copyWith({required PaymentStatus status, required String paymentIntentId}) {
    return PaymentState(status: status, paymentIntentId: paymentIntentId);
  }

  // PaymentState copyWithPaymentIntentId({required String paymentIntenId}) {
  //   return PaymentState(paymentIntentId: paymentIntenId);
  // }
}
