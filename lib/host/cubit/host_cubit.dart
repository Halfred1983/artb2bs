import 'package:artb2b/utils/common.dart';
import 'package:database_service/database.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'host_state.dart';
import 'dart:convert';


class HostCubit extends Cubit<HostState> {
  HostCubit({required this.databaseService,
    required this.userId}) : super(InitialState()) {
    getUser(userId);
  }

  final DatabaseService databaseService;
  final String userId;

  void getUser(String userId) async {
    try {
      emit(LoadingState());
      final user = await databaseService.getUser(userId: userId);
      emit(LoadedState(user!));
    } catch (e) {}
  }

  void chooseAccountHolder(String accountHolder) {
    User user = this.state.props[0] as User;

    try {
      if (user.payoutInfo == null) {
        user =
            user.copyWith(payoutInfo: PayoutInfo(accountHolder: accountHolder));
      } else {
        user = user.copyWith(payoutInfo: user.payoutInfo!.copyWith(
            accountHolder: accountHolder));
      }

      emit(LoadedState(user));
    } catch (e) {
      emit(ErrorState(user, e.toString()));
    }
  }

  void chooseBankCountry(String bankCountry, String bankCountryCode) {
    User user = this.state.props[0] as User;

    try {
      if (user.payoutInfo == null) {
        user = user.copyWith(payoutInfo: PayoutInfo(
            bankCountry: bankCountry, bankCountryCode: bankCountryCode));
      } else {
        user = user.copyWith(payoutInfo: user.payoutInfo!.copyWith(
            bankCountry: bankCountry, bankCountryCode: bankCountryCode));
      }

      emit(LoadedState(user));
    } catch (e) {
      emit(ErrorState(user, e.toString()));
    }
  }

  void chooseCurrency(String currency) {
    User user = this.state.props[0] as User;

    try {
      if (user.payoutInfo == null) {
        user = user.copyWith(payoutInfo: PayoutInfo(currency: currency));
      } else {
        user = user.copyWith(
            payoutInfo: user.payoutInfo!.copyWith(currency: currency));
      }

      emit(LoadedState(user));
    } catch (e) {
      emit(ErrorState(user, e.toString()));
    }
  }

  // void chooseSortCode(String sortCode) {
  //   User user = this.state.props[0] as User;
  //
  //   try {
  //     if (user.payoutInfo == null) {
  //       user = user.copyWith(payoutInfo: PayoutInfo(routingNumber: sortCode));
  //     } else {
  //       user = user.copyWith(
  //           payoutInfo: user.payoutInfo!.copyWith(routingNumber: sortCode));
  //     }
  //
  //     emit(LoadedState(user));
  //   } catch (e) {
  //     emit(ErrorState(user, e.toString()));
  //   }
  // }

  // void chooseAccountNumber(String accountNumber) {
  //   User user = this.state.props[0] as User;
  //
  //   try {
  //     if (user.payoutInfo == null) {
  //       user =
  //           user.copyWith(payoutInfo: PayoutInfo(accountNumber: accountNumber));
  //     } else {
  //       user = user.copyWith(payoutInfo: user.payoutInfo!.copyWith(
  //           accountNumber: accountNumber));
  //     }
  //
  //     emit(LoadedState(user));
  //   } catch (e) {
  //     emit(ErrorState(user, e.toString()));
  //   }
  // }

  void chooseIBAN(String iban) {
    User user = this.state.props[0] as User;

    try {
      if (user.payoutInfo == null) {
        user = user.copyWith(payoutInfo: PayoutInfo(iban: iban));
      } else {
        user = user.copyWith(
            payoutInfo: user.payoutInfo!.copyWith(iban: iban));
      }

      emit(LoadedState(user));
    } catch (e) {
      emit(ErrorState(user, e.toString()));
    }
  }

  void choosePaypalAccount(String paypalAccount) {
    User user = this.state.props[0] as User;

    try {
      if (!paypalAccount.isValidEmail()) {
        emit(ErrorState(user, 'Paypal account must be an email.'));
      }
      else {
        if (user.bookingSettings != null) {
          user = user.copyWith(bookingSettings: user.bookingSettings!.copyWith(
              paypalAccount: paypalAccount));
        }
        else {
          user = user.copyWith(
              bookingSettings: BookingSettings(paypalAccount: paypalAccount));
        }

        emit(BookingSettingsDetail(user));
      }
    } catch (e) {
      emit(ErrorState(user, e.toString()));
    }
  }



  Future<void> save(User user, [UserStatus? userStatus]) async {
    // User user = this.state.props[0] as User;
    emit(LoadingState());

    try {
      if (userStatus != null) {
        user = user.copyWith(userStatus: userStatus);
      }

      await databaseService.updateUser(user: user);

      final Map<String, dynamic> response = await _createBankAccount(user.id);
      if (response['error'] != null) {
        emit(ErrorState(user, response['error']['message']));
        return;
      }

      emit(DataSaved(user));
    } catch (e) {
      emit(ErrorState(user, "Error saving the art details"));
    }
  }


  Future<void> saveBookingSettings() async {
    User user = this.state.props[0] as User;

    try {
      emit(LoadingState());
      await databaseService.updateUser(user: user);
      emit(DataSaved(user));
    } catch (e) {
      emit(ErrorState(user, e.toString()));
    }
  }

  Future <Map<String, dynamic>> _createBankAccount(String userId) async {
    final url = Uri.parse(
        'https://us-central1-artb2b-34af2.cloudfunctions.net/createBankAccount');

    final Map<String, dynamic> requestBody = {
      'userId': userId,
    };

    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
      },
      body: json.encode(requestBody),
    );
    if(response.statusCode != 200) {
      return {'error': 'An error occurred'};
    }

    return {'status': 'successful'};
  }

}