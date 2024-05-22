import 'package:auth_service/auth.dart';
import 'package:database_service/database.dart';
import 'package:equatable/equatable.dart';

abstract class OnboardingState extends Equatable {}

class InitialState extends OnboardingState {
  @override
  List<Object> get props => [];
}

class LoadingState extends OnboardingState {
  @override
  List<Object> get props => [];
}

class LoadedState extends OnboardingState {
  LoadedState(this.user);

  final User user;

  @override
  List<Object> get props => [user];
}

class CapacityChosen extends OnboardingState {
  CapacityChosen(this.user);
  final User user;


  @override
  List<Object> get props => [user];
}

class SpacesChosen extends OnboardingState {
  SpacesChosen(this.user);
  final User user;


  @override
  List<Object> get props => [user];
}

class DataSaved extends OnboardingState {
  DataSaved(this.user);
  final User user;


  @override
  List<Object> get props => [user];
}

class UserTypeChosen extends OnboardingState {
  UserTypeChosen(this.user);
  final User user;


  @override
  List<Object> get props => [user];
}

class NameChosen extends OnboardingState {
  NameChosen(this.user);
  final User user;


  @override
  List<Object> get props => [user];
}

class ErrorState extends OnboardingState {
  final String errorMessage;
  final User user;

  ErrorState(this.user, this.errorMessage);
  @override
  List<Object> get props => [user, errorMessage];
}