import 'package:auth_service/auth.dart';
import 'package:database_service/database.dart';
import 'package:equatable/equatable.dart';

abstract class PersonalInfoState extends Equatable {

}

class InitialState extends PersonalInfoState {
  InitialState(this.artb2bUserEntityInfo);
  final UserInfo artb2bUserEntityInfo;

  @override
  List<Object> get props => [artb2bUserEntityInfo];
}

class UserTypeChosen extends PersonalInfoState {
  UserTypeChosen(this.artb2bUserEntityInfo);
  final UserInfo artb2bUserEntityInfo;


  @override
  List<Object> get props => [artb2bUserEntityInfo];
}

class NameChosen extends PersonalInfoState {
  final UserInfo artb2bUserEntityInfo;

  NameChosen(this.artb2bUserEntityInfo);


  @override
  List<Object> get props => [artb2bUserEntityInfo];
}

class AddressChosen extends PersonalInfoState {
  final UserInfo artb2bUserEntityInfo;

  AddressChosen(this.artb2bUserEntityInfo);


  @override
  List<Object> get props => [artb2bUserEntityInfo];
}

class DataSaved extends PersonalInfoState {
  final UserInfo artb2bUserEntityInfo;

  DataSaved(this.artb2bUserEntityInfo);


  @override
  List<Object> get props => [artb2bUserEntityInfo];
}


class ErrorState extends PersonalInfoState {
  final UserInfo userInfo;
  final String errorMessage;

  ErrorState(this.userInfo, this.errorMessage);

  @override
  List<Object> get props => [userInfo, errorMessage];
}

class LoadingState extends PersonalInfoState {

  @override
  List<Object> get props => [];
}