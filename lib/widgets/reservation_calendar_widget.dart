import 'dart:math';

import 'package:artb2b/widgets/loading_screen.dart';
import 'package:database_service/database.dart';
import 'package:flutter/material.dart';
// import 'package:booking_calendar/booking_calendar.dart';
import 'package:flutter/rendering.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:table_calendar/table_calendar.dart' as tc
    show StartingDayOfWeek;

import '../app/resources/styles.dart';
import '../app/resources/theme.dart';
import '../booking/service/booking_service.dart';
import '../injection.dart';
import '../utils/common.dart';
import 'common_card_widget.dart';

class ReservationCalendarWidget extends StatefulWidget {
  ReservationCalendarWidget({super.key, required this.user});

  final User user;

  @override
  State<ReservationCalendarWidget> createState() => _ReservationCalendarWidgetState();
}

class _ReservationCalendarWidgetState extends State<ReservationCalendarWidget> {
  final now = DateTime.now();

  FirestoreDatabaseService firestoreDatabaseService = locator<FirestoreDatabaseService>();
  late final ValueNotifier<List<Booking>> _selectedEvents;
  Map<String, DateTimeRange> _bookingDateRange = {};
  List<Booking> _bookings = [];

  @override
  void initState() {
    super.initState();
    initializeDateFormatting();
    generateDateTimeRage().then((dates) {
      setState(() {
        _bookingDateRange = dates;
      });
    });
    _selectedEvents = ValueNotifier(_getEventsForDay(_selectedDay!));
  }

  @override
  void dispose() {
    _selectedEvents.dispose();
    super.dispose();
  }

  Future<Map<String, DateTimeRange>> generateDateTimeRage() async {
    _bookings = await firestoreDatabaseService.retrieveBookingList(user: widget.user);
    _bookings = _bookings.where((element) => element.bookingStatus == BookingStatus.accepted).toList();

    Map<String, DateTimeRange> bookingDateRange = {};
    for (var booking in _bookings) {
      bookingDateRange[booking.bookingId!] =
          DateTimeRange(start: booking.from!, end: booking.to!);
    }

    return bookingDateRange;
  }


  List<Booking> _getEventsForDay(DateTime day) {
    List<Booking> result = [];
    _bookingDateRange.forEach((bookingId, dateRange) {
      if(_isDateTimeWithinRange(day, dateRange)) {
        result.add(_bookings.where((booking) => booking.bookingId! == bookingId).first);
      }
    });
    return result;
  }

  bool _isDateTimeWithinRange(DateTime dateTime, DateTimeRange dateRange) {
    return (dateRange.start.isBefore(dateTime) && dateRange.end.isAfter(dateTime)) ||
        dateRange.start.isSameDay(dateTime) || dateRange.end.isSameDay(dateTime);
  }

