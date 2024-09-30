import 'package:artb2b/app/resources/styles.dart';
import 'package:artb2b/widgets/calendar_loader.dart';
import 'package:database_service/database.dart';
import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:table_calendar/table_calendar.dart' as tc
    show StartingDayOfWeek;

import '../app/resources/theme.dart';
import '../booking/service/booking_service.dart';
import '../injection.dart';
import '../utils/calendar_utils.dart';
import '../utils/common.dart';
import 'common_card_widget.dart';

class BookingCalendarWidget extends StatefulWidget {
  BookingCalendarWidget(this.rangeStartChanged, {super.key, required this.host, this.widget});

  final ValueChanged<DateTimeRangeWithInt> rangeStartChanged;
  final User host;
  final Widget? widget;

  @override
  State<BookingCalendarWidget> createState() => _BookingCalendarWidgetState(rangeStartChanged);
}

class _BookingCalendarWidgetState extends State<BookingCalendarWidget> {
  final now = DateTime.now();

  _BookingCalendarWidgetState(this._rangeStartChanged);
  FirestoreDatabaseService firestoreDatabaseService = locator<FirestoreDatabaseService>();
  Map<String, DateTimeRange> _bookingDateRange = {};
  List<DateTime> _unavailableDates = [];
  List<Booking> _bookings = [];
  Map<DateTime, String> _unavailableDatesSpaces = {};
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    initializeDateFormatting();

