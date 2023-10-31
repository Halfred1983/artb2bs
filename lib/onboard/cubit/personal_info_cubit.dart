import 'package:artb2b/onboard/cubit/personal_info_state.dart';
import 'package:database_service/database.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class PersonalInfoCubit extends Cubit<PersonalInfoState> {
  PersonalInfoCubit({required this.databaseService,
    required this.userId}) : super(InitialState(UserInfo(userType: UserType.unknown)));

  final DatabaseService databaseService;
  final String userId;


  void chooseUserType(UserType userType) {
    UserInfo artb2bUserEntityInfo = this.state.props[0] as UserInfo;

    try {
      if(userType == UserType.unknown) emit(ErrorState(artb2bUserEntityInfo, "Chose gallery or artist"));

      artb2bUserEntityInfo = artb2bUserEntityInfo.copyWith(userType: userType);

      emit(UserTypeChosen(artb2bUserEntityInfo));
    } catch (e) {
      emit(ErrorState(artb2bUserEntityInfo, "Invalid value for user type"));
    }
  }

  void chooseName(String name) {
    UserInfo artb2bUserEntityInfo = this.state.props[0] as UserInfo;

    try {
      if(name.isEmpty) emit(ErrorState(artb2bUserEntityInfo, "Chose a valid user name"));
      artb2bUserEntityInfo = artb2bUserEntityInfo.copyWith(name: name);

      emit(NameChosen(artb2bUserEntityInfo));
    } catch (e) {
      emit(ErrorState(artb2bUserEntityInfo, "Chose a valid user name"));
    }
  }

  void chooseAddress(UserAddress artb2bUserEntityAddress) {
    UserInfo artb2bUserEntityInfo = this.state.props[0] as UserInfo;

    try {
      artb2bUserEntityInfo = artb2bUserEntityInfo.copyWith(address: artb2bUserEntityAddress);

      emit(AddressChosen(artb2bUserEntityInfo));
    } catch (e) {
      emit(ErrorState(artb2bUserEntityInfo, "Error in setting the address of the user"));
    }
  }

  void save() async {
    UserInfo? userInfo = this.state.props[0] as UserInfo;
    emit(LoadingState()); //needed to capture the cahnge of state

    if(userInfo.userType == UserType.unknown ) {
    emit(ErrorState(userInfo, "Chose a valid user type: Gallery or Artist"));
    }
    else if(userInfo.name == null || userInfo.name!.isEmpty) {
      emit(ErrorState(userInfo, "Chose a valid user name"));
    }

    else if(userInfo.address == null || userInfo.address!.formattedAddress.isEmpty ) {
      emit(ErrorState(userInfo, "Chose a valid address"));
    }



    else {
      try {

        emit(LoadingState());
        User? user = await databaseService.getUser(
            userId: userId);

        //if all is good set to personal info
        user =
            user!.copyWith.userInfo(userInfo)
                .copyWith(userStatus: UserStatus.personalInfo);
        await databaseService.updateUser(user: user);
        emit(DataSaved(userInfo));

      }
      catch (e) {
          emit(ErrorState(userInfo, "Error in saving the user details"));
        }
      }
    }
  }


// void getUser(String userId) async {
//   try {
//     emit(LoadingState());
//     final user = await databaseService.getUser(userId: userId);
//     emit(LoadedState(user));
//   } catch (e) {
//     emit(ErrorState());
//   }
// }
