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
import '../booking/view/booking_page.dart';
import '../host/view/photo_details.dart';
import '../injection.dart';
import '../utils/currency/currency_helper.dart';
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
import '../booking/view/booking_page.dart';
import '../host/view/photo_details.dart';
import '../injection.dart';
import '../utils/currency/currency_helper.dart';
import 'host_list_card_big.dart';

class MapView extends StatefulWidget {
  const MapView({super.key, required this.hosts, required this.user});

  final User user;
  final List<User> hosts;

  @override
  _MapViewState createState() => _MapViewState();
}

class _MapViewState extends State<MapView> {
  final Completer<GoogleMapController> _mapController = Completer();

  final FirestoreDatabaseService firebaseDatabaseService = locator<FirestoreDatabaseService>();

  late BitmapDescriptor markerGalleryIcon;

  late Stream<List<User>> usersStream;

  final radiusInputSubject = BehaviorSubject<double>.seeded(50.0);
  // final priceInputSubject = BehaviorSubject<String>.seeded('');
  // final daysInputSubject = BehaviorSubject<String>.seeded('');
  late BehaviorSubject<User> userLatLngSubject = BehaviorSubject<User>.seeded(widget.user);

  Map<MarkerId, Marker> markers = <MarkerId, Marker>{};

  @override
  void initState() {
    super.initState();

    rootBundle.loadString('assets/googleMapsStyle.json').then((string) {
      _mapStyle = string;
    });

    BitmapDescriptor.asset(
        const ImageConfiguration(size: Size(40, 40)),
        'assets/images/marker_gallery.png'
    ).then((onValue) {
      markerGalleryIcon = onValue;
    });

    // usersStream = firebaseDatabaseService.getHostsStream();
    usersStream = Stream.value(widget.hosts);
    _subscribeToUpdatedStream();
  }

  @override
  void didUpdateWidget(covariant MapView oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.user.userInfo!.address != oldWidget.user.userInfo!.address ||
        widget.hosts != oldWidget.hosts) {
      userLatLngSubject.add(widget.user); //
      usersStream = Stream.value(widget.hosts); // Update the user location
      _moveCameraToNewLocation(widget.user);
      _subscribeToUpdatedStream(); // Rebuild the stream and update markers
    }
  }

  void _subscribeToUpdatedStream() {
    usersStream.listen((List<User> documentList) {
      _updateMarkers(documentList);
    });
  }

  void _moveCameraToNewLocation(User user) async {
    final GoogleMapController controller = await _mapController.future;
    controller.animateCamera(CameraUpdate.newLatLng(
      LatLng(
        user.userInfo!.address!.location!.latitude,
        user.userInfo!.address!.location!.longitude,
      ),
    ));
  }

  @override
  void dispose() {
    radiusInputSubject.close();
    userLatLngSubject.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GoogleMap(
      gestureRecognizers: <Factory<OneSequenceGestureRecognizer>>{
        Factory<PanGestureRecognizer>(() => PanGestureRecognizer()),
        Factory<ScaleGestureRecognizer>(() => ScaleGestureRecognizer()),
        Factory<TapGestureRecognizer>(() => TapGestureRecognizer()),
        Factory<VerticalDragGestureRecognizer>(() => VerticalDragGestureRecognizer()),
      },
      myLocationButtonEnabled: false,
      zoomControlsEnabled: false,
      zoomGesturesEnabled: true,
      scrollGesturesEnabled: true,
      mapToolbarEnabled: false,
      rotateGesturesEnabled: false,
      tiltGesturesEnabled: false,
      myLocationEnabled: false,
      mapType: MapType.normal,
      compassEnabled: false,
      onMapCreated: _onMapCreated,
      initialCameraPosition: CameraPosition(
        target: LatLng(
          widget.user.userInfo!.address!.location!.latitude,
          widget.user.userInfo!.address!.location!.longitude,
        ),
        zoom: 12.0,
      ),
      markers: Set<Marker>.of(markers.values),
    );
  }

  String _mapStyle = '';

  void _onMapCreated(GoogleMapController controller) {
    _mapController.complete(controller);
    controller.setMapStyle(_mapStyle);
  }

  // Stream<List<User>> combineBehaviorSubjects(
  //     BehaviorSubject<double> radiusStream,
  //     BehaviorSubject<String> priceInputStream,
  //     BehaviorSubject<String> daysInputStream,
  //     BehaviorSubject<User> userLatLngStream,
  //     Stream<List<User>> usersStream,
  //     ) {
  //   return Rx.combineLatest5(
  //     radiusStream.stream,
  //     priceInputStream.stream,
  //     daysInputStream.stream,
  //     userLatLngStream.stream,
  //     usersStream,
  //         (double radius, String priceInput, String daysInput, User userLatLng, List<User> users) {
  //       return firebaseDatabaseService.filterUsersByRadiusAndPriceAndDaysAndTypes(
  //         userLatLng, // Pass the correct user object here
  //         users,
  //         radius,
  //         priceInput,
  //         daysInput,
  //       );
  //     },
  //   );
  // }

  void _addMarker(User user, int index) {
    final GeoPoint point = user.userInfo!.address!.location!.geoPoint;
    // Offset the markers slightly based on the index
    double offset = 0.00010 * index;

    final id = MarkerId(point.latitude.toString() + point.longitude.toString() + index.toString());

    final Marker marker = Marker(
      markerId: id,
      position: LatLng(point.latitude + offset, point.longitude + offset),
      icon: markerGalleryIcon,
      onTap: () {
        _showMarkerDetails(user);
      },
    );

    if(mounted) {
      setState(() {
      markers[id] = marker;
    });
    }
  }

  void _updateMarkers(List<User> documentList) {
   if(mounted) {
     setState(() {
      markers.clear();
      var index = 0;// Clear existing markers
      for (User user in documentList) {
        print(index);
        _addMarker(user, index);
        index++;
      }
    });
   }
  }

  void _showMarkerDetails(User user) {
    showModalBottomSheet<void>(
        context: context,
        isScrollControlled: true,
        builder: (BuildContext context) {
          return SizedBox(
              height: 450,
              child: Padding(
                  padding: allPadding32,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      HostListCardBig(user: user),
                      verticalMargin16,
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed:() {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => BookingPage(host: user,)),
                            );
                          },
                          child: Text("Book", style: TextStyles.semiBoldAccent14,),
                        ),
                      )
                    ],
                  )
              )
          );
        }
    );
  }
}
