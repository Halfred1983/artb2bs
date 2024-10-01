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


class ForgotPassword extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return const _ForgotPasswordForm();
  }
}

class _ForgotPasswordForm extends StatelessWidget {
  const _ForgotPasswordForm({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        scrolledUnderElevation: 0,
        title: Text('Reset password', style: TextStyles.boldN90017,),
        centerTitle: true,
        iconTheme: const IconThemeData(
          color: AppTheme.n900, //change your color here
        ),
      ),
      body: Padding(
        padding: horizontalPadding32,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Forgot your password?', style: TextStyles.boldN90029,),
            verticalMargin16,
            Text('Enter your email below and we will send a reset link.', style: TextStyles.regularN90014,),
            verticalMargin24,
            ResetPasswordScreen(),
            verticalMargin24,
Expanded(child: Container(),)
          ],
        ),
      ),
    );
  }
}

class ResetPasswordScreen extends StatefulWidget {
  @override
  _ResetPasswordScreenState createState() => _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends State<ResetPasswordScreen> {
  final TextEditingController _usernameController = TextEditingController();

  var _isLoading = false;

  @override
  void dispose() {
    _usernameController.removeListener(_updateState);
    _usernameController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _usernameController.addListener(_updateState);
  }

  void _updateState() {
    setState(() {});
  }

  Future<void> _forgotPassword() async {
    setState(() => _isLoading = true);


    String username = _usernameController.text.trim();

    if(username.isEmpty) {
      showCustomSnackBar('Please enter your email ', context);
      setState(() => _isLoading = false);
      return;
    }

    context
        .read<LoginCubit>()
        .forgotPassword(username)
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
        else if (state is LoginResult) { // Replace LoginFailureState with your actual failure state class
          print('LOGIN Successfull');
          showCustomSnackBar('Check your email and click on the reset link.', context, true);
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
          verticalMargin24,
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: !_canContinue() ||_isLoading ? null : () => _forgotPassword(),
              child: _isLoading
                  ? Container(
                width: 24,
                height: 24,
                padding: const EdgeInsets.all(2.0),
                child: const CircularProgressIndicator(
                  color: Colors.white,
                  strokeWidth: 3,
                ),
              ) : const Text('Request reset link'),
            ),
          ),
        ],
      ),
    );
  }

  bool _canContinue() {
    return _usernameController.text.isNotEmpty &&
        UserUtils().isValidEmail(_usernameController.text);
  }
}

