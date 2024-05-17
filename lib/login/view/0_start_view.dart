import 'package:artb2b/app/resources/theme.dart';
import 'package:artb2b/login/cubit/login_cubit.dart';
import 'package:artb2b/utils/common.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:lottie/lottie.dart';

import '../../app/resources/styles.dart';
import '1_login_signup_view.dart';


class StartView extends StatelessWidget {

  const StartView({Key? key}) : super(key: key);

  static Route<void> route() {
    return MaterialPageRoute<void>(builder: (_) => StartView());
  }

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
              height: 150,
              width: 150,
            ),
            verticalMargin32,
            SizedBox(
              height: 300,
              child: Lottie.asset(
                'assets/logo.json',
                fit: BoxFit.fill,
              ),
            ),
            Expanded(child: Container()),
            Padding(
                padding: horizontalPadding32,
                child: Text('Where art finds space, and spaces find art!', style: TextStyles.boldN90024,
                  textAlign: TextAlign.center,)),
            verticalMargin32,
            Padding(
                padding: horizontalPadding32,
                child: SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed:
                        () {

                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) =>
                             LoginSignUpView()
                            ),
                          );

                    },
                    child: Text('Get started', style: TextStyles.boldPrimary17,),
                  ),
                )
            ),
            // _GoogleLoginButton(),
            verticalMargin32,
            // RegistrationScreen(),
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
        .loginWithGoogle().then((value) => setState(() => _isLoading = false));
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

class RegistrationScreen extends StatefulWidget {
  @override
  _RegistrationScreenState createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  Future<void> _register() async {
    try {
      UserCredential userCredential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(
          email: _usernameController.text.trim(),
          password: _passwordController.text.trim());

      print('User registered: ${userCredential.user?.uid}');
    } catch (e) {
      print('Registration failed: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        TextField(
          controller: _usernameController,
          decoration: InputDecoration(labelText: 'Username'),
        ),
        TextField(
          controller: _passwordController,
          decoration: InputDecoration(labelText: 'Password'),
          obscureText: true,
        ),
        SizedBox(height: 20),
        ElevatedButton(
          onPressed: _register,
          child: Text('Register'),
        ),
      ],
    );
  }
}

