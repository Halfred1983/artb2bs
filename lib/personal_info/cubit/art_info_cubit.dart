import 'package:database_service/database.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'art_info_state.dart';

class ArtInfoCubit extends Cubit<ArtInfoState> {
  ArtInfoCubit({required this.databaseService,
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

  void chooseCapacity(String capacity) {
    User user = this.state.props[0] as User;

    try {
      emit(LoadingState());

      // artb2bUserEntityInfo = user.copyWith(name: name);

      emit(CapacityChosen(user));
    } catch (e) {
      emit(ErrorState());
    }
  }

  void chooseSpaces(String capacity) {
    User user = this.state.props[0] as User;

    try {
      emit(LoadingState());

      // artb2bUserEntityInfo = user.copyWith(name: name);

      emit(SpacesChosen(user));
    } catch (e) {
      emit(ErrorState());
    }
  }


  void save() async {
    UserInfo userInfo = this.state.props[0] as UserInfo;

    try {
      emit(LoadingState());
      User? user = await databaseService.getUser(
          userId: userId);

      //if all is good set to personal info
      user =
          user!.copyWith.userInfo(userInfo)
              .copyWith(userStatus: UserStatus.personalInfo);
      await databaseService.updateUser(user: user);
      emit(DataSaved(user));
    } catch (e) {
      emit(ErrorState());
    }
  }
}