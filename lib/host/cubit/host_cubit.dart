import 'package:artb2b/utils/common.dart';
import 'package:database_service/database.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'host_state.dart';


class HostCubit extends Cubit<HostState> {
  HostCubit({required this.databaseService,
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
    }
  }

  void choosePaypalAccount(String paypalAccount) {
    User user = this.state.props[0] as User;

    try {
      if(!paypalAccount.isValidEmail()) {
        emit(ErrorState(user, 'Paypal account must be an email.'));
      }
      else{
        if (user.bookingSettings != null) {
          user = user.copyWith(bookingSettings: user.bookingSettings!.copyWith(
              paypalAccount: paypalAccount));
        }
        else {
          user = user.copyWith(
              bookingSettings: BookingSettings(paypalAccount: paypalAccount));
        }

        emit(BookingSettingsDetail(user));
      }
    } catch (e) {
      emit(ErrorState(user, e.toString()));
    }
  }

  Future<void> saveBookingSettings() async {
    User user = this.state.props[0] as User;

    try {
      emit(LoadingState());
      await databaseService.updateUser(user: user);
      emit(DataSaved(user));
    } catch (e) {
      emit(ErrorState(user, e.toString()));
    }
  }
}