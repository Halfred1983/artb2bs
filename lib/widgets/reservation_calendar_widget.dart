import 'package:database_service/database.dart';
import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:lottie/lottie.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:table_calendar/table_calendar.dart' as tc
    show StartingDayOfWeek;

import '../app/resources/styles.dart';
import '../injection.dart';
import '../app/resources/theme.dart';
import '../utils/common.dart';
import 'booking_summary_card.dart';
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
  ValueNotifier<List<Booking>> _selectedEvents = ValueNotifier([]);
  Map<String, DateTimeRange> _bookingDateRange = {};
  List<Booking> _bookings = [];
  List<DateTime> _unavailableDates = [];
  Map<DateTime, String> _unavailableDatesSpaces = {};

  @override
  void initState() {
    super.initState();
    initializeDateFormatting();

    firestoreDatabaseService.findBookingsByUser(widget.user).then((bookings) {
      _bookings = bookings;
      Future.wait([
        generateDateTimeRage(),
        firestoreDatabaseService.getDisabledDates(widget.user.id),
        firestoreDatabaseService.getDisabledSpaces(widget.user.id),
      ]).then((List<dynamic> results) {
        // setState(() {
        _bookingDateRange = results[0];
        _unavailableDates = retrieveUnavailableDates(results[1]);
        _unavailableDatesSpaces = retrieveUnavailableSpaces(results[2]);
        _selectedEvents = ValueNotifier(_getEventsForDay(_selectedDay!));
        // });
      }).catchError((error) {
        print('Error fetching data: $error');
      });
    });

    // Future.wait([
    //   firestoreDatabaseService.findBookingsByUser(widget.user),
    //   generateDateTimeRage(),
    //   firestoreDatabaseService.getDisabledDates(widget.user.id),
    //   firestoreDatabaseService.getDisabledSpaces(widget.user.id),
    // ]).then((List<dynamic> results) {
    //   // setState(() {
    //   _bookings = results[0];
    //   _bookingDateRange = results[1];
    //   _unavailableDates = retrieveUnavailableDates(results[2]);
    //   _unavailableDatesSpaces = retrieveUnavailableSpaces(results[3]);
    //   _selectedEvents = ValueNotifier(_getEventsForDay(_selectedDay!));
    //   // });
    // }).then((value) => {
    //   setState(() {})
    // }).catchError((error) {
    //   print('Error fetching data: $error');
    // });
  }

  @override
  void dispose() {
    _selectedEvents.dispose();
    super.dispose();
  }

  Future<Map<String, DateTimeRange>> generateDateTimeRage() async {
    List<Booking> acceptedBooking = _bookings.where((element) => element.bookingStatus == BookingStatus.accepted).toList();

    Map<String, DateTimeRange> bookingDateRange = {};
    for (var booking in acceptedBooking) {
      bookingDateRange[booking.bookingId!] =
          DateTimeRange(start: booking.from!, end: booking.to!);
    }

    return bookingDateRange;
  }


  List<Booking> _getEventsForDay(DateTime day) {
    List<Booking> result = [];
    _bookingDateRange.forEach((bookingId, dateRange) {
      if(day.isDateTimeWithinRange(dateRange)) {
        result.add(_bookings.where((booking) => booking.bookingId! == bookingId).first);
      }
    });
    return result;
  }

  Map<DateTime, String> retrieveUnavailableSpaces(List<UnavailableSpaces> unavailableDates) {
    Map<DateTime, String> unavailableDateList = {};


    unavailableDates.forEach((unavailableSpace) {
      generateDateList(unavailableSpace.from!,
          unavailableSpace.to!).forEach((dateTime) { unavailableDateList[dateTime] = unavailableSpace.spaces!; });
    });

    return unavailableDateList;
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

  List<DateTime> retrieveUnavailableDates(List<Unavailable> unavailableDates) {
    List<DateTime> unavailableDateList = [];


    unavailableDates.forEach((unavailable) {
      unavailableDateList.addAll(generateDateList(unavailable.from!,
          unavailable.to!));
    });

    return unavailableDateList;
  }

  List<DateTime> generateDateList(DateTime start, DateTime end) {
    List<DateTime> dateList = [];

    // Loop through the dates and add them to the list
    for (var date = start; date.isBeforeWithoutTime(end) || date.isAtSameMomentAs(end);
    date = date.add(Duration(days: 1))) {
      dateList.add(date);
    }
    return dateList;
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
                        availableGestures: AvailableGestures.none,//this single code will solve
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
                                margin: const EdgeInsets.only(top: 25),
                                padding: const EdgeInsets.all(1),
                                child: Text(bookedSpaces.toString(), style: TextStyles
                                    .semiBoldAccent14),
                              );
                            }
                            else {
                              int freeSpaces = int.parse(widget.user.venueInfo!.spaces!);

                              // if (events.isEmpty) {
                              //   return Container(
                              //     margin: const EdgeInsets.only(top: 40),
                              //     padding: const EdgeInsets.all(1),
                              //     child: Text(freeSpaces.toString(), style: TextStyles
                              //         .semiBoldAccent14),
                              //   );
                              // }
                              for(Object? e in events) {
                                Booking b = e as Booking;
                                freeSpaces = freeSpaces - int.parse(b.spaces!);
                              }

                              _unavailableDatesSpaces.forEach((day, spaces) {
                                if (isSameDay(day, date)) {
                                  freeSpaces = freeSpaces - int.parse(spaces);
                                }
                              });

                              return Container(
                                margin: const EdgeInsets.only(top: 25),
                                padding: const EdgeInsets.all(1),
                                child: Text(freeSpaces.toString(), style: TextStyles
                                    .semiBoldAccent14),
                              );
                            }
                          },
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
                        headerStyle: AppTheme.calendarHeaderStyle,
                        calendarStyle: AppTheme.calendarStyle,
                        daysOfWeekStyle: DaysOfWeekStyle(
                          weekdayStyle: TextStyles.semiBoldN90012,
                          weekendStyle: TextStyles.semiBoldN90012,
                        ),

                        selectedDayPredicate: (day) {
                          return isSameDay(_selectedDay, day);
                        },
                        onPageChanged: (focusedDay) {
                          _focusedDay = focusedDay;
                        },
                        enabledDayPredicate: (day) {
                          if (_unavailableDates.isEmpty) return true;

                          bool isEnabled = true;
                          _unavailableDates.forEach((date) {
                            if (isSameDay(day, date)) {
                              isEnabled = false;
                            }
                          });

                          return isEnabled;
                        }
                    ),
                  ]
              )
          ),

          verticalMargin12,
          ValueListenableBuilder<List<Booking>>(
            valueListenable: _selectedEvents,
            builder: (context, value, _) {
              return ListView.builder(
                  physics: const NeverScrollableScrollPhysics(),
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
                            User user = snapshot.data!;
                            UserType userType = widget.user.userInfo!.userType!;
                            Booking booking = value[index];

                            return Padding(
                              padding: verticalPadding12,
                              child: BookingSummaryCard(userType: userType, user: user, booking: booking),
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
