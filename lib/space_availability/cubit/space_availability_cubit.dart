import 'package:database_service/database.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

import 'space_availability_state.dart';



class SpaceAvailabilityCubit extends Cubit<SpaceAvailabilityState> {
  SpaceAvailabilityCubit({required this.databaseService,
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

  Future<void> setDates(User user, UnavailableSpaces unavailableSpaces) async {
    try {
      emit(LoadingState());
      await databaseService.setDisabledSpaces(user.id, unavailableSpaces);
      emit(LoadedState(user));
    } catch (e) {
      emit(ErrorState());
    }
  }

  void saveDates(User user, List<UnavailableSpaces> unavailableList) async {
    try {
      emit(LoadingState());
      await databaseService.saveDisabledSpaces(user.id, unavailableList);
      emit(LoadedState(user));
    } catch (e) {
      emit(ErrorState());
    }
  }



}