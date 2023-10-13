import 'package:database_service/database.dart';
import 'package:flutter/material.dart';
// import 'package:booking_calendar/booking_calendar.dart';
import 'package:flutter/rendering.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:table_calendar/table_calendar.dart' as tc
    show StartingDayOfWeek;

import '../app/resources/theme.dart';
import '../injection.dart';
import '../utils/common.dart';
import 'common_card_widget.dart';

class BookingCalendarWidget extends StatefulWidget {
  BookingCalendarWidget(this.rangeStartChanged, {super.key, required this.host});

  final ValueChanged<DateTimeRange> rangeStartChanged;
  final User host;

  @override
  State<BookingCalendarWidget> createState() => _BookingCalendarWidgetState(rangeStartChanged);
}

class _BookingCalendarWidgetState extends State<BookingCalendarWidget> {
  final now = DateTime.now();

  _BookingCalendarWidgetState(this._rangeStartChanged);
  FirestoreDatabaseService firestoreDatabaseService = locator<FirestoreDatabaseService>();

  @override
  void initState() {
    super.initState();
    initializeDateFormatting();
    generateDisabledDates().then((dates) {
      setState(() {
        _disabledDates = dates;
      });
    });
    // DateTime.now().startOfDay
    // DateTime.now().endOfDay
    // mockBookingService = BookingService(
    //     serviceName: 'Mock Service',
    //     serviceDuration: 30,
    //     bookingEnd: DateTime(now.year, now.month, now.day, 18, 0),
    //     bookingStart: DateTime(now.year, now.month, now.day, 8, 0));
  }

  Stream<dynamic>? getBookingStreamMock(
      {required DateTime end, required DateTime start}) {
    return Stream.value([]);
  }

  // Future<dynamic> uploadBookingMock(
  //     {required BookingService newBooking}) async {
  //   await Future.delayed(const Duration(seconds: 1));
  //   converted.add(DateTimeRange(
  //       start: newBooking.bookingStart, end: newBooking.bookingEnd));
  //   print('${newBooking.toJson()} has been uploaded');
  // }

  List<DateTimeRange> converted = [];

  List<DateTimeRange> convertStreamResultMock({required dynamic streamResult}) {
    ///here you can parse the streamresult and convert to [List<DateTimeRange>]
    ///take care this is only mock, so if you add today as disabledDays it will still be visible on the first load
    ///disabledDays will properly work with real data
    DateTime first = now;
    DateTime tomorrow = now.add(Duration(days: 1));
    DateTime second = now.add(const Duration(minutes: 55));
    DateTime third = now.subtract(const Duration(minutes: 240));
    DateTime fourth = now.subtract(const Duration(minutes: 500));
    converted.add(
        DateTimeRange(start: first, end: now.add(const Duration(minutes: 30))));
    converted.add(DateTimeRange(
        start: second, end: second.add(const Duration(minutes: 23))));
    converted.add(DateTimeRange(
        start: third, end: third.add(const Duration(minutes: 15))));
    converted.add(DateTimeRange(
        start: fourth, end: fourth.add(const Duration(minutes: 50))));

    //book whole day example
    converted.add(DateTimeRange(
        start: DateTime(tomorrow.year, tomorrow.month, tomorrow.day, 5, 0),
        end: DateTime(tomorrow.year, tomorrow.month, tomorrow.day, 23, 0)));
    return converted;
  }

  List<DateTimeRange> generatePauseSlots() {
    return [
      DateTimeRange(
          start: DateTime(now.year, now.month, now.day, 12, 0),
          end: DateTime(now.year, now.month, now.day, 13, 0))
    ];
  }

  Future<List<DateTime>> generateDisabledDates() async {
    List<Booking> bookings = await firestoreDatabaseService.retrieveBookingList(user: widget.host);
    List<DateTime> unavailableDates = [];

    for (var booking in bookings) {
      if(booking.bookingStatus == BookingStatus.accepted) {
        unavailableDates.addAll(generateDateList(booking.from!, booking.to!));
      }
    }

    return unavailableDates;
  }

  void debugDumpRenderTree() {
    debugPrint(RendererBinding.instance.renderView.toStringDeep());
  }

  List<DateTime> generateDateList(DateTime start, DateTime end) {
    List<DateTime> dateList = [];

    // Loop through the dates and add them to the list
    for (var date = start; date.isBefore(end) || date.isAtSameMomentAs(end); date = date.add(Duration(days: 1))) {
      dateList.add(date);
    }

    return dateList;
  }




  @override
  Widget build(BuildContext context) {
    return CommonCard(
      child: TableCalendar(
        availableCalendarFormats: const {CalendarFormat.month: 'Month'},
        startingDayOfWeek: tc.StartingDayOfWeek.monday,
        rangeStartDay: _rangeStart,
        rangeEndDay: _rangeEnd,
        rangeSelectionMode: _rangeSelectionMode,
        // holidayPredicate: (day) {
        //   if (_disabledDates == null) return false;
        //
        //   bool isHoliday = false;
        //   for (var holiday in _disabledDates!) {
        //     if (isSameDay(day, holiday)) {
        //       isHoliday = true;
        //     }
        //   }
        //   return isHoliday;
        // },
        enabledDayPredicate: (day) {
          if (_disabledDates.isEmpty) return true;

          bool isEnabled = true;
          for (var unavailable in _disabledDates) {
            if (isSameDay(day, unavailable)) {
              isEnabled = false;
            }

            // if (!isEnabled) return false;
          }

          return isEnabled;
        },
        locale: 'en_GB',
        firstDay: calculateFirstDay(),
        lastDay: DateTime.now().add(const Duration(days: 1000)),
        focusedDay: _focusedDay,
        calendarFormat: CalendarFormat.month,
        calendarStyle: const CalendarStyle(
          rangeHighlightColor: AppTheme.accentColourOrangeOpacity,
          isTodayHighlighted: true,
          todayDecoration: BoxDecoration(
            color: AppTheme.accentColourOrange,
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
        // onDaySelected: (selectedDay, focusedDay) {
        //   if (!isSameDay(_selectedDay, selectedDay)) {
        //     setState(() {
        //       _selectedDay = selectedDay;
        //       _focusedDay = focusedDay;
        //     });
        //     // selectNewDateRange();
        //   }
        // },
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
        // onFormatChanged: (format) {
        //   if (_calendarFormat != format) {
        //     setState(() {
        //       _calendarFormat = format;
        //     });
        //   }
        // },
        onPageChanged: (focusedDay) {
          _focusedDay = focusedDay;
        },
      ),
    );
  }

  void _rangeDateChange() {
    var range = DateTimeRange(start: _rangeStart!, end: _rangeEnd!);
    _rangeStartChanged(range);
  }

  late DateTime? _selectedDay = calculateFirstDay();
  late DateTime _focusedDay = calculateFirstDay();
  RangeSelectionMode _rangeSelectionMode = RangeSelectionMode
      .toggledOn; // Can be toggled on/off by longpressing a date
  DateTime? _rangeStart;
  DateTime? _rangeEnd;

  final ValueChanged<DateTimeRange> _rangeStartChanged;
  List<DateTime> _disabledDates = List.empty();

  DateTime calculateFirstDay() {
    return DateTime.now();
    // if (widget.disabledDays != null) {
    //   return widget.disabledDays!.contains(now.weekday)
    //       ? now.add(Duration(days: getFirstMissingDay(now.weekday)))
    //       : now;
    // } else {
    //   return DateTime.now();
    // }
  }
}