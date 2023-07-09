import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:database_service/database.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:rxdart/rxdart.dart';

import '../app/resources/theme.dart';
import '../injection.dart';

class MapViewTwo extends StatefulWidget {
  const MapViewTwo({super.key, required this.artb2bUserEntityl});

  final User artb2bUserEntityl;

  @override
  _MapViewTwoState createState() => _MapViewTwoState();
}

class _MapViewTwoState extends State<MapViewTwo> {
  final Completer<GoogleMapController> _mapController = Completer();

  late Stream<List<DocumentSnapshot>> stream;
  FirestoreDatabaseService firebaseDatabaseService = locator<FirestoreDatabaseService>();


  final radius = BehaviorSubject<double>.seeded(1.0);
  Map<MarkerId, Marker> markers = <MarkerId, Marker>{};

  _MapViewTwoState();

  @override
  void initState() {
    super.initState();

    rootBundle.loadString('assets/googleMapsStyle.json').then((string) {
      _mapStyle = string;
    });

    stream = radius.switchMap((rad) {

      return firebaseDatabaseService.findUsersByTypeAndRadius(artb2bUserEntity: widget.artb2bUserEntityl ,
          radius: rad);

    });
  }

  @override
  void dispose() {
    radius.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GoogleMap(
      gestureRecognizers: Set()
        ..add(Factory<PanGestureRecognizer>(() => PanGestureRecognizer()))
        ..add(Factory<ScaleGestureRecognizer>(() => ScaleGestureRecognizer()))
        ..add(Factory<TapGestureRecognizer>(() => TapGestureRecognizer()))
        ..add(Factory<VerticalDragGestureRecognizer>(
                () => VerticalDragGestureRecognizer())),
      myLocationEnabled: true,
      zoomControlsEnabled: true,
      myLocationButtonEnabled: false,
      onMapCreated: _onMapCreated,
      initialCameraPosition: CameraPosition(
        target: LatLng(
          widget.artb2bUserEntityl.artb2bUserEntityInfo!.address!.location!.latitude!,
          widget.artb2bUserEntityl.artb2bUserEntityInfo!.address!.location!.longitude!,
        ),
        zoom: 12.0,
      ),
      markers: Set<Marker>.of(markers.values),
    );
  }
  String _mapStyle = '';


  void _onMapCreated(GoogleMapController controller) {
    setState(() {
      _mapController.complete(controller);
      _mapController.future.then((controller) => controller.setMapStyle(_mapStyle));

//      _showHome();
      //start listening after map is created
      stream.listen((List<DocumentSnapshot> documentList) {
        _updateMarkers(documentList);
      });
    });
  }

  // void _showHome() {
  //   _mapController.complete.animateCamera(CameraUpdate.newCameraPosition(
  //     const CameraPosition(
  //       target: LatLng(12.960632, 77.641603),
  //       zoom: 15.0,
  //     ),
  //   ));
  // }

  // void _addPoint(double lat, double lng) {
  //   GeoFirePoint geoFirePoint = geo.point(latitude: lat, longitude: lng);
  //   _firestore
  //       .collection('locations')
  //       .add({'name': 'random name', 'position': geoFirePoint.data}).then((_) {
  //     print('added ${geoFirePoint.hash} successfully');
  //   });
  // }

  //example to add geoFirePoint inside nested object
  // void _addNestedPoint(double lat, double lng) {
  //   GeoFirePoint geoFirePoint = geo.point(latitude: lat, longitude: lng);
  //   _firestore.collection('nestedLocations').add({
  //     'name': 'random name',
  //     'address': {
  //       'location': {'position': geoFirePoint.data}
  //     }
  //   }).then((_) {
  //     print('added ${geoFirePoint.hash} successfully');
  //   });
  // }

  void _addMarker(double lat, double lng) {
    final id = MarkerId(lat.toString() + lng.toString());
    final _marker = Marker(
      markerId: id,
      position: LatLng(lat, lng),
      icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueViolet),
      infoWindow: InfoWindow(title: 'latLng', snippet: '$lat,$lng'),
    );
    setState(() {
      markers[id] = _marker;
    });
  }

  void _updateMarkers(List<DocumentSnapshot> documentList) {
    documentList.forEach((DocumentSnapshot document) {
      User user = User.fromJson(document.data() as Map<String, dynamic>);
      final GeoPoint point = user.artb2bUserEntityInfo!.address!.location!.geoPoint;
      _addMarker(point.latitude, point.longitude);
    });
  }

  // double _value = 20.0;
  // String _label = '';
  //
  // changed(value) {
  //   setState(() {
  //     _value = value;
  //     _label = '${_value.toInt().toString()} kms';
  //     markers.clear();
  //   });
  //   radius.add(value);
  // }
}