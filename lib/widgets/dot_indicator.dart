import 'package:flutter/material.dart';

import '../app/resources/theme.dart';

class LineIndicator extends StatelessWidget {
  final int totalSteps;
  final int currentStep;

  const LineIndicator({
    Key? key,
    required this.totalSteps,
    required this.currentStep,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: List.generate(totalSteps, (index) {
        return Container(
          margin: const EdgeInsets.symmetric(horizontal: 4.0),
          width: index == currentStep ? 40.0 : 16.0,
          height: 8.0,
          decoration: BoxDecoration(
            color: index == currentStep ? AppTheme.primaryColor : AppTheme.disabledButton,
            borderRadius: BorderRadius.circular(4),

          ),
        );
      }),
    );
  }
}