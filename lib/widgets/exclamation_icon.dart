
import 'package:artb2b/app/resources/theme.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class ExclamationIcon extends StatelessWidget {
  const ExclamationIcon({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
        width: 20,
        height: 20,
        decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(color: AppTheme.d200)
        ),
        child: const Icon( FontAwesomeIcons.exclamation, color: AppTheme.d200, size: 15,)
    );
  }
}
