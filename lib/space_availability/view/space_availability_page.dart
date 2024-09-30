import 'package:artb2b/app/resources/styles.dart';
import 'package:artb2b/app/resources/theme.dart';
import 'package:artb2b/space_availability/cubit/space_availability_cubit.dart';
import 'package:artb2b/space_availability/cubit/space_availability_state.dart';
import 'package:artb2b/widgets/common_card_widget.dart';
import 'package:artb2b/widgets/input_text_widget.dart';
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

import '../../../../injection.dart';
import '../../../utils/common.dart';
import '../../utils/calendar_utils.dart';

class SpaceAvailabilityPage extends StatelessWidget {

  SpaceAvailabilityPage({super.key, required this.user});
  final User user;


  final FirebaseAuthService authService = locator<FirebaseAuthService>();
  final FirestoreDatabaseService databaseService = locator<FirestoreDatabaseService>();

  @override
  Widget build(BuildContext context) {

    return
      BlocProvider<SpaceAvailabilityCubit>(
          create: (context) => SpaceAvailabilityCubit(
            databaseService: databaseService,
            userId: authService.getUser().id,
          ),
          child:SpaceAvailabilityView(user: user, rangeChanged: (dateRangeChoosen) => print(dateRangeChoosen))
      );
  }
}

class SpaceAvailabilityView extends StatefulWidget {


  SpaceAvailabilityView({super.key, required this.user,
    required this.rangeChanged});

  final User user;
  final ValueChanged<DateTimeRange> rangeChanged;

  @override
  State<SpaceAvailabilityView> createState() => _SpaceAvailabilityViewState();
}

class _SpaceAvailabilityViewState extends State<SpaceAvailabilityView> {
  FirestoreDatabaseService firestoreDatabaseService = locator<
      FirestoreDatabaseService>();
  List<DateTime> _bookedDates = [];
  Map<DateTime, String> _unavailableDates = {};
  List<UnavailableSpaces> _unavailableSpacesList = [];
  late DateTime? _selectedDay = calculateFirstDay();
  late DateTime _focusedDay = calculateFirstDay();
  RangeSelectionMode _rangeSelectionMode = RangeSelectionMode
      .toggledOn; // Can be toggled on/off by longpressing a date
  DateTime? _rangeStart;
  DateTime? _rangeEnd;
  List<Booking> _bookings = [];
  String _errorMessage = '';
  String _unavailableSpaces = '0';
  bool _isLoading = false;
  Map<String, DateTimeRange> _bookingDateRange = {};
  final TextEditingController _spacesController = TextEditingController();

  _SpaceAvailabilityViewState();

  @override
  void initState() {
    super.initState();
    initializeDateFormatting();
    _isLoading = true;
    firestoreDatabaseService.findBookingsByUser(widget.user, [BookingStatus.accepted, BookingStatus.pending]).then((bookings) {
      _bookings = bookings;

    Future.wait([
      retrieveBookedDates(),
      firestoreDatabaseService.getDisabledSpaces(widget.user.id),
      generateDateTimeRage(),

    ]).then((List<dynamic> results) {
      setState(() {
        _isLoading = false;

        _bookedDates = results[0];
        _unavailableSpacesList = results[1];
        _unavailableDates = retrieveUnavailableSpaces(results[1]);
        _bookingDateRange = results[2];

      });
    }).catchError((error) {
      print('Error fetching data: $error');
    });
    });
  }

  @override
  void dispose() {
    _spacesController.dispose();
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
    for (var date = start; date.isBeforeWithoutTime(end) || date.isAtSameMomentAs(end);
    date = date.add(Duration(days: 1))) {
      dateList.add(date);
    }
    return dateList;
  }

