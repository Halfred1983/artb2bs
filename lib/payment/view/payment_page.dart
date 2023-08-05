import 'package:artb2b/payment/bloc/payment_bloc.dart';
import 'package:artb2b/utils/common.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_stripe/flutter_stripe.dart';

import '../../app/resources/styles.dart';
import '../../widgets/loading_screen.dart';

class PaymentPage extends StatelessWidget {
  const PaymentPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => PaymentBloc(),
      child: Scaffold(
          appBar: AppBar(
            title: Text("Booking Page", style: TextStyles.boldAccent24,),
            centerTitle: true,
          ),
          body: BlocBuilder<PaymentBloc, PaymentState>(
            builder: (context, state) {
              CardFormEditController controller = CardFormEditController(
                initialDetails: state.cardFieldInputDetails,
              );
              if (state.status == PaymentStatus.initial) {
                return Padding(
                  padding: horizontalPadding24,
                  child: Column(
                    children: [
                      const Text('Card Form'),
                      verticalMargin24,
                      CardFormField(controller: controller,),
                      ElevatedButton(

                        onPressed:
                            () {
                          (controller.details.complete) ?
                          context.read<PaymentBloc>().add(
                            const PaymentCreateIntent(
                                billingDetails: BillingDetails(email: 'alfsalvati@gmail.com'),
                                items: [
                                  {'id':'0'},
                                  {'id':'0'},
                                  {'id':'0'},
                                ]
                            ),
                          ) :
                          ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('Please fill the info'))
                          );
                          // context.read<BookingCubit>().save();
                        },
                        child: Text("Pay", style: TextStyles.boldWhite16,),)

                    ],
                  ),
                );
              }
              if(state.status == PaymentStatus.success) {
                return Padding(
                  padding: horizontalPadding24,
                  child: Column(
                    children: [
                      const Text('Payment Successful'),
                      verticalMargin24,
                      CardFormField(controller: CardFormEditController(),),
                      ElevatedButton(
                        onPressed:
                            () {
                          context.read<PaymentBloc>().add(PaymentStart());
                        },
                        child: Text("Pay", style: TextStyles.boldWhite16,),)

                    ],
                  ),
                );
              }
              if(state.status == PaymentStatus.failure) {
                return Padding(
                  padding: horizontalPadding24,
                  child: Column(
                    children: [
                      const Text('Payment failed'),
                      verticalMargin24,
                      CardFormField(controller: CardFormEditController(),),
                      ElevatedButton(
                        onPressed:
                            () {
                          context.read<PaymentBloc>().add(PaymentStart());
                        },
                        child: Text("Pay", style: TextStyles.boldWhite16,),)

                    ],
                  ),
                );
              }

              return const LoadingScreen();
            },
          )
      ),
    );
  }
}
