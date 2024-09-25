import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_firestore/cloud_firestore.dart' as firestore;
import 'package:database_service/src/models/models.dart';
import 'package:database_service/src/service/database_service.dart';
import 'package:geoflutterfire2/geoflutterfire2.dart';
import 'package:uuid/uuid.dart';


class FirestoreDatabaseService implements DatabaseService {
  FirestoreDatabaseService({
    required firestore.FirebaseFirestore database
  }) : _firestore = database;

  final firestore.FirebaseFirestore _firestore;
  final geoLocation = GeoFlutterFire();


  @override
  Future<void> addUser({required User userEntity}) {
    try {
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
    try {
      var documentSnapshot = (await _firestore.collection('users')
          .doc(userId).get());
      if (documentSnapshot.exists) {
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
    try {
      await _firestore.collection('users')
          .doc(user.id).update(user.toJson());
      return user;
    } on Exception {
      rethrow;
    }
  }

  @override
  Stream<List<User>> getHostsStream( {User? nextToUser}) {
    var collectionReference = _firestore.collection('users');

    return collectionReference.snapshots().map((querySnapshot) {
      return querySnapshot.docs.map((e) => User.fromJson(e.data()))
          .where((user) {
            bool isNextToUser = true;
            if(nextToUser != null) {
              isNextToUser = user.userInfo != null && user.userInfo!.address != null &&
                  nextToUser.userInfo!.address!.city == (user.userInfo!.address!.city);
            }

        return user.userInfo?.userType == UserType.gallery &&
            user.bookingSettings != null &&
            user.bookingSettings!.active != null &&
            user.bookingSettings!.active == true &&
            isNextToUser;
      }).toList();
    });
  }

  @override
  Future<List<User>> getHostsList({User? nextToUser}) async {
    var collectionReference = _firestore.collection('users');

    var querySnapshot = await collectionReference.get();
    return querySnapshot.docs.map((e) => User.fromJson(e.data()))
        .where((user) {

      bool isNextToUser = true;
      if(nextToUser != null) {
        isNextToUser = user.userInfo != null && user.userInfo!.address != null &&
            nextToUser.userInfo!.address!.city == (user.userInfo!.address!.city);
      }


      return user.userInfo?.userType == UserType.gallery &&
          user.bookingSettings != null &&
          user.bookingSettings!.active != null &&
          user.bookingSettings!.active == true &&
          isNextToUser;
    }).toList();
  }

  @override
  Future<User> getMostRecentHost() async {
    Query<Map<String, dynamic>> collectionReference =

    _firestore.collection('users')
        .where('userInfo.userType', isEqualTo: 1)
        .where('bookingSettings.active', isEqualTo: true)
        .orderBy('createdAt', descending: true)
        .limit(1);

    var querySnapshot = await collectionReference.get();
    return querySnapshot.docs.map((e) => User.fromJson(e.data()))
        .first;
  }

  @override
  Stream<DocumentSnapshot> getUserStream(String userId) {
    var collectionReference = _firestore.collection('users');

    return collectionReference
        .where('id', isEqualTo: userId)
        .snapshots().map((querySnapshot) {
      return querySnapshot.docs
          .toList()
          .first;
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
  List<User> filterUsersByRadiusAndPriceAndDaysAndTypes(User user,
      List<User> users,
      double? radius,
      String? priceInput,
      String? daysInput,
      ) {
    final geo = GeoFlutterFire();
    final geoFirePoint = geo.point(
      latitude: user.userInfo!.address!.location!.latitude,
      longitude: user.userInfo!.address!.location!.longitude,
    );

    return users.where((user) {
      if (user.bookingSettings != null &&
          user.bookingSettings!.active != null &&
          user.bookingSettings!.active == false) {
        return false; // Skip non-artist users
      }

      if (priceInput != null && priceInput.isNotEmpty) {
        int price = int.parse(priceInput);
        if (int.parse(user.bookingSettings!.basePrice!) > price) {
          return false; // Price is not within the specified range
        }
      }

      if (daysInput != null && daysInput.isNotEmpty) {
        int days = int.parse(daysInput);
        if (int.parse(user.bookingSettings!.minLength!) > days) {
          return false; // User is not available for the specified number of days
        }
      }

      if (radius != null) {
        // Check if the user is within the specified radius
        final distance = geoFirePoint.distance(
            lat: user.userInfo!.address!.location!.latitude,
            lng: user.userInfo!.address!.location!.longitude);
        return distance <= radius;
      }

      return true;
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
    try {
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
    try {
      Future.wait([
        _firestore.collection('bookings')
            .doc(booking.bookingId).update(booking.toJson()),
        // updateBookingInUser(booking.hostId!, booking, true),
        // updateBookingInUser(booking.artistId!, booking, false),
      ]);
    } on Exception {
      rethrow;
    }
  }

  // Future<void> updateBookingInUser(String userId, Booking booking, bool updateBalance) async {
  //   try{
  //     DocumentSnapshot host = await _firestore.collection('users')
  //         .doc(userId).get();
  //     User user = User.fromJson(host.data()! as Map<String, dynamic>);
  //
  //     user.bookings!.removeWhere((element) => element.bookingId == booking.bookingId);
  //     user.bookings!.add(booking);
  //     if(updateBalance) user.balance = (double.parse(user.balance ?? '0') + double.parse(booking.price!)).toString();
  //
  //     _firestore.collection('users')
  //         .doc(userId).update(user.toJson());
  //   } on Exception {
  //     rethrow;
  //   }
  // }


  @override
  Future<void> createRefundRequest(Refund refundRequest) async {
    try {
      await _firestore.collection('refunds')
          .doc(refundRequest.bookingId)
          .set(refundRequest.toJson());
    } on Exception catch (e) {
      throw e;
    }
  }

  @override
  Future<void> createAccepted(Accepted accepted) async {
    try {
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
      final DocumentReference userDocRef = _firestore.collection(
          'disabledDates')
          .doc(userId);

      // Retrieve the current list of Unavailiable items from Firestore
      final DocumentSnapshot userDoc = await userDocRef.get();
      List<Unavailable>? currentUnavailiableList = [];

      if (userDoc.exists) {
        final List<dynamic>? unavailableDataList =
            (userDoc.data() as Map<String, dynamic>)['unavailableDate'] ?? [];

        currentUnavailiableList =
            unavailableDataList!.map((data) => Unavailable.fromJson(data))
                .toList();
      }

      // Add the new Unavailiable item to the list
      currentUnavailiableList.add(unavailable);

      // Update the Firestore document with the updated list
      await userDocRef.set({
        'unavailableDate': currentUnavailiableList.map((e) => e.toJson())
            .toList()
      });
    } on Exception catch (e) {
      throw e;
    }
  }

  @override
  Future<void> setDisabledSpaces(String userId,
      UnavailableSpaces unavailableSpaces) async {
    try {
      final DocumentReference userDocRef = _firestore.collection(
          'disabledSpaces')
          .doc(userId);

      // Retrieve the current list of Unavailiable items from Firestore
      final DocumentSnapshot userDoc = await userDocRef.get();
      List<UnavailableSpaces>? currentUnavailiableList = [];

      if (userDoc.exists) {
        final List<dynamic>? unavailableDataList =
            (userDoc.data() as Map<String, dynamic>)['unavailableSpaces'] ?? [];

        currentUnavailiableList =
            unavailableDataList!.map((data) => UnavailableSpaces.fromJson(data))
                .toList();
      }

      // Add the new Unavailiable item to the list
      currentUnavailiableList.add(unavailableSpaces);

      // Update the Firestore document with the updated list
      await userDocRef.set({
        'unavailableSpaces': currentUnavailiableList.map((e) => e.toJson())
            .toList()
      });
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

    if (snapshot.exists) {
      final List<dynamic>? unavailableDataList =
      (snapshot.data() as Map<String, dynamic>)['unavailableDate'];

      return unavailableDataList!.map((data) => Unavailable.fromJson(data))
          .toList();
    } else {
      return [];
    }
  }

  @override
  Future<List<UnavailableSpaces>> getDisabledSpaces(String userId) async {
    final cRef = _firestore.collection('disabledSpaces');
    final DocumentSnapshot snapshot = await cRef
        .doc(userId)
        .get();

    if (snapshot.exists) {
      final List<dynamic>? unavailableDataList =
      (snapshot.data() as Map<String, dynamic>)['unavailableSpaces'];

      return unavailableDataList!.map((data) =>
          UnavailableSpaces.fromJson(data)).toList();
    } else {
      return [];
    }
  }

  @override
  Future<void> saveDisabledDates(String userId,
      List<Unavailable> unavailableList) async {
    try {
      final DocumentReference userDocRef = _firestore.collection(
          'disabledDates')
          .doc(userId);

      await userDocRef.set(
          {'unavailableDate': unavailableList.map((e) => e.toJson()).toList()});
    } on Exception catch (e) {
      throw e;
    }
  }

  @override
  Future<void> saveDisabledSpaces(String userId,
      List<UnavailableSpaces> unavailableList) async {
    try {
      final DocumentReference userDocRef = _firestore.collection(
          'disabledSpaces')
          .doc(userId);

      await userDocRef.set({
        'unavailableSpaces': unavailableList.map((e) => e.toJson()).toList()
      });
    } on Exception catch (e) {
      throw e;
    }
  }

  @override
  Future<List<Booking>> findBookingsByUser(User user) async {
    List<Booking> bookings = [];
    var userId = user.userInfo!.userType == UserType.gallery
        ? 'hostId'
        : 'artistId';

    try {
      final QuerySnapshot<Map<String, dynamic>> querySnapshot = await _firestore
          .collection('bookings')
          .where(userId, isEqualTo: user.id)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        bookings = querySnapshot.docs.map((document) {
          return Booking.fromJson(document.data());
        }).toList();
      }
    } catch (e) {
      print('Error fetching bookings: $e');
    }

    return bookings;
  }

  @override
  Future<List<Payout>> findPayoutsByUser(User user) async {
    List<Payout> payouts = [];

    try {
      final QuerySnapshot<Map<String, dynamic>> querySnapshot = await _firestore
          .collection('payouts')
          .where('userId', isEqualTo: user.id)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        payouts = querySnapshot.docs.map((document) {
          return Payout.fromJson(document.data());
        }).toList();
      }
    } catch (e) {
      print('Error fetching bookings: $e');
    }

    return payouts;
  }

  @override
  Stream<List<Booking>> findBookingsByUserStream(User user) {
    var userId = user.userInfo!.userType == UserType.gallery
        ? 'hostId'
        : 'artistId';

    try {
      return _firestore
          .collection('bookings')
          .where(userId, isEqualTo: user.id)
          .snapshots()
          .map((querySnapshot) =>
          querySnapshot.docs.map((document) {
            return Booking.fromJson(document.data());
          }).toList());
    } catch (e) {
      print('Error fetching bookings: $e');
      // Return an empty stream in case of error
      return Stream.value([]);
    }
  }

  Stream<List<DocumentSnapshot>> findBookingsByUserNordStream(User user, {int limit = 10,
    DocumentSnapshot? startAfter, BookingStatus? status, DateTime? startDate}) {
    var userId = user.userInfo!.userType == UserType.gallery ? 'hostId' : 'artistId';

    Query query = _firestore.collection('bookings')
        .where(userId, isEqualTo: user.id)
        .orderBy('from', descending: true)
        .limit(limit);

    if (startAfter != null) {
      query = query.startAfterDocument(startAfter);
    }

  if (status != null) {
    query = query.where('bookingStatus', isEqualTo: status.index);
  }

  if(startDate != null){
    query = query.where('from', isGreaterThanOrEqualTo: startDate);
    query = query.where('bookingStatus', isEqualTo: BookingStatus.accepted.index);
  }

  return query.snapshots().map((querySnapshot) => querySnapshot.docs);
        // .map((querySnapshot) =>
        // querySnapshot.docs.map((document) {
        //   return Booking.fromJson(document.data() as Map<String, dynamic>);
        // })
        //     .toList());
  }


  @override
  Future<Map<String, dynamic>> fetchConfigData() async {
    DocumentSnapshot<Map<String, dynamic>> snapshot =
    await FirebaseFirestore.instance.collection('config').doc('config').get(const GetOptions(source: Source.server));

    if (snapshot.exists) {
      return snapshot.data()!;
    } else {
      throw Exception('Config document not found');
    }
  }

}

