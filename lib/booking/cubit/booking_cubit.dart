import 'package:database_service/database.dart';
import 'package:flutter/src/material/date.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'booking_state.dart';


class BookingCubit extends Cubit<BookingState> {
  BookingCubit({required this.databaseService,
    required this.userId}) : super(InitialState()) {
    getUser(userId);
  }

  final DatabaseService databaseService;
  final String userId;

  void getUser(String userId) async {
    try {
      emit(LoadingState());
      final user = await databaseService.getUser(userId: userId);
      emit(LoadedState(user!, Booking()));
    } catch (e) {
      emit(ErrorState());
    }
  }

  chooseRange(DateTimeRange dateRangeChosen) {

    Booking booking = this.state.props[1] as Booking;
    User user = this.state.props[0] as User;

    booking = booking.copyWith(from: dateRangeChosen.start, to: dateRangeChosen.end);

    emit(DateRangeChosen(user, booking));
  }

  chooseSpaces(String spaceValue) {
    Booking booking = this.state.props[1] as Booking;
    User user = this.state.props[0] as User;

    booking = booking.copyWith(spaces: spaceValue);

    emit(DateRangeChosen(user, booking));
  }


}