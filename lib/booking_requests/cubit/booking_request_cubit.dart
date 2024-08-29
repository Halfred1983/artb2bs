import 'package:artb2b/utils/common.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:database_service/database.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

import 'booking_request_state.dart';

class BookingRequestCubit extends Cubit<BookingRequestState> {
  final DatabaseService databaseService;
  final String userId;
  DocumentSnapshot? _lastDocument;
  bool _hasMoreData = true;

  BookingRequestCubit({required this.databaseService, required this.userId})
      : super(InitialState(User.empty())) {
    getUser(userId);
  }

  void getUser(String userId) async {
    try {
      emit(LoadingState(user: User.empty(), bookings: [], filter: 'All'));
      final user = await databaseService.getUser(userId: userId);
      if (user != null) {
        emit(LoadedState(user: user, bookings: [], filter: 'All', hasMoreData: true));
        fetchBookings(user: user, filter: 'All', reset: true);
      } else {
        emit(ErrorState(user: User.empty(), bookings: [], filter: 'All', error: 'User not found'));
      }
    } catch (e) {
      emit(ErrorState(user: User.empty(), bookings: [], filter: 'All', error: e.toString()));
    }
  }

  Future<void> fetchBookings({required User user, required String filter, bool reset = false}) async {
    // If the state is already loading or there is no more data, don't fetch more data
    if (state is LoadingState || !_hasMoreData && !reset) return;

    if (reset) {
      // Reset pagination when switching filters
      _lastDocument = null;
      _hasMoreData = true;
      emit(LoadingState(user: user, bookings: [], filter: filter));
    } else {
      emit(LoadingState(user: user, bookings: state.bookings, filter: filter));
    }

    try {
      final stream = databaseService.findBookingsByUserNordStream(
        user,
        startAfter: _lastDocument,
        limit: 10,
        status: Booking().getBookingStatusFromFilter(filter),
        startDate: filter == 'Upcoming' ? DateTime.now() : null,
      );

      await for (var newDocuments in stream) {
        if (newDocuments.isNotEmpty) {
          final newBookings = newDocuments.map((document) {
            return Booking.fromJson(document.data() as Map<String, dynamic>);
          }).toList();

          _lastDocument = newDocuments.last;
          _hasMoreData = newDocuments.length == 10;  // If less than 10 documents were returned, assume no more data
          emit(LoadedState(
            user: user,
            bookings: [...state.bookings, ...newBookings],
            filter: filter,
            hasMoreData: _hasMoreData,
          ));
        } else {
          // No more data to load
          _hasMoreData = false;
          emit(LoadedState(
            user: user,
            bookings: state.bookings,
            filter: filter,
            hasMoreData: _hasMoreData,
          ));
        }
      }
    } catch (e) {
      emit(ErrorState(user: user, bookings: state.bookings, filter: filter, error: e.toString()));
    }
  }
  Future<List<Booking>> fetchBookingList({required User user, required String filter, bool reset = false}) async {
    // If the state is already loading or there is no more data, don't fetch more data


    if (reset) {
      // Reset pagination when switching filters
      _lastDocument = null;
      _hasMoreData = true;
    }

    try {
      final stream = databaseService.findBookingsByUserNordStream(
        user,
        startAfter: _lastDocument,
        limit: 10,
        status: Booking().getBookingStatusFromFilter(filter),
        startDate: filter == 'Upcoming' ? DateTime.now() : null,
      );

      await for (var newDocuments in stream) {
        if (newDocuments.isNotEmpty) {
          final newBookings = newDocuments.map((document) {
            return Booking.fromJson(document.data() as Map<String, dynamic>);
          }).toList();

          _lastDocument = newDocuments.last;
          _hasMoreData = newDocuments.length == 10;  // If less than 10 documents were returned, assume no more data
          return newBookings;
        } else {
          // No more data to load
          return [];
        }
      }
    } catch (e) {
      emit(ErrorState(user: user, bookings: state.bookings, filter: filter, error: e.toString()));
    }
    return [];

  }


  void exitAlert(User user) {
    emit(LoadedState(user: user, bookings: state.bookings, filter: state.filter, hasMoreData: _hasMoreData));
  }

  void rejectBooking(Booking booking, User user) async {
    try {
      emit(LoadingState(user: User.empty(),bookings: [],filter:  'All'));
      booking = booking.copyWith(bookingStatus: BookingStatus.rejected , reviewdTime: DateTime.now());
      Refund refund = Refund(bookingId: booking.bookingId, paymentIntentId: booking.paymentIntentId,
          refundStatus: RefundStatus.pending, refundTimestamp: DateTime.now(),
          artistId: booking.artistId, hostId: booking.hostId);
      await databaseService.updateBooking(booking: booking);
      await databaseService.createRefundRequest(refund);
      emit(LoadedState(user: user, bookings: [], filter: 'All',));
    } catch (e) {
      emit(ErrorState(user: User.empty(), bookings: [], filter: 'All', error: e.toString()));
    }
  }

  void acceptBooking(Booking booking, User host, User artist) async {
    try {
      emit(LoadingState(user: User.empty(),bookings: [],filter:  'All'));

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
        emit(OverlapErrorState(user: host, bookings: bookings, filter: 'All', message: 'There are not enough free spaces for '
            'the dates:\n from ${DateFormat.yMMMEd().format(booking.from!)} \n'
            'to ${DateFormat.yMMMEd().format(booking.to!)}' ));
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

        //CALCULATE THE COMMISSION FOR THE HOST BASED ON THE BOOKING PRICE
        //SET IT IN THE BALANCE OF THE HOST

        await databaseService.updateUser(user: host);
        await databaseService.updateUser(user: artist);
        emit(LoadedState(user: host, bookings: [], filter: 'All',));
      }
    } catch (e) {
      emit(ErrorState(user: User.empty(), bookings: [], filter: 'All', error: e.toString()));
    }
  }

  void cancelBooking(Booking booking, User user) async {
    try {
      emit(LoadingState(user: User.empty(),bookings: [],filter:  'All'));
      booking = booking.copyWith(bookingStatus: BookingStatus.cancelled , reviewdTime: DateTime.now());
      Refund refund = Refund(bookingId: booking.bookingId, paymentIntentId: booking.paymentIntentId,
          refundStatus: RefundStatus.pending, refundTimestamp: DateTime.now(),
          artistId: booking.artistId, hostId: booking.hostId);
      await databaseService.updateBooking(booking: booking);
      await databaseService.createRefundRequest(refund);
      emit(LoadedState(user: user, bookings: [], filter: 'All',));
    } catch (e) {
      emit(ErrorState(user: User.empty(), bookings: [], filter: 'All', error: e.toString()));
    }
  }
}
