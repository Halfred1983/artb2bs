
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../app/resources/theme.dart';
import '../login/cubit/login_cubit.dart';

class AppleSigninButton extends StatefulWidget {
  @override
  State<AppleSigninButton> createState() => _AppleSigninButtonState();
}

class _AppleSigninButtonState extends State<AppleSigninButton> {
  var _isLoading = false;

  void _onSubmit() {
    setState(() => _isLoading = true);
    context
        .read<LoginCubit>()
        .loginWithApple().then((value) => setState(() => _isLoading = false));
  }

  @override
  Widget build(BuildContext context) {
    return  ElevatedButton(
        key: const Key('loginForm_googleLogin_raisedButton'),
        style: ButtonStyle(
            overlayColor: MaterialStateProperty.all(AppTheme.n900),
            backgroundColor:_isLoading ?  MaterialStateProperty.all(AppTheme.grey) : MaterialStateProperty.all(AppTheme.n900),
            shape:  MaterialStateProperty.all<CircleBorder>(const CircleBorder())
        ),
        child: _isLoading
            ? Container(
          width: 24,
          height: 24,
          padding: const EdgeInsets.all(2.0),
          child: const CircularProgressIndicator(
            color: Colors.white,
            strokeWidth: 3,
          ),
        ) :  const Icon(FontAwesomeIcons.apple, color: Colors.white, size: 20,),
        onPressed: () =>   _isLoading ? null : _onSubmit()
    );
  }
}
