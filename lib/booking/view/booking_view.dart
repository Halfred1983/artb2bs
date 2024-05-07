import 'package:artb2b/booking/view/booking_confirmation_page.dart';
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
import '../../utils/currency/currency_helper.dart';
import '../../widgets/input_text_widget.dart';
import '../../widgets/summary_card.dart';
import '../cubit/booking_cubit.dart';
import '../cubit/booking_state.dart';
import '../service/booking_service.dart';
import 'package:input_quantity/input_quantity.dart';

class BookingView extends StatelessWidget {

  final User host;
  FirestoreDatabaseService firestoreDatabaseService = locator<FirestoreDatabaseService>();

  BookingView({super.key, required this.host});

  @override
  Widget build(BuildContext context) {
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
                    title: Text('Select spaces and date', style: TextStyles.boldN90017,),
                    centerTitle: true,
                    backgroundColor: AppTheme.white,
                    iconTheme: const IconThemeData(
                      color: AppTheme.n900, //change your color here
                    ),
                  ),
                  body: SingleChildScrollView(
                    physics: const ClampingScrollPhysics(),
                    child: Padding(
                      padding: horizontalPadding32,
                      child:Column(
                        children: [
                          verticalMargin24,
                          SizedBox(
                            height: 113,
                            child: CommonCard(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text("How many spaces", style: TextStyles.semiBoldN90014,),
                                      Expanded(child: Container(),),
                                      SizedBox(
                                        width: 100,
                                        child: InputQty.int(
                                          onQtyChanged: (spaceValue) => context.read<BookingCubit>().chooseSpaces(spaceValue.toString(), host, maxSpacesAvailable),
                                            qtyFormProps: const QtyFormProps(enableTyping: false),
                                            steps: 1,
                                            maxVal: int.parse(host.userArtInfo!.spaces!) ,
                                            minVal: int.parse(host.bookingSettings!.minSpaces!),
                                            initVal: int.parse(host.bookingSettings!.minSpaces!),
                                            decoration: const QtyDecorationProps(
                                                btnColor: AppTheme.accentColor,
                                                isBordered: false,
                                                borderShape: BorderShapeBtn.circle,
                                                width: 20)
                                        ),
                                      ),
                                    ],
                                  ),
                                  verticalMargin8,
                                  Text('For artworks larger than 1 meter, please book 2 spaces.',
                                    style: TextStyles.regularN50012,)
                                ],
                              ),
                            ),
                          ),
                          verticalMargin12,
                          dataRangeError.length>1 ? Text(dataRangeError, style: TextStyles.semiBoldAccent14,) : Container(),
                          verticalMargin12,
                          BookingCalendarWidget((dateRangeChoosen) =>
                              context.read<BookingCubit>().chooseRange(dateRangeChoosen, host), host: host,
                            widget: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                              Text('When is your exhibition?', style: TextStyles.semiBoldN90014,),
                              verticalMargin24
                            ],),
                          ),
                          verticalMargin12,

                        ],
                      ),
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
                            booking!.from != null &&
                                booking!.to != null &&
                                dataRangeError.isEmpty &&
                                spaceError.isEmpty &&
                                booking!.spaces != null ? Column(
                              children: [
                                Expanded(child: Container()),
                                Text('Total booking: ',
                                  style: TextStyles.semiBoldN10014,),

                                Text('${BookingService().calculateGrandTotal(BookingService().calculatePrice(booking!, host),
                                    BookingService().calculateCommission(BookingService().calculatePrice(booking!, host)))} ${CurrencyHelper.currency(host.userInfo!.address!.country).currencySymbol}',
                                  style: TextStyles.boldN90014, ),
                                Expanded(child: Container()),
                              ],
                            ) : Container(),
                            Flexible(child: Container()),
                            ElevatedButton(
                              onPressed: booking!.from != null &&
                                  booking!.to != null &&
                                  dataRangeError.isEmpty &&
                                  spaceError.isEmpty &&
                                  booking!.spaces != null ?
                                  () {

                                Navigator.push(
                                  context,
                                  MaterialPageRoute(builder: (context) =>
                                      BookingConfirmationPage(host: host, booking: booking!)
                                  ),
                                );

                              } : null,
                              child: Text("Continue Booking", style: TextStyles.semiBoldPrimary14,),),
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
