import 'package:artb2b/payment/view/payment_page.dart';
import 'package:artb2b/widgets/app_input_validators.dart';
import 'package:artb2b/widgets/booking_calendar_widget.dart';
import 'package:artb2b/widgets/common_card_widget.dart';
import 'package:artb2b/widgets/loading_screen.dart';
import 'package:database_service/database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../app/resources/styles.dart';
import '../../app/resources/theme.dart';
import '../../injection.dart';
import '../../utils/common.dart';
import '../../widgets/input_text_widget.dart';
import '../../widgets/summary_card.dart';
import '../cubit/booking_cubit.dart';
import '../cubit/booking_state.dart';
import '../service/booking_service.dart';

class BookingView extends StatelessWidget {

  final User host;
  FirestoreDatabaseService firestoreDatabaseService = locator<FirestoreDatabaseService>();

  BookingView({super.key, required this.host});

  @override
  Widget build(BuildContext context) {
    User? user;
    Booking? booking;
    int maxSpacesAvailable = int.parse(host.userArtInfo!.spaces!);
    return
      BlocBuilder<BookingCubit, BookingState>(
          builder: (context, state) {
            if (state is LoadingState) {
              return const LoadingScreen();
            }

            if (state is LoadedState || state is DateRangeChosen
                || state is SpacesChosen || state is DateRangeErrorState || state is SpacesErrorState) {
              user = state.props[0] as User;
              booking = state.props[1] as Booking;

              if(state is DateRangeChosen) {
                maxSpacesAvailable = state.maxSpacesForRange;
              }

              var dataRangeError = '';
              if(state is DateRangeErrorState) {
                dataRangeError = state.props[2] as String;
              }
              var spaceError = '';
              if(state is SpacesErrorState ) {
                spaceError = state.props[2] as String;
              }

              return Scaffold(
                  appBar: AppBar(
                    title: Text("Booking Page", style: TextStyles.boldAccent24,),
                    centerTitle: true,
                    iconTheme: const IconThemeData(
                      color: AppTheme.primaryColourViolet, //change your color here
                    ),
                  ),
                  body: SingleChildScrollView(
                    physics: const ClampingScrollPhysics(),
                    child: Padding(
                      padding: horizontalPadding24,
                      child:Column(
                        children: [
                          CommonCard(
                            child: Column(
                              children: [
                                Row(
                                  children: [
                                    Image.asset('assets/images/gallery.png', width: 40,),
                                    horizontalMargin12,
                                    Text(host.userInfo!.name!, style: TextStyles.boldViolet16,),
                                  ],
                                ),
                                verticalMargin12,
                                const Divider(thickness: 0.5, color: AppTheme.primaryColor,),
                                verticalMargin12,
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Text("Address: ", style: TextStyles.boldViolet14,),
                                    Flexible(child: Text(host.userInfo!.address!.formattedAddress, softWrap: true,
                                      style: TextStyles.semiBoldViolet14,)),

                                  ],
                                ),
                                verticalMargin12,
                                Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    mainAxisSize: MainAxisSize.max,
                                    children: [
                                      Text("Spaces: ", style: TextStyles.boldViolet14,),
                                      Text(host.userArtInfo!.spaces!, style: TextStyles.semiBoldViolet14,),
                                      Expanded(child: Container()),
                                      Text("Audience: ", style: TextStyles.boldViolet14,),
                                      Text(host.userArtInfo!.audience ?? 'n/a', style: TextStyles.semiBoldViolet14,),
                                      Expanded(child: Container()),
                                      Text("Min. spaces: ", style: TextStyles.boldViolet14,),
                                      Text(host.bookingSettings!.minSpaces!, style: TextStyles.semiBoldViolet14,),
                                      Expanded(child: Container()),
                                      Text("Min. days: ", style: TextStyles.boldViolet14,),
                                      Text(host.bookingSettings!.minLength!, style: TextStyles.semiBoldViolet14,),
                                    ]
                                ),
                              ],
                            ),
                          ),
                          verticalMargin12,
                          dataRangeError.length>1 ? Text(dataRangeError, style: TextStyles.boldAccent16,) : Container(),
                          verticalMargin12,
                          BookingCalendarWidget((dateRangeChoosen) =>
                              context.read<BookingCubit>().chooseRange(dateRangeChoosen, host), host: host,
                          ),
                          verticalMargin12,

                          InputTextWidget((spaceValue) => context.read<BookingCubit>().chooseSpaces(spaceValue, host, maxSpacesAvailable),
                              'Number of spaces', TextInputType.number),
                          spaceError.length>1 ? Text(spaceError, style: TextStyles.boldAccent16,) : Container(),
                          //Price
                          verticalMargin24,
                          booking!.from != null &&
                              booking!.to != null &&
                              booking!.spaces != null ?
                          SummaryCard(booking: booking, host: host) : Container(),
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
                            dataRangeError.isEmpty &&
                            spaceError.isEmpty &&
                            booking!.spaces != null ?
                            () {

                          Booking pendingBooking = context.read<BookingCubit>().finaliseBooking(
                              BookingService().calculatePrice(booking!, host).toString(),
                              BookingService().calculateCommission(
                                  BookingService().calculatePrice(booking!, host)).toString(),
                              BookingService().calculateGrandTotal(BookingService().calculatePrice(booking!, host),
                                  BookingService().calculateCommission(BookingService().calculatePrice(booking!, host))).toString(),
                              host
                          );

                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => PaymentPage(
                                booking: pendingBooking, user: user!, host: host)),
                          );

                        } : null,
                        child: Text("Book", style: TextStyles.boldWhite16,),)
                  )
              );

            }
            return Container();
          }
      );
  }
}
