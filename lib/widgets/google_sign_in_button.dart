
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../app/resources/theme.dart';
import '../login/cubit/login_cubit.dart';

class GoogleLoginButton extends StatefulWidget {
  @override
  State<GoogleLoginButton> createState() => _GoogleLoginButtonState();
}

class _GoogleLoginButtonState extends State<GoogleLoginButton> {
  var _isLoading = false;

  void _onSubmit() {
    setState(() => _isLoading = true);
    context
        .read<LoginCubit>()
        .loginWithGoogle().then((value) => setState(() => _isLoading = false));
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
        ) :  const Icon(FontAwesomeIcons.google, color: Colors.white, size: 20,),
        onPressed: () =>   _isLoading ? null : _onSubmit()
    );
  }
}
