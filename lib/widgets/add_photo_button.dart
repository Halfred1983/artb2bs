
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';

import '../app/resources/styles.dart';
import '../app/resources/theme.dart';
import '../photo/view/artwork_upload_page.dart';

class AddPhotoButton extends StatelessWidget {

  AddPhotoButton({
    super.key, required this.action,
  });

  final Function action;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        action();
      },

      child: DottedBorder(
        color: AppTheme.divider,
        strokeWidth: 2,
        borderType: BorderType.RRect,
        radius: const Radius.circular(12),
        dashPattern: const [
          6,
          6,
        ],
        child: SizedBox(
          height: 150,
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [

                Text(
                  "+",
                  style: TextStyles.boldN90029.copyWith(color: AppTheme.n200),
                ),
                Text(
                  "Add Photo",
                  style: TextStyles.semiBoldN20014,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
