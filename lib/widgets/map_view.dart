import 'dart:async';

import 'package:artb2b/utils/common.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:database_service/database.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:rxdart/rxdart.dart';

import '../app/resources/styles.dart';
import '../app/resources/theme.dart';
import '../injection.dart';

class MapView extends StatefulWidget {
  const MapView({super.key, required this.artb2bUserEntity});

  final User artb2bUserEntity;

  @override
  _MapViewState createState() => _MapViewState();
}

class _MapViewState extends State<MapView> {
  final Completer<GoogleMapController> _mapController = Completer();

  late Stream<List<DocumentSnapshot>> stream;
  FirestoreDatabaseService firebaseDatabaseService = locator<FirestoreDatabaseService>();

  late BitmapDescriptor markerArtistIcon;
  late BitmapDescriptor markerGalleryIcon;

  final radius = BehaviorSubject<double>.seeded(3.0);
  Map<MarkerId, Marker> markers = <MarkerId, Marker>{};

  _MapViewState();

  @override
  void initState() {
    super.initState();

    rootBundle.loadString('assets/googleMapsStyle.json').then((string) {
      _mapStyle = string;
    });

    BitmapDescriptor.fromAssetImage(
        const ImageConfiguration(size: Size(40, 40)), 'assets/images/marker.png')
        .then((onValue) {
      markerArtistIcon = onValue;
    });

    BitmapDescriptor.fromAssetImage(
        const ImageConfiguration(size: Size(40, 40)), 'assets/images/marker_gallery.png')
        .then((onValue) {
      markerGalleryIcon = onValue;
    });

    stream = radius.switchMap((rad) {

      return firebaseDatabaseService.findUsersByTypeAndRadius(user: widget.artb2bUserEntity ,
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
          widget.artb2bUserEntity.userInfo!.address!.location!.latitude!,
          widget.artb2bUserEntity.userInfo!.address!.location!.longitude!,
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

  void _addMarker(User user) {
    final GeoPoint point = user.userInfo!.address!.location!.geoPoint;

    final id = MarkerId(point.latitude.toString() + point.longitude.toString());
    final _marker = Marker(
      markerId: id,
      position: LatLng(point.latitude, point.longitude),
      icon: user.userInfo!.userType!.index == 0 ? markerArtistIcon : markerGalleryIcon,
      onTap: () {
        showModalBottomSheet<void>(context: context, builder: (BuildContext context) {
          return Container(
              height: 300,
              child: Padding(
                  padding: allPadding32,
                  child: Column (
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("More Details", style: TextStyles.boldAccent24, textAlign: TextAlign.left,),
                      verticalMargin24,
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          Text("Type: ", style: TextStyles.boldViolet16,),
                            user.userInfo!.userType!.index == 0 ? Image.asset('assets/images/artist.png', width: 40,) :
                          Image.asset('assets/images/gallery.png', width: 40,)
                        ],
                      ),
                      verticalMargin12,
                      const Divider(thickness: 0.5, color: AppTheme.primaryColor,),
                      verticalMargin12,
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          Text("Address: ", style: TextStyles.boldViolet16,),
                          Text(user.userInfo!.address!.formattedAddress, style: TextStyles.semiBolViolet16,),
                        ],
                      ),
                    ],
                  )
              )
          );
        });
      }
    );
    setState(() {
      markers[id] = _marker;
    });
  }

  void _updateMarkers(List<DocumentSnapshot> documentList) {
    documentList.forEach((DocumentSnapshot document) {
      User user = User.fromJson(document.data() as Map<String, dynamic>);
      _addMarker(user);
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