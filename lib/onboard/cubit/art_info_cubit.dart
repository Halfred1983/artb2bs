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
        if (user.venueInfo != null) {
          user = user.copyWith(
              venueInfo: user.venueInfo!.copyWith(aboutYou: aboutYou));
        }
        else {
          user = user.copyWith(venueInfo: VenueInfo(aboutYou: aboutYou));
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
        if (user.venueInfo != null) {
          user = user.copyWith(
              venueInfo: user.venueInfo!.copyWith(spaces: spaces));
        }
        else {
          user = user.copyWith(venueInfo: VenueInfo(spaces: spaces));
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


  void chooseAudience(String audience) {
    User user = this.state.props[0] as User;
    emit(LoadingState());

    try {
      if(audience.isNotEmpty && int.parse(audience) > 0) {
        if (user.venueInfo != null) {
          user = user.copyWith(
              venueInfo: user.venueInfo!.copyWith(audience: audience));
        }
        else {
          user = user.copyWith(venueInfo: VenueInfo(audience: audience));
        }
        emit(LoadedState(user));
      }
      else {
        emit(ErrorState(user ,"Audience value not valid"));
      }

    } catch (e) {
      emit(ErrorState(user ,"Audience value not valid"));
    }
  }

  void hostVenue(List<String> typeVenue) {
    User user = this.state.props[0] as User;
    emit(LoadingState());

    try {
        if (user.venueInfo != null) {
          user = user.copyWith(
              venueInfo: user.venueInfo!.copyWith(typeOfVenue: typeVenue));
        }
        else {
          user = user.copyWith(venueInfo: VenueInfo(typeOfVenue: typeVenue));
        }
        emit(LoadedState(user));

    } catch (e) {
      emit(ErrorState(user ,"Audience value not valid"));
    }
  }


  void artistTags(List<String> artistTags) {
    User user = this.state.props[0] as User;
    emit(LoadingState());

    try {
      if (user.venueInfo != null) {
        user = user.copyWith(
            venueInfo: user.venueInfo!.copyWith(vibes: artistTags));
      }
      else {
        user = user.copyWith(venueInfo: VenueInfo(vibes: artistTags));
      }
      emit(LoadedState(user));

    } catch (e) {
      emit(ErrorState(user ,"Audience value not valid"));
    }
  }

  void save() async {
    User user = this.state.props[0] as User;
    emit(LoadingState());

    if(user.userInfo!.userType! == UserType.gallery) {
      try {
        if (user.venueInfo == null || user.venueInfo!.spaces == null ||
            user.venueInfo!.spaces!.isEmpty ||
            int.parse(user.venueInfo!.spaces!) < 1 ||
            user.venueInfo!.audience!.isEmpty ||
            user.venueInfo!.typeOfVenue!.isEmpty
        ) {
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

      if (user.venueInfo == null || user.venueInfo!.aboutYou == null ||
          user.venueInfo!.aboutYou!.isEmpty) {
        emit(ErrorState(user, "Tell us something about you"));
        return;
      }

      if(user.venueInfo != null) {
        user = user.copyWith(
            userStatus: UserStatus.artInfo,
        );
      }
      // else {
      //   user = user.copyWith(
      //       userStatus: UserStatus.artInfo);
      // }

      await databaseService.updateUser(user: user);
      emit(DataSaved(user));
    } catch (e) {
      emit(ErrorState(user, "Error saving the art details"));
    }
  }

}