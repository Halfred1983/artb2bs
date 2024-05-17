import 'package:flutter/material.dart';
import 'package:artb2b/app/resources/styles.dart';

import '../login/view/1_login_signup_view.dart';

void showCustomSnackBar(String text, BuildContext context, [bool? navigate = false]) {
  final snackBar = SnackBar(
    content: Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(text, style: TextStyles.regularPrimary14,),
      ],
    ),
    duration: const Duration(seconds: 3),
  );

  ScaffoldMessenger.of(context).showSnackBar(snackBar);

  // Wait for the SnackBar to hide
  if(navigate != null && navigate) {
    Future.delayed(Duration(seconds: 2), () {
      print('Navigating');
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => LoginSignUpView()),
      );
    });
  }
}