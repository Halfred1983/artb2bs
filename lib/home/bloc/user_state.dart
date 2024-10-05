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
  LoadedState(this.user, {this.pendingRequests, this.nextExhibition});

  final User user;
  int? pendingRequests;
  String? nextExhibition;

  @override
  List<Object> get props => [user, pendingRequests ?? 0, nextExhibition ?? ''];
}

class ErrorState extends UserState {
  @override
  List<Object> get props => [];
}