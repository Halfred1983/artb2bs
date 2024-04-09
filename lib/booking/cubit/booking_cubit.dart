import 'package:artb2b/widgets/booking_calendar_widget.dart';
import 'package:database_service/database.dart';
import 'package:flutter/src/material/date.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../utils/currency/currency_helper.dart';
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
      emit(LoadedState(user!, Booking(bookingStatus:BookingStatus.pending )));
    } catch (e) {
      emit(ErrorState());
    }
  }

  chooseRange(DateTimeRangeWithInt dateRangeChosen, User host) {

    Booking booking = this.state.props[1] as Booking;
    User user = this.state.props[0] as User;

    if(dateRangeChosen.dateTimeRange.duration.inDays < int.parse(host.bookingSettings!.minLength!) ) {
      emit(DateRangeErrorState(user, booking, 'You need to book at least ${host.bookingSettings!.minLength!} days'));
    }
    else {
      booking = booking.copyWith(
          from: dateRangeChosen.dateTimeRange.start,
          to: dateRangeChosen.dateTimeRange.end
      );

      emit(DateRangeChosen(user, booking, dateRangeChosen.maxSpacesAvailable));
    }
  }

  chooseSpaces(String spaceValue, User host, int maxSpaceAvailable) {
    Booking booking = this.state.props[1] as Booking;
    User user = this.state.props[0] as User;

    if(spaceValue.length > 0 && int.parse(spaceValue) < int.parse(host.bookingSettings!.minSpaces!) ) {
      emit(SpacesErrorState(user, booking, 'You need to book at least ${host.bookingSettings!.minSpaces!} spaces'));
    }
    else if(spaceValue.length == 0) {
      emit(SpacesErrorState(user, booking, 'Please choose how many spaces you need. At least ${host.bookingSettings!.minSpaces!}'));
    }
    else if(int.parse(spaceValue) > maxSpaceAvailable) {
      emit(SpacesErrorState(user, booking, 'There are only ${maxSpaceAvailable} available for the selected dates'));
    }
    else {
      booking = booking.copyWith(spaces: spaceValue);
      emit(SpacesChosen(user, booking));
    }
  }

  Booking finaliseBooking(Booking booking, String price, String commission, String totalPrice, User host) {
    // Booking booking = this.state.props[1] as Booking;
    User user = this.state.props[0] as User;

    booking = booking.copyWith(price: price,
        commission: commission,
        hostId: host.id,
        artistId: user.id,
    currencyCode: CurrencyHelper.currency(user.userInfo!.address!.country).currencyName,
    totalPrice: totalPrice);

    return booking;
    // emit(FinaliseBooking(user, booking));
  }

  void completeBooking(Booking booking, User user, User host, String paymentIntentId) async {
      try {
        emit(PaymentLoadingState());
        booking = booking.copyWith(bookingStatus: BookingStatus.pending,
            paymentIntentId: paymentIntentId, bookingTime: DateTime.now());
        String bookingId = await databaseService.addBooking(booking: booking);

        // booking.bookingId = bookingId;
        //
        // if(user.bookings != null && user.bookings!.isNotEmpty) {
        //   user.bookings!.insert(0, booking);
        // }
        // else {
        //   user.bookings = List.of([booking], growable: true);
        // }
        // databaseService.updateUser(user: user);
        //
        // if(host.bookings != null && host.bookings!.isNotEmpty) {
        //   host.bookings!.insert(0, booking);
        // }
        // else {
        //   host.bookings = List.of([booking], growable: true);
        // }
        // databaseService.updateUser(user: host);


        emit(PaymentLoadedState(user, booking));
      } catch (e) {
        emit(ErrorState());
      }
  }
}