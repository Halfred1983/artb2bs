import 'package:artb2b/payment/view/payment_page.dart';
import 'package:artb2b/widgets/booking_calendar_widget.dart';
import 'package:artb2b/widgets/common_card_widget.dart';
import 'package:artb2b/widgets/loading_screen.dart';
import 'package:database_service/database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../injection.dart';
import '../../../utils/common.dart';
import '../../../widgets/input_text_widget.dart';
import '../../../widgets/summary_card.dart';
import '../../resources/styles.dart';
import '../../resources/theme.dart';
import '../cubit/exhibition_cubit.dart';
import '../cubit/exhibition_state.dart';

class ExhibitionView extends StatelessWidget {

  FirestoreDatabaseService firestoreDatabaseService = locator<FirestoreDatabaseService>();

  ExhibitionView({super.key});

  @override
  Widget build(BuildContext context) {
    User? user;
    return
      BlocBuilder<ExhibitionCubit, ExhibitionState>(
          builder: (context, state) {
            if (state is LoadingState) {
              return const LoadingScreen();
            }

            if (state is LoadedState) {
              user = state.props[0] as User;


              return Scaffold(
                  appBar: AppBar(
                    title: Text("Your Bookings", style: TextStyles.boldAccent24,),
                    centerTitle: true,
                  ),
                body: Container(),
              );
            }
            return Container();
          }
      );
  }
}
