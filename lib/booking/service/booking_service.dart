import 'package:database_service/database.dart';
import 'package:intl/intl.dart';

class BookingService {

  double calculatePrice(Booking booking, User host) {
    int? spaces = int.tryParse(booking.spaces!) ?? 0;
    int days = daysBetweenWithOpeningTimes(booking.from!, booking.to!, host);
    return (days * int.parse(host.bookingSettings!.basePrice!) * spaces).toDouble();
  }

  double calculatePricePerDay(double pricePerSpace, int spaces) {
    return pricePerSpace * spaces;
  }

  double calculateCommission(double price, double commissionRate) {
    return price * commissionRate;
  }

  // double calculateGrandTotal(double price, double commission) {
  //   return price + commission;
  // }

  int daysBetween(DateTime from, DateTime to) {
    from = DateTime(from.year, from.month, from.day);
    to = DateTime(to.year, to.month, to.day);
    return (to.difference(from).inHours / 24).round() + 1;
  }

  int daysBetweenWithOpeningTimes(DateTime from, DateTime to, User host) {
    from = DateTime(from.year, from.month, from.day);
    to = DateTime(to.year, to.month, to.day);
    int daysCount = 0;

    for (DateTime date = from; date.isBefore(to) || date.isAtSameMomentAs(to); date = date.add(Duration(days: 1))) {
      if (isDayWithinOpeningTimes(date, host)) {
        daysCount++;
      }
    }
    return daysCount;
  }

  bool isDayWithinOpeningTimes(DateTime day, User host) {
    String dayName = DateFormat('EEEE').format(day).toLowerCase();
    DayOfWeek dayOfWeek = DayOfWeek.values.firstWhere((d) => d.toString().split('.').last == dayName);

    for (var businessDay in host.venueInfo!.openingTimes!) {
      if (businessDay.dayOfWeek == dayOfWeek && businessDay.open == true) {
        return true;
      }
    }
    return false;
  }

  int toStripeInt(String price){
    return (double.parse(price) * 100).toInt();
  }
}