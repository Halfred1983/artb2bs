import 'package:artb2b/app/resources/theme.dart';
import 'package:artb2b/artwork/cubit/artwork_cubit.dart';
import 'package:artb2b/artwork/cubit/artwork_state.dart';
import 'package:artb2b/widgets/loading_screen.dart';
import 'package:artb2b/widgets/map_view.dart';
import 'package:database_service/database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:salomon_bottom_bar/salomon_bottom_bar.dart';

import '../../../login/cubit/login_cubit.dart';
import '../../../login/view/login_page.dart';
import '../../../utils/common.dart';
import '../../resources/styles.dart';


class ProfileView extends StatelessWidget {
  const ProfileView({super.key});

  @override
  Widget build(BuildContext context) {
    User? user;
    return Scaffold(
        appBar: AppBar(
          title: Text("Your Profile", style: TextStyles.boldAccent24,),
          centerTitle: true,
        ),
        body: Padding(
          padding: horizontalPadding24,
          child: Column(
            children: [
              ElevatedButton(
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
                  }
              ),
            ],
          ),
        )
    );
  }
}
