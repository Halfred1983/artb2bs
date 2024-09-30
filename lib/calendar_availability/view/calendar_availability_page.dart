import 'package:artb2b/app/resources/styles.dart';
import 'package:artb2b/app/resources/theme.dart';
import 'package:artb2b/calendar_availability/cubit/calendar_availability_cubit.dart';
import 'package:artb2b/calendar_availability/cubit/calendar_availability_state.dart';
import 'package:artb2b/widgets/common_card_widget.dart';
import 'package:artb2b/widgets/loading_screen.dart';
import 'package:auth_service/auth.dart';
import 'package:database_service/database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';
import 'package:table_calendar/table_calendar.dart' as tc
    show StartingDayOfWeek;
import 'package:table_calendar/table_calendar.dart';
import 'package:uuid/uuid.dart';

import '../../../../injection.dart';
import '../../../utils/common.dart';
import '../../utils/calendar_utils.dart';

class CalendarAvailabilityPage extends StatelessWidget {

  CalendarAvailabilityPage({super.key, required this.user});
  final User user;


  final FirebaseAuthService authService = locator<FirebaseAuthService>();
  final FirestoreDatabaseService databaseService = locator<FirestoreDatabaseService>();

  @override
  Widget build(BuildContext context) {

    return
      BlocProvider<CalendarAvailabilityCubit>(
          create: (context) => CalendarAvailabilityCubit(
            databaseService: databaseService,
            userId: authService.getUser().id,
          ),
          child:CalendarAvailabilityView(user: user, rangeChanged: (dateRangeChoosen) => print(dateRangeChoosen))
      );
  }
}


class CalendarAvailabilityView extends StatefulWidget {


  CalendarAvailabilityView({super.key, required this.user,
    required this.rangeChanged});

  final User user;
  final ValueChanged<DateTimeRange> rangeChanged;

  @override
  State<CalendarAvailabilityView> createState() => _CalendarAvailabilityViewState();
}

class _CalendarAvailabilityViewState extends State<CalendarAvailabilityView> {
  FirestoreDatabaseService firestoreDatabaseService = locator<
      FirestoreDatabaseService>();
  List<DateTime> _bookedDates = [];
  List<DateTime> _unavailableDates = [];
  List<Unavailable> _unavailableList = [];
  late DateTime? _selectedDay = calculateFirstDay();
  late DateTime _focusedDay = calculateFirstDay();
  RangeSelectionMode _rangeSelectionMode = RangeSelectionMode
      .toggledOn; // Can be toggled on/off by longpressing a date
  DateTime? _rangeStart;
  DateTime? _rangeEnd;
  bool _isLoading = false;
  List<Booking> _bookings = [];
  String _errorMessage = '';

  _CalendarAvailabilityViewState();

  @override
  void initState() {
    super.initState();
    initializeDateFormatting();
    _isLoading = true;

    firestoreDatabaseService.findBookingsByUser(widget.user, [BookingStatus.accepted, BookingStatus.pending]).then((bookings) {
      _bookings = bookings;
      Future.wait([
        retrieveBookedDates(),
        firestoreDatabaseService.getDisabledDates(widget.user.id),
      ]).then((List<dynamic> results) {
        setState(() {
          _isLoading = false;
          _bookedDates = results[0];
          _unavailableList = results[1];
          _unavailableDates = retrieveUnavailableDates(results[1]);
        });
      }).catchError((error) {
        print('Error fetching data: $error');
      });
    });
  }

  @override
  void dispose() {
    super.dispose();
  }


