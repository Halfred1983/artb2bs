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
      // emit(LoadingState());

      if(user.userArtInfo != null) {
        user = user.copyWith(userArtInfo: user.userArtInfo!.copyWith(capacity: capacity));
      }
      else {
        user = user.copyWith(userArtInfo: UserArtInfo(capacity: capacity));
      }

      // emit(CapacityChosen(user));
    } catch (e) {
      emit(ErrorState());
    }
  }

  void chooseSpaces(String spaces) {
    User user = this.state.props[0] as User;

    try {
      // emit(LoadingState());

      if(user.userArtInfo != null) {
        user = user.copyWith(userArtInfo: user.userArtInfo!.copyWith(spaces: spaces));
      }
      else {
        user = user.copyWith(userArtInfo: UserArtInfo(spaces: spaces));
      }

      // emit(SpacesChosen(user));
    } catch (e) {
      emit(ErrorState());
    }
  }


  void save(List<String> tags) async {
    User user = this.state.props[0] as User;

    try {
      emit(LoadingState());

      if(user.userArtInfo != null) {
        user = user.copyWith(
            userStatus: UserStatus.artInfo,
            userArtInfo: user.userArtInfo!.copyWith(vibes: tags)
        );
      }
      else {
        user = user.copyWith(
            userStatus: UserStatus.artInfo,
            userArtInfo: UserArtInfo(vibes: tags));
      }

      await databaseService.updateUser(user: user);
      emit(DataSaved(user));
    } catch (e) {
      emit(ErrorState());
    }
  }
}