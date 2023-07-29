
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';

import '../app/resources/styles.dart';
import '../app/resources/theme.dart';
import '../photo/view/photo_page.dart';

class AddPhotoButton extends StatelessWidget {
  const AddPhotoButton({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => PhotoPage()),
      ),

      child: DottedBorder(
        color: AppTheme.primaryColourViolet,
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
                  style: TextStyles.boldViolet16.copyWith(fontSize: 20),
                ),
                Text(
                  "Add Photo",
                  style: TextStyles.boldViolet16,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
