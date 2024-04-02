import 'package:artb2b/app/resources/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../app/resources/assets.dart';

class AudienceWidget extends StatelessWidget {
  final int audienceCount;

  const AudienceWidget({
    Key? key,
    required this.audienceCount,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    const int totalIcons = 5;
    final int filledIcons = (audienceCount / 100).ceil();
    final List<Widget> icons = List.generate(totalIcons, (index) {
      if (index < filledIcons) {
        return SizedBox(
          width: 8,
          height: 14,
          child: SvgPicture.asset(
            Assets.audience,
            semanticsLabel: 'audience',
          ),
        );
      } else {
        return  SizedBox(
            width: 8,
            height: 14,
            child: SvgPicture.asset(
              Assets.audience,
              semanticsLabel: 'audience',
              colorFilter: const ColorFilter.mode(AppTheme.n200, BlendMode.srcIn),
            )
        );
      }
    });

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: icons,
    );
  }
}
