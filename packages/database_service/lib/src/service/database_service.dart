import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../models/models.dart';

abstract class DatabaseService {

  Future<void> addUser({
    required User userEntity,
  });

  Future<User?> getUser({
    required String userId,
  });

  Stream<DocumentSnapshot> getUserStream(String userId);

  Stream<DocumentSnapshot> findArtworkByUser({required User user});

  Future<String> addBooking({
    required Booking booking,
  });

  // Stream<QuerySnapshot> findBookings({required User user,
  //   required int fromIndex,
  //   required int toIndex});

  // Future<List<Booking>> retrieveBookingList({required User user, DateTime? dateFrom, DateTime? dateTo});

  Future<void> updateBooking({required Booking booking});

  Future<void> createRefundRequest(Refund refundRequest);

  Future<List<Booking>> findBookingsByUser(User user);

  Future<List<Payout>> findPayoutsByUser(User user);

  Stream<List<Booking>> findBookingsByUserStream(User user);

  Stream<List<DocumentSnapshot>> findBookingsByUserNordStream(User user, {int limit = 10,
    DocumentSnapshot? startAfter, BookingStatus? status, DateTime? startDate});

  Future<void> createAccepted(Accepted accepted);

  Future<void> updateViewCounter(String userId);

  Future<void> getViewCounter(String userId);

  Future<void> setDisabledDates(String userId, Unavailable unavailable);

  Future<void> setDisabledSpaces(String userId, UnavailableSpaces unavailable);

  Future<List<Unavailable>> getDisabledDates(String userId);

  Future<void> saveDisabledDates(String id, List<Unavailable> unavailableList);

  Future<void> saveDisabledSpaces(String userId, List<UnavailableSpaces> unavailableList);

  Stream<List<User>> getHostsStream( {User? nextToUser});

  Future<List<User>> getHostsList({User? nextToUser});

  List<User> filterUsersByRadiusAndPriceAndDaysAndTypes(User user,
      List<User> users,
      double radius,
      String priceInput,
      String daysInput,
      );

  Future<User> getMostRecentHost();

  Future<User> updateUser({required User user});

  Future<Map<String, dynamic>> fetchConfigData();


}