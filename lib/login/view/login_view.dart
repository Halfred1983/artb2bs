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
            Text(
                'ArtB2B',
                style: TextStyles.boldAccent24.copyWith(fontSize: 90)),
            Lottie.asset(
              'assets/logo.json',
              fit: BoxFit.fill,
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

class _GoogleLoginButton extends StatelessWidget {
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
            backgroundColor: MaterialStateProperty.all(AppTheme.accentColor),
            shape:  MaterialStateProperty.all<RoundedRectangleBorder>(RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30.0),
            ))
        ),
        icon: const Icon(FontAwesomeIcons.google, color: Colors.white),
        onPressed: () =>  context
            .read<LoginCubit>()
            .login()
    );
  }
}
