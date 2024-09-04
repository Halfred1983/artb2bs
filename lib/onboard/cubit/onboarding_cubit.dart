import 'package:artb2b/utils/user_utils.dart';
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

      user = user.copyWith(userInfo: userInfo, userStatus: UserStatus.type);

      emit(LoadedState(user));
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

      emit(LoadedState(user));
    } catch (e) {
      emit(ErrorState(user, "Chose a valid user name"));
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

  void chooseSpaces(String spaces, {bool onboarding = true}) {
    User user = this.state.props[0] as User;
    emit(LoadingState());

    try {
      if (onboarding || _validateSpaces(spaces, user)) {
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
    String? currentErrorMessage;

    if (state is ErrorState) {
      currentErrorMessage = (state as ErrorState).errorMessage;
    }

    emit(LoadingState());

    try {
      if (audience.isNotEmpty && int.parse(audience) > 0) {
        if (user.venueInfo != null) {
          user = user.copyWith(
              venueInfo: user.venueInfo!.copyWith(audience: audience));
        } else {
          user = user.copyWith(venueInfo: VenueInfo(audience: audience));
        }
        if(currentErrorMessage == null) {
          emit(LoadedState(user));
        } else {
          emit(ErrorState(user, currentErrorMessage));
        }
      } else {
        emit(ErrorState(user, currentErrorMessage ?? "Audience value not valid"));
      }
    } catch (e) {
      emit(ErrorState(user, currentErrorMessage ?? "Audience value not valid"));
    }
  }

  bool _validateSpaces(String spaces, User user) {
    if (spaces.isNotEmpty && int.parse(spaces) > 0) {
      if (int.parse(spaces) <= int.parse(user.venueInfo!.spaces!)) {
        return true;
      } else {
        emit(ErrorState(user, "Chose a valid value for spaces. From 1 to ${user.venueInfo!.spaces!}. "
            "You can change your space availability in venue settings."));
        return false;
      }
    } else {
      emit(ErrorState(user, "Spaces value not valid"));
      return false;
    }
  }

  void choseVenueType(List<String> typeVenue) {
    User user = this.state.props[0] as User;
    emit(LoadingState());

    try {

      user = user.copyWith(
          venueInfo: user.venueInfo != null ?
          user.venueInfo!.copyWith(typeOfVenue: typeVenue)
              : VenueInfo(typeOfVenue: typeVenue));

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
          venueInfo: user.venueInfo != null ?
          user.venueInfo!.copyWith(vibes: vibes)
              : VenueInfo(vibes: vibes));

      emit(LoadedState(user));

    } catch (e) {
      emit(ErrorState(user ,"Audience value not valid"));
    }
  }

  void chooseAddress(UserAddress artb2bUserEntityAddress) {
    User user = this.state.props[0] as User;

    try {
      user = user.copyWith(userInfo:
      user.userInfo != null ?
      user.userInfo!.copyWith(address: artb2bUserEntityAddress) :
      UserInfo(address: artb2bUserEntityAddress));

      emit(AddressChosen(user));
    } catch (e) {
      emit(ErrorState(user, "Error in setting the address of the user"));
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
      emit(ErrorState(user ,"Tags value not valid"));
    }
  }

  void chooseBasePrice(String basePrice) {
    User user = this.state.props[0] as User;
    String? currentErrorMessage;

    if (state is ErrorState) {
      currentErrorMessage = (state as ErrorState).errorMessage;
    }

    try {
      // emit(LoadingState());

      if (user.bookingSettings != null) {
        user = user.copyWith(bookingSettings: user.bookingSettings!.copyWith(
            basePrice: basePrice));
      }
      else {
        user = user.copyWith(
            bookingSettings: BookingSettings(basePrice: basePrice));
      }

      if(currentErrorMessage == null) {
        emit(LoadedState(user));
      } else {
        emit(ErrorState(user, currentErrorMessage));
      }
    } catch (e) {
      emit(ErrorState(user, e.toString()));
    }
  }

  final List<BusinessDay> _businessDays = <BusinessDay>[
    BusinessDay(DayOfWeek.monday, [], null),
    BusinessDay(DayOfWeek.tuesday, [], null),
    BusinessDay(DayOfWeek.wednesday, [], null),
    BusinessDay(DayOfWeek.thursday, [], null),
    BusinessDay(DayOfWeek.friday, [], null),
    BusinessDay(DayOfWeek.saturday, [], null),
    BusinessDay(DayOfWeek.sunday, [], null),
  ];


  void updateBusinessDay(BusinessDay updatedDay) {
    User user = this.state.props[0] as User;

    emit(LoadingState());

    List<BusinessDay> updatedBusinessDays = [];
    if(user.venueInfo != null) {

      if(user.venueInfo!.openingTimes == null ||
          user.venueInfo!.openingTimes!.isEmpty) {
        user = user.copyWith(
            venueInfo: user.venueInfo!.copyWith(
                openingTimes: _businessDays)
        );
      }

      // Update the business days list
      updatedBusinessDays = user.venueInfo!.openingTimes!
          .map((day) {
        return day.dayOfWeek == updatedDay.dayOfWeek ? updatedDay : day;
      }).toList();

      // Update the user object with the new business days list
      user = user.copyWith(
          venueInfo: user.venueInfo!.copyWith(
              openingTimes: updatedBusinessDays)
      );
    }
    emit(BusinessDaysUpdated(user, updatedBusinessDays));
  }

  void chooseMinSpaces(String minSpaces) {
    User user = this.state.props[0] as User;

    try {
      if (user.bookingSettings != null) {
        user = user.copyWith(bookingSettings: user.bookingSettings!.copyWith(
            minSpaces: minSpaces));
      }
      else {
        user = user.copyWith(
            bookingSettings: BookingSettings(minSpaces: minSpaces));
      }

      if(int.parse(minSpaces) > int.parse(user.venueInfo!.spaces!)) {
        emit(ErrorState(user, "Chose a valid value for spaces. From 1 to ${user.venueInfo!.spaces!}. "
            "You can change your space availability in venue settings."));
        return;
      }

      emit(LoadedState(user));
    } catch (e) {
      emit(ErrorState(user, e.toString()));
    }
  }

  void chooseMinDays(String minLength) {
    User user = this.state.props[0] as User;
    String? currentErrorMessage;

    if (state is ErrorState) {
      currentErrorMessage = (state as ErrorState).errorMessage;
    }

    try {
      if (user.bookingSettings != null) {
        user = user.copyWith(bookingSettings: user.bookingSettings!.copyWith(
            minLength: minLength));
      }
      else {
        user = user.copyWith(
            bookingSettings: BookingSettings(minLength: minLength));
      }
      if(currentErrorMessage == null) {
        emit(LoadedState(user));
      } else {
        emit(ErrorState(user, currentErrorMessage));
      }
    } catch (e) {
      emit(ErrorState(user, e.toString()));
    }
  }


  void setActive(bool active) async {
    User user = this.state.props[0] as User;

    try {
      if (user.bookingSettings != null) {
        user = user.copyWith(bookingSettings: user.bookingSettings!.copyWith(
            active: active));
      }
      else {
        user = user.copyWith(
            bookingSettings: BookingSettings(active: active));
      }
      await databaseService.updateUser(user: user);
      emit(LoadedState(user));

    } catch (e) {
      emit(ErrorState(user, e.toString()));
    }
  }


  /////////// Art Info ///////////

  void choseArtStyle(String style) {
    User user = this.state.props[0] as User;
    emit(LoadingState());

    try {

      ArtStyle? artStyle = UserUtils().getArtStyleFromString(style);

      if (user.artInfo != null) {
        user = user.copyWith(
            artInfo: user.artInfo!.copyWith(artStyle: artStyle));
      }
      else {
        user = user.copyWith(artInfo: ArtInfo(artStyle: artStyle));
      }

      emit(LoadedState(user));

    } catch (e) {
      emit(ErrorState(user ,"ArtStyle value not valid"));
    }
  }


  void chooseArtistName(String artistName) {
    User user = this.state.props[0] as User;
    emit(LoadingState());

    try {

      if (user.artInfo != null) {
        user = user.copyWith(
            artInfo: user.artInfo!.copyWith(artistName: artistName));
      }
      else {
        user = user.copyWith(artInfo: ArtInfo(artistName: artistName));
      }

      emit(LoadedState(user));

    } catch (e) {
      emit(ErrorState(user ,"artistName value not valid"));
    }
  }

  void choseBio(String biography) {
    User user = this.state.props[0] as User;
    emit(LoadingState());

    try {

      if (user.artInfo != null) {
        user = user.copyWith(
            artInfo: user.artInfo!.copyWith(biography: biography));
      }
      else {
        user = user.copyWith(artInfo: ArtInfo(biography: biography));
      }

      emit(LoadedState(user));

    } catch (e) {
      emit(ErrorState(user ,"biography value not valid"));
    }
  }



  Future<void> save(User user, [UserStatus? userStatus]) async {
    // User user = this.state.props[0] as User;
    emit(LoadingState());

    try {

      if(userStatus != null) {
        user = user.copyWith(userStatus: userStatus);
      }
      await databaseService.updateUser(user: user);

      // Your save logic here
      emit(DataSaved(user));
    } catch (e) {
      emit(ErrorState(user, "Error saving the art details"));
    }
  }




}