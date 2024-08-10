import 'package:artb2b/utils/common.dart';
import 'package:database_service/database.dart';
import 'package:flutter/material.dart';

import '../app/resources/assets.dart';
import '../app/resources/styles.dart';
import '../app/resources/theme.dart';
import '../utils/currency/currency_helper.dart';
import 'common_card_widget.dart';

class VenueCard extends StatelessWidget {
  VenueCard({
    Key? key,
    required this.user,
    this.showActive = false,
  }) : super(key: key);

final User user;
bool showActive = false;

@override
Widget build(BuildContext context) {
  return Container(
    width: double.infinity,
    padding: verticalPadding8,
    child: CommonCard(
      padding: EdgeInsets.zero,
      borderRadius: BorderRadius.circular(24),
      child: Column(
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [

            if(user!.photos == null && user.photos!.isEmpty) ...[
              const Stack(
                children: [
                  SizedBox(
                    height: 200,
                    width: double.infinity,
                    child: FadeInImage(
                      placeholder: AssetImage(Assets.logo),
                      image:NetworkImage(Assets.logoUrl),
                      fit: BoxFit.fitWidth,
                    ), // Select photo dynamically using index
                  ),
                ],
              ),
            ]
            else ... [
              Stack(
                children: [
                  Container(
                    decoration: const BoxDecoration(
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(24),
                        topRight: Radius.circular(24),
                      ),
                    ),
                    width: double.infinity,
                    height: 200,
                    child: ClipRRect(
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(24),
                        topRight: Radius.circular(24),
                      ),
                      child: FadeInImage(
                        placeholder: const AssetImage(Assets.logo),
                        image: NetworkImage(user.photos![0].url!),
                        fit: BoxFit.fitWidth,
                      ),
                    ),
                  ),
                  if(showActive)...[
                    Positioned(
                      right: 8,
                      top: 8,
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(24),
                          color: user.bookingSettings!.active! ? AppTheme.s100 : AppTheme.d200,
                        ),
                        child: Center(
                          child: Padding(
                            padding: horizontalPadding8 + verticalPadding8,
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(user.bookingSettings!.active! ? 'Active' :'Inactive', style: TextStyles.semiBoldN90012.copyWith(color: AppTheme.white),),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ]
                  else...[
                    Positioned(
                      right: 8,
                      top: 8,
                      child: Container(
                        width: 53,
                        height: 38,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(24),
                          color: AppTheme.n900,
                        ),
                        child: Center(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text('From', style: TextStyles.regularPrimary10,),
                              Text(' ${user.bookingSettings!.basePrice!} '
                                  '${CurrencyHelper.currency(user.userInfo!.address!.country).currencySymbol}',
                                style: TextStyles.semiBoldPrimary12,),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ]
                ],
              ),
            ],
            SizedBox(
              height: 100,
              child: Padding(
                padding: horizontalPadding24 + verticalPadding12,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(user.userInfo!.name!, style: TextStyles.boldN90017,),
                    Row(
                      children: [
                        const Icon(Icons.location_pin, size: 10,),
                        Text(user.userInfo!.address!.city,
                          softWrap: true, style: TextStyles.regularN90010,),
                      ],
                    ),
                    verticalMargin12,                                    Text(user.venueInfo!.vibes != null ?
                    user.venueInfo!.vibes!.join(", ") :
                    '', softWrap: true, style: TextStyles.semiBoldP40010,),
                    verticalMargin8,
                    Text(user.venueInfo!.typeOfVenue!.join(", "),
                      softWrap: true, style: TextStyles.semiBoldN90010,),
                  ],
                ),

              ),
            )
          ]
      ),
    ),
  );
}
}