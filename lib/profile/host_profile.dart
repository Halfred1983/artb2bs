import 'package:artb2b/app/resources/styles.dart';
import 'package:artb2b/app/resources/theme.dart';
import 'package:artb2b/artwork/view/artwork_details.dart';
import 'package:artb2b/booking/view/booking_page.dart';
import 'package:artb2b/host/view/photo_details.dart';
import 'package:artb2b/injection.dart';
import 'package:artb2b/utils/common.dart';
import 'package:artb2b/widgets/booking_settings.dart';
import 'package:artb2b/widgets/fadingin_picture.dart';
import 'package:artb2b/widgets/host_widget.dart';
import 'package:artb2b/widgets/loading_screen.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:database_service/database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:flutter_svg/svg.dart';
import 'package:lottie/lottie.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

import '../app/resources/assets.dart';
import '../utils/currency/currency_helper.dart';
import '../widgets/audience.dart';

class HostProfilePage extends StatefulWidget {
  final String userId;

  HostProfilePage({Key? key, required this.userId})
      : super(key: key);

  @override
  State<HostProfilePage> createState() => _HostProfilePageState();
}

class _HostProfilePageState extends State<HostProfilePage> {
  final FirestoreDatabaseService databaseService = locator<FirestoreDatabaseService>();
  int _currentIndex = 0;
  final controller = PageController(viewportFraction: 1, keepPage: true);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<User?>(
        future: databaseService.getUser(userId: widget.userId),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return  Container(height: 10,);
          } else if (snapshot.connectionState == ConnectionState.active
              || snapshot.connectionState == ConnectionState.done) {

            if (snapshot.hasData && snapshot.data != null) {
              User user = snapshot.data!;
              return HostProfileWidget(user: user);
            }
            else {
              return Container();
            }
          }
          else {
            return Container();
          }
        }
    );
  }
}