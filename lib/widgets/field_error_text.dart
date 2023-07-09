import 'package:artb2b/utils/common.dart';
import 'package:artb2b/app/resources/styles.dart';
import 'package:flutter/material.dart';

@immutable
class FieldErrorText extends StatelessWidget {
  const FieldErrorText({
    Key? key,
    required this.errorText,
  }) : super(key: key);

  final String? errorText;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      container: true,
      liveRegion: true,
      child: AnimatedSwitcher(
        duration: kThemeAnimationDuration,
        switchInCurve: Curves.easeOut,
        switchOutCurve: Curves.easeIn,
        transitionBuilder: (Widget child, Animation<double> animation) {
          return FadeTransition(
            opacity: animation,
            child: SizeTransition(
              sizeFactor: animation,
              axis: Axis.vertical,
              axisAlignment: 1.0,
              child: child,
            ),
          );
        },
        layoutBuilder: (Widget? currentChild, List<Widget> previousChildren) {
          return Stack(
            alignment: Alignment.topLeft,
            children: <Widget>[
              ...previousChildren,
              if (currentChild != null) currentChild,
            ],
          );
        },
        child: errorText != null
            ? Column(
          key: Key('errorText-$errorText!'),
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            verticalMargin4,
            Text(
              errorText!,
              style: TextStyles.semiBoldLightGrey14,
            ),
          ],
        )
            : emptyWidgetWide,
      ),
    );
  }
}
