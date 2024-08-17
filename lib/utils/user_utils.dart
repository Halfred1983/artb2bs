import 'package:database_service/database.dart';

class UserUtils {
  static List<VenueInformationMissing> isUserInformationComplete(User user) {
    List<VenueInformationMissing> missingInformation = [];

    // Check if the user has a photo
    bool hasPhoto = user.photos != null && user.photos!.isNotEmpty;
    if (!hasPhoto) {
      missingInformation.add(VenueInformationMissing.photos);
    }

    // Check if the user has venue information
    bool hasVenue = isVenueInformationComplete(user).isEmpty;
    if (!hasVenue) {
      missingInformation.add(VenueInformationMissing.venueInformation);
    }

    // Check if the user has payout settings
    bool hasPayoutSettings = user.bookingSettings!.paypalAccount != null && user.bookingSettings!.paypalAccount!.isNotEmpty;
    if (!hasPayoutSettings) {
      missingInformation.add(VenueInformationMissing.payoutSettings);
    }

    // Check if the user has a base price
    bool hasBasePrice = user.bookingSettings != null && user.bookingSettings!.basePrice != null && user.bookingSettings!.basePrice!.isNotEmpty;
    if (!hasBasePrice) {
      missingInformation.add(VenueInformationMissing.basePriceMissing);
    }

    // Check if the user has a minimum booking duration
    bool hasMinimumBookingDuration = user.bookingSettings != null && user.bookingSettings!.minLength != null;
    if (!hasMinimumBookingDuration) {
      missingInformation.add(VenueInformationMissing.minimumBookingDurationMissing);
    }

    // Check if the user has a minimum space
    bool hasMinimumSpace = user.bookingSettings != null && user.bookingSettings!.minSpaces != null;
    if (!hasMinimumSpace) {
      missingInformation.add(VenueInformationMissing.minimumSpaceMissing);
    }

    return missingInformation;
  }

  static List<VenueInformationMissing> isVenueInformationComplete(User user) {
    List<VenueInformationMissing> missingInformation = [];

    // Check if the user has a type of venue
    bool hasType = user.venueInfo != null && user.venueInfo!.typeOfVenue != null && user.venueInfo!.typeOfVenue!.isNotEmpty;
    if (!hasType) {
      missingInformation.add(VenueInformationMissing.type);
    }

    // Check if the user has vibes
    bool hasVibes = user.venueInfo != null && user.venueInfo!.vibes != null && user.venueInfo!.vibes!.isNotEmpty;
    if (!hasVibes) {
      missingInformation.add(VenueInformationMissing.vibes);
    }

    // Check if the user has opening hours
    bool hasOpeningHours = user.venueInfo != null
        && user.venueInfo!.openingTimes != null && user.venueInfo!.openingTimes!.isNotEmpty
    && user.venueInfo!.openingTimes!.every((element) => element.hourInterval != null && element.hourInterval.isNotEmpty
        || element.open != null);
    if (!hasOpeningHours) {
      missingInformation.add(VenueInformationMissing.openingHours);
    }

    // Check if the user has a venue description
    bool hasVenueDescription = user.venueInfo != null && user.venueInfo!.aboutYou != null && user.venueInfo!.aboutYou!.isNotEmpty;
    if (!hasVenueDescription) {
      missingInformation.add(VenueInformationMissing.venueDescription);
    }

    return missingInformation;
  }

  ArtStyle? getArtStyleFromString(String artStyle) {
    return ArtStyle.values.firstWhere(
          (style) => style.toString().split('.').last.toLowerCase() == artStyle.toLowerCase(),
      orElse: () => throw Exception('Art style not found'),
    );
  }

  bool isValidEmail(String email) {
    final RegExp emailRegex = RegExp(
      r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
    );
    return emailRegex.hasMatch(email);
  }
}

enum VenueInformationMissingCategory {
  venue,
  booking,
  photo,
  payout,
  type,
  vibes,
  openingHours,
  venueDescription
}

class VenueInformationMissing {
  final String name;
  final VenueInformationMissingCategory category;

  const VenueInformationMissing(this.name, this.category);

  static const photos = VenueInformationMissing('photos', VenueInformationMissingCategory.photo);
  static const payoutSettings = VenueInformationMissing('payoutSettings', VenueInformationMissingCategory.payout);
  static const venueInformation = VenueInformationMissing('venueInformation', VenueInformationMissingCategory.venue);
  static const basePriceMissing = VenueInformationMissing('basePriceMissing', VenueInformationMissingCategory.booking);
  static const minimumBookingDurationMissing = VenueInformationMissing('minimumBookingDurationMissing', VenueInformationMissingCategory.booking);
  static const minimumSpaceMissing = VenueInformationMissing('minimumSpaceMissing', VenueInformationMissingCategory.booking);
  static const type = VenueInformationMissing('type', VenueInformationMissingCategory.type);
  static const vibes = VenueInformationMissing('vibes', VenueInformationMissingCategory.vibes);
  static const openingHours = VenueInformationMissing('openingHours', VenueInformationMissingCategory.openingHours);
  static const venueDescription = VenueInformationMissing('venueDescription', VenueInformationMissingCategory.venueDescription);
}