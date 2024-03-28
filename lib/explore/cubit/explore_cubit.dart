import 'package:database_service/database.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'explore_state.dart';


class ExploreCubit extends Cubit<ExploreState> {
  ExploreCubit({required this.databaseService,
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
      emit(ErrorState());
    }
  }

  // void save(List<String> tags) async {
  //   User user = this.state.props[0] as User;
  //
  //   try {
  //     emit(LoadingState());
  //
  //     if(user.userArtInfo != null) {
  //       user = user.copyWith(
  //           userStatus: UserStatus.artInfo,
  //           userArtInfo: user.userArtInfo!.copyWith(vibes: tags)
  //       );
  //     }
  //     else {
  //       user = user.copyWith(
  //           userStatus: UserStatus.artInfo,
  //           userArtInfo: UserArtInfo(vibes: tags));
  //     }
  //
  //     await databaseService.updateUser(user: user);
  //     emit(DataSaved(user));
  //   } catch (e) {
  //     emit(ErrorState());
  //   }
  // }
}