  Map<DateTime, String> generateSpacesList(DateTime start, DateTime end, String spaces) {
    Map<DateTime, String> dateList = {};

    // Loop through the dates and add them to the list
    for (var date = start; date.isBeforeWithoutTime(end) || date.isAtSameMomentAs(end);
    date = date.add(Duration(days: 1))) {
      dateList[date] = spaces;
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
      BlocBuilder<SpaceAvailabilityCubit, SpaceAvailabilityState>(
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
                            Text('Edit spaces availability per day',
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
                                calendarBuilders: CalendarUtils.buildCalendarBuilders(_isLoading, widget.user, _unavailableDates, [], true),
                                startingDayOfWeek: tc.StartingDayOfWeek.monday,
                                rangeStartDay: _rangeStart,
                                rangeEndDay: _rangeEnd,
                                rangeSelectionMode: _rangeSelectionMode,
                                onDaySelected: _onDaySelected,
                                locale: 'en_GB',
                                eventLoader: (day) {
                                  return _getEventsForDay(day);
                                },
                                firstDay: calculateFirstDay(),
                                lastDay: DateTime.now().add(
                                    const Duration(days: 1000)),
                                focusedDay: _focusedDay,
                                calendarFormat: CalendarFormat.month,
                                // calendarBuilders: CalendarBuilders(
                                //   markerBuilder: (BuildContext context, date, events) {
                                //     int freeSpaces = int.parse(user!.venueInfo!.spaces!);
                                //
                                //     // if (events.isEmpty) {
                                //     //   return Container(
                                //     //     margin: const EdgeInsets.only(top: 40),
                                //     //     padding: const EdgeInsets.all(1),
                                //     //     child: Text(freeSpaces.toString(), style: TextStyles
                                //     //         .semiBoldAccent14),
                                //     //   );
                                //     // }
                                //     for(Object? e in events) {
                                //       Booking b = e as Booking;
                                //       freeSpaces = freeSpaces - int.parse(b.spaces!);
                                //     }
                                //
                                //     _unavailableDates.forEach((day, spaces) {
                                //       if (isSameDay(day, date)) {
                                //         freeSpaces = freeSpaces - int.parse(spaces);
                                //       }
                                //     });
                                //     return Container(
                                //       margin: const EdgeInsets.only(top: 36),
                                //       padding: const EdgeInsets.all(1),
                                //       child: Text(freeSpaces.toString(), style: TextStyles
                                //           .semiBoldAccent12),
                                //     );
                                //   },
                                // ),

                                headerStyle: AppTheme.calendarHeaderStyle,
                                calendarStyle: AppTheme.calendarStyle,
                                selectedDayPredicate: (day) {
                                  return isSameDay(_selectedDay, day);
                                },
                                onPageChanged: (focusedDay) {
                                  _focusedDay = focusedDay;
                                },
                                enabledDayPredicate: (day) {
                                  // if (_unavailableDates.isEmpty) return true;
                                  //
                                  // bool isEnabled = true;
                                  // _unavailableDates.forEach((date) {
                                  //   if (isSameDay(day, date)) {
                                  //     isEnabled = false;
                                  //   }
                                  // });
                                  //
                                  // return isEnabled;
                                  return true;
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
                              style: TextStyles.semiBoldAccent14,) : Container(),
                            verticalMargin16,
                            _errorMessage.length < 1 && _rangeStart != null &&
                                _rangeEnd != null ?
                            CommonCard(child:
                            Column(
                              children: [
                                Text("How many spaces you want to make unavailable? ",
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
                                verticalMargin12,

                                TextField(
                                  controller: _spacesController,
                                  autofocus: false,
                                  style: TextStyles.semiBoldN90014,
                                  onChanged: (String value) {
                                    setState(() {
                                      _unavailableSpaces = value;
                                    });
                                  },
                                  autocorrect: false,
                                  enableSuggestions: false,
                                  decoration: AppTheme.textInputDecoration.copyWith(
                                    hintText: 'Number of spaces unavailable',
                                    hintStyle: TextStyles.semiBoldN90014,),
                                  keyboardType: TextInputType.number,
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

                        context.read<SpaceAvailabilityCubit>()
                            .setDates(user!,
                            UnavailableSpaces(from: _rangeStart, to: _rangeEnd, spaces: _unavailableSpaces))
                            .then((value) =>
                        {

                          setState(() {
                            _unavailableDates.addAll(
                                generateSpacesList(_rangeStart!, _rangeEnd!, _unavailableSpaces ));
                            _unavailableSpacesList.add(UnavailableSpaces(from: _rangeStart!, to: _rangeEnd!, spaces:_unavailableSpaces ));
                            _rangeStart = null; // Important to clean those
                            _rangeEnd = null;
                          })
                        });
                      },
                      child: Text("Save",),)
                ) : null,
              );
            }
            return Container();
          }
      );
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

  Widget getExistingUnavailableDateList(User user) {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: _unavailableSpacesList.length,
      itemBuilder: (context, index) {
        _unavailableSpacesList.sort((a, b) => a.from!.compareTo(b.from!));
        return Column(
          children: [
            Text("Your blocked spaces",
              style: TextStyles.semiBoldN90017,),
            verticalMargin12,
            Padding(
              padding: verticalPadding12,
              child: CommonCard(
                child: ListTile(
                  title: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              '${_unavailableSpacesList[index].spaces!} blocked spaces',
                              style: TextStyles
                                  .semiBoldN90014,),
                            Text(
                              ' on ',
                              style: TextStyles
                                  .semiBoldN90014,),
                            Text(
                              DateFormat('d MMM').format(
                                  _unavailableSpacesList[index].from!),
                              style: TextStyles
                                  .semiBoldN90014,),
                            verticalMargin12,
                            Text(' - ', style: TextStyles
                                .regularN90014,),
                            Text(DateFormat('d MMM').format(
                                _unavailableSpacesList[index].to!),
                              style: TextStyles
                                  .semiBoldN90014,),
                          ],
                        ),
                      ]
                  ),
                  trailing: IconButton(
                    icon: const Icon(Icons.delete),
                    onPressed: () {
                      removeUnavailableDate(user, index);
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

  void removeUnavailableDate(User user, int index) {
    setState(() {

      generateDateList(_unavailableSpacesList.elementAt(index).from!,
          _unavailableSpacesList.elementAt(index).to!).forEach((element) {
        _unavailableDates.remove(element);
      });

      _unavailableSpacesList.removeAt(index);

      context.read<SpaceAvailabilityCubit>().saveDates(
          user, _unavailableSpacesList);
    });
  }
}

