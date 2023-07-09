import 'package:flutter/material.dart';

class AppInputValidators {

  static FormFieldValidator<String> required(String fieldName) {
    return (String? value) {
      value = value?.trim() ?? '';
      if (value.isEmpty) return '$fieldName required';
      return null;
    };
  }

  static FormFieldValidator<String> get phone {
    return (String? value) {
      value = value?.trim() ?? '';
      if (value.isEmpty) {
        return 'Numero di telefono richiesto';
      }
      final stripped = value.replaceAll(r'[^0-9\+]', '');
      if (stripped.length < 10) {
        return 'Per favore inserisci un '
          'numero di telefono valido';
      }
      return null;
    };
  }

  static FormFieldValidator<String> get email {
    return (String? value) {
      value = value?.trim() ?? '';
      if (value.isEmpty) {
        return 'Indirizzo email richiesto';
      }
      // if (!EmailValidator.validate(value.trim())) {
      //   return 'Per favore inserisci un '
      //       'indirizzo email valido';
      // }
      return null;
    };
  }

  static FormFieldValidator<String> get codiceFiscale {
    return (String? value) {
      value = value?.trim() ?? '';
      if (value.isEmpty) {
        return 'Codice fiscale richiesto';
      }
      value = value.replaceAll(' ', '');

      return null;
    };
  }

  static FormFieldValidator<String> get cap {
    return (String? value) {
      value = value?.trim() ?? '';
      if (value.isEmpty) return 'Cap richiesto';
      final valid = RegExp('^[0-9]{5}').hasMatch(value);
      if (!valid) return 'Formato Cap errato';
      return null;
    };
  }


  static FormFieldValidator<String> get date {
    return (String? value) {
      value = value?.trim() ?? '';
      if (value.isEmpty) return 'Data richiesta';
      const pattern = r'^(0[1-9]|[12][0-9]|3[01])\/(0[1-9]|1[012])\/(19|20)\d\d';
      if (!RegExp(pattern).hasMatch(value)) {
        return 'Per favore inserisci una data valida';
      }
      return null;
    };
  }

  static FormFieldValidator<String> get dateOfBirth {
    final dateValidator = date;
    return (String? value) {
      final dateValid = dateValidator(value);
      if (dateValid != null) {
        return dateValid;
      }
      // converts DD/MM/YYYY to YYYY-MM-DD
      final date = value!.trim();
      final formatted = '${date.substring(6, 10)}-${date.substring(3, 5)}-${date.substring(0, 2)}';
      final dateOfBirth = DateTime.tryParse(formatted);
      if (dateOfBirth == null) {
        return 'Per favore inserisci una data valida';
      }
      if (dateOfBirth.isAfter(DateTime.now())) {
        return 'La data inserita è nel futuro';
      }
      if (DateTime.now().difference(dateOfBirth).inDays < (365 * 18)) {
        return 'Devi aver compiuto almeno 18 anni per poter registarti';
      }
      return null;
    };
  }

}
