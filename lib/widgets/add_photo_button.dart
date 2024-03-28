
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
        color: AppTheme.primaryColor,
        strokeWidth: 4,
        borderType: BorderType.RRect,
        radius: const Radius.circular(10),
        dashPattern: const [
          8,
          10,
        ],
        child: SizedBox(
          height: 150,
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [

                Text(
                  "+",
                  style: TextStyles.semiBoldAccent14.copyWith(fontSize: 20),
                ),
                Text(
                  "Add Photo",
                  style: TextStyles.semiBoldAccent14,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
