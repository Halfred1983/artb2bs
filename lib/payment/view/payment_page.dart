import 'package:artb2b/booking/cubit/booking_state.dart';
import 'package:artb2b/home/view/home_page.dart';
import 'package:artb2b/payment/bloc/payment_bloc.dart';
import 'package:artb2b/utils/common.dart';
import 'package:artb2b/utils/currency/currency_helper.dart';
import 'package:artb2b/widgets/loading_screen.dart';
import 'package:auth_service/auth.dart';
import 'package:confetti/confetti.dart';
import 'package:database_service/database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:go_router/go_router.dart';
import 'package:lottie/lottie.dart';

import '../../app/resources/styles.dart';
import '../../app/resources/theme.dart';
import '../../booking/cubit/booking_cubit.dart';
import '../../booking/service/booking_service.dart';
import '../../injection.dart';
import '../../widgets/snackbar.dart';
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
  late CardFormEditController _controller;
  bool _isCardValid = false;

  @override
  void initState() {
    super.initState();
    _controller = CardFormEditController();
    _controller.addListener(_onCardDetailsChanged);
    _controllerCenter =
        ConfettiController(duration: const Duration(seconds: 10));
  }

  @override
  void dispose() {
    _controller.removeListener(_onCardDetailsChanged);
    _controller.dispose();
    _controllerCenter.dispose();
    super.dispose();
  }

  void _onCardDetailsChanged() {
    setState(() {
      _isCardValid = _controller.details.complete;
    });
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
                widget.host,
                databaseService: databaseService,
                userId: authService.getUser().id,
              )),
        ],
        child: BlocBuilder<PaymentBloc, PaymentState>(
          builder: (context, state) {
            CardFormEditController controller = CardFormEditController(
              initialDetails: state.cardFieldInputDetails,
            );
            if (state.status == PaymentStatus.initial) {
              return Scaffold(
                appBar: AppBar(
                  scrolledUnderElevation: 0,
                  title: Text('Finalise your booking', style: TextStyles.boldN90017,),
                  centerTitle: true,
                  backgroundColor: AppTheme.white,
                  iconTheme: const IconThemeData(
                    color: AppTheme.n900, //change your color here
                  ),
                ),
                body: SingleChildScrollView(
                  child: Container(
                    margin: verticalPadding24,
                    padding: horizontalPadding32,
                    color: AppTheme.white,
                    width: MediaQuery.of(context).size.width,
                    height: 700,
                    child: Center(
                      child: Column(
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              verticalMargin24,
                              Text('Price Details', style: TextStyles.boldN90017),
                              verticalMargin24,
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text('${double.parse(widget.host.bookingSettings!.basePrice!)} ${CurrencyHelper.currency(widget.host.userInfo!.address!.country).currencySymbol} x ${widget.booking.spaces} spaces x ${BookingService().daysBetween(widget.booking!.from!, widget.booking!.to!).toString()} days',
                                    style: TextStyles.regularN90014,),
                                  Text('${BookingService().calculatePrice(widget.booking!, widget.host!)} ${CurrencyHelper.currency(widget.host.userInfo!.address!.country).currencySymbol}',
                                    style: TextStyles.regularN90014, ),
                                ],
                              ),
                              verticalMargin24,
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text('Total ', style: TextStyles.boldN90012),
                                  Text('${BookingService().calculatePrice(widget.booking!, widget.host!)} ${CurrencyHelper.currency(widget.host.userInfo!.address!.country).currencySymbol}',
                                    style: TextStyles.semiBoldN90014, ),
                                ],
                              )
                            ],
                          ),
                          verticalMargin32,
                          CardFormField(
                            controller: _controller,
                            style: CardFormStyle(
                                borderColor: AppTheme.primaryColor,
                                cursorColor: AppTheme.accentColor,
                                textColor: AppTheme.primaryColor,
                                textErrorColor: AppTheme.accentColor,
                                fontSize: 16
                            ),
                            countryCode: 'en_${widget.host.userInfo!.address!.country}',
                          ),
                          verticalMargin24,
                          Text('Once your booking is finalised the host will have 48h to accept or reject your request.\n\n'+
                              'If the 48h expire or the request is rejected\nwe will refund you within 3 business days.',
                            style: TextStyles.regularN90014,),
                          Expanded(child: Container()),
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              onPressed:
                                  () {
                                (_isCardValid) ?
                                context.read<PaymentBloc>().add(
                                  PaymentCreateIntent(
                                      billingDetails: BillingDetails(
                                        email: widget.user.email,
                                      ),
                                      grandTotal: BookingService().toStripeInt(widget.booking.totalPrice!).toString(),
                                      currency: CurrencyHelper.currency(widget.host.userInfo!.address!.country)
                                  ),
                                ) :
                                showCustomSnackBar('Please fill the info', context);
                                // context.read<BookingCubit>().save();
                              },
                              child: const Text('Pay'),),
                          ),
                          verticalMargin32
                        ],
                      ),
                    ),
                  ),
                ),
              );
            }
            if(state.status == PaymentStatus.success) {
              context.read<BookingCubit>().completeBooking(widget.booking, widget.user, widget.host, state.paymentIntentId!);
              _controllerCenter.play();
              return BlocBuilder<BookingCubit, BookingState>(
                  builder: (context, state) {
                    if (state is PaymentLoadedState) {

                      // User user = state.props[0] as User;
                      Booking booking = state.props[1] as Booking;


                      return Scaffold(
                        appBar: AppBar(
                          scrolledUnderElevation: 0,
                          title: Text('Finalise your booking', style: TextStyles.boldN90017,),
                          centerTitle: true,
                          backgroundColor: AppTheme.white,
                        ),
                        body: SingleChildScrollView(
                          child: Padding(
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
                                Text('Thank you!', style: TextStyles.semiBoldN60014,),
                                verticalMargin24,
                                RichText(
                                    textAlign: TextAlign.center,
                                    text: TextSpan(
                                        children: [
                                          TextSpan(text: 'Your booking is ', style: TextStyles.boldN90029,),
                                          TextSpan(text: 'complete!', style: TextStyles.boldP40029,),
                                        ]
                                    )
                                ),
                                verticalMargin32,
                                SummaryCard(booking: booking, host: widget.host, currentUser: widget.user,),
                                verticalMargin32,
                                Container(
                                  padding: const EdgeInsets.fromLTRB(21, 15, 21, 15),
                                  height: 140,
                                  decoration: BoxDecoration(
                                    color: AppTheme.s50,
                                    borderRadius: BorderRadius.circular(15),
                                  ),
                                  child: Center(
                                    child: Text('The host will review your request within 48h.\nIf it\'s rejected or time expires, '
                                        'you\'ll be refunded to your card within 3-4 business days.', style: TextStyles.regularN90014,),
                                  ),
                                ),
                                verticalMargin32,
                                verticalMargin32,
                              ],
                            ),
                          ),
                        ),
                        floatingActionButton: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 32.0),
                            width: double.infinity,
                            child: FloatingActionButton(
                              onPressed:
                                  () {
                                _controllerCenter.stop();
                                Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(builder: (context) => HomePage(index: 3)),
                                );
                              },
                              child: Text("Close", style: TextStyles.semiBoldPrimary14,),)),
                        floatingActionButtonLocation: FloatingActionButtonLocation
                            .centerDocked,
                      );
                    }
                    return Container();
                  });
            }
            if(state.status == PaymentStatus.failure) {
              return Scaffold(
                appBar: AppBar(
                  scrolledUnderElevation: 0,
                  title: Text('Finalise your booking', style: TextStyles.boldN90017,),
                  centerTitle: true,
                  backgroundColor: AppTheme.white,
                  iconTheme: const IconThemeData(
                    color: AppTheme.n900, //change your color here
                  ),
                ),
                body: Padding(
                  padding: horizontalPadding24,
                  child: Column(
                    children: [
                      Text('Sorry, the payment failed!', style:TextStyles.semiBoldAccent14 ,),
                      verticalMargin24,
                      verticalMargin24,
                      ElevatedButton(
                        onPressed:
                            () {
                          context.read<PaymentBloc>().add(PaymentStart());
                        },
                        child: Text("Try again", style: TextStyles.semiBoldAccent14,),)
                    ],
                  ),
                ),
              );
            }

            return Scaffold(
              body: Padding(
                  padding: horizontalPadding24 + verticalPadding24,
                  child:Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text("Please don't close the page!",
                        style: TextStyles.semiBoldN60014,),
                      verticalMargin12,
                      RichText(
                          textAlign: TextAlign.center,
                          text: TextSpan(
                            style: TextStyles.boldN90029,
                            children: [
                              const TextSpan(
                                text: 'We are ',
                              ),
                              TextSpan(
                                text: 'processing',
                                style: TextStyles.boldP40029,
                              ),
                              const TextSpan(
                                text: ' your payment!',
                              ),
                            ],
                          )
                      ),
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

    );
  }
}
