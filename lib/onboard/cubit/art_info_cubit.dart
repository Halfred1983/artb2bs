import 'package:auth_service/auth.dart';
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
      emit(ErrorState(User.empty(), "Something went wrong in loading the user details"));
    }
  }

  void choseAboutYou(String aboutYou) {
    User user = this.state.props[0] as User;

    try {
      emit(LoadingState());
      if(aboutYou.isNotEmpty) {
        if (user.userArtInfo != null) {
          user = user.copyWith(
              userArtInfo: user.userArtInfo!.copyWith(aboutYou: aboutYou));
        }
        else {
          user = user.copyWith(userArtInfo: UserArtInfo(aboutYou: aboutYou));
        }
        emit(LoadedState(user));
      }
      else {
        emit(ErrorState(user ,"Tell us something about you"));
      }
    } catch (e) {
      emit(ErrorState(user, "Tell us something about you"));
    }
  }

  void chooseSpaces(String spaces) {
    User user = this.state.props[0] as User;
    emit(LoadingState());

    try {
      if(spaces.isNotEmpty && int.parse(spaces) > 0) {
        if (user.userArtInfo != null) {
          user = user.copyWith(
              userArtInfo: user.userArtInfo!.copyWith(spaces: spaces));
        }
        else {
          user = user.copyWith(userArtInfo: UserArtInfo(spaces: spaces));
        }
        emit(LoadedState(user));
      }
      else {
        emit(ErrorState(user ,"Spaces value not valid"));
      }

    } catch (e) {
      emit(ErrorState(user ,"Spaces value not valid"));
    }
  }


  void save(List<String> tags) async {
    User user = this.state.props[0] as User;
    emit(LoadingState());

    if(user.userInfo!.userType! == UserType.gallery) {
      try {
        if (user.userArtInfo == null || user.userArtInfo!.spaces == null ||
            user.userArtInfo!.spaces!.isEmpty ||
            int.parse(user.userArtInfo!.spaces!) < 1) {
          emit(ErrorState(user, "Spaces value not valid"));
          return;
        }
      }
      catch (e) {
        emit(ErrorState(user, "About you or Spaces value not valid"));
        return;
      }
    }

    try {

      if (user.userArtInfo == null || user.userArtInfo!.aboutYou == null ||
          user.userArtInfo!.aboutYou!.isEmpty) {
        emit(ErrorState(user, "Tell us something about you"));
        return;
      }

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
      emit(ErrorState(user, "Error saving the art details"));
    }
  }
}