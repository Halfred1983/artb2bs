import 'package:artb2b/login/view/login_view.dart';
import 'package:flutter/material.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({Key? key}) : super(key: key);

  static Route<void> route() {
    return MaterialPageRoute<void>(builder: (_) => LoginPage());
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(body: LoginView());
  }
}
