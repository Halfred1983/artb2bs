import 'package:flutter/material.dart';

import '0_start_view.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({Key? key}) : super(key: key);

  static Route<void> route() {
    return MaterialPageRoute<void>(builder: (_) => LoginPage());
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(body: const StartView());
  }
}
