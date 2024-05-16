import 'package:artb2b/app/resources/theme.dart';
import 'package:artb2b/login/cubit/login_cubit.dart';
import 'package:artb2b/utils/common.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:lottie/lottie.dart';

import '../../app/resources/styles.dart';
import '../../widgets/google_sign_in_button.dart';
import '0_start_view.dart';


class SignUpView extends StatelessWidget {
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
        child: Padding(
          padding: horizontalPadding32,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('Create account', style: TextStyles.boldN90029,),
              verticalMargin16,
              Text('Let\'s bring art to life together!', style: TextStyles.regularN90014,),
              verticalMargin24,
              RegistrationScreen(),
              verticalMargin24,
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Expanded(
                    child: Container(
                      height: 1, // Height of the divider
                      // width: 100, // Width of the divider
                      color: AppTheme.n200, // Color of the divider
                    ),
                  ),
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 8), // Space around the text
                    child: Text('Or sign in with'),
                  ),
                  Expanded(
                    child: Container(
                      height: 1, // Height of the divider
                      // width: 100, // Width of the divider
                      color: AppTheme.n200, // Color of the divider
                    ),
                  ),
                ],
              ),
              verticalMargin48,
              GoogleLoginButton(),
              verticalMargin48,
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Don\'t have an account?', style: TextStyles.regularN90014,),
                  Text('Sign up', style: TextStyles.boldAccent17,)
                ],
              ),


            ],
          ),
        ),
      ),
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
  final TextEditingController _confirmPasswordController = TextEditingController();

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
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Email', style: TextStyles.semiBoldN90014,),
        verticalMargin4,
        TextField(
          autofocus: false,
          style: TextStyles.semiBoldAccent14,
          // onChanged: (String value) {
          //   context.read<ExploreCubit>().updateSearchQuery(value);
          // },
          decoration: InputDecoration(
            hintText: 'user@email.com',
            hintStyle: TextStyles.regularN90014,
            prefixIcon: const Icon(Icons.search, color: AppTheme.n900),
            contentPadding: const EdgeInsets.symmetric(horizontal: 20),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(50),
              borderSide: const BorderSide(
                color: AppTheme.accentColor, // Color of the border
                width: 0.5, // Width of the border
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(50),
              borderSide: const BorderSide(
                color: AppTheme.accentColor, // Color when the TextField is focused
                width: 0.5, // Width when focused
              ),
            ),
            // Enabled border style
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(50),
              borderSide: const BorderSide(
                color: AppTheme.accentColor, // Color when the TextField is enabled
                width: 0.5, // Width when enabled
              ),
            ),
            filled: true,
            fillColor: Colors.white,
          ),
          keyboardType: TextInputType.text,
          controller: _usernameController,
        ),
        verticalMargin16,
        Text('Password', style: TextStyles.semiBoldN90014,),
        verticalMargin4,
        TextField(
          controller: _passwordController,
          decoration: InputDecoration(
            hintText: 'Password',
            hintStyle: TextStyles.regularN90014,
            prefixIcon: const Icon(Icons.search, color: AppTheme.n900),
            contentPadding: const EdgeInsets.symmetric(horizontal: 20),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(50),
              borderSide: const BorderSide(
                color: AppTheme.accentColor, // Color of the border
                width: 0.5, // Width of the border
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(50),
              borderSide: const BorderSide(
                color: AppTheme.accentColor, // Color when the TextField is focused
                width: 0.5, // Width when focused
              ),
            ),
            // Enabled border style
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(50),
              borderSide: const BorderSide(
                color: AppTheme.accentColor, // Color when the TextField is enabled
                width: 0.5, // Width when enabled
              ),
            ),
            filled: true,
            fillColor: Colors.white,
          ),
          keyboardType: TextInputType.text,
          obscureText: true,
        ),
        verticalMargin16,
        Text('Confirm Password', style: TextStyles.semiBoldN90014,),
        verticalMargin4,
        TextField(
          controller: _confirmPasswordController,
          decoration: InputDecoration(
            hintText: 'Confirm Password',
            hintStyle: TextStyles.regularN90014,
            prefixIcon: const Icon(Icons.search, color: AppTheme.n900),
            contentPadding: const EdgeInsets.symmetric(horizontal: 20),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(50),
              borderSide: const BorderSide(
                color: AppTheme.accentColor, // Color of the border
                width: 0.5, // Width of the border
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(50),
              borderSide: const BorderSide(
                color: AppTheme.accentColor, // Color when the TextField is focused
                width: 0.5, // Width when focused
              ),
            ),
            // Enabled border style
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(50),
              borderSide: const BorderSide(
                color: AppTheme.accentColor, // Color when the TextField is enabled
                width: 0.5, // Width when enabled
              ),
            ),
            filled: true,
            fillColor: Colors.white,
          ),
          keyboardType: TextInputType.text,
          obscureText: true,
        ),
        verticalMargin48,
        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: _register,
            child: const Text('Create account'),
          ),
        ),
      ],
    );
  }
}

