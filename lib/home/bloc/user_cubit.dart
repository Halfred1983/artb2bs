import 'package:artb2b/home/bloc/user_state.dart';
import 'package:artb2b/utils/common.dart';
import 'package:database_service/database.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:intl/intl.dart';

class UserCubit extends Cubit<UserState> {
  UserCubit({required this.databaseService,
    required this.userId}) : super(InitialState()) {
    getUser(userId);
  }

  final DatabaseService databaseService;
  final String userId;

  void getUser(String userId) async {
    try {
      emit(LoadingState());
      int pendingRequests = 0;
      int pastExhibitions = 0;

      final user = await databaseService.getUser(userId: userId);
      if(user!.userStatus != null && user.userInfo != null) {
        databaseService.findBookingsByUserStream(user!).listen((bookings) {

          pendingRequests = bookings
              .where((booking) =>
          booking.bookingStatus == BookingStatus.pending)
              .length;

          pastExhibitions = bookings
              .where((booking) => booking.bookingStatus == BookingStatus.accepted
              && booking.to!.isBefore(DateTime.now()))
              .length;

          List<Booking> nextBookings = bookings
              .where((booking) => booking.bookingStatus == BookingStatus.accepted
              && ( booking.from!.isAfter(DateTime.now()) || booking.from!.isSameDay(DateTime.now())))
              .toList();

          String nextExhibition = '';
          if (nextBookings.isNotEmpty) {
            nextBookings.sort((a, b) => a.from!.compareTo(b.from!));

            DateTime today = DateTime.now();
              if (nextBookings.first.from!.isSameDay(today)) {
                nextExhibition = 'today';
              } else {
                nextExhibition = DateFormat('EEE dd MMMM').format(nextBookings.first.from!);
              }
          }

          if(user.userInfo!.userType == UserType.gallery) {
            emit(LoadedState(user, pendingRequests: pendingRequests,
                nextExhibition: nextExhibition, pastExhibitions: pastExhibitions));
          }
          else {
            emit(LoadedState(user, pendingRequests: 0, nextExhibition: nextExhibition));
          }
        });
      }
      else {
        emit(LoadedState(user, pendingRequests: 0, nextExhibition: ''));
      }
    } catch (e) {
      print(e.toString());
      emit(ErrorState());
    }
  }
}