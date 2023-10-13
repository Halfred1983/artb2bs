import 'package:database_service/database.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

import 'booking_request_state.dart';



class BookingRequestCubit extends Cubit<BookingRequestState> {
  BookingRequestCubit({required this.databaseService,
    required this.userId}) : super(InitialState()) {
    getUser(userId);
  }

  final DatabaseService databaseService;
  final String userId;

  void getUser(String userId) async {
    try {
      emit(LoadingState());
      final user = await databaseService.getUser(userId: userId);
      emit(LoadedState(user!));
    } catch (e) {
      emit(ErrorState());
    }
  }

  void acceptBooking(Booking booking, User user) async {
      try {
        emit(LoadingState());

        var overlap = '';
        var bookings = await databaseService.retrieveBookingList(user: user);

        for(var book in bookings) {
          if(booking.from!.isBefore(book.to!) && booking.to!.isAfter(book.from!)
              && booking.bookingId != book.bookingId && book.bookingStatus == BookingStatus.accepted) {

            overlap = 'from ${DateFormat.yMMMEd().format(booking.from!)} \nto ${DateFormat.yMMMEd().format(booking.to!)}';
          }
        }

        if(overlap.length > 1) {
          emit(OverlapErrorState('There is already a booking confirmed in the dates:\n $overlap', user));
        }
        else {
          booking = booking.copyWith(bookingStatus: BookingStatus.accepted );
          await databaseService.updateBooking(booking: booking);
          Accepted accepted = Accepted(hostId: booking.hostId,
              artistId: booking.artistId, bookingId: booking.bookingId,
          acceptedTimestamp: DateTime.now());
          await databaseService.createAccepted(accepted);
          emit(LoadedState(user));
        }
      } catch (e) {
        emit(ErrorState());
      }
  }

  void rejectBooking(Booking booking, User user) async {
    try {
      emit(LoadingState());
      booking = booking.copyWith(bookingStatus: BookingStatus.rejected );
      Refund refund = Refund(bookingId: booking.bookingId, paymentIntentId: booking.paymentIntentId,
          refundStatus: RefundStatus.pending, refundTimestamp: DateTime.now(),
          artistId: booking.artistId, hostId: booking.hostId);
      await databaseService.updateBooking(booking: booking);
      await databaseService.createRefundRequest(refund);
      emit(LoadedState(user));
    } catch (e) {
      emit(ErrorState());
    }
  }

  void exitAlert(User user) {
    emit(LoadedState(user));
  }

}