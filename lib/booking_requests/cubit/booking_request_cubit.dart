import 'package:database_service/database.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

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
      emit(LoadedState(user!, Booking(bookingStatus:BookingStatus.pending )));
    } catch (e) {
      emit(ErrorState());
    }
  }

  void completeBooking(Booking booking, User user, User host) async {
      try {
        emit(PaymentLoadingState());
        booking = booking.copyWith(bookingStatus: BookingStatus.accepted );
        String bookingId = await databaseService.addBooking(booking: booking);

        booking.bookingId = bookingId;

        if(user.bookings != null && user.bookings!.isNotEmpty) {
          user.bookings!.add(bookingId);
        }
        else {
          user.bookings = List.of([bookingId], growable: true);
        }
        databaseService.updateUser(user: user);

        if(host.bookings != null && host.bookings!.isNotEmpty) {
          host.bookings!.add(bookingId);
        }
        else {
          host.bookings = List.of([bookingId], growable: true);
        }
        databaseService.updateUser(user: host);


        emit(PaymentLoadedState(user, booking));
      } catch (e) {
        emit(ErrorState());
      }

  }

}