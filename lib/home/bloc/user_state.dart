import 'package:auth_service/auth.dart';
import 'package:database_service/database.dart';
import 'package:equatable/equatable.dart';

abstract class UserState extends Equatable {}

class InitialState extends UserState {
  @override
  List<Object> get props => [];
}

class LoadingState extends UserState {
  @override
  List<Object> get props => [];
}

class LoadedState extends UserState {
  LoadedState(this.artb2bUserEntity);

  final User artb2bUserEntity;

  @override
  List<Object> get props => [artb2bUserEntity];
}

class ErrorState extends UserState {
  @override
  List<Object> get props => [];
}