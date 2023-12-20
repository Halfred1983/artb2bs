import 'dart:async';

import 'package:artb2b/utils/common.dart';
import 'package:artb2b/widgets/input_text_widget.dart';
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

class MapView extends StatefulWidget {
  const MapView({super.key, required this.user});

  final User user;

  @override
  _MapViewState createState() => _MapViewState();
}

class _MapViewState extends State<MapView> {
  final Completer<GoogleMapController> _mapController = Completer();

  FirestoreDatabaseService firebaseDatabaseService = locator<FirestoreDatabaseService>();

  late BitmapDescriptor markerArtistIcon;
  late BitmapDescriptor markerGalleryIcon;

  late Stream<List<User>> usersStream;
  late Stream<List<User>> updatedStream;

  final radiusInputSubject = BehaviorSubject<double>.seeded(10.0);
  final priceInputSubject = BehaviorSubject<String>.seeded('');
  final daysInputSubject = BehaviorSubject<String>.seeded('');

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

    usersStream = firebaseDatabaseService.getHostsStream();

    updatedStream = combineBehaviorSubjects(radiusInputSubject,
        priceInputSubject, daysInputSubject, usersStream );

  }



  @override
  void dispose() {
    radiusInputSubject.close();
    daysInputSubject.close();
    priceInputSubject.close();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [

        GoogleMap(
          gestureRecognizers: Set()
            ..add(Factory<PanGestureRecognizer>(() => PanGestureRecognizer()))
            ..add(Factory<ScaleGestureRecognizer>(() => ScaleGestureRecognizer()))
            ..add(Factory<TapGestureRecognizer>(() => TapGestureRecognizer()))
            ..add(Factory<VerticalDragGestureRecognizer>(
                    () => VerticalDragGestureRecognizer())),
          zoomControlsEnabled: false,
          zoomGesturesEnabled: true,
          scrollGesturesEnabled: true,
          mapToolbarEnabled: false,
          rotateGesturesEnabled: false,
          tiltGesturesEnabled: false,
          myLocationEnabled: true,
          mapType: MapType.normal,
          compassEnabled: false,
          onMapCreated: _onMapCreated,
          initialCameraPosition: CameraPosition(
            target: LatLng(
              widget.user.userInfo!.address!.location!.latitude!,
              widget.user.userInfo!.address!.location!.longitude!,
            ),
            zoom: 12.0,
          ),
          markers: Set<Marker>.of(markers.values),
        ),
        Padding(
          padding: horizontalPadding24,
          child: SafeArea(
            child: Column(
              children: [
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Expanded(
                      child: InputTextWidget((priceValue) {
                        setState(() {
                          markers.clear();
                        });
                        priceInputSubject.add(priceValue);

                      },
                          'Max Price', TextInputType.number),
                    ),
                    horizontalMargin12,
                    Expanded(
                      child: InputTextWidget((daysValue) {
                        setState(() {
                          markers.clear();
                        });
                        daysInputSubject.add(daysValue);
                      } ,
                          'Days', TextInputType.number),
                    ),
                  ],
                ),
                verticalMargin12,
                Slider(
                  min: 1,
                  max: 200,
                  divisions: 4,
                  value: _value,
                  label: 'Radius: $_label',
                  activeColor: AppTheme.primaryColourVioletOpacity,
                  inactiveColor: AppTheme.accentColourOrangeOpacity,
                  onChanged: (double value) => changed(value) ,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
  String _mapStyle = '';
  double _value = 10.0;
  String _label = '';

  changed(value) {
    setState(() {
      _value = value;
      _label = '${_value.toInt().toString()} km';
      markers.clear();
    });
    radiusInputSubject.add(value);
  }

  void _onMapCreated(GoogleMapController controller) {
    if (context.mounted) {
      setState(() {
        _mapController.complete(controller);
        _mapController.future.then((controller) =>
            controller.setMapStyle(_mapStyle));

        //start listening after map is created
        updatedStream .listen((List<User> documentList) {
          _updateMarkers(documentList);
        });
      });
    }
  }

  Stream<List<User>> combineBehaviorSubjects(
      BehaviorSubject<double> radiusStream,
      BehaviorSubject<String> priceInputStream,
      BehaviorSubject<String> daysInputStream,
      Stream<List<User>> usersStream, // The original stream of users
      ) {
    return Rx.combineLatest4(
      radiusStream.stream,
      priceInputStream.stream,
      daysInputStream.stream,
      usersStream,
          (double radius, String priceInput, String daysInput, List<User> users) {
        // Combine the results from the streams and filter as needed
        return firebaseDatabaseService.filterUsersByRadiusAndPriceAndDays(widget.user, users, radius, priceInput, daysInput);
      },
    );
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
          showModalBottomSheet<void>(context: context,
              isScrollControlled:true,
              builder: (BuildContext context) {
                return SizedBox(
                    height: 640,
                    child: Padding(
                        padding: allPadding32,
                        child: Column (
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Text("More Details", style: TextStyles.boldAccent24, textAlign: TextAlign.left,),
                            // verticalMargin24,
                            Row(
                              // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              // mainAxisSize: MainAxisSize.max,
                              children: [
                                user.userInfo!.userType!.index == 0 ?
                                Image.asset('assets/images/artist.png', width: 40,) :
                                Image.asset('assets/images/gallery.png', width: 40,),
                                horizontalMargin12,
                                Text(user.userInfo!.name!, style: TextStyles.boldViolet16,),
                              ],
                            ),
                            verticalMargin12,
                            const Divider(thickness: 0.5, color: AppTheme.primaryColor,),
                            verticalMargin12,
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              mainAxisSize: MainAxisSize.max,
                              children: [
                                Text("Address: ", style: TextStyles.boldViolet14,),
                                Flexible(child: Text(user.userInfo!.address!.formattedAddress,
                                  softWrap: true, style: TextStyles.semiBoldViolet14,)),
                              ],
                            ),
                            verticalMargin12,
                            const Divider(thickness: 0.5, color: AppTheme.primaryColor,),
                            verticalMargin12,
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              mainAxisSize: MainAxisSize.max,
                              children: [
                                Text("Spaces: ", style: TextStyles.boldViolet14,),
                                Text(user.userArtInfo!.spaces!, style: TextStyles.semiBoldViolet14,),
                                Expanded(child: Container()),
                                Text("Audience: ", style: TextStyles.boldViolet14,),
                                Text(user.userArtInfo!.audience?? 'n\a', style: TextStyles.semiBoldViolet14,),
                              ],
                            ),
                            verticalMargin12,
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              mainAxisSize: MainAxisSize.max,
                              children: [
                                Flexible(flex: 1, child: Text("Vibes: ", softWrap: true, style: TextStyles.boldViolet14,)),
                              ],
                            ),
                            Text(user.userArtInfo!.vibes!.join(", "), softWrap: true, style: TextStyles.semiBoldViolet14,),

                            verticalMargin12,
                            const Divider(thickness: 0.5, color: AppTheme.primaryColor,),
                            verticalMargin12,
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              mainAxisSize: MainAxisSize.max,
                              children: [
                                Text("Price per space per day: ", style: TextStyles.boldViolet14,),
                                Expanded(child: Container()),
                                Text(user.bookingSettings!.basePrice!+' £', style: TextStyles.boldViolet24,),
                              ],
                            ),
                            verticalMargin12,
                            Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                mainAxisSize: MainAxisSize.max,
                                children: [
                                  Text("Min. spaces: ", style: TextStyles.boldViolet14,),
                                  Text(user.bookingSettings!.minSpaces!, style: TextStyles.semiBoldViolet14,),
                                  Expanded(child: Container()),
                                  Text("Min. days: ", style: TextStyles.boldViolet14,),
                                  Text(user.bookingSettings!.minLength!, style: TextStyles.semiBoldViolet14,),
                                ]
                            ),

                            verticalMargin12,
                            const Divider(thickness: 0.5, color: AppTheme.primaryColor,),
                            verticalMargin12,
                            StreamBuilder(
                                stream: firebaseDatabaseService.findArtworkByUser(user: user),
                                builder: (context, snapshot){
                                  if (snapshot.hasError) {
                                    return const Text('Something went wrong');
                                  }

                                  if (snapshot.connectionState == ConnectionState.waiting) {
                                    return const Text("Loading");
                                  }

                                  if(snapshot.hasData) {
                                    User user = User.fromJson(snapshot.data!.data() as Map<String, dynamic>);

                                    return user.photos != null && user.photos!.isNotEmpty ?
                                    SizedBox(
                                      width: double.infinity,
                                      height: 100,
                                      child: ListView.builder(
                                        itemCount: user.photos!.length,
                                        physics: const BouncingScrollPhysics(),
                                        scrollDirection: Axis.horizontal,
                                        shrinkWrap: true,
                                        itemBuilder: (context, index) {
                                          return SizedBox(
                                            height: 90,
                                            child: InkWell(
                                              onTap: () => Navigator.push(
                                                context,
                                                MaterialPageRoute(builder: (context) => PhotoDetails(photo: user.photos![index], isOwner: false)),
                                              ),
                                              child: Stack(
                                                children: [
                                                  ShaderMask(
                                                    shaderCallback: (rect) {
                                                      return const LinearGradient(
                                                        begin: Alignment.center,
                                                        end: Alignment.bottomCenter,
                                                        colors: [Colors.transparent, Colors.black],
                                                      ).createShader(Rect.fromLTRB(0, 0, rect.width, rect.height));
                                                    },
                                                    blendMode: BlendMode.darken,
                                                    child: ClipRRect(
                                                      borderRadius: BorderRadius.circular(10),
                                                      child: Image.network(
                                                          user.photos![index].url!,
                                                          fit: BoxFit.contain
                                                      ),
                                                    ),
                                                  ),
                                                  Positioned(
                                                    bottom: 15,
                                                    right: 25,
                                                    child: Text(user.photos![index].description ?? '',
                                                      style: TextStyles.boldWhite14,),
                                                  )
                                                ],
                                              ),
                                            ),
                                          );

                                        },
                                      ),
                                    ) : SizedBox(height: 90, child: Center(child: Text("Host has no photos yet",  style: TextStyles.semiBoldViolet16)));
                                  }
                                  return SizedBox(height: 90, child: Center(child: Text("Host has no photos yet" , style: TextStyles.semiBoldViolet16,)));
                                }),

                            verticalMargin32,
                            SizedBox(
                              width: double.infinity,
                              child: ElevatedButton(
                                onPressed:() {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(builder: (context) => BookingPage(host: user,)),
                                  );
                                  // context.read<BookingCubit>().save();
                                },
                                child: Text("Book", style: TextStyles.boldWhite16,),),
                            )
                          ],
                        )
                    )
                );
              });
        }
    );
    if (mounted) {
      setState(() {
        markers[id] = _marker;
      });
    }
  }

  void _updateMarkers(List<User> documentList) {
    documentList.forEach((User user) {
        _addMarker(user);
    });
  }
}