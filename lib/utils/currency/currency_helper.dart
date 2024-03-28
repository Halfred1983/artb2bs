import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'countries.dart';

class CurrencyHelper {
  static NumberFormat currency(String countryCode) {
    return NumberFormat.simpleCurrency(name: countryList.firstWhere(
          (country) => country.isoCode.toLowerCase() == countryCode.toLowerCase(),
    ).currencyCode);
  }
}