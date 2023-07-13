import 'package:artb2b/personal_info/cubit/personal_info_state.dart';
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
      emit(LoadingState());

      artb2bUserEntityInfo = artb2bUserEntityInfo.copyWith(userType: userType);

      emit(UserTypeChosen(artb2bUserEntityInfo));
    } catch (e) {
      emit(ErrorState(artb2bUserEntityInfo));
    }
  }

  void chooseName(String name) {
    UserInfo artb2bUserEntityInfo = this.state.props[0] as UserInfo;

    try {
      emit(LoadingState());

      artb2bUserEntityInfo = artb2bUserEntityInfo.copyWith(name: name);

      emit(NameChosen(artb2bUserEntityInfo));
    } catch (e) {
      emit(ErrorState(artb2bUserEntityInfo));
    }
  }

  void chooseAddress(UserAddress artb2bUserEntityAddress) {
    UserInfo artb2bUserEntityInfo = this.state.props[0] as UserInfo;

    try {
      emit(LoadingState());

      artb2bUserEntityInfo = artb2bUserEntityInfo.copyWith(address: artb2bUserEntityAddress);

      emit(AddressChosen(artb2bUserEntityInfo));
    } catch (e) {
      emit(ErrorState(artb2bUserEntityInfo));
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
      emit(DataSaved(userInfo));
    } catch (e) {
      emit(ErrorState(userInfo));
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
}