    _isLoading = true;
    firestoreDatabaseService.findBookingsByUser(widget.host).then((bookings) {
      _bookings = bookings;
      Future.wait([
        generateDisabledDates(),
        generateDateTimeRage(),
        firestoreDatabaseService.getDisabledDates(widget.host.id),
        firestoreDatabaseService.getDisabledSpaces(widget.host.id),
      ]).then((List<dynamic> results) {
        setState(() {
          _isLoading = false;
          _disabledDates = results[0];
          _bookingDateRange = results[1];
          _unavailableDates = retrieveUnavailableDates(results[2]);
          _unavailableDatesSpaces = retrieveUnavailableSpaces(results[3]);
        });
      }).catchError((error) {
        print('Error fetching data at initialization: $error');
      });
    });
  }


  List<DateTimeRange> converted = [];

  Future<Map<DateTime, int>> generateDisabledDates() async {
    //use the one loaded at the beginning
    // List<Booking> bookings = await firestoreDatabaseService.findBookingsByUser(widget.host);

    Map<DateTime, int> dateSpaces = {};
    int availableSpaces = int.parse(widget.host.venueInfo!.spaces!);

    for (var booking in _bookings) {
      if(booking.bookingStatus == BookingStatus.accepted) {

        generateDateList(booking.from!, booking.to!).forEach((dateTime) {
          if(dateSpaces.containsKey(dateTime)) {
            dateSpaces[dateTime] = dateSpaces[dateTime]! - int.parse(booking.spaces!);
          }
          else {
            dateSpaces[dateTime] = availableSpaces - int.parse(booking.spaces!);
          }
        });
      }
    }

    return dateSpaces;
  }

  List<DateTime> retrieveUnavailableDates(List<Unavailable> unavailableDates) {
    List<DateTime> unavailableDateList = [];


    unavailableDates.forEach((unavailable) {
      unavailableDateList.addAll(generateDateList(unavailable.from!,
          unavailable.to!));
    });

    return unavailableDateList;
  }

  Map<DateTime, String> retrieveUnavailableSpaces(List<UnavailableSpaces> unavailableDates) {
    Map<DateTime, String> unavailableDateList = {};


    unavailableDates.forEach((unavailableSpace) {
      generateDateList(unavailableSpace.from!,
          unavailableSpace.to!).forEach((dateTime) { unavailableDateList[dateTime] = unavailableSpace.spaces!; });
    });

    return unavailableDateList;
  }


  List<DateTime> generateDateList(DateTime start, DateTime end) {
    List<DateTime> dateList = [];

    // Loop through the dates and add them to the list
    for (var date = start; date.isBeforeWithoutTime(end) || date.isAtSameMomentAs(end); date = date.add(const Duration(days: 1))) {
      dateList.add(date);
    }

    return dateList;
  }




  @override
  Widget build(BuildContext context) {
    return CommonCard(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          widget.widget ?? Container(),
          TableCalendar(
            daysOfWeekHeight:50,
            rowHeight: 64,
            headerStyle: AppTheme.calendarHeaderStyle,
            daysOfWeekStyle: DaysOfWeekStyle(
              weekdayStyle: TextStyles.semiBoldN90012,
              weekendStyle: TextStyles.semiBoldN90012,
            ),
            availableGestures: AvailableGestures.none,//this single code will solve
            availableCalendarFormats: const {CalendarFormat.month: 'Month'},
            startingDayOfWeek: tc.StartingDayOfWeek.monday,
            rangeStartDay: _rangeStart,
            rangeEndDay: _rangeEnd,
            rangeSelectionMode: _rangeSelectionMode,
            calendarBuilders: CalendarUtils.buildCalendarBuilders(_isLoading, widget.host, _unavailableDatesSpaces, []),
            eventLoader: (day) {
              return _getEventsForDay(day);
            },
            enabledDayPredicate: (day) {
              if (_disabledDates.isEmpty && _unavailableDates.isEmpty) return true;

              bool isEnabled = true;
              _disabledDates.forEach((date, spaces) {
                if (isSameDay(day, date)) {

                  if (spaces <= 0 ||
                      spaces < int.parse(widget.host.bookingSettings!.minSpaces!)) {
                    isEnabled = false;
                  }

                }
              });
              _unavailableDates.forEach((date) {
                if (isSameDay(day, date)) {
                  isEnabled = false;
                }
              });

              // Check if the day is within the user's opening times
              if (!BookingService().isDayWithinOpeningTimes(day, widget.host)) {
                isEnabled = false;
              }

              return isEnabled;
            },
            locale: 'en_GB',
            firstDay: calculateFirstDay(),
            lastDay: DateTime.now().add(const Duration(days: 1000)),
            focusedDay: _focusedDay,
            calendarFormat: CalendarFormat.month,
            calendarStyle:AppTheme.calendarStyle,
            selectedDayPredicate: (day) {
              return isSameDay(_selectedDay, day);
            },
            onDaySelected: (selectedDay, focusedDay) {
              if (!isSameDay(_selectedDay, selectedDay)) {
                setState(() {
                  _selectedDay = selectedDay;
                  _focusedDay = focusedDay;
                  _rangeStart = null; // Important to clean those
                  _rangeEnd = null;
                  _rangeSelectionMode = RangeSelectionMode.toggledOff;
                });
              }
            },
            onRangeSelected: (start, end, focusedDay) {

              setState(() {
                _selectedDay = null;
                _focusedDay = focusedDay;
                _rangeStart = start;
                _rangeEnd = end;
                if(start != null && end != null) {
                  _rangeDateChange();
                }
                _rangeSelectionMode = RangeSelectionMode.toggledOn;
              });
            },


            onPageChanged: (focusedDay) {
              _focusedDay = focusedDay;
            },
          ),
        ],
      ),
    );
  }

  void _rangeDateChange() {
    var range = DateTimeRange(start: _rangeStart!, end: _rangeEnd!);
    int maxSpaces = findMinimumValueInDateRange(_disabledDates, _unavailableDatesSpaces, _rangeStart, _rangeEnd);
    DateTimeRangeWithInt dateTimeRangeWithInt = DateTimeRangeWithInt(range, maxSpaces);
    _rangeStartChanged(dateTimeRangeWithInt);
  }

  late DateTime? _selectedDay = calculateFirstDay();
  late DateTime _focusedDay = calculateFirstDay();
  RangeSelectionMode _rangeSelectionMode = RangeSelectionMode
      .toggledOn; // Can be toggled on/off by longpressing a date
  DateTime? _rangeStart;
  DateTime? _rangeEnd;

  final ValueChanged<DateTimeRangeWithInt> _rangeStartChanged;
  Map<DateTime, int> _disabledDates = {};

  DateTime calculateFirstDay() {
    return DateTime.now();
  }

  Future<Map<String, DateTimeRange>> generateDateTimeRage() async {
    List<Booking> acceptedBooking = _bookings.where((element) => element.bookingStatus ==
        BookingStatus.accepted).toList();

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


  int findMinimumValueInDateRange(
      Map<DateTime, int> datesBookedSpaces,
      Map<DateTime, String> datesUnavailableSpaces, DateTime? startDate, DateTime? endDate) {
    int minValue = int.parse(widget.host.venueInfo!.spaces!); // Initialize to null

    int unavailableSpaces = 0;
    if(startDate != null && endDate != null) {
      datesUnavailableSpaces.forEach((dateTime, value) {
        if (dateTime.isAfterWithoutTime(startDate) && dateTime.isBeforeWithoutTime(endDate)) {
          // Check if the DateTime is within the specified range
          unavailableSpaces = unavailableSpaces + int.parse(value);
        }
      });


      datesBookedSpaces.forEach((dateTime, value) {
        if (dateTime.isAfterWithoutTime(startDate) && dateTime.isBeforeWithoutTime(endDate)) {
          // Check if the DateTime is within the specified range
          if (value < minValue) {
            minValue = value;
          }
        }
      });

      minValue = minValue - unavailableSpaces;
    }
    return minValue; // Return the minimum value or 0 if no value is found
  }
}

class DateTimeRangeWithInt {
  final DateTimeRange dateTimeRange;
  final int maxSpacesAvailable;

  DateTimeRangeWithInt(this.dateTimeRange, this.maxSpacesAvailable);
}