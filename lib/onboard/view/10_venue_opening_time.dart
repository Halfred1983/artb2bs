import 'package:artb2b/utils/common.dart';
import 'package:auth_service/auth.dart';
import 'package:database_service/database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../app/resources/styles.dart';
import '../../app/resources/theme.dart';
import '../../host/view/host_setting_page.dart';
import '../../injection.dart';
import '../../widgets/dot_indicator.dart';
import '../../widgets/loading_screen.dart';
import 'package:artb2b/onboard/cubit/onboarding_cubit.dart';
import 'package:artb2b/onboard/cubit/onboarding_state.dart';

import '../../widgets/tags.dart';
import '11_onboard_end.dart';

class VenueOpeningTime extends StatelessWidget {
  static Route<void> route() {
    return MaterialPageRoute<void>(builder: (_) => VenueOpeningTime());
  }

  VenueOpeningTime({Key? key, this.isOnboarding = true}) : super(key: key);

  bool isOnboarding;
  final FirebaseAuthService authService = locator<FirebaseAuthService>();
  final FirestoreDatabaseService databaseService = locator<FirestoreDatabaseService>();

  @override
  Widget build(BuildContext context) {
    return BlocProvider<OnboardingCubit>(
      create: (context) => OnboardingCubit(
        databaseService: databaseService,
        userId: authService.getUser().id,
      ),
      child: VenueOpeningTimeView(isOnboarding:isOnboarding),
    );
  }
}

class VenueOpeningTimeView extends StatefulWidget {
  VenueOpeningTimeView({super.key, this.isOnboarding = true});

  final bool isOnboarding;
  @override
  _VenueOpeningTimeViewState createState() => _VenueOpeningTimeViewState();
}

class _VenueOpeningTimeViewState extends State<VenueOpeningTimeView> {
  List<BusinessDay> _businessDays = [
    BusinessDay(DayOfWeek.monday, [], false),
    BusinessDay(DayOfWeek.tuesday, [], false),
    BusinessDay(DayOfWeek.wednesday, [], false),
    BusinessDay(DayOfWeek.thursday, [], false),
    BusinessDay(DayOfWeek.friday, [], false),
    BusinessDay(DayOfWeek.saturday, [], false),
    BusinessDay(DayOfWeek.sunday, [], false),
  ];
  String? _selectedDay;

