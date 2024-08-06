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

  _SpaceAvailabilityViewState();

  @override
  void initState() {
    super.initState();
    initializeDateFormatting();
    Future.wait([
      firestoreDatabaseService.findBookingsByUser(widget.user),
      retrieveBookedDates(),
      firestoreDatabaseService.getDisabledSpaces(widget.user.id),
    ]).then((List<dynamic> results) {
      setState(() {
        _bookings = results[0];
        _bookedDates = results[1];
        _unavailableSpacesList = results[2];
        _unavailableDates = retrieveUnavailableSpaces(results[2]);
      });
    }).catchError((error) {
      print('Error fetching data: $error');
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
                                style: TextStyles.boldN90029),
                            verticalMargin24,
                            CommonCard(
                              child: TableCalendar(
                                availableGestures: AvailableGestures.none,//this single code will solve
                                availableCalendarFormats: const {
                                  CalendarFormat.month: 'Month'
                                },
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
                                calendarBuilders: CalendarBuilders(
                                  markerBuilder: (BuildContext context, date, events) {
                                    int freeSpaces = int.parse(user!.userArtInfo!.spaces!);

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

                                    _unavailableDates.forEach((day, spaces) {
                                      if (isSameDay(day, date)) {
                                        freeSpaces = freeSpaces - int.parse(spaces);
                                      }
                                    });
                                    return Container(
                                      margin: const EdgeInsets.only(top: 36),
                                      padding: const EdgeInsets.all(1),
                                      child: Text(freeSpaces.toString(), style: TextStyles
                                          .semiBoldAccent12),
                                    );
                                  },
                                ),

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
                                Text("Add Unavailable Dates",
                                  style: TextStyles.semiBoldAccent14,),
                                verticalMargin16,
                                Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Text('From: ', style: TextStyles
                                          .semiBoldAccent14,),
                                      Text(
                                        DateFormat.yMMMEd().format(
                                            _rangeStart!),
                                        style: TextStyles
                                            .semiBoldAccent14,),
                                    ]
                                ),
                                verticalMargin12,
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Text('To: ', style: TextStyles
                                        .semiBoldAccent14,),
                                    Text(DateFormat.yMMMEd().format(
                                        _rangeEnd!),
                                      style: TextStyles
                                          .semiBoldAccent14,),
                                  ],
                                ),
                                verticalMargin12,
                                InputTextWidget((spaceValue) => setState(() {
                                  _unavailableSpaces =spaceValue;
                                }),'Number of spaces unavailable', TextInputType.number),
                              ],
                            ),
                            ) : Container(),
                            verticalMargin24,
                            Text("Existing Unavailable Dates",
                              style: TextStyles.semiBoldAccent14,),
                            verticalMargin12,
                            getExistingUnavailableDateList(user!)
                          ]
                      )
                  ),
                ),
                bottomNavigationBar: Container(
                    padding: buttonPadding,
                    child: ElevatedButton(
                      onPressed: _errorMessage.length < 2 && _rangeStart != null
                          && _rangeEnd != null ? () {

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
                      } : null,
                      child: Text("Save", style: TextStyles.semiBoldAccent14,),)
                ),
              );
            }
            return Container();
          }
      );
  }


  Widget getExistingUnavailableDateList(User user) {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: _unavailableSpacesList.length,
      itemBuilder: (context, index) {
        _unavailableSpacesList.sort((a, b) => a.from!.compareTo(b.from!));
        return Padding(
          padding: verticalPadding12,
          child: CommonCard(
            child: ListTile(
              title: Column(
                  children: [Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text('From: ', style: TextStyles
                            .semiBoldAccent14,),
                        Text(
                          DateFormat.yMMMEd().format(
                              _unavailableSpacesList[index].from!),
                          style: TextStyles
                              .semiBoldAccent14,),
                      ]
                  ),
                    verticalMargin12,
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text('To: ', style: TextStyles
                            .semiBoldAccent14,),
                        Text(DateFormat.yMMMEd().format(
                            _unavailableSpacesList[index].to!),
                          style: TextStyles
                              .semiBoldAccent14,),
                      ],
                    ),
                    verticalMargin12,
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text('Spaces: ', style: TextStyles
                            .semiBoldAccent14,),
                        Text(
                          _unavailableSpacesList[index].spaces!,
                          style: TextStyles
                              .semiBoldAccent14,),
                      ],
                    )
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

