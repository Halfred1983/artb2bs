import 'package:artb2b/home/bloc/user_cubit.dart';
import 'package:artb2b/home/bloc/user_state.dart';
import 'package:artb2b/login/cubit/login_cubit.dart';
import 'package:artb2b/personal_info/view/personal_info_page.dart';
import 'package:artb2b/widgets/loading_screen.dart';
import 'package:auth_service/auth.dart';
import 'package:database_service/database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../app/resources/theme.dart';
import '../../injection.dart';
import '../../login/view/login_page.dart';
import '../../utils/common.dart';
import '../../widgets/map_view_2.dart';

class HomeView extends StatelessWidget {
  final FirebaseAuthService authService = locator.get<FirebaseAuthService>();
  final FirestoreDatabaseService firestoreDatabaseService = locator.get<FirestoreDatabaseService>();


  @override
  Widget build(BuildContext context) {
    UserEntity userEntity = authService.currentUser;
    User? artb2bUserEntity;
    return
      BlocBuilder<UserCubit, UserState>(
          builder: (context, state) {
            Widget widget = Container();
            if (state is LoadingState) {
              return const LoadingScreen();
            }
            if (state is LoadedState) {
              artb2bUserEntity = state.artb2bUserEntity;
              widget =  MapViewTwo(artb2bUserEntityl: artb2bUserEntity!);
              if (artb2bUserEntity!.userStatus == UserStatus.initialised) {
                return PersonalInfoPage();
              }
            }
            return Scaffold(
              body: Stack(
                  children: [
                    widget,
                    artb2bUserEntity != null ? Padding(
                      padding: horizontalPadding12 + verticalPadding48,
                      child: InkWell(
                        onTap: () => print("test"),
                        child: Material(
                          elevation: 10,
                          borderRadius: const BorderRadius.all(Radius.circular(50)),
                          child: ClipOval(
                              child: Image.network(artb2bUserEntity!.imageUrl, width: 70,)
                          ),
                        ),
                      ),
                    ) : Container()
                  ]
              ),
              bottomNavigationBar: ElevatedButton(
                  child: Text("Logout"),
                  onPressed: () =>
                  {
                    context
                        .read<LoginCubit>()
                        .logout(),
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const LoginPage()),
                    )
                  }),
            );
          }
      );
  }
}
