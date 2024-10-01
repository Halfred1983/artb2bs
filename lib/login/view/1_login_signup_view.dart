import 'package:artb2b/app/resources/theme.dart';
import 'package:artb2b/login/cubit/login_cubit.dart';
import 'package:artb2b/utils/common.dart';
import 'package:artb2b/utils/user_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../app/resources/styles.dart';
import '../../widgets/google_sign_in_button.dart';
import '../../widgets/snackbar.dart';
import '2_signup_view.dart';
import 'forgot_password.dart';


class LoginSignUpView extends StatelessWidget {
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
              Text('Sign in', style: TextStyles.boldN90029,),
              verticalMargin16,
              Text('Welcome back, let\'s bring art to life together!', style: TextStyles.regularN90014,),
              verticalMargin24,
              LoginScreen(),
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
                  GestureDetector(onTap:()  {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) =>
                          SignUpView()
                      ),
                    );
                  },
                      child: Text('Sign up', style: TextStyles.boldAccent17,))
                ],
              ),


            ],
          ),
        ),
      ),
    );
  }
}

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  var _isLoading = false;

  @override
  void dispose() {
    _usernameController.removeListener(_updateState);
    _passwordController.removeListener(_updateState);
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _usernameController.addListener(_updateState);
    _passwordController.addListener(_updateState);
  }

  void _updateState() {
    setState(() {});
  }

  Future<void> _login() async {
    setState(() => _isLoading = true);


    String username = _usernameController.text.trim();
    String password = _passwordController.text.trim();

    if(username.isEmpty || password.isEmpty) {
      showCustomSnackBar('Please enter your email and password', context);
      setState(() => _isLoading = false);
      return;
    }

    context
        .read<LoginCubit>()
        .loginUsernamePassword(username, password)
        .then((value) => setState(() => _isLoading = false));

  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<LoginCubit, LoginState>(
      listener: (context, state) {
        if (state is LoginError) { // Replace LoginFailureState with your actual failure state class
          print('LOGIN');
          showCustomSnackBar(state.error.message, context);
        }
        else if (state is RegistrationResult) { // Replace LoginFailureState with your actual failure state class
          print('LOGIN Successfull');
          showCustomSnackBar('Please verify your email.', context, true);
        }
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Email', style: TextStyles.semiBoldN90014,),
          verticalMargin4,
          TextField(
            autocorrect: false, // Disable auto-correct
            autofocus: false,
            style: TextStyles.semiBoldAccent14,
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
            autocorrect: false,
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
          verticalMargin4,
          InkWell(onTap: () {
            // Navigator.pushNamed(context, '/forgot_password');
            Navigator.push(context, MaterialPageRoute(builder: (context) => ForgotPassword()));
          },
              child: Text('Forgot password?', style: TextStyles.boldAccent14, )
          ),
          verticalMargin48,
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: !_canContinue() ||_isLoading ? null : () => _login(),
              child: _isLoading
                  ? Container(
                width: 24,
                height: 24,
                padding: const EdgeInsets.all(2.0),
                child: const CircularProgressIndicator(
                  color: Colors.white,
                  strokeWidth: 3,
                ),
              ) : const Text('Sign in'),
            ),
          ),
        ],
      ),
    );
  }

  bool _canContinue() {
    return _usernameController.text.isNotEmpty &&
        UserUtils().isValidEmail(_usernameController.text)
        && _passwordController.text.isNotEmpty;
  }
}

