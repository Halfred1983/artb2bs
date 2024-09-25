import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart' show Colors, DateTimeRange, kMinInteractiveDimension;

import '../app/resources/theme.dart';

// Common Widgets

const emptyWidget = SizedBox();
const emptyWidgetWide = SizedBox(width: double.infinity);
const emptyIconButton = SizedBox(width: kMinInteractiveDimension);

// Layout Margins

const horizontalMargin4 = SizedBox(width: 4.0);
const horizontalMargin8 = SizedBox(width: 8.0);
const horizontalMargin12 = SizedBox(width: 12.0);
const horizontalMargin16 = SizedBox(width: 16.0);
const horizontalMargin24 = SizedBox(width: 24.0);
const horizontalMargin32 = SizedBox(width: 32.0);
const horizontalMargin48 = SizedBox(width: 48.0);

const verticalMargin4 = SizedBox(height: 4.0);
const verticalMargin8 = SizedBox(height: 8.0);
const verticalMargin12 = SizedBox(height: 12.0);
const verticalMargin16 = SizedBox(height: 16.0);
const verticalMargin24 = SizedBox(height: 24.0);
const verticalMargin32 = SizedBox(height: 32.0);
const verticalMargin48 = SizedBox(height: 48.0);

const sliverVerticalMargin4 = SliverToBoxAdapter(child: SizedBox(height: 4.0));
const sliverVerticalMargin8 = SliverToBoxAdapter(child: SizedBox(height: 8.0));
const sliverVerticalMargin12 = SliverToBoxAdapter(child: SizedBox(height: 12.0));
const sliverVerticalMargin16 = SliverToBoxAdapter(child: SizedBox(height: 16.0));
const sliverVerticalMargin24 = SliverToBoxAdapter(child: SizedBox(height: 24.0));
const sliverVerticalMargin32 = SliverToBoxAdapter(child: SizedBox(height: 32.0));
const sliverVerticalMargin48 = SliverToBoxAdapter(child: SizedBox(height: 48.0));

// Layout Paddings

const horizontalPadding4 = EdgeInsets.symmetric(horizontal: 4.0);
const horizontalPadding8 = EdgeInsets.symmetric(horizontal: 8.0);
const horizontalPadding12 = EdgeInsets.symmetric(horizontal: 12.0);
const horizontalPadding16 = EdgeInsets.symmetric(horizontal: 16.0);
const horizontalPadding24 = EdgeInsets.symmetric(horizontal: 24.0);
const horizontalPadding32 = EdgeInsets.symmetric(horizontal: 32.0);
const horizontalPadding48 = EdgeInsets.symmetric(horizontal: 48.0);

const verticalPadding2 = EdgeInsets.symmetric(vertical: 2.0);
const verticalPadding4 = EdgeInsets.symmetric(vertical: 4.0);
const verticalPadding8 = EdgeInsets.symmetric(vertical: 8.0);
const verticalPadding12 = EdgeInsets.symmetric(vertical: 12.0);
const verticalPadding16 = EdgeInsets.symmetric(vertical: 16.0);
const verticalPadding24 = EdgeInsets.symmetric(vertical: 24.0);
const verticalPadding20 = EdgeInsets.symmetric(vertical: 20.0);
const verticalPadding32 = EdgeInsets.symmetric(vertical: 32.0);
const verticalPadding48 = EdgeInsets.symmetric(vertical: 48.0);

const allPadding4 = EdgeInsets.all(4.0);
const allPadding8 = EdgeInsets.all(8.0);
const allPadding12 = EdgeInsets.all(12.0);
const allPadding16 = EdgeInsets.all(16.0);
const allPadding24 = EdgeInsets.all(24.0);
const allPadding32 = EdgeInsets.all(32.0);
const allPadding48 = EdgeInsets.all(48.0);

const leftPadding4 = EdgeInsets.only(left: 4.0);
const leftPadding8 = EdgeInsets.only(left: 8.0);
const leftPadding12 = EdgeInsets.only(left: 12.0);
const leftPadding16 = EdgeInsets.only(left: 16.0);
const leftPadding24 = EdgeInsets.only(left: 24.0);
const leftPadding32 = EdgeInsets.only(left: 32.0);
const leftPadding48 = EdgeInsets.only(left: 48.0);

const topPadding1 = EdgeInsets.only(top: 1.0);
const topPadding2 = EdgeInsets.only(top: 2.0);
const topPadding4 = EdgeInsets.only(top: 4.0);
const topPadding8 = EdgeInsets.only(top: 8.0);
const topPadding12 = EdgeInsets.only(top: 12.0);
const topPadding16 = EdgeInsets.only(top: 16.0);
const topPadding24 = EdgeInsets.only(top: 24.0);
const topPadding32 = EdgeInsets.only(top: 32.0);
const topPadding48 = EdgeInsets.only(top: 48.0);

