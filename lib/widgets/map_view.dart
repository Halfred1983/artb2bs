import 'dart:async';
import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapSample extends StatefulWidget {
  const MapSample({Key? key}) : super(key: key);

  @override
  _MapSampleState createState() => _MapSampleState();
}

class _MapSampleState extends State<MapSample> {

// created controller for displaying Google Maps
  Completer<GoogleMapController> _controller = Completer();

  String _mapStyle = '';
// given camera position
  static const CameraPosition _kGoogle = CameraPosition(
    target: LatLng(19.0759837, 72.8776559),
    zoom: 15,
  );

  Uint8List? marketimages;
  List<String> images = ['assets/images/pin.png', 'assets/images/pin.png',
    'assets/images/pin.png'
    ,'assets/images/pin.png' ,'assets/images/pin.png' ,'assets/images/pin.png'];

// created empty list of markers
  final List<Marker> _markers = <Marker>[];

// created list of coordinates of various locations
  final List<LatLng> _latLen = <LatLng>[

    LatLng(19.0759837, 72.8776559),
    LatLng(28.679079, 77.069710),
    LatLng(26.850000, 80.949997),
    LatLng(24.879999, 74.629997),
    LatLng(16.166700, 74.833298),
    LatLng(12.971599, 77.594563),
  ];

// declared method to get Images
  Future<Uint8List> getImages(String path, int width) async{
    ByteData data = await rootBundle.load(path);
    ui.Codec codec = await ui.instantiateImageCodec(data.buffer.asUint8List(), targetHeight: width);
    ui.FrameInfo fi = await codec.getNextFrame();
    return(await fi.image.toByteData(format: ui.ImageByteFormat.png))!.buffer.asUint8List();

  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    rootBundle.loadString('assets/googleMapsStyle.json').then((string) {
      _mapStyle = string;
    });
    // initialize loadData method
    loadData();
  }

// created method for displaying custom markers according to index
  loadData() async{
    for(int i=0 ;i<images.length; i++){
      final Uint8List markIcons = await getImages(images[i], 100);
      // makers added according to index
      _markers.add(
          Marker(
            // given marker id
            markerId: MarkerId(i.toString()),
            // given marker icon
            icon: BitmapDescriptor.fromBytes(markIcons),
            // given position
            position: _latLen[i],
            infoWindow: InfoWindow(
              // given title for marker
              title: 'Location: '+i.toString(),
            ),
          )
      );
      setState(() {
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   backgroundColor: Color(0xFF0F9D58),
      //   // on below line we have given title of app
      //   title: Text("GFG"),
      // ),
      body: Container(
        child: SafeArea(
          child: GoogleMap(
            gestureRecognizers: Set()
              ..add(Factory<PanGestureRecognizer>(() => PanGestureRecognizer()))
              ..add(Factory<ScaleGestureRecognizer>(() => ScaleGestureRecognizer()))
              ..add(Factory<TapGestureRecognizer>(() => TapGestureRecognizer()))
              ..add(Factory<VerticalDragGestureRecognizer>(
                      () => VerticalDragGestureRecognizer())),
            myLocationEnabled: true,
            zoomControlsEnabled: true,
            myLocationButtonEnabled: false,
            // given camera position
            initialCameraPosition: _kGoogle,
            // set markers on google map
            markers: Set<Marker>.of(_markers),
            // on below line we have given map type
            mapType: MapType.normal,
            // on below line we have enabled location
            // on below line we have enabled compass
            compassEnabled: true,
            // below line displays google map in our app
            onMapCreated: (GoogleMapController controller){
              _controller.complete(controller);
              _controller.future.then((controller) => controller.setMapStyle(_mapStyle));
            },
          ),
        ),
      ),
    );
  }
}
