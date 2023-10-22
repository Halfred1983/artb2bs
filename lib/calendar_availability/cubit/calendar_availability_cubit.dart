import 'package:database_service/database.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

import 'calendar_availability_state.dart';



class CalendarAvailabilityCubit extends Cubit<CalendarAvailabilityState> {
  CalendarAvailabilityCubit({required this.databaseService,
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

  Future<void> setDates(User user, Unavailable unavailable) async {
    try {
      emit(LoadingState());
      await databaseService.setDisabledDates(user.id, unavailable);
      emit(LoadedState(user));
    } catch (e) {
      emit(ErrorState());
    }
  }

  void saveDates(User user, List<Unavailable> unavailableList) async {
    try {
      emit(LoadingState());
      await databaseService.saveDisabledDates(user.id, unavailableList);
      emit(LoadedState(user));
    } catch (e) {
      emit(ErrorState());
    }
  }



}