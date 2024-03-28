import 'package:artb2b/app/resources/styles.dart';
import 'package:artb2b/app/resources/theme.dart';
import 'package:artb2b/utils/common.dart';
import 'package:database_service/database.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:geoflutterfire2/geoflutterfire2.dart';
import 'package:google_places_flutter/DioErrorHandler.dart';
import 'package:google_places_flutter/google_places_flutter.dart';
import 'package:google_places_flutter/model/place_details.dart';
import 'package:google_places_flutter/model/prediction.dart';

import '../utils/currency/currency_helper.dart';


class GoogleAddressLookup extends StatefulWidget {
  const GoogleAddressLookup({Key? key}) : super(key: key);


  @override
  _GoogleAddressLookupState createState() => _GoogleAddressLookupState();
}

class _GoogleAddressLookupState extends State<GoogleAddressLookup> {
  // GooglePlace? _googlePlace;
  GeoFlutterFire geoFlutterFire = GeoFlutterFire();
  String apiKey = 'AIzaSyACKPGCrcpyYx3w1PWxoaQhXOd0wGB7cSk';
  late var _dio;

  // List<AutocompletePrediction> _predictions = [];
  late final TextEditingController _placeController;

  @override
  void initState() {
    // _googlePlace = GooglePlace(apiKey);
    _dio = Dio();
    _placeController = TextEditingController(text: '');
    super.initState();
  }