  void _onDaySelected(DateTime selectedDay, DateTime focusedDay) {
    if (!isSameDay(_selectedDay, selectedDay)) {
      setState(() {
        _selectedDay = selectedDay;
        _focusedDay = focusedDay;
        _rangeStart = null; // Important to clean those
        _rangeEnd = null;
        _rangeSelectionMode = RangeSelectionMode.toggledOff;
      });

      _selectedEvents.value = _getEventsForDay(selectedDay);
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child:
      Column(
        children: [
          CommonCard(
              child: Column(
                  children: [
                    TableCalendar(
                      calendarBuilders: CalendarBuilders(
                        markerBuilder: (BuildContext context, date, events) {
                          if(widget.user.userInfo!.userType == UserType.artist) {

                            if (events.isEmpty) return const SizedBox();
                            int bookedSpaces = 0;
                            for(Object? e in events) {
                              Booking b = e as Booking;
                              bookedSpaces = bookedSpaces + int.parse(b.spaces!);
                            }
                            return Container(
                              margin: const EdgeInsets.only(top: 40),
                              padding: const EdgeInsets.all(1),
                              child: Text(bookedSpaces.toString(), style: TextStyles
                                  .semiBoldViolet12),
                            );
                          }
                          else {
                            int freeSpaces = int.parse(widget.user.userArtInfo!.spaces!);

                            if (events.isEmpty) {
                              return Container(
                                margin: const EdgeInsets.only(top: 40),
                                padding: const EdgeInsets.all(1),
                                child: Text(freeSpaces.toString(), style: TextStyles
                                    .semiBoldViolet12),
                              );
                            }
                            for(Object? e in events) {
                              Booking b = e as Booking;
                              freeSpaces = freeSpaces - int.parse(b.spaces!);
                            }
                            return Container(
                              margin: const EdgeInsets.only(top: 40),
                              padding: const EdgeInsets.all(1),
                              child: Text(freeSpaces.toString(), style: TextStyles
                                  .semiBoldViolet12),
                            );
                          }
                        },
                        // singleMarkerBuilder: (context, date, event) {
                        //   return Container(
                        //     decoration: const BoxDecoration(
                        //         shape: BoxShape.circle,
                        //         color: Colors.red
                        //     ),
                        //     width: 7.0,
                        //     height: 7.0,
                        //     margin: const EdgeInsets.symmetric(horizontal: 1.5),
                        //   );
                        // },
                      ),
                      availableCalendarFormats: const {CalendarFormat.month: 'Month'},
                      startingDayOfWeek: tc.StartingDayOfWeek.monday,
                      rangeStartDay: _rangeStart,
                      rangeEndDay: _rangeEnd,
                      rangeSelectionMode: _rangeSelectionMode,
                      onDaySelected: _onDaySelected,
                      eventLoader: (day) {
                        return _getEventsForDay(day);
                      },

                      locale: 'en_GB',
                      firstDay: calculateFirstDay(),
                      lastDay: DateTime.now().add(const Duration(days: 1000)),
                      focusedDay: _focusedDay,
                      calendarFormat: CalendarFormat.month,
                      calendarStyle: const CalendarStyle(
                        rangeHighlightColor: AppTheme.accentColourOrangeOpacity,
                        isTodayHighlighted: true,
                        selectedDecoration:  BoxDecoration(
                          color: AppTheme.primaryCalendarViolet,
                          shape: BoxShape.circle,
                        ),
                        todayDecoration: BoxDecoration(
                          color: AppTheme.accentColourOrangeOpacity,
                          shape: BoxShape.circle,
                        ),
                        rangeStartDecoration: BoxDecoration(
                          color: AppTheme.primaryColourVioletOpacity,
                          shape: BoxShape.circle,
                        ),
                        rangeEndDecoration: BoxDecoration(
                          color: AppTheme.primaryColourVioletOpacity,
                          shape: BoxShape.circle,
                        ),
                        disabledTextStyle: TextStyle(color: Color(0xFFBFBFBF), decoration: TextDecoration.lineThrough),
                      ),
                      selectedDayPredicate: (day) {
                        return isSameDay(_selectedDay, day);
                      },
                      onPageChanged: (focusedDay) {
                        _focusedDay = focusedDay;
                      },
                    ), ]
              )
          ),

          verticalMargin12,
          ValueListenableBuilder<List<Booking>>(
          valueListenable: _selectedEvents,
          builder: (context, value, _) {
            return ListView.builder(
              shrinkWrap: true,
                itemCount: value.length,
                itemBuilder: (context, index) {
                  return FutureBuilder<User?>(
                      future: widget.user.userInfo!.userType == UserType.gallery ?
                      firestoreDatabaseService.getUser(userId: value[index].artistId!) :
                      firestoreDatabaseService.getUser(userId: value[index].hostId!),
                      builder: (context, snapshot) {
                        if (snapshot.hasData &&
                            snapshot.connectionState ==
                                ConnectionState.done) {
                          return Padding(
                            padding: verticalPadding12,
                            child: CommonCard(
                              child: Column(
                                  children: [
                                    Row(
                                      children: [
                                        Image.asset(widget.user.userInfo!.userType! == UserType.gallery ?
                                        'assets/images/artist.png' : 'assets/images/gallery.png',
                                          width: 40,),
                                        horizontalMargin12,
                                        Text(snapshot.data!.userInfo!.name!,
                                          style: TextStyles.boldViolet16,),
                                      ],
                                    ),
                                    // verticalMargin12,
                                    // const Divider(thickness: 0.5, color: AppTheme.primaryColor,),
                                    // verticalMargin12,
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment
                                          .start,
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        if(snapshot.data!.userInfo!.userType! == UserType.artist) ...[
                                          Text("City: ",
                                            style: TextStyles.boldViolet16,),
                                          Flexible(child: Text(snapshot.data!
                                              .userInfo!.address!
                                              .city,
                                            softWrap: true, style: TextStyles
                                                .semiBolViolet16,))
                                        ] else ...[
                                          Text("Address: ",
                                            style: TextStyles.boldViolet16,),
                                          Flexible(child: Text(snapshot.data!
                                              .userInfo!.address!
                                              .formattedAddress,
                                            softWrap: true, style: TextStyles
                                                .semiBolViolet16,)),
                                        ]

                                      ],
                                    ),
                                    verticalMargin12,
                                    const Divider(
                                      thickness: 0.6, color: Colors.black38,),
                                    Column(
                                      children: [
                                        Row(
                                            mainAxisAlignment: MainAxisAlignment
                                                .start,
                                            children: [
                                              Text('Spaces: ',
                                                style: TextStyles
                                                    .semiBoldAccent16,),
                                              Text(value[index].spaces!,
                                                style: TextStyles
                                                    .semiBoldViolet16,),
                                            ]
                                        ),
                                        verticalMargin12,
                                        Row(
                                            mainAxisAlignment: MainAxisAlignment
                                                .start,
                                            children: [
                                              Text('Days: ', style: TextStyles
                                                  .semiBoldAccent16,),
                                              Text(
                                                BookingService()
                                                    .daysBetween(
                                                    value[index].from!,
                                                    value[index].to!)
                                                    .toString(),
                                                style: TextStyles
                                                    .semiBoldViolet16,),
                                            ]
                                        ),

                                        verticalMargin12,
                                        Row(
                                            mainAxisAlignment: MainAxisAlignment
                                                .start,
                                            children: [
                                              Text('From: ', style: TextStyles
                                                  .semiBoldAccent16,),
                                              Text(
                                                DateFormat.yMMMEd().format(
                                                    value[index].from!),
                                                style: TextStyles
                                                    .semiBoldViolet16,),
                                            ]
                                        ),
                                        verticalMargin12,
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment
                                              .start,
                                          children: [
                                            Text('To: ', style: TextStyles
                                                .semiBoldAccent16,),
                                            Text(DateFormat.yMMMEd().format(
                                                value[index].to!),
                                              style: TextStyles
                                                  .semiBoldViolet16,),
                                          ],
                                        ),
                                        verticalMargin12,
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment
                                              .start,
                                          children: [
                                            Text('Price: ', style: TextStyles
                                                .semiBoldAccent16,),
                                            // Text('${booking!.spaces!} spaces X ${daysBetween(booking!.from!, booking!.to!)} days X ${int.parse(user!.bookingSettings!.basePrice!).toDouble()} GBP',
                                            //   style: TextStyles.semiBoldViolet16, ),
                                            Text('${value[index].price!} GBP',
                                              style: TextStyles
                                                  .semiBoldViolet16,),
                                          ],
                                        ),
                                        verticalMargin12,
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment
                                              .start,
                                          children: [
                                            Text('Commission (15%): ',
                                              style: TextStyles
                                                  .semiBoldAccent16,),
                                            Text(
                                              '${value[index].commission!} GBP',
                                              style: TextStyles
                                                  .semiBoldViolet16,),
                                          ],
                                        ),
                                        verticalMargin12,
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment
                                              .start,
                                          children: [
                                            Text('Total price: ',
                                              style: TextStyles
                                                  .semiBoldAccent16,),
                                            Text(
                                              '${value[index].totalPrice!} GBP',
                                              style: TextStyles
                                                  .semiBoldViolet16,),
                                          ],
                                        ),
                                      ],
                                    )
                                  ]
                              ),
                            ),
                          );
                        }
                        else {
                          return Center(
                              child: Lottie.asset(
                                'assets/loading.json',
                                fit: BoxFit.fill,
                              ));
                        }
                      }
                  );
                });
          },
          ),
        ],
      ),
    );
  }


  late DateTime? _selectedDay = calculateFirstDay();
  late DateTime _focusedDay = calculateFirstDay();
  RangeSelectionMode _rangeSelectionMode = RangeSelectionMode.toggledOff; // Can be toggled on/off by longpressing a date
  DateTime? _rangeStart;
  DateTime? _rangeEnd;

  DateTime calculateFirstDay() {
    return DateTime.now();
  }
}