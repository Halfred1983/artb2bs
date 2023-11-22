import 'package:artb2b/booking/cubit/booking_state.dart';
import 'package:artb2b/payment/bloc/payment_bloc.dart';
import 'package:artb2b/utils/common.dart';
import 'package:auth_service/auth.dart';
import 'package:confetti/confetti.dart';
import 'package:database_service/database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:lottie/lottie.dart';

import '../../app/resources/styles.dart';
import '../../app/resources/theme.dart';
import '../../booking/cubit/booking_cubit.dart';
import '../../booking/service/booking_service.dart';
import '../../injection.dart';
import '../../widgets/summary_card.dart';

class PaymentPage extends StatefulWidget {
  PaymentPage({super.key, required this.booking, required this.user, required this.host});
  final Booking booking;
  final User user;
  final User host;

  @override
  State<PaymentPage> createState() => _PaymentPageState();
}

class _PaymentPageState extends State<PaymentPage> {
  final FirebaseAuthService authService = locator<FirebaseAuthService>();

  final FirestoreDatabaseService databaseService = locator<FirestoreDatabaseService>();
  late ConfettiController _controllerCenter;

  @override
  void initState() {
    super.initState();
    _controllerCenter =
        ConfettiController(duration: const Duration(seconds: 10));
  }

  @override
  void dispose() {
    _controllerCenter.dispose();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => PaymentBloc(),
        ),
        BlocProvider<BookingCubit>(
            create: (context) => BookingCubit(
              databaseService: databaseService,
              userId: authService.getUser().id,
            )),
      ],
      child: Scaffold(
          appBar: AppBar(
            title: Text("Finalise your booking", style: TextStyles.boldAccent24,),
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
                      Text('Total (GBP): ${widget.booking.totalPrice!}', style: TextStyles.boldAccent16,),
                      verticalMargin24,
                      CardFormField(
                        controller: controller,
                        style: CardFormStyle(
                            borderColor: AppTheme.primaryColourViolet,
                            cursorColor: AppTheme.accentColourOrange,
                            textColor: AppTheme.primaryColourViolet,
                            textErrorColor: AppTheme.accentColourOrange,
                            fontSize: 16
                        ),
                        countryCode: 'en_GB',

                      ),
                      Expanded(child: Container()),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(

                          onPressed:
                              () {
                            (controller.details.complete) ?
                            context.read<PaymentBloc>().add(
                              PaymentCreateIntent(
                                billingDetails: BillingDetails(
                                  email: widget.user.email,
                                ),
                                grandTotal: BookingService().toStripeInt(widget.booking.totalPrice!).toString(),
                              ),
                            ) :
                            ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text('Please fill the info', style: TextStyles.semiBoldWhite16,),
                                  backgroundColor: AppTheme.accentColor,)
                            );
                            // context.read<BookingCubit>().save();
                          },
                          child: Text("Pay", style: TextStyles.boldWhite16,),),
                      ),
                      verticalMargin32
                    ],
                  ),
                );
              }
              if(state.status == PaymentStatus.success) {
                context.read<BookingCubit>().completeBooking(widget.booking, widget.user, widget.host, state.paymentIntentId!);

                return BlocBuilder<BookingCubit, BookingState>(
                    builder: (context, state) {
                      // if( state is PaymentLoadingState) {
                      //
                      // }
                      if (state is PaymentLoadedState) {
                        User user = state.props[0] as User;
                        Booking booking = state.props[1] as Booking;

                        _controllerCenter.play();

                        return Padding(
                          padding: horizontalPadding24 + verticalPadding24,
                          child: Column(
                            children: [
                              Align(
                                alignment: Alignment.center,
                                child: ConfettiWidget(
                                  confettiController: _controllerCenter,
                                  blastDirectionality: BlastDirectionality
                                      .explosive, // don't specify a direction, blast randomly
                                  shouldLoop:
                                  true, // start again as soon as the animation is finished
                                  colors: const [
                                    Colors.green,
                                    Colors.blue,
                                    Colors.pink,
                                    Colors.orange,
                                    Colors.purple
                                  ], // manually specify the colors to be used
                                  // createParticlePath: drawStar, // define a custom shape/path.
                                ),
                              ),
                              Text('Thank you, ${user.firstName}!', style: TextStyles.semiBoldViolet21,),
                              verticalMargin24,
                              Text('Your booking is complete!', style: TextStyles.semiBoldViolet21,),
                              verticalMargin32,
                              SummaryCard(booking: booking, host: widget.host),
                              verticalMargin12,
                              Text('Your booking id is:', style: TextStyles.semiBoldAccent16,),
                              verticalMargin12,
                              SelectableText(booking.bookingId!, style: TextStyles.semiBoldViolet16,),
                              Expanded(child: Container()),
                              ElevatedButton(
                                onPressed:
                                    () {
                                      _controllerCenter.stop();
                                  Navigator.of(context)..pop()..pop();
                                },
                                child: Text("OK", style: TextStyles.boldWhite16,),)

                            ],
                          ),
                        );
                      }
                      return Container();
                    });
              }
              if(state.status == PaymentStatus.failure) {
                return Padding(
                  padding: horizontalPadding24,
                  child: Column(
                    children: [
                      Text('Sorry, the payment failed!', style:TextStyles.semiBoldViolet21 ,),
                      verticalMargin24,
                      verticalMargin24,
                      ElevatedButton(
                        onPressed:
                            () {
                          context.read<PaymentBloc>().add(PaymentStart());
                        },
                        child: Text("Try again", style: TextStyles.boldWhite16,),)
                    ],
                  ),
                );
              }

              return Scaffold(
                body: Padding(
                    padding: horizontalPadding24 + verticalPadding24,
                    child:Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text("We are processing your payment!",
                          style: TextStyles.semiBoldAccent16,),
                        verticalMargin12,
                        Text("Please don't close the page!",
                          style: TextStyles.semiBoldAccent16,),
                        verticalMargin32,
                        Lottie.asset(
                          'assets/loading.json',
                          fit: BoxFit.fill,
                        ),
                      ],
                    )
                ),
              );
            },
          )
      ),
    );
  }
}
