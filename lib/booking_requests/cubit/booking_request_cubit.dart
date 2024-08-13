import 'package:artb2b/utils/common.dart';
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

  void acceptBooking(Booking booking, User host, User artist) async {
      try {
        emit(LoadingState());

        var bookings = await databaseService.findBookingsByUser(host);

        int freeSpaces = int.parse(host.venueInfo!.spaces!) -  int.parse(booking.spaces!);
        for(var book in bookings) {
          if(booking.from!.isBeforeWithoutTime(book.to!) && booking.to!.isAfterWithoutTime(book.from!)
              && booking.bookingId != book.bookingId &&
              book.bookingStatus == BookingStatus.accepted) {

            freeSpaces = freeSpaces - int.parse(book.spaces!);
          }
        }

        if(freeSpaces < 0) {
          emit(OverlapErrorState('There are not enough free spaces for '
              'the dates:\n from ${DateFormat.yMMMEd().format(booking.from!)} \n'
              'to ${DateFormat.yMMMEd().format(booking.to!)}', host));
        }
        else {
          booking = booking.copyWith(bookingStatus: BookingStatus.accepted , reviewdTime: DateTime.now());
          await databaseService.updateBooking(booking: booking);
          Accepted accepted = Accepted(hostId: booking.hostId,
              artistId: booking.artistId, bookingId: booking.bookingId,
          acceptedTimestamp: DateTime.now());
          await databaseService.createAccepted(accepted);

          host = host.copyWith(exhibitionCount: host.exhibitionCount + 1);
          artist = artist.copyWith(exhibitionCount: artist.exhibitionCount + 1);

          await databaseService.updateUser(user: host);
          await databaseService.updateUser(user: artist);
          emit(LoadedState(host));
        }
      } catch (e) {
        emit(ErrorState());
      }
  }

  void rejectBooking(Booking booking, User user) async {
    try {
      emit(LoadingState());
      booking = booking.copyWith(bookingStatus: BookingStatus.rejected , reviewdTime: DateTime.now());
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

  void cancelBooking(Booking booking, User user) async {
    try {
      emit(LoadingState());
      booking = booking.copyWith(bookingStatus: BookingStatus.cancelled , reviewdTime: DateTime.now());
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


  void updateFilter(String filter, User user) {
    emit(FilterState(user, filter));
  }


  void exitAlert(User user) {
    emit(LoadedState(user));
  }


}