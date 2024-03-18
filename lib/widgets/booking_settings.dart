
import 'package:artb2b/app/resources/styles.dart';
import 'package:artb2b/utils/common.dart';
import 'package:database_service/database.dart';
import 'package:flutter/material.dart';

import '../utils/currency/currency_helper.dart';

class BookingSettingsWidget extends StatelessWidget {
  const BookingSettingsWidget({
    super.key,
    required this.user,
  });

  final User? user;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Text('Base price per space: ', style: TextStyles.semiBoldAccent16, ),
              Text('${user!.bookingSettings!.basePrice ?? 'n/a'} '
                  '${CurrencyHelper.currency(user!.userInfo!.address!.country).currencySymbol}', style: TextStyles.semiBoldViolet16, ),
            ]
        ),
        verticalMargin12,
        Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Text('Minimum length: ', style: TextStyles.semiBoldAccent16, ),
              Text('${user!.bookingSettings!.minLength ?? 'n/a'} days', style: TextStyles.semiBoldViolet16, ),
            ]
        ),
        verticalMargin12,
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Text('Minimum spaces: ', style: TextStyles.semiBoldAccent16, ),
            Text(user!.bookingSettings!.minLength ?? 'n/a', style: TextStyles.semiBoldViolet16, ),
          ],
        ),
      ],
    );
  }
}
