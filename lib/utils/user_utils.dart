import 'package:database_service/database.dart';

class UserUtils {
  static bool isUserInformationComplete(User user) {
    // Check if the user has a photo
    bool hasPhoto = user.photos != null && user.photos!.isNotEmpty;

    // Check if the user has venue information
    bool hasVenue = user.userArtInfo != null && user.userArtInfo!.typeOfVenue != null && user.userArtInfo!.typeOfVenue!.isNotEmpty;

    // Check if the user has payout settings
    bool hasPayoutSettings = user.bookingSettings!.paypalAccount != null && user.bookingSettings!.paypalAccount!.isNotEmpty;

    // Check if the user has a base price
    bool hasBasePrice = user.bookingSettings != null && user.bookingSettings!.basePrice != null && user.bookingSettings!.basePrice!.isNotEmpty;

    // Return true if all information is present, otherwise false
    return hasPhoto && hasVenue && hasPayoutSettings && hasBasePrice;
  }
}