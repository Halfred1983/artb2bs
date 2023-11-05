import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_firestore/cloud_firestore.dart' as firestore;
import 'package:database_service/src/models/models.dart';
import 'package:database_service/src/service/database_service.dart';
import 'package:flutter/material.dart';
import 'package:geoflutterfire2/geoflutterfire2.dart';
import 'package:uuid/uuid.dart';

import '../models/refund.dart';


class FirestoreDatabaseService implements DatabaseService {
  FirestoreDatabaseService({
    required firestore.FirebaseFirestore database
  }) : _firestore = database;

  final firestore.FirebaseFirestore _firestore;
  final geoLocation = GeoFlutterFire();


  @override
  Future<void> addUser({required User userEntity}) {
    try  {
      userEntity = userEntity.copyWith(userStatus: UserStatus.initialised);
      return _firestore.collection('users')
          .doc(userEntity.id)
          .set(userEntity.toJson());
    } on Exception catch (e) {
      throw e;
    }
  }

  @override
  Future<User?> getUser({required String userId}) async {
    try  {
      var documentSnapshot = (await _firestore.collection('users')
          .doc(userId).get());
      if(documentSnapshot.exists) {
        var data = documentSnapshot.data();
        return User.fromJson(data!);
      }
      return Future.value(null);
    } catch (e) {
      print(e.toString());
      return Future.value(null);
    }
  }

  @override
  Future<User> updateUser({required User user}) async {
    try  {
      await _firestore.collection('users')
          .doc(user.id).update(user.toJson());
      return user;
    } on Exception {
      rethrow;
    }
  }

  @override
  Stream<List<DocumentSnapshot>> getHostsStream()  {

    var collectionReference = _firestore.collection('users');

    return collectionReference.snapshots().map((querySnapshot) {
      return querySnapshot.docs.toList();
    });
  }

  @override
  Stream<DocumentSnapshot> getUserStream(String userId)  {

    var collectionReference = _firestore.collection('users');

    return collectionReference
        .where('id', isEqualTo: userId)
        .snapshots().map((querySnapshot) {
      return querySnapshot.docs.toList().first;
    });
  }

  // @override
  // Stream<List<DocumentSnapshot>> findUsersByTypeAndRadius({
  //   required User user,
  //   required double radius})  {
  //
  //   var collectionReference = _firestore.collection('users');
  //
  //   String field = 'userInfo.address.location';
  //
  //   return geoLocation.collection(collectionRef: collectionReference)
  //       .within(center: user.userInfo!.address!.location!,
  //       radius: radius, field: field)
  //       .map((document) {
  //     return document.where((element) {
  //       var user = User.fromJson(element.data() as Map<String, dynamic>);
  //       return user.userInfo!.userType! == UserType.artist;
  //     }).toList();
  //   });
  //
  // }

  @override
  List<DocumentSnapshot> filterUsersByRadiusAndPriceAndDays(
      User user,
      List<DocumentSnapshot> users,
      double radius,
      String priceInput,
      String daysInput,
      ) {


    final geo = GeoFlutterFire();
    final geoFirePoint = geo.point(
      latitude: user.userInfo!.address!.location!.latitude,
      longitude: user.userInfo!.address!.location!.longitude,
    );

    return users.where((element) {
      var user = User.fromJson(element.data() as Map<String, dynamic>);
      if (user.userInfo!.userType != UserType.gallery) {
        return false; // Skip non-artist users
      }

      if (user.bookingSettings != null &&
          user.bookingSettings!.active != null &&
          user.bookingSettings!.active == false) {
        return false; // Skip non-artist users
      }

      if(priceInput.isNotEmpty) {
        int price = int.parse(priceInput);
        if (int.parse(user.bookingSettings!.basePrice!) > price) {
          return false; // Price is not within the specified range
        }
      }

      if(daysInput.isNotEmpty) {
        int days = int.parse(daysInput);
        if (int.parse(user.bookingSettings!.minLength!) > days) {
          return false; // User is not available for the specified number of days
        }
      }

      // Check if the user is within the specified radius
      final distance = geoFirePoint.distance(lat: user.userInfo!.address!.location!.latitude,
          lng: user.userInfo!.address!.location!.longitude);
      return distance <= radius;
    }).toList();
  }


  @override
  Stream<DocumentSnapshot> findArtworkByUser({required User user}) {
    try {
      return _firestore
          .collection('users')
          .doc(user.id).snapshots();
    }
    catch (e) {
      print('findArtworkByUser $e');
      throw e;
    }
  }

  @override
  Future<String> addBooking({required Booking booking}) async {
    try  {
      String id = const Uuid().v4();

      booking.bookingId = id;
      await _firestore.collection('bookings')
          .doc(id)
          .set(booking.toJson());
      return id;
    } on Exception catch (e) {
      throw e;
    }
  }


  // @override
  // Future<List<Booking>> retrieveBookingList({required User user, DateTime? dateFrom, DateTime? dateTo}) async {
  //   try {
  //     List<Booking> dataList = [];
  //
  //     // Reference to your Firestore collection
  //     CollectionReference collection = _firestore.collection('bookings');
  //
  //     // Build the base query
  //     Query query = collection
  //         .where(FieldPath.documentId, whereIn: user.bookings);
  //
  //     QuerySnapshot querySnapshot = await query.get();
  //
  //     for (var document in querySnapshot.docs) {
  //       dataList.add(Booking.fromJson(
  //           document.data() as Map<String, dynamic>));
  //     }
  //
  //     return dataList;
  //   } catch (e) {
  //     print('retrieveBookingList $e');
  //     throw e;
  //   }
  // }

  @override
  Future<void> updateBooking({required Booking booking}) async {
    try  {
      Future.wait([
        _firestore.collection('bookings')
            .doc(booking.bookingId).update(booking.toJson()),
        updateBookingInUser(booking.hostId!, booking),
        updateBookingInUser(booking.artistId!, booking),
      ]);

    } on Exception {
      rethrow;
    }
  }

  Future<void> updateBookingInUser(String userId, Booking booking) async {
    try{
      DocumentSnapshot host = await _firestore.collection('users')
          .doc(userId).get();
      User user = User.fromJson(host.data()! as Map<String, dynamic>);

      user.bookings!.removeWhere((element) => element.bookingId == booking.bookingId);
      user.bookings!.add(booking);

      _firestore.collection('users')
          .doc(userId).update(user.toJson());
    } on Exception {
      rethrow;
    }
  }


  @override
  Future<void> createRefundRequest(Refund refundRequest) async {
    try  {
      await _firestore.collection('refunds')
          .doc(refundRequest.bookingId)
          .set(refundRequest.toJson());
    } on Exception catch (e) {
      throw e;
    }
  }

  @override
  Future<void> createAccepted(Accepted accepted) async {
    try  {
      await _firestore.collection('accepted')
          .doc(accepted.bookingId)
          .set(accepted.toJson());
    } on Exception catch (e) {
      throw e;
    }
  }

  @override
  Future<int> updateViewCounter(String userId) async {
    final cRef = _firestore.collection('views');
    await cRef
        .doc(userId)
        .set({"count": FieldValue.increment(1)}, SetOptions(merge: true));

    // Retrieve the updated counter value
    final snapshot = await cRef.doc(userId).get();
    // Extract the counter value from the snapshot
    final counter = snapshot.data()!['count'] as int;

    return counter;
  }

  @override
  Future<int> getViewCounter(String userId) async {
    final cRef = _firestore.collection('views');

    // Retrieve the updated counter value
    final snapshot = await cRef.doc(userId).get();
    // Extract the counter value from the snapshot
    final counter = snapshot.data()!['count'] as int;

    return counter;
  }


  @override
  Future<void> setDisabledDates(String userId, Unavailable unavailable) async {
    try {
      final DocumentReference userDocRef = _firestore.collection('disabledDates')
          .doc(userId);

      // Retrieve the current list of Unavailiable items from Firestore
      final DocumentSnapshot userDoc = await userDocRef.get();
      List<Unavailable>? currentUnavailiableList = [];

      if (userDoc.exists) {
        final List<dynamic>? unavailableDataList =
            (userDoc.data() as Map<String, dynamic>)['unavailableDate'] ?? [];

        currentUnavailiableList = unavailableDataList!.map((data) => Unavailable.fromJson(data)).toList();
      }

      // Add the new Unavailiable item to the list
      currentUnavailiableList.add(unavailable);

      // Update the Firestore document with the updated list
      await userDocRef.set({'unavailableDate': currentUnavailiableList.map((e) => e.toJson()).toList()});
    } on Exception catch (e) {
      throw e;
    }
  }

  @override
  Future<List<Unavailable>> getDisabledDates(String userId) async {
    final cRef = _firestore.collection('disabledDates');
    final DocumentSnapshot snapshot = await cRef
        .doc(userId)
        .get();

    if(snapshot.exists) {
      final List<dynamic>? unavailableDataList =
      (snapshot.data() as Map<String, dynamic>)['unavailableDate'];

      return unavailableDataList!.map((data) => Unavailable.fromJson(data)).toList();
    } else {
      return [];
    }
  }

  @override
  Future<void> saveDisabledDates(String userId, List<Unavailable> unavailableList) async {
    try {
      final DocumentReference userDocRef = _firestore.collection('disabledDates')
          .doc(userId);

      await userDocRef.set({'unavailableDate': unavailableList.map((e) => e.toJson()).toList()});
    } on Exception catch (e) {
      throw e;
    }
  }
}

