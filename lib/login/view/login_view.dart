import 'package:artb2b/app/resources/theme.dart';
import 'package:artb2b/login/cubit/login_cubit.dart';
import 'package:artb2b/utils/common.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:lottie/lottie.dart';

import '../../app/resources/styles.dart';


class LoginView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return const _LoginForm();
  }
}

class _LoginForm extends StatelessWidget {
  const _LoginForm({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(child: Container()),
            Image.asset(
              'assets/images/artb2b_logo.png',
              height: 200,
              width: 200,
            ),
            SizedBox(
              height: 350,
              child: Lottie.asset(
                'assets/logo.json',
                fit: BoxFit.fill,
              ),
            ),
            Expanded(child: Container()),
            _GoogleLoginButton(),
            verticalMargin48
          ],
        ),
      ),
    );
  }
}

class _GoogleLoginButton extends StatefulWidget {
  @override
  State<_GoogleLoginButton> createState() => _GoogleLoginButtonState();
}

class _GoogleLoginButtonState extends State<_GoogleLoginButton> {
  var _isLoading = false;

  void _onSubmit() {
    setState(() => _isLoading = true);
    context
        .read<LoginCubit>()
        .login().then((value) => setState(() => _isLoading = false));
  }

  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
        key: const Key('loginForm_googleLogin_raisedButton'),
        label: const Text(
          'SIGN IN WITH GOOGLE',
          style: TextStyle(color: Colors.white),
        ),
        style: ButtonStyle(
            overlayColor: MaterialStateProperty.all(AppTheme.primaryColor),
            backgroundColor:_isLoading ?  MaterialStateProperty.all(AppTheme.grey) : MaterialStateProperty.all(AppTheme.accentColor),
            shape:  MaterialStateProperty.all<RoundedRectangleBorder>(RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30.0),
            ))
        ),
        icon: _isLoading
            ? Container(
          width: 24,
          height: 24,
          padding: const EdgeInsets.all(2.0),
          child: const CircularProgressIndicator(
            color: Colors.white,
            strokeWidth: 3,
          ),
        ) :  const Icon(FontAwesomeIcons.google, color: Colors.white),
        onPressed: () =>   _isLoading ? null : _onSubmit()
    );
  }
}