  @override
  void dispose() {
    _placeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        iconTheme: const IconThemeData(
            color: AppTheme.primaryColor //change your color here
        ),
        title: Text("Your location", style: TextStyles.boldAccent24,),
        centerTitle: true,
      ),
      body: Container(
        padding: horizontalPadding24,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
          verticalMargin12,
          // Row(
          //   children: <Widget>[
          //     Expanded(
          //       flex: 4,
          //       child: AppTextField(
          //         controller: _placeController,
          //         key: const Key('Address place'),
          //         autoCorrect: false,
          //         onChanged: (value) {
          //           if (value.isNotEmpty) {
          //             autoCompleteSearch(value);
          //           } else {
          //             if (_predictions.length > 0 && mounted) {
          //               setState(() {
          //                 _predictions = [];
          //               });
          //             }
          //           }
          //         },
          //       ),
          //     ),
          //     horizontalMargin12,
          //     Expanded(
          //         flex: 1,
          //         child:
          //         TextButton(
          //           onPressed: () {
          //             setState(() {
          //               _placeController.text = '';
          //               _predictions = [];
          //             });
          //           },
          //             style: ButtonStyle(
          //               overlayColor: MaterialStateColor.resolveWith((states) => AppTheme.accentColor),
          //             ),
          //             child:Text('Clear',
          //             style: TextStyles.semiBoldViolet14.copyWith(decoration: TextDecoration.underline),)
          //         ),
          //
          //     )
          //   ],
          // ),

          // ListView.builder(
          //   padding: EdgeInsets.zero,
          //   itemCount: _predictions.length,
          //   shrinkWrap: true,
          //   physics: const NeverScrollableScrollPhysics(),
          //   itemBuilder: (context, index) {
          //     return ListTile(
          //       title: Row(
          //         mainAxisAlignment: MainAxisAlignment.start,
          //         children: [
          //           const Padding(
          //             padding: EdgeInsets.only(right: 4.0),
          //             child: Icon(Icons.location_on_outlined,
          //               size: 30, color: AppTheme.black,),
          //           ),
          //           Flexible(
          //            child: Text(_predictions[index].description ?? '',
          //                 style: TextStyles.semiBoldViolet16,),
          //           ),
          //         ],
          //       ),
          //
          //       onTap: () async {
          //         debugPrint(_predictions[index].placeId);
          //         var address = await getDetails(_predictions[index].placeId!);
          //
          //         Navigator.of(context).pop(address);
          //
          //       },
          //     );
          //   },
          // ),
          GooglePlaceAutoCompleteTextField(
            textEditingController: _placeController,
            googleAPIKey: apiKey,
            inputDecoration: InputDecoration(
              hintText: "Search your location",
              border: InputBorder.none,
              enabledBorder: InputBorder.none,
            ),
            debounceTime: 400,
            countries: ["in", "fr"],
            isLatLngRequired: true,
            getPlaceDetailWithLatLng: (Prediction prediction) {
              print("placeDetails" + prediction.lat.toString());
            },

            itemClick: (Prediction prediction) async {
              _placeController.text = prediction.description ?? "";
              _placeController.selection = TextSelection.fromPosition(
                  TextPosition(offset: prediction.description?.length ?? 0));
              var address = await getPlaceDetailsFromPlaceId(prediction);
              Navigator.of(context).pop(address);
            },
            seperatedBuilder: Divider(),
            containerHorizontalPadding: 10,

            // OPTIONAL// If you want to customize list view item builder
            itemBuilder: (context, index, Prediction prediction) {
              return Container(
                padding: EdgeInsets.all(10),
                child: Row(
                  children: [
                    Icon(Icons.location_on),
                    SizedBox(
                      width: 7,
                    ),
                    Expanded(child: Text("${prediction.description ?? ""}"))
                  ],
                ),
              );
            },

            isCrossBtnShown: true,

            // default 600 ms ,
          ),
        ],
      ),
    ),
    );
  }

  // void autoCompleteSearch(String value) async {
  //   var result = await _googlePlace?.autocomplete.get(value);
  //   if (result != null && result.predictions != null && mounted) {
  //     setState(() {
  //       _predictions = result.predictions!;
  //     });
  //   }
  // }

  String _address = '';
  String _place = '';
  String _province = '';
  String _city = '';
  String _zip = '';
  String _number = '';
  String _country = 'GB';
  String _locale = 'en_GB';

  // Future<UserAddress?> getDetails(Prediction prediction) async {
  //   // var result = await _googlePlace?.details.get(placeId);
  //   GooglePlaces
  //
  //   if (result != null && result.result != null && mounted) {
  //
  //     result.result?.addressComponents?.forEach((element) {
  //       if (element.types!.contains('administrative_area_level_2')) {
  //         _province = element.shortName!;
  //       }
  //       if (element.types!.contains('route')) {
  //         _address = element.longName!;
  //       }
  //       if (element.types!.contains('street_number')) {
  //         _number = element.longName!;
  //       }
  //       if (element.types!.contains('administrative_area_level_3')) {
  //         _city = element.longName!;
  //       }
  //       if (element.types!.contains('postal_town')) {
  //         _city = element.longName!;
  //       }
  //       if (element.types!.contains('locality')) {
  //         _place = element.longName!;
  //       }
  //       if (element.types!.contains('postal_code')) {
  //         _zip = element.longName!;
  //       }
  //       if (element.types!.contains('country')) {
  //         _country = element.shortName!;
  //         _locale = 'en_$_country';
  //       }
  //     });
  //     String? formattedAddress = result.result?.formattedAddress;
  //
  //     GeoFirePoint location;
  //     // if(result.result != null && result.result?.geometry != null ) {
  //     double? lat = result.result?.geometry?.location?.lat;
  //     double? lng = result.result?.geometry?.location?.lng;
  //
  //     location = geoFlutterFire.point(latitude: lat!, longitude: lng!);
  //     // }
  //
  //     return UserAddress(address: _address, place: _place,
  //         province: _province, city: _city ,
  //         number: _number, zipcode:_zip, country: _country,
  //         locale: _locale, currencyCode: CurrencyHelper.currency(_country).currencyName!,
  //         location: location, formattedAddress: formattedAddress ?? "");
  //   }
  // }

  Future<UserAddress?> getPlaceDetailsFromPlaceId(Prediction prediction) async {
    var url = "https://maps.googleapis.com/maps/api/place/details/json?placeid=${prediction.placeId}&key=${apiKey}";
    try {
      Response response = await _dio.get(
        url,
      );

      PlaceDetails placeDetails = PlaceDetails.fromJson(response.data);


      if (placeDetails.result != null && mounted) {
        placeDetails.result?.addressComponents?.forEach((element) {
          if (element.types!.contains('administrative_area_level_2')) {
            _province = element.shortName!;
          }
          if (element.types!.contains('route')) {
            _address = element.longName!;
          }
          if (element.types!.contains('street_number')) {
            _number = element.longName!;
          }
          if (element.types!.contains('administrative_area_level_3')) {
            _city = element.longName!;
          }
          if (element.types!.contains('postal_town')) {
            _city = element.longName!;
          }
          if (element.types!.contains('locality')) {
            _place = element.longName!;
          }
          if (element.types!.contains('postal_code')) {
            _zip = element.longName!;
          }
          if (element.types!.contains('country')) {
            _country = element.shortName!;
            _locale = 'en_$_country';
          }
        });
        String? formattedAddress = placeDetails.result?.formattedAddress;

        GeoFirePoint location;
        // if(result.result != null && result.result?.geometry != null ) {
        double? lat = placeDetails.result?.geometry?.location?.lat;
        double? lng = placeDetails.result?.geometry?.location?.lng;

        location = geoFlutterFire.point(latitude: lat!, longitude: lng!);
        // }

        return UserAddress(address: _address,
            place: _place,
            province: _province,
            city: _city,
            number: _number,
            zipcode: _zip,
            country: _country,
            locale: _locale,
            currencyCode: CurrencyHelper
                .currency(_country)
                .currencyName!,
            location: location,
            formattedAddress: formattedAddress ?? "");
      }
    }
    catch(e){
      var errorHandler = ErrorHandler.internal().handleError(e);
      _showSnackBar("${errorHandler.message}");
    }
  }

  _showSnackBar(String errorData) {
      final snackBar = SnackBar(
        content: Text("$errorData"),
      );

      // Find the ScaffoldMessenger in the widget tree
      // and use it to show a SnackBar.
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }
}