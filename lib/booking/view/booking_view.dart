import 'package:artb2b/payment/view/payment_page.dart';
import 'package:artb2b/widgets/booking_calendar_widget.dart';
import 'package:artb2b/widgets/common_card_widget.dart';
import 'package:artb2b/widgets/loading_screen.dart';
import 'package:database_service/database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

import '../../app/resources/styles.dart';
import '../../injection.dart';
import '../../utils/common.dart';
import '../../widgets/input_text_widget.dart';
import '../cubit/booking_cubit.dart';
import '../cubit/booking_state.dart';

class BookingView extends StatelessWidget {

  FirestoreDatabaseService firestoreDatabaseService = locator<FirestoreDatabaseService>();

  @override
  Widget build(BuildContext context) {
    User? user;
    Booking? booking;
    return
      BlocBuilder<BookingCubit, BookingState>(
          builder: (context, state) {
            if (state is LoadingState) {
              return const LoadingScreen();
            }

            if (state is LoadedState || state is DateRangeChosen
                || state is SpacesChosen) {
              user = state.props[0] as User;
              booking = state.props[1] as Booking;

              return Scaffold(
                  appBar: AppBar(
                    title: Text("Booking Page", style: TextStyles.boldAccent24,),
                    centerTitle: true,
                  ),
                  body: SingleChildScrollView(
                    physics: const ClampingScrollPhysics(),
                    child: Padding(
                      padding: horizontalPadding24,
                      child:Column(
                        children: [
                          BookingCalendarWidget((dateRangeChoosen) =>
                              context.read<BookingCubit>().chooseRange(dateRangeChoosen)
                          ),
                          verticalMargin12,
                          InputTextWidget((spaceValue) => context.read<BookingCubit>().chooseSpaces(spaceValue),
                              'Number of spaces', TextInputType.number),
                          //Price
                          verticalMargin24,
                          booking!.from != null &&
                              booking!.to != null &&
                              booking!.spaces != null ?
                          CommonCard(
                              child: Column(
                                children: [
                                  Text('Your booking details:', style: TextStyles.semiBoldAccent18, ),
                                  const Divider(thickness: 0.6, color: Colors.black38,),
                                  Column(
                                    children: [
                                      Row(
                                          mainAxisAlignment: MainAxisAlignment.start,
                                          children: [
                                            Text('Spaces: ', style: TextStyles.semiBoldAccent16, ),
                                            Text(booking!.spaces!, style: TextStyles.semiBoldViolet16, ),
                                          ]
                                      ),
                                      verticalMargin12,
                                      Row(
                                          mainAxisAlignment: MainAxisAlignment.start,
                                          children: [
                                            Text('Days: ', style: TextStyles.semiBoldAccent16, ),
                                            Text(daysBetween(booking!.from!, booking!.to!).toString(), style: TextStyles.semiBoldViolet16, ),
                                          ]
                                      ),
                                      verticalMargin12,
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.start,
                                        children: [
                                          Text('Price per day: ', style: TextStyles.semiBoldAccent16, ),
                                          Text('${double.parse(user!.bookingSettings!.basePrice!)} GBP', style: TextStyles.semiBoldViolet16, ),
                                        ],
                                      ),
                                      verticalMargin12,
                                      Row(
                                          mainAxisAlignment: MainAxisAlignment.start,
                                          children: [
                                            Text('From: ', style: TextStyles.semiBoldAccent16, ),
                                            Text(
                                              DateFormat.yMMMEd().format(booking!.from!), style: TextStyles.semiBoldViolet16, ),
                                          ]
                                      ),
                                      verticalMargin12,
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.start,
                                        children: [
                                          Text('To: ', style: TextStyles.semiBoldAccent16, ),
                                          Text(DateFormat.yMMMEd().format(booking!.to!), style: TextStyles.semiBoldViolet16, ),
                                        ],
                                      ),
                                      verticalMargin12,
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.start,
                                        children: [
                                          Text('Price: ', style: TextStyles.semiBoldAccent16, ),
                                          // Text('${booking!.spaces!} spaces X ${daysBetween(booking!.from!, booking!.to!)} days X ${int.parse(user!.bookingSettings!.basePrice!).toDouble()} GBP',
                                          //   style: TextStyles.semiBoldViolet16, ),
                                          Text('${_calculatePrice(booking!, user!)} GBP',
                                            style: TextStyles.semiBoldViolet16, ),
                                        ],
                                      ),
                                      verticalMargin12,
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.start,
                                        children: [
                                          Text('Commission (15%): ', style: TextStyles.semiBoldAccent16, ),
                                          Text('${_calculateCommission(_calculatePrice(booking!, user!))} GBP',
                                            style: TextStyles.semiBoldViolet16, ),
                                        ],
                                      ),
                                      verticalMargin12,
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.start,
                                        children: [
                                          Text('Grand Total: ', style: TextStyles.semiBoldAccent16, ),
                                          Text('${_calculateGrandTotal(_calculatePrice(booking!, user!),
                                              _calculateCommission(_calculatePrice(booking!, user!)))} GBP',
                                            style: TextStyles.semiBoldViolet16, ),
                                        ],
                                      ),
                                    ],
                                  )
                                ],
                              )
                          ) : Container(),
                          verticalMargin32
                        ],
                      ),
                    ),
                  ),
                  bottomNavigationBar: Container(
                      padding: buttonPadding,
                      child: ElevatedButton(

                        onPressed: booking!.from != null &&
                            booking!.to != null &&
                            booking!.spaces != null ?
                            () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) => const PaymentPage()),
                              );
                          // context.read<BookingCubit>().save();
                        } : null,
                        child: Text("Book", style: TextStyles.boldWhite16,),)
                  )
              );
            }
            return Container();
          }
      );
  }

  double _calculatePrice(Booking booking, User user) {
    int? spaces = int.tryParse(booking.spaces!) ?? 0;
    int days = daysBetween(booking.from!, booking.to!);
    return (days * int.parse(user.bookingSettings!.basePrice!) * spaces).toDouble();
  }

  double _calculateCommission(double price) {
    return price * 0.15;
  }

  double _calculateGrandTotal(double price, double commission) {
    return price + commission;
  }

  int daysBetween(DateTime from, DateTime to) {
    from = DateTime(from.year, from.month, from.day);
    to = DateTime(to.year, to.month, to.day);
    return (to.difference(from).inHours / 24).round();
  }
}