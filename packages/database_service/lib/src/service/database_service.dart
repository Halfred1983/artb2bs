import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/models.dart';

abstract class DatabaseService {

  Future<void> addUser({
    required User userEntity,
  });

  Future<User?> getUser({
    required String userId,
  });

  Future<User> updateUser({
    required User user});

  Stream<List<DocumentSnapshot>> findUsersByTypeAndRadius({
    required User user,
    required double radius});

  Stream<DocumentSnapshot> findArtworkByUser({required User user});

  Future<String> addBooking({
    required Booking booking,
  });

  Stream<QuerySnapshot> findBookings({required User user});

}