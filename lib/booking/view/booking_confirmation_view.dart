import 'package:artb2b/payment/view/payment_page.dart';
import 'package:artb2b/widgets/app_input_validators.dart';
import 'package:artb2b/widgets/booking_calendar_widget.dart';
import 'package:artb2b/widgets/common_card_widget.dart';
import 'package:artb2b/widgets/loading_screen.dart';
import 'package:database_service/database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

import '../../app/resources/assets.dart';
import '../../app/resources/styles.dart';
import '../../app/resources/theme.dart';
import '../../injection.dart';
import '../../utils/common.dart';
import '../../utils/currency/currency_helper.dart';
import '../../widgets/input_text_widget.dart';
import '../../widgets/summary_card.dart';
import '../cubit/booking_cubit.dart';
import '../cubit/booking_state.dart';
import '../service/booking_service.dart';
import 'package:input_quantity/input_quantity.dart';

class BookingConfirmationView extends StatelessWidget {

  final User host;
  final Booking booking;
  FirestoreDatabaseService firestoreDatabaseService = locator<FirestoreDatabaseService>();

  BookingConfirmationView({super.key, required this.host, required this.booking});

  @override
  Widget build(BuildContext context) {
    User? user;
    return
      BlocBuilder<BookingCubit, BookingState>(
          builder: (context, state) {
            if (state is LoadingState) {
              return const LoadingScreen();
            }

            if (state is LoadedState ) {
              user = state.props[0] as User;


              return Scaffold(
                  appBar: AppBar(
                    scrolledUnderElevation: 0,
                    title: Text('Confirm and pay', style: TextStyles.boldN90017,),
                    centerTitle: true,
                    backgroundColor: AppTheme.white,
                    iconTheme: const IconThemeData(
                      color: AppTheme.n900, //change your color here
                    ),
                  ),
                  body: SingleChildScrollView(
                    physics: const ClampingScrollPhysics(),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        verticalMargin24,
                        Container(
                          padding: horizontalPadding32,
                          color: AppTheme.white,
                          width: MediaQuery.of(context).size.width,
                          height: 160,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              SizedBox(
                                width: 144,
                                height: 105,
                                child:  ClipRRect(
                                  borderRadius: const BorderRadius.all( Radius.circular(16)),
                                  child: FadeInImage(
                                    width: double.infinity,
                                    placeholder: const AssetImage(Assets.logo),
                                    image: NetworkImage(host.photos![0].url!),
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                              horizontalMargin12,
                              Flexible(
                                flex: 1,
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(host.userInfo!.name!, style: TextStyles.boldN90017,),
                                    verticalMargin12,
                                    Text(host.userInfo!.address!.formattedAddress,
                                      style: TextStyles.regularN50012,
                                      overflow: TextOverflow.ellipsis,
                                      maxLines: 2,
                                      softWrap: true,
                                    )
                                  ],
                                ),
                              )
                            ],
                          ),
                        ),
                        verticalMargin16,
                        Container(
                          height: 180,
                          width: MediaQuery.of(context).size.width,
                          padding: horizontalPadding32,
                          color: AppTheme.white,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Your exhibition', style: TextStyles.boldN90017),
                              verticalMargin24,
                              Text('Dates', style: TextStyles.boldN90017),
                              Text(
                                '${DateFormat.MMMEd().format(booking.from!)} - ${DateFormat.yMMMEd().format(booking.to!)}',
                                style: TextStyles.regularN90012, ),
                              verticalMargin24,
                              Text('Spaces', style: TextStyles.boldN90017),
                              Text(
                                '${booking.spaces!} spaces',
                                style: TextStyles.regularN90012,
                              ),
                            ],
                          ),
                        ),
                        verticalMargin16,
                        Container(
                          height: 133,
                          width: MediaQuery.of(context).size.width,
                          padding: horizontalPadding32,
                          color: AppTheme.white,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text('Price Details', style: TextStyles.boldN90017),
                              verticalMargin24,
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text('${double.parse(host.bookingSettings!.basePrice!)} ${CurrencyHelper.currency(host.userInfo!.address!.country).currencySymbol}'
                                      ' x ${BookingService().daysBetween(booking!.from!, booking!.to!).toString()} days',
                                    style: TextStyles.regularN90014,),
                                  Text('${BookingService().calculateGrandTotal(BookingService().calculatePrice(booking!, host!),
                                      0)} ${CurrencyHelper.currency(host.userInfo!.address!.country).currencySymbol}',
                                    style: TextStyles.regularN90014, ),
                                ],
                              ),
                              verticalMargin24,

                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text('Total ', style: TextStyles.boldN90012),
                                  Text('${BookingService().calculateGrandTotal(BookingService().calculatePrice(booking!, host!),
                                      0)} ${CurrencyHelper.currency(host.userInfo!.address!.country).currencySymbol}',
                                    style: TextStyles.semiBoldN90014, ),
                                ],
                              )
                            ],
                          ),
                        ),
                        // SummaryCard(booking: booking, host: host),
                        verticalMargin32
                      ],
                    ),
                  ),
                  bottomNavigationBar: Container(
                    width: double.infinity,
                    height: 110,
                    decoration: BoxDecoration(
                        boxShadow: [
                          AppTheme.bottomBarShadow
                        ],
                        color: AppTheme.white,
                        borderRadius: const BorderRadius.only(
                            topLeft: Radius.circular(15.0),
                            topRight: Radius.circular(15.0)
                        )
                    ),
                    child: SizedBox(
                        width: double.infinity,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            horizontalMargin32,

                            Column(
                              children: [
                                Expanded(child: Container()),
                                Text('Total booking: ',
                                  style: TextStyles.boldN90014,),

                                Text('${BookingService().calculateGrandTotal(BookingService().calculatePrice(booking!, host),
                                    BookingService().calculateCommission(BookingService().calculatePrice(booking!, host)))} ${CurrencyHelper.currency(host.userInfo!.address!.country).currencySymbol}',
                                  style: TextStyles.boldN90014, ),
                                Expanded(child: Container()),
                              ],
                            ) ,
                            Flexible(child: Container()),
                            ElevatedButton(
                              onPressed:
                                  () {

                                Booking pendingBooking = context.read<BookingCubit>().finaliseBooking(booking,
                                    BookingService().calculatePrice(booking, host).toString(),
                                    BookingService().calculateCommission(
                                        BookingService().calculatePrice(booking, host)).toString(),
                                    BookingService().calculateGrandTotal(BookingService().calculatePrice(booking!, host),
                                        BookingService().calculateCommission(BookingService().calculatePrice(booking!, host))).toString(),
                                    host
                                );

                                Navigator.push(
                                  context,
                                  MaterialPageRoute(builder: (context) => PaymentPage(
                                      booking: pendingBooking, user: user!, host: host)),
                                );

                              },
                              child: Text("Finalise Booking", style: TextStyles.semiBoldPrimary14,),),
                            horizontalMargin32,
                          ],
                        )
                    ),
                  )
              );

            }
            return Container();
          }
      );
  }
}
