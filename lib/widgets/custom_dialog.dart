import 'package:artb2b/utils/common.dart';
import 'package:flutter/material.dart';

import '../app/resources/styles.dart';
import '../app/resources/theme.dart';

class CustomAlertDialog extends StatelessWidget {
  final String title;
  final String content;
  final List<Widget> actions;
  final AlertType type;

  const CustomAlertDialog({
    Key? key,
    required this.title,
    required this.content,
    required this.actions,
    required this.type,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    IconData icon;
    Color iconColor;

    switch (type) {
      case AlertType.error:
        icon = Icons.error_sharp;
        iconColor = AppTheme.d200;
        break;
      case AlertType.confirmation:
        icon = Icons.help;
        iconColor = AppTheme.s300;
        break;
      case AlertType.success:
        icon = Icons.check_circle;
        iconColor = AppTheme.s100;
        break;
    }

    return AlertDialog(
      backgroundColor: AppTheme.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      title: Column(
        children: [
          Icon(icon, color: iconColor, size: 40),
          verticalMargin16,
          Center(child: Text(title, style: TextStyles.semiBoldN90017)),
        ],
      ),
      content: Text(content, textAlign: TextAlign.center, style: TextStyle(fontSize: 16)),
      actions: actions,
      shadowColor: Colors.black,
      elevation: 24,
    );
  }
}

enum AlertType {
  error,
  confirmation,
  success,
}