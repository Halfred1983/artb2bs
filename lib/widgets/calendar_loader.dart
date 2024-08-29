import 'package:flutter/material.dart';

import '../app/resources/theme.dart';

class CalendarLoader extends StatelessWidget {
  const CalendarLoader({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
        height: 12,
        width: 12,
        margin: const EdgeInsets.only(top: 40),
        padding: const EdgeInsets.all(1),
        child: const CircularProgressIndicator(color: AppTheme.accentColor,)
    );
  }
}
