import 'package:auth_service/auth.dart';
import 'package:database_service/database.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'onboarding_state.dart';

class OnboardingCubit extends Cubit<OnboardingState> {
  OnboardingCubit({required this.databaseService,
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


  void chooseUserType(UserType userType) {
    User user = this.state.props[0] as User;

    try {
      if(userType == UserType.unknown) emit(ErrorState(user, "Chose gallery or artist"));

      UserInfo userInfo = UserInfo(userType: userType);

      user = user.copyWith(userInfo: userInfo);

      emit(UserTypeChosen(user));
    } catch (e) {
      emit(ErrorState(user, "Invalid value for user type"));
    }
  }

  void chooseName(String name) {
    User user = this.state.props[0] as User;

    try {
      if(name.isEmpty) emit(ErrorState(user, "Chose a valid user name"));
      user = user.copyWith(userInfo: user.userInfo != null ?
      user.userInfo!.copyWith(name: name) : UserInfo(name: name));

      emit(NameChosen(user));
    } catch (e) {
      emit(ErrorState(user, "Chose a valid user name"));
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


  void chooseAudience(String audience) {
    User user = this.state.props[0] as User;
    emit(LoadingState());

    try {
      if(audience.isNotEmpty && int.parse(audience) > 0) {
        if (user.userArtInfo != null) {
          user = user.copyWith(
              userArtInfo: user.userArtInfo!.copyWith(audience: audience));
        }
        else {
          user = user.copyWith(userArtInfo: UserArtInfo(audience: audience));
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

  void choseVenueType(List<String> typeVenue) {
    User user = this.state.props[0] as User;
    emit(LoadingState());

    try {

          user = user.copyWith(
              userArtInfo: user.userArtInfo != null ?
              user.userArtInfo!.copyWith(typeOfVenue: typeVenue)
              : UserArtInfo(typeOfVenue: typeVenue));

        emit(LoadedState(user));

    } catch (e) {
      emit(ErrorState(user ,"Audience value not valid"));
    }
  }

  void choseVibes(List<String> vibes) {
    User user = this.state.props[0] as User;
    emit(LoadingState());

    try {

      user = user.copyWith(
          userArtInfo: user.userArtInfo != null ?
          user.userArtInfo!.copyWith(vibes: vibes)
              : UserArtInfo(vibes: vibes));

      emit(LoadedState(user));

    } catch (e) {
      emit(ErrorState(user ,"Audience value not valid"));
    }
  }



  void artistTags(List<String> artistTags) {
    User user = this.state.props[0] as User;
    emit(LoadingState());

    try {
      if (user.userArtInfo != null) {
        user = user.copyWith(
            userArtInfo: user.userArtInfo!.copyWith(vibes: artistTags));
      }
      else {
        user = user.copyWith(userArtInfo: UserArtInfo(vibes: artistTags));
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
        if (user.userArtInfo == null || user.userArtInfo!.spaces == null ||
            user.userArtInfo!.spaces!.isEmpty ||
            int.parse(user.userArtInfo!.spaces!) < 1 ||
            user.userArtInfo!.audience!.isEmpty ||
            user.userArtInfo!.typeOfVenue!.isEmpty
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

      if (user.userArtInfo == null || user.userArtInfo!.aboutYou == null ||
          user.userArtInfo!.aboutYou!.isEmpty) {
        emit(ErrorState(user, "Tell us something about you"));
        return;
      }

      if(user.userArtInfo != null) {
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