  List<bool> _isBooked(DateTime day) {
    for (var date in _bookedDates) {
      if (date.isSameDay(day)) {
        return [true];
      }
    }
    return [];
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

  Future<List<DateTime>> retrieveBookedDates() async {
    List<DateTime> dateSpaces = [];

    for (var booking in _bookings) {
      dateSpaces.addAll(generateDateList(booking.from!, booking.to!));
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

  List<DateTime> generateDateList(DateTime start, DateTime end) {
    List<DateTime> dateList = [];

    // Loop through the dates and add them to the list
    for (var date = start; date.isBeforeWithoutTime(end) || date.isAtSameMomentAs(end);
    date = date.add(Duration(days: 1))) {
      dateList.add(date);
    }
    return dateList;
  }

  void _rangeDateChange() {
    var range = DateTimeRange(start: _rangeStart!, end: _rangeEnd!);
    if (doesDateTimeRangeOverlapWithList(range, _bookedDates)) {
      // setState(() {
      _errorMessage = 'There are some bookings in the range selected';
      // });
    }
    else {
      _errorMessage = '';
    }
    widget.rangeChanged(range);
  }

  bool doesDateTimeRangeOverlapWithList(DateTimeRange range,
      List<DateTime> dateTimeList) {
    for (final dateTime in dateTimeList) {
      if (range.start.isBeforeWithoutTime(dateTime) && range.end.isAfterWithoutTime(dateTime)) {
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
      BlocBuilder<CalendarAvailabilityCubit, CalendarAvailabilityState>(
          builder: (context, state) {
            if (state is LoadingState) {
              return const LoadingScreen();
            }
            if (state is LoadedState) {
              user = state.props[0] as User;

              return Scaffold(
                appBar: AppBar(
                scrolledUnderElevation: 0,
                title: Text(user!.userInfo!.name!, style: TextStyles.boldN90017,),
                centerTitle: true,
                iconTheme: const IconThemeData(
                  color: AppTheme.n900, //change your color here
                ),
              ),
                body: SingleChildScrollView(
                  child: Padding(
                      padding: horizontalPadding24,
                      child: Column(
                          children: [
                            Text('Add dates when your venue can not take any bookings',
                                style: TextStyles.boldN90020),
                            verticalMargin24,
                            CommonCard(
                              child: TableCalendar(
                                daysOfWeekHeight:50,
                                rowHeight: 64,
                                availableGestures: AvailableGestures.none,//this single code will solve
                                availableCalendarFormats: const {
                                  CalendarFormat.month: 'Month'
                                },
                                calendarBuilders: CalendarUtils.buildCalendarBuilders(_isLoading, widget.user, {}, _unavailableDates, false),

                                startingDayOfWeek: tc.StartingDayOfWeek.monday,
                                rangeStartDay: _rangeStart,
                                rangeEndDay: _rangeEnd,
                                rangeSelectionMode: _rangeSelectionMode,
                                onDaySelected: _onDaySelected,
                                locale: 'en_GB',
                                firstDay: calculateFirstDay(),
                                lastDay: DateTime.now().add(
                                    const Duration(days: 1000)),
                                focusedDay: _focusedDay,
                                calendarFormat: CalendarFormat.month,
                                headerStyle: AppTheme.calendarHeaderStyle,
                                calendarStyle: AppTheme.calendarStyle,
                                selectedDayPredicate: (day) {
                                  return isSameDay(_selectedDay, day);
                                },
                                onPageChanged: (focusedDay) {
                                  _focusedDay = focusedDay;
                                },
                                eventLoader: (day) {
                                  return _isBooked(day);
                                },
                                enabledDayPredicate: (day) {
                                  if (_unavailableDates.isEmpty) return true;

                                  bool isEnabled = true;
                                  // _unavailableDates.forEach((date) {
                                  //   if (isSameDay(day, date)) {
                                  //     isEnabled = false;
                                  //   }
                                  // });

                                  return isEnabled;
                                },
                                onRangeSelected: (start, end, focusedDay) {
                                  setState(() {
                                    _selectedDay = null;
                                    _focusedDay = focusedDay;
                                    _rangeStart = start;
                                    _rangeEnd = end;
                                    if (start != null && end != null) {
                                      _rangeDateChange();
                                    }
                                    _rangeSelectionMode =
                                        RangeSelectionMode.toggledOn;
                                  });
                                },
                              ),
                            ),
                            verticalMargin16,
                            _errorMessage.length > 1 ? Text(
                              _errorMessage, textAlign: TextAlign.center,
                              style: TextStyles.semiBoldSD20014,) : Container(),
                            verticalMargin16,
                            _errorMessage.length < 1 && _rangeStart != null &&
                                _rangeEnd != null ?
                            CommonCard(child:
                            Column(
                              children: [
                                Text("Do you want to these dates ? ",
                                  style: TextStyles.semiBoldN90017,),
                                verticalMargin16,
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                    DateFormat('d MMM').format(
                                          _rangeStart!),
                                      style: TextStyles
                                          .semiBoldN90014,),
                                    verticalMargin12,
                                    Text(' - ', style: TextStyles
                                        .regularN90014,),
                                    Text(DateFormat('d MMM').format(
                                        _rangeEnd!),
                                      style: TextStyles
                                          .semiBoldN90014,),
                                  ],
                                ),
                              ],
                            ),
                            ) : Container(),
                            verticalMargin12,
                            getExistingUnavailableDateList(user!)
                          ]
                      )
                  ),
                ),
                bottomNavigationBar: _errorMessage.length < 2 && _rangeStart != null
                    && _rangeEnd != null ? Container(
                    padding: buttonPadding,
                    child: ElevatedButton(
                      onPressed: () {

                        Unavailable unavialable = Unavailable(id: const Uuid().v4(), from: _rangeStart!, to: _rangeEnd!);
                        context.read<CalendarAvailabilityCubit>()
                            .setDates(user!,
                            unavialable)
                            .then((value) =>
                        {

                          setState(() {
                            _unavailableDates.addAll(
                                generateDateList(_rangeStart!, _rangeEnd!));
                            _unavailableList.add(unavialable);
                            _rangeStart = null; // Important to clean those
                            _rangeEnd = null;
                          })
                        });
                      },
                      child: Text("Save", style: TextStyles.semiBoldAccent14,),)
                ) : null,
              );
            }
            return Container();
          }
      );
  }


  Widget getExistingUnavailableDateList(User user) {
    return ListView.builder(
      shrinkWrap: true,
      itemCount: _unavailableList.length,
      itemBuilder: (context, index) {
        _unavailableList.sort((a, b) => a.from!.compareTo(b.from!));
        return Column(
          children: [
            Text("Your blocked dates",
              style: TextStyles.semiBoldN90017,),
            verticalMargin12,
            Padding(
              padding: verticalPadding12,
              child: CommonCard(
                child: ListTile(
                  // padding: horizontalPadding16,
                  // width: double.infinity,
                  title: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              DateFormat('d MMM').format(
                                  _unavailableList[index].from!),
                              style: TextStyles
                                  .semiBoldN90014,),
                            verticalMargin12,
                            Text(' - ', style: TextStyles
                                .regularN90014,),
                            Text(DateFormat('d MMM').format(
                                _unavailableList[index].to!),
                              style: TextStyles
                                  .semiBoldN90014,),
                          ],
                        )
                      ]
                  ),
                  trailing: IconButton(
                    icon: const Icon(Icons.delete),
                    onPressed: () {
                      removeUnavailableDate(user, _unavailableList[index]);
                    },
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }


  void removeUnavailableDate(User user, Unavailable unavailable) {
    setState(() {

      generateDateList(unavailable.from!,
          unavailable.to!).forEach((element) {
        _unavailableDates.remove(element);
      });

      _unavailableList.remove(unavailable);

      context.read<CalendarAvailabilityCubit>().saveDates(
          user, _unavailableList);
    });
  }
}

