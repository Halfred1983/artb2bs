import 'package:artb2b/app/resources/styles.dart';
import 'package:artb2b/app/resources/theme.dart';
import 'package:artb2b/booking/view/booking_page.dart';
import 'package:artb2b/injection.dart';
import 'package:artb2b/utils/common.dart';
import 'package:artb2b/widgets/host_widget.dart';
import 'package:database_service/database.dart';
import 'package:flutter/material.dart';

import '../utils/currency/currency_helper.dart';

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
              return Scaffold(
                  appBar: AppBar(
                    scrolledUnderElevation: 0,
                    title: Text(user.userInfo!.name!, style: TextStyles.boldN90017,),
                    centerTitle: true,
                    iconTheme: const IconThemeData(
                      color: AppTheme.n900, //change your color here
                    ),
                    elevation: 0,
                  ),
                  body: HostProfileWidget(user: user),
                  bottomNavigationBar:
                  Container(
                    width: double.infinity,
                    height: 110,
                    decoration: BoxDecoration(
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.30),
                            offset: const Offset(0, -10),
                            blurRadius: 7,
                            spreadRadius: 0,
                          )
                        ],
                        color: AppTheme.white,
                        borderRadius: const BorderRadius.only(
                            topLeft: Radius.circular(15.0),
                            topRight: Radius.circular(15.0)
                        )
                    ),
                    child: SizedBox(
                      width: double.infinity,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          horizontalMargin32,
                          Column(
                            children: [
                              Expanded(child: Container()),
                              Text('From ${user.bookingSettings!.basePrice!} '
                                  '${CurrencyHelper.currency(user.userInfo!.address!.country).currencySymbol}',
                                style: TextStyles.boldN90014,),
                              Text('Space per day',
                                style: TextStyles.semiBoldN90012,),
                              Expanded(child: Container()),

                            ],
                          ),
                          Flexible(child: Container()),
                          ElevatedButton(
                            onPressed:() {
                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) => BookingPage(host: snapshot.data!,)),
                              );
                            },
                            child: Text('Book Now', style: TextStyles.semiBoldPrimary14,),),
                          horizontalMargin32,
                        ],
                      ),
                    ),
                  )
              );

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