  @override
  void initState() {
    super.initState();
    // Initialize _businessDays with data from the user model
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final user = context.read<OnboardingCubit>().state.user;
      if (user != null) {
        setState(() {
          _businessDays = user!.venueInfo!.openingTimes ??  _businessDays;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<OnboardingCubit, OnboardingState>(
      builder: (context, state) {
        if (state is LoadingState) {
          return const LoadingScreen();
        }
        User? user;
        if (state is BusinessDaysUpdated) {
          user = state.user;
          _businessDays = state.businessDays;
        }
        if (state is LoadedState || state is DataSaved) {
          user = state.user;
          _businessDays = user!.venueInfo!.openingTimes ??  _businessDays;
        }
        return Scaffold(
          appBar: !widget.isOnboarding ? AppBar(
            scrolledUnderElevation: 0,
            title: Text(user!.userInfo!.name!, style: TextStyles.boldN90017,),
            centerTitle: true,
            iconTheme: const IconThemeData(
              color: AppTheme.n900, //change your color here
            ),
          ) : null,
          body: SingleChildScrollView(
            child: Padding(
              padding: horizontalPadding32 + (widget.isOnboarding ? verticalPadding48 : EdgeInsets.zero),
              child: Center(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    if(widget.isOnboarding)... [
                      verticalMargin48,
                      const LineIndicator(
                        totalSteps: 9,
                        currentStep: 8,
                      ),
                      verticalMargin24,
                      const Text('Select open days and set opening hours',
                          style: TextStyle(
                              fontSize: 29, fontWeight: FontWeight.bold)),
                      verticalMargin24,
                    ],
                    Text('Set your venue\'s capacity by choosing the amount of people that fits into your venue.',
                        style: TextStyles.semiBoldN90014),
                    verticalMargin24,
                    Tags(
                      _businessDays.map((day) =>
                      day.dayOfWeek
                          .toString()
                          .split('.')
                          .last).toList(),

                      _businessDays
                          .where((day) => _selectedDay == day.dayOfWeek.toString().split('.').last)
                          .map((day) => day.dayOfWeek.toString().split('.').last)
                          .toList(),

                          (selectedDays) {
                        setState(() {
                          _selectedDay = selectedDays.isNotEmpty ? selectedDays.first : null;
                          // for (var day in _businessDays) {
                          //   day.open = selectedDays.contains(day.dayOfWeek
                          //       .toString()
                          //       .split('.')
                          //       .last);
                          // }
                        });
                        context.read<OnboardingCubit>().updateBusinessDay(
                            _businessDays.firstWhere((day) =>
                                selectedDays.contains(day.dayOfWeek
                                    .toString()
                                    .split('.')
                                    .last)));
                      },
                      isScrollable: true,
                      isMultiple: false,
                    ),
                    if (_selectedDay != null) _buildDayDetails(context, _selectedDay!),
                  ],
                ),
              ),
            ),
          ),
          floatingActionButton: Container(
            padding: const EdgeInsets.symmetric(horizontal: 32.0),
            width: double.infinity,
            child: FloatingActionButton(
              backgroundColor:  _canContinue() ? AppTheme.n900 : AppTheme.disabledButton,
              foregroundColor: _canContinue() ? AppTheme.primaryColor : AppTheme.n900,
              onPressed: () {
                if (_canContinue()) {

                  if (widget.isOnboarding) {
                    context.read<OnboardingCubit>().save(
                        user!, UserStatus.openingTimes);
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => VenueOnboardEnd()),
                    );
                  }
                  else {
                    context.read<OnboardingCubit>().save(user!);
                    Navigator.of(context)..pop()..pop();
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) => HostSettingPage()),
                    );
                  }
                }
              },
              child: const Text('Continue'),
            ),
          ),
          floatingActionButtonLocation: FloatingActionButtonLocation
              .centerDocked,
        );
      },
    );
  }


  Widget _buildDayDetails(BuildContext context, String day) {
    final businessDay = _businessDays.firstWhere((d) => d.dayOfWeek.toString().split('.').last == day);
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('Open to public:', style: TextStyles.semiBoldN90017),
            Switch(
              value: businessDay.open ?? false,
              activeColor: AppTheme.accentColor,
              inactiveThumbColor: AppTheme.n500,
              onChanged: (bool value) {
                setState(() {
                  businessDay.open = value;
                });
                context.read<OnboardingCubit>().updateBusinessDay(businessDay);
              },
            ),
          ],
        ),
        verticalMargin16,
        if (businessDay.open ?? false) ...[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Open:', style: TextStyles.semiBoldN90017),
              TextButton(
                onPressed: () async {
                  await showModalBottomSheet(
                    context: context,
                    builder:  (_) {
                      var initialDate = DateTime(
                        0,
                        0,
                        0,
                        businessDay.hourInterval.isNotEmpty ? businessDay.hourInterval.first.from?.hour ?? 10 : 10,
                        businessDay.hourInterval.isNotEmpty ? businessDay.hourInterval.first.from?.minute ?? 0 : 0,
                      );
                      return BlocProvider.value(
                          value: context.read<OnboardingCubit>(),
                          child: Container(
                            padding: horizontalPadding24,
                            color: AppTheme.white,
                            height: 400,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text('Choose opening time', style: TextStyles.semiBoldN90017),
                                verticalMargin12,
                                SizedBox(
                                  height: 200,
                                  child: CupertinoDatePicker(
                                    mode: CupertinoDatePickerMode.time,
                                    initialDateTime: initialDate,
                                    use24hFormat: false,
                                    onDateTimeChanged: (DateTime newDateTime) {
                                      setState(() {
                                        final timeOfDay = TimeOfDay(hour: newDateTime.hour, minute: newDateTime.minute);
                                        if (businessDay.hourInterval.isEmpty) {
                                          businessDay.hourInterval.add(BusinessHours(timeOfDay, null));
                                        } else {
                                          businessDay.hourInterval.first.from = timeOfDay;
                                        }
                                      });
                                      context.read<OnboardingCubit>().updateBusinessDay(businessDay);
                                    },
                                  ),
                                ),
                                verticalMargin12,
                                SizedBox(
                                  width: double.infinity,
                                  child: ElevatedButton(
                                    onPressed: () {
                                      if (businessDay.hourInterval.isEmpty) {
                                        businessDay.hourInterval.add(BusinessHours(TimeOfDay(hour: initialDate.hour,
                                            minute: initialDate.minute), null));
                                      }
                                      businessDay.hourInterval.first.from ??= TimeOfDay(hour: initialDate.hour, minute: initialDate.minute);
                                      context.read<OnboardingCubit>().updateBusinessDay(businessDay);
                                      Navigator.pop(context);
                                    },
                                    child: const Text('Done'),
                                  ),
                                ),
                              ],
                            ),
                          ));
                    },
                  );
                },
                child: Text(businessDay.hourInterval.isNotEmpty ?
                businessDay.hourInterval.first.from?.format(context) ?? 'Select Time' : 'Select Time'
                  ,style: TextStyles.semiBoldN90014,),
              ),
            ],
          ),
          verticalMargin24,
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Close:', style: TextStyles.semiBoldN90017),
              TextButton(
                onPressed: () async {
                  await showModalBottomSheet(
                    context: context,
                    builder: (_) {
                      var initialDateTime = DateTime(
                        0,
                        0,
                        0,
                        businessDay.hourInterval.isNotEmpty ? businessDay.hourInterval.first.to?.hour ?? 18 : 18,
                        businessDay.hourInterval.isNotEmpty ? businessDay.hourInterval.first.to?.minute ?? 0 : 0,
                      );
                      return BlocProvider.value(
                          value: context.read<OnboardingCubit>(),
                          child: Container(
                            padding: horizontalPadding24,
                            color: AppTheme.white,
                            height: 400,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text('Choose closing time', style: TextStyles.semiBoldN90017),
                                verticalMargin12,
                                SizedBox(
                                  height: 200,
                                  child: CupertinoDatePicker(
                                    mode: CupertinoDatePickerMode.time,
                                    initialDateTime: initialDateTime,
                                    use24hFormat: false,
                                    onDateTimeChanged: (DateTime newDateTime) {
                                      setState(() {
                                        final timeOfDay = TimeOfDay(hour: newDateTime.hour, minute: newDateTime.minute);
                                        if (businessDay.hourInterval.isEmpty) {
                                          businessDay.hourInterval.add(BusinessHours(null, timeOfDay));
                                        } else {
                                          businessDay.hourInterval.first.to = timeOfDay;
                                        }
                                      });
                                      context.read<OnboardingCubit>().updateBusinessDay(businessDay);
                                    },
                                  ),
                                ),
                                verticalMargin12,
                                SizedBox(
                                  width: double.infinity,
                                  child: ElevatedButton(
                                    onPressed: () {
                                      if (businessDay.hourInterval.isEmpty ) {
                                        businessDay.hourInterval.add(BusinessHours(null,
                                            TimeOfDay(hour: initialDateTime.hour, minute: initialDateTime.minute)));
                                      }
                                      businessDay.hourInterval.first.to ??= TimeOfDay(hour: initialDateTime.hour, minute: initialDateTime.minute);
                                      context.read<OnboardingCubit>().updateBusinessDay(businessDay);
                                      Navigator.pop(context);
                                    },
                                    child: const Text('Done'),
                                  ),
                                ),
                              ],
                            ),
                          ));
                    },
                  );
                },
                child: Text(businessDay.hourInterval.isNotEmpty ? businessDay.hourInterval.first.to?.format(context) ??
                    'Select Time' : 'Select Time' ,style: TextStyles.semiBoldN90014,),
              ),
            ],
          ),
        ],
      ],
    );
  }

  bool _canContinue() {
    return _businessDays.any((day) => day.open ?? false);
  }
}