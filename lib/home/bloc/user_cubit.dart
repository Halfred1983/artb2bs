import 'package:artb2b/home/bloc/user_state.dart';
import 'package:database_service/database.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

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
      final user = await databaseService.getUser(userId: userId);
      final bookings = user!.bookings ?? [];
      int pendingRequests = bookings.where((booking) => booking.bookingStatus! == BookingStatus.pending)
                  .toList().length;
      emit(LoadedState(user, pendingRequests: pendingRequests));
    } catch (e) {
      emit(ErrorState());
    }
  }
}