const rightPadding4 = EdgeInsets.only(right: 4.0);
const rightPadding8 = EdgeInsets.only(right: 8.0);
const rightPadding12 = EdgeInsets.only(right: 12.0);
const rightPadding16 = EdgeInsets.only(right: 16.0);
const rightPadding24 = EdgeInsets.only(right: 24.0);
const rightPadding32 = EdgeInsets.only(right: 32.0);
const rightPadding48 = EdgeInsets.only(right: 48.0);

const bottomPadding1 = EdgeInsets.only(bottom: 1.0);
const bottomPadding2 = EdgeInsets.only(bottom: 2.0);
const bottomPadding4 = EdgeInsets.only(bottom: 4.0);
const bottomPadding8 = EdgeInsets.only(bottom: 8.0);
const bottomPadding12 = EdgeInsets.only(bottom: 12.0);
const bottomPadding16 = EdgeInsets.only(bottom: 16.0);
const bottomPadding24 = EdgeInsets.only(bottom: 24.0);
const bottomPadding32 = EdgeInsets.only(bottom: 32.0);
const bottomPadding48 = EdgeInsets.only(bottom: 48.0);
const buttonPadding = EdgeInsets.only(left: 28, right: 28, bottom: 40, top:20);

extension StringExtension on String {
  String capitalize() {
    return "${this[0].toUpperCase()}${substring(1).toLowerCase()}";
  }

  String deCapitalize() {
    return "${this[0].toLowerCase()}${substring(1).toLowerCase()}";
  }


  String extractBookingId() {
    int dashIndex = indexOf('-');
    return dashIndex != -1 ? substring(0, dashIndex).toUpperCase() : this;
  }
}

extension BookingStatusColorExtension on String {
  Color getColorForBookingStatus() {
    switch (toLowerCase()) {
      case 'accepted':
        return AppTheme.sv300; // Set the color for accepted status
      case 'pending':
        return AppTheme.wv500; // Set the color for pending status
      case 'cancelled':
        return AppTheme.dv400;
      case 'rejected':
        return AppTheme.dv400;
      default:
        return AppTheme.sv300; // Default color if status is not recognized
    }
  }

  Color getBackgroundColorForBookingStatus() {
    switch (toLowerCase()) {
      case 'accepted':
        return AppTheme.sv50; // Set the color for accepted status
      case 'pending':
        return AppTheme.wv50; // Set the color for pending status
      case 'cancelled':
        return AppTheme.dv50;
      case 'rejected':
        return AppTheme.dv50;
      default:
        return AppTheme.sv50; // Default color if status is not recognized
    }
  }
}

extension PayoutStatusColorExtension on String {
  Color getColorForPayoutStatus() {
    switch (toLowerCase()) {
      case 'completed':
        return AppTheme.sv300; // Set the color for accepted status
      case 'onProgress':
        return AppTheme.wv500;
      case 'initialised':
        return AppTheme.wv500; // Set the color for pending status
      case 'failed':
        return AppTheme.dv400; // Set the color for cancelled status
      default:
        return AppTheme.primaryColor; // Default color if status is not recognized
    }
  }

  Color getBackgroundColorForPayoutStatus() {
    switch (toLowerCase()) {
      case 'completed':
        return AppTheme.sv50; // Set the color for accepted status
      case 'initialised':
        return AppTheme.wv50; // Set the color for accepted status
      case 'onProgress':
        return AppTheme.wv50; // Set the color for pending status
      case 'failed':
        return AppTheme.dv50;
      default:
        return AppTheme.sv50; // Default color if status is not recognized
    }
  }
}


extension EmailValidator on String {
  bool isValidEmail() {
    // Simple email validation using a regular expression
    // This is a basic example and may not cover all edge cases
    RegExp emailRegExp = RegExp(
      r'^[a-zA-Z0-9._-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,4}$',
    );
    return emailRegExp.hasMatch(this);
  }
}


extension DateUtils on DateTime {
  bool isSameDay(DateTime date) {
    return year == date.year &&
        month == date.month &&
        day == date.day;
  }

  bool isBeforeWithoutTime(DateTime date1) {
    // Create new DateTime objects with the time set to midnight
    DateTime midnightDate1 = DateTime(year, month, day);
    DateTime midnightDate2 = DateTime(date1.year, date1.month, date1.day);

    // Compare the dates without considering the time
    return midnightDate1.isBefore(midnightDate2);
  }

  bool isAfterWithoutTime(DateTime date1) {
    // Create new DateTime objects with the time set to midnight
    DateTime midnightDate1 = DateTime(year, month, day);
    DateTime midnightDate2 = DateTime(date1.year, date1.month, date1.day);

    // Compare the dates without considering the time
    return midnightDate1.isAfter(midnightDate2);
  }

  bool isDateTimeWithinRange(DateTimeRange dateRange) {
    return (dateRange.start.isBeforeWithoutTime(this) && dateRange.end.isAfterWithoutTime(this)) ||
        dateRange.start.isSameDay(this) || dateRange.end.isSameDay(this);
  }
}
