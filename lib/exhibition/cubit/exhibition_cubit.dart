import 'package:database_service/database.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'exhibition_state.dart';



class ExhibitionCubit extends Cubit<ExhibitionState> {
  ExhibitionCubit({required this.databaseService,
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
}