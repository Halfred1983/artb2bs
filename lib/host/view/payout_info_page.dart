import 'package:artb2b/host/cubit/host_cubit.dart';
import 'package:artb2b/host/cubit/host_state.dart';
import 'package:auth_service/auth.dart';
import 'package:country_picker/country_picker.dart';
import 'package:currency_picker/currency_picker.dart';
import 'package:database_service/database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../app/resources/styles.dart';
import '../../app/resources/theme.dart';
import '../../injection.dart';
import '../../utils/common.dart';
import '../../widgets/dropdown_box.dart';
import '../../widgets/loading_screen.dart';
import '../../widgets/snackbar.dart';
import 'host_setting_page.dart';



class PayoutInfoPage extends StatelessWidget {
  static Route<void> route() {
    return MaterialPageRoute<void>(builder: (_) => PayoutInfoPage());
  }
  PayoutInfoPage({Key? key}) : super(key: key);

  final FirebaseAuthService authService = locator<FirebaseAuthService>();
  final FirestoreDatabaseService databaseService = locator<FirestoreDatabaseService>();

  @override
  Widget build(BuildContext context) {
    return BlocProvider<HostCubit>(
      create: (context) => HostCubit(
        databaseService: databaseService,
        userId: authService.getUser().id,
      ),
      child: PayoutInfoView(),
    );
  }
}




class PayoutInfoView extends StatefulWidget {
  @override
  _PayoutInfoViewState createState() => _PayoutInfoViewState();
}

class _PayoutInfoViewState extends State<PayoutInfoView> {
  String? _selectedBankCountry;
  String? _selectedCurrency;
  String? _accountHolder;
  String? _iban;

  final TextEditingController _countryController = TextEditingController();
  final TextEditingController _currencyController = TextEditingController();
  final TextEditingController _accountHolderController = TextEditingController();
  final TextEditingController _ibanController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocListener<HostCubit, HostState>(
      listener: (context, state) {
        if (state is ErrorState) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            showCustomSnackBar('Error saving payment info: ${state.message}', context);

          });
        } else if (state is DataSaved) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            Navigator.of(context).pop();
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => HostSettingPage(initialIndex: 1)),
            );
          });
        }
      },
      child: BlocBuilder<HostCubit, HostState>(
        builder: (context, state) {
          if (state is LoadingState) {
            return const LoadingScreen();
          }
          User? user;

          if (state is ErrorState || state is LoadedState || state is DataSaved) {
            user = state.user;

            if (user!.payoutInfo != null) {
              _countryController.text = user.payoutInfo!.bankCountry ?? '';
              _selectedBankCountry = user.payoutInfo!.bankCountry ?? '';
              _currencyController.text = user.payoutInfo!.currency ?? '';
              _selectedCurrency = user.payoutInfo!.currency ?? '';
              _accountHolderController.text = user.payoutInfo!.accountHolder ?? '';
              _accountHolder = user.payoutInfo!.accountHolder ?? '';
              if (user.payoutInfo!.iban != null) {
                _ibanController.text = user.payoutInfo!.iban!;
                _iban = user.payoutInfo!.iban!;
              }
            }
          }

          return Scaffold(
            appBar: AppBar(
              scrolledUnderElevation: 0,
              title: Text(user!.userInfo!.name!, style: TextStyles.boldN90017,),
              centerTitle: true,
              iconTheme: const IconThemeData(
                color: AppTheme.n900, //change your color here
              ),
            ),
            body: SingleChildScrollView(
              child: Padding(
                padding: horizontalPadding32,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    verticalMargin48,
                    Text('Bank Country', style: TextStyles.boldN90016),
                    verticalMargin8,
                    TextField(
                      decoration: AppTheme.textInputDecoration.copyWith(hintText: 'Bank Country'),
                      onTap: () {
                        showCountryPicker(
                          context: context,
                          showPhoneCode: false,
                          countryListTheme: CountryListThemeData(
                              flagSize: 20,
                              backgroundColor: Colors.white,
                              textStyle: TextStyles.semiBoldN90014,
                              bottomSheetHeight: 500, // Optional. Country list modal height
                              //Optional. Sets the border radius for the bottomsheet.
                              borderRadius: const BorderRadius.only(
                                topLeft: Radius.circular(20.0),
                                topRight: Radius.circular(20.0),
                              ),
                              //Optional. Styles the search field.
                              inputDecoration: AppTheme.textInputDecoration.copyWith(
                                  hintText: 'Start typing to search')
                          ),
                          onSelect: (Country country) {
                            _countryController.text = country.displayNameNoCountryCode;
                            _selectedBankCountry = country.countryCode;
                            context.read<HostCubit>().chooseBankCountry(country.displayNameNoCountryCode, country.countryCode);
                          },
                        );
                      },
                      controller: _countryController,
                      autofocus: false,
                      style: TextStyles.semiBoldN90014,
                      autocorrect: false,
                      enableSuggestions: false,
                      keyboardType: TextInputType.text,
                    ),
                    verticalMargin24,
                    Text('Currency', style: TextStyles.boldN90016),
                    verticalMargin8,
                    TextField(
                      onTap: () {
                        showCurrencyPicker(
                          context: context,
                          theme: CurrencyPickerThemeData(
                            flagSize: 25,
                            titleTextStyle: TextStyles.semiBoldN90017,
                            subtitleTextStyle: TextStyles.semiBoldN90012,
                            bottomSheetHeight: 500,
                            backgroundColor: Colors.white,
                            inputDecoration: AppTheme.textInputDecoration.copyWith(
                              hintText: 'Start typing to search',
                            ),
                          ),
                          onSelect: (Currency currency) {
                            _currencyController.text = currency.name;
                            _selectedCurrency = currency.code;
                            context.read<HostCubit>().chooseCurrency(_selectedCurrency!);
                          },
                        );
                      },
                      controller: _currencyController,
                      autofocus: false,
                      style: TextStyles.semiBoldN90014,
                      autocorrect: false,
                      enableSuggestions: false,
                      decoration: AppTheme.textInputDecoration.copyWith(hintText: 'Currency'),
                      keyboardType: TextInputType.text,
                    ),
                    verticalMargin24,
                    Text('Account Holder', style: TextStyles.boldN90016),
                    verticalMargin8,
                    TextField(
                      controller: _accountHolderController,
                      autofocus: false,
                      style: TextStyles.semiBoldN90014,
                      onChanged: (String value) {
                        _accountHolder = value;
                        context.read<HostCubit>().chooseAccountHolder(value);
                      },
                      autocorrect: false,
                      enableSuggestions: false,
                      decoration: AppTheme.textInputDecoration.copyWith(hintText: 'Name of the account holder'),
                      keyboardType: TextInputType.text,
                    ),
                    verticalMargin24,
                    Text('IBAN', style: TextStyles.boldN90016),
                    verticalMargin8,
                    TextField(
                      controller: _ibanController,
                      decoration: AppTheme.textInputDecoration.copyWith(hintText: 'IBAN'),
                      keyboardType: TextInputType.text,
                      maxLength: 34,
                      onChanged: (String value) {
                        _iban = value;
                        context.read<HostCubit>().chooseIBAN(value);
                      },
                    ),
                  ],
                ),
              ),
            ),
            floatingActionButton: Container(
              padding: horizontalPadding32,
              width: double.infinity,
              child: FloatingActionButton(
                backgroundColor: _canContinue() ? AppTheme.n900 : AppTheme.disabledButton,
                foregroundColor: _canContinue() ? AppTheme.primaryColor : AppTheme.n900,
                onPressed: () async {
                  if (_canContinue()) {
                    context.read<HostCubit>().save(user!, UserStatus.paymentInfo);
                  } else {
                    return;
                  }
                },
                child: const Text('Continue'),
              ),
            ),
            floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
          );
        },
      ),
    );
  }

  bool _canContinue() {
    return _selectedBankCountry != null && _selectedCurrency != null &&
        _accountHolder != null && _iban != null && _iban!.isNotEmpty
        && _accountHolder!.isNotEmpty;
  }
}