import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_firestore/cloud_firestore.dart' as firestore;
import 'package:database_service/src/models/models.dart';
import 'package:database_service/src/service/database_service.dart';
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
  Stream<List<DocumentSnapshot>> findUsersByTypeAndRadius({
    required User user,
    required double radius})  {

    var collectionReference = _firestore.collection('users');

    String field = 'userInfo.address.location';

    return geoLocation.collection(collectionRef: collectionReference)
        .within(center: user.userInfo!.address!.location!,
        radius: radius, field: field);
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

  @override
  Stream<QuerySnapshot> findBookings({
    required User user,
    required int fromIndex,
    required int toIndex}) {
    try {
      
      // Reference to your Firestore collection
      CollectionReference collection = _firestore.collection('bookings');

      // Build the base query
      Query query = collection
          .where(FieldPath.documentId, whereIn: user.bookings
      );

      return query.snapshots();
    } catch (e) {
      print('findArtworkByUser $e');
      throw e;
    }
  }


  @override
  Future<List<Booking>> retrieveBookingList({required User user, DateTime? dateFrom, DateTime? dateTo}) async {
    try {
      List<Booking> dataList = [];

      // Reference to your Firestore collection
      CollectionReference collection = _firestore.collection('bookings');

      // Build the base query
      Query query = collection
          .where(FieldPath.documentId, whereIn: user.bookings);

      QuerySnapshot querySnapshot = await query.get();

      for (var document in querySnapshot.docs) {
        dataList.add(Booking.fromJson(
            document.data() as Map<String, dynamic>));
      }

      return dataList;
    } catch (e) {
      print('retrieveBookingList $e');
      throw e;
    }
  }

  @override
  Future<void> updateBooking({required Booking booking}) async {
    try  {
      await _firestore.collection('bookings')
          .doc(booking.bookingId).update(booking.toJson());
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
      final cRef = FirebaseFirestore.instance.collection('views');
      await cRef
          .doc(userId)
          .set({"count": FieldValue.increment(1)}, SetOptions(merge: true));

      // Retrieve the updated counter value
      final snapshot = await cRef.doc(userId).get();
      // Extract the counter value from the snapshot
      final counter = snapshot.data()!['count'] as int;
      
      return counter;
  }
}

