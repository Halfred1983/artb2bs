part of 'payment_bloc.dart';


enum PaymentStatus {initial, loading, success, failure }

class PaymentState extends Equatable {
  final PaymentStatus status;
  final CardFieldInputDetails cardFieldInputDetails;
  const PaymentState({
    this.status = PaymentStatus.initial,
    this.cardFieldInputDetails = const CardFieldInputDetails(complete: false)
  });

  @override
  List<Object> get props => [status, cardFieldInputDetails];

  PaymentState copyWith({required PaymentStatus status}) {
    return PaymentState(status: status);
  }
}
