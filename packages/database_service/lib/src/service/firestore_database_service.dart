import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:database_service/src/models/models.dart';
import 'package:database_service/src/service/database_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart' as firestore;
import 'package:geoflutterfire2/geoflutterfire2.dart';


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
      print(user.id);
      return _firestore
          .collection('users')
          .doc(user.id).snapshots();
          // .map((snapshot) =>
          // snapshot.docs.map((doc) => Artwork.fromJson(doc.data())));

      // return collection;
    }
    catch (e) {
      print(e.toString());
      throw e;
    }
  }
}

