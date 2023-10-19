import 'package:artb2b/app/resources/styles.dart';
import 'package:artb2b/app/resources/theme.dart';
import 'package:artb2b/booking_requests/cubit/booking_request_cubit.dart';
import 'package:artb2b/booking_requests/cubit/booking_request_state.dart';
import 'package:artb2b/widgets/common_card_widget.dart';
import 'package:artb2b/widgets/loading_screen.dart';
import 'package:database_service/database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:table_calendar/table_calendar.dart' as tc
    show StartingDayOfWeek;
import 'package:table_calendar/table_calendar.dart';

import '../../../injection.dart';
import '../../../utils/common.dart';

class CalendarAvailabilityView extends StatefulWidget {


  CalendarAvailabilityView({super.key, required this.user,
    required this.rangeChanged});

  final User user;
  final ValueChanged<DateTimeRange> rangeChanged;

  @override
  State<CalendarAvailabilityView> createState() => _CalendarAvailabilityViewState();
}

class _CalendarAvailabilityViewState extends State<CalendarAvailabilityView> {
  FirestoreDatabaseService firestoreDatabaseService = locator<FirestoreDatabaseService>();
  List<DateTime> _disabledDates = [];
  late DateTime? _selectedDay = calculateFirstDay();
  late DateTime _focusedDay = calculateFirstDay();
  RangeSelectionMode _rangeSelectionMode = RangeSelectionMode.toggledOn; // Can be toggled on/off by longpressing a date
  DateTime? _rangeStart;
  DateTime? _rangeEnd;

  String _errorMessage = '';

  _CalendarAvailabilityViewState();

  @override
  void initState() {
    super.initState();
    initializeDateFormatting();
    generateDisabledDates().then((dates) {
      setState(() {
        _disabledDates = dates;
      });
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  DateTime calculateFirstDay() {
    return DateTime.now();
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
    }
  }

  Future<List<DateTime>> generateDisabledDates() async {
    List<Booking> bookings = await firestoreDatabaseService
        .retrieveBookingList(user: widget.user);

    List<DateTime> dateSpaces = [];

    for (var booking in bookings) {
      dateSpaces.addAll(generateDateList(booking.from!, booking.to!));
    }

    return dateSpaces;
  }

  List<DateTime> generateDateList(DateTime start, DateTime end) {
    List<DateTime> dateList = [];

    // Loop through the dates and add them to the list
    for (var date = start; date.isBefore(end) || date.isAtSameMomentAs(end);
    date = date.add(Duration(days: 1))) {
      dateList.add(date);
    }
    return dateList;
  }

  void _rangeDateChange() {
    var range = DateTimeRange(start: _rangeStart!, end: _rangeEnd!);
    if(doesDateTimeRangeOverlapWithList(range, _disabledDates)) {
      // setState(() {
        _errorMessage = 'There are some bookings in the range selected';
      // });
    }
    else {
      _errorMessage = '';
    }
    widget.rangeChanged(range);
  }

  bool doesDateTimeRangeOverlapWithList(DateTimeRange range, List<DateTime> dateTimeList) {
    for (final dateTime in dateTimeList) {
      if (range.start.isBefore(dateTime) && range.end.isAfter(dateTime)) {
        // The DateTimeRange overlaps with the DateTime in the list
        return true;
      }
    }
    return false;
  }


  @override
  Widget build(BuildContext context) {
    User? user;
    return
      BlocBuilder<BookingRequestCubit, BookingRequestState>(
          builder: (context, state) {
            if (state is LoadingState) {
              return const LoadingScreen();
            }
            if (state is LoadedState) {
              user = state.props[0] as User;

              return Scaffold(
                  appBar: AppBar(
                    title: Text("Calendar Availability", style: TextStyles.boldAccent24,),
                    centerTitle: true,
                  ),
                  body: Padding(
                      padding: horizontalPadding24,
                      child: CommonCard(
                          child: Column(
                              children: [
                                TableCalendar(
                                  availableCalendarFormats: const {CalendarFormat.month: 'Month'},
                                  startingDayOfWeek: tc.StartingDayOfWeek.monday,
                                  rangeStartDay: _rangeStart,
                                  rangeEndDay: _rangeEnd,
                                  rangeSelectionMode: _rangeSelectionMode,
                                  onDaySelected: _onDaySelected,
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
                                  enabledDayPredicate: (day) {
                                    if (_disabledDates.isEmpty) return true;

                                    bool isEnabled = true;
                                    _disabledDates.forEach((date) {
                                      if (isSameDay(day, date)) {
                                        isEnabled = false;
                                      }
                                    });

                                    return isEnabled;
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
                                ),
                                verticalMargin16,
                                _errorMessage.length>1 ? Text(_errorMessage, textAlign: TextAlign.center,
                                  style: TextStyles.boldAccent16,) : Container(),
                              ]
                          )
                      )
                  )
              );
            }
            return Container();
          }
      );
  }
}
