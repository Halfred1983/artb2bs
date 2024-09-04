import 'package:database_service/database.dart';

class BookingService {

  double calculatePrice(Booking booking, User host) {
    int? spaces = int.tryParse(booking.spaces!) ?? 0;
    int days = daysBetween(booking.from!, booking.to!);
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
    return (to.difference(from).inHours / 24).round();
  }

  int toStripeInt(String price){
    return (double.parse(price) * 100).toInt();